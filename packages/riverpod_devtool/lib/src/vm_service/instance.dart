part of '../vm_service.dart';

sealed class ResolvedVariable implements VariableRef {
  const ResolvedVariable();

  factory ResolvedVariable.fromInstance(Instance instance) {
    final kind = _SimplifiedInstanceKind.fromInstanceKind(
      _SealedInstanceKind.fromString(instance.kind!),
    );

    switch (kind) {
      case .string:
        return StringVariable._(instance);
      case .int:
        return IntVariable._(instance);
      case .double:
        return DoubleVariable._(instance);
      case .bool:
        return BoolVariable._(instance);
      case .nill:
        return NullVariable._();
      case .type:
        return TypeVariable._(instance);
      case .list:
        return ListVariable._(instance);
      case .record:
        return RecordVariable._(instance);
      case .set:
        return SetVariable._(instance);

      case .object:
      case .map:
        return UnknownObjectVariable._(instance);
    }
  }

  // TODO
  List<Byte<VariableRef>> get children => const [];
}

mixin _SelfResolvedVariable<T extends _SelfResolvedVariable<T>> {
  Future<Byte<T>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) async {
    if (this is! T) {
      throw StateError(
        '_SelfResolvedVariable can only be extended by its generic type T',
      );
    }

    return ByteVariable(this as T);
  }
}

final class NullVariable extends ResolvedVariable
    with _SelfResolvedVariable<NullVariable>
    implements NullVariableRef {
  NullVariable._();

  @override
  InstanceRef? get ref => null;
}

final class BoolVariable extends ResolvedVariable
    with _SelfResolvedVariable<BoolVariable>
    implements BoolVariableRef {
  BoolVariable._(this.ref) : value = ref.valueAsString! == 'true';
  @override
  final bool value;
  @override
  final InstanceRef ref;
}

final class StringVariable extends ResolvedVariable
    with _SelfResolvedVariable<StringVariable>
    implements StringVariableRef {
  StringVariable._2(this.ref, {required this.value});
  StringVariable._(this.ref) : value = ref.valueAsString! {
    if (ref.valueAsStringIsTruncated ?? false) {
      throw StateError('String value is truncated');
    }
  }

  @override
  final String value;
  @override
  bool get isTruncated => false;
  @override
  String get truncatedValue => value;
  @override
  final InstanceRef ref;
}

final class IntVariable extends ResolvedVariable
    with _SelfResolvedVariable<IntVariable>
    implements VariableRef, IntVariableRef {
  IntVariable._(this.ref) : value = int.parse(ref.valueAsString!);
  @override
  final int value;
  @override
  final InstanceRef ref;
}

final class DoubleVariable extends ResolvedVariable
    with _SelfResolvedVariable<DoubleVariable>
    implements DoubleVariableRef, VariableRef {
  DoubleVariable._(this.ref) : value = double.parse(ref.valueAsString!);

  @override
  final double value;
  @override
  final InstanceRef ref;
}

final class ListVariable extends ResolvedVariable
    with _SelfResolvedVariable<ListVariable>
    implements ListVariableRef, VariableRef {
  ListVariable._(this.ref)
    : children = [
        ...ref.elements!
            .map(Byte.instanceRef)
            .map((byte) => byte.map(VariableRef.fromInstanceRef)),
      ];

  @override
  final List<Byte<VariableRef>> children;
  @override
  final Instance ref;
}

final class RecordVariable extends ResolvedVariable
    with _SelfResolvedVariable<RecordVariable>
    implements RecordVariableRef {
  RecordVariable._(this.ref)
    : children = [
        ...ref.fields!
            .map((field) => _FieldVariableRefImpl(field, object: ref))
            .map(ByteVariable.new),
      ];

  @override
  final List<Byte<FieldVariableRef>> children;
  @override
  final Instance ref;
}

final class SetVariable extends ResolvedVariable
    with _SelfResolvedVariable<SetVariable>
    implements VariableRef {
  SetVariable._(this.ref)
    : children = [
        ...ref.elements!
            .map(Byte.instanceRef)
            .map((byte) => byte.map(VariableRef.fromInstanceRef)),
      ];

  @override
  final List<Byte<VariableRef>> children;
  @override
  final Instance ref;
}

final class TypeVariable extends ResolvedVariable
    with _SelfResolvedVariable<TypeVariable>
    implements TypeVariableRef {
  TypeVariable._(this.ref) : name = ref.name!;

  final String name;
  @override
  final InstanceRef ref;
}

final class UnknownObjectVariable extends ResolvedVariable
    with _SelfResolvedVariable<UnknownObjectVariable>
    implements UnknownObjectVariableRef {
  UnknownObjectVariable._(this.ref)
    : type = ref.classRef!.name!,
      identityHashCode = ref.identityHashCode,
      children = [
        for (final field in ref.fields ?? <BoundField>[])
          ByteVariable(_FieldVariableRefImpl(field, object: ref)),
      ];

  final String type;
  final int? identityHashCode;
  @override
  final List<ByteVariable<FieldVariableRef>> children;
  @override
  final Instance ref;
}

final class FieldVariable extends ResolvedVariable
    with _SelfResolvedVariable<FieldVariable>
    implements FieldVariableRef {
  FieldVariable({required this.key, required this.value});

  final FieldKey key;
  final Byte<ResolvedVariable> value;

  @override
  InstanceRef? get ref => switch (value) {
    ByteVariable<ResolvedVariable>(:final instance) => instance.ref,
    ByteSentinel<ResolvedVariable>() => null,
  };

  @override
  List<Byte<VariableRef>> get children => switch (value) {
    ByteVariable<ResolvedVariable>(:final instance) => instance.children,
    ByteSentinel<ResolvedVariable>() => const [],
  };
}

sealed class FieldKey {
  factory FieldKey.from(Object? key) {
    return switch (key) {
      final String value => NamedFieldKey(value),
      final int value => PositionalFieldKey(value),
      _ => throw StateError('Field name is neither String nor int: $key'),
    };
  }
}

final class PositionalFieldKey implements FieldKey {
  PositionalFieldKey(this.index);
  final int index;
}

final class NamedFieldKey implements FieldKey {
  NamedFieldKey(this.name);
  final String name;
}
