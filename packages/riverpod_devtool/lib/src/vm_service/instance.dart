part of '../vm_service.dart';

sealed class ResolvedVariable {
  const ResolvedVariable(this.object);

  factory ResolvedVariable.fromInstance(
    CachedObject object,
    Instance instance,
  ) {
    final kind = _SimplifiedInstanceKind.fromInstanceKind(
      _SealedInstanceKind.fromString(instance.kind!),
    );

    switch (kind) {
      case .string:
        return StringVariable._fromInstance(object, instance);
      case .int:
        return IntVariable._fromInstance(object, instance);
      case .double:
        return DoubleVariable._fromInstance(object, instance);
      case .bool:
        return BoolVariable._fromInstance(object, instance);
      case .nill:
        return NullVariable._(object);
      case .type:
        return TypeVariable._fromInstance(object, instance);
      case .record:
        return RecordVariable._fromInstance(object, instance);
      case .list:
        return ListVariable._fromInstance(object, instance);
      case .set:
        return SetVariable._fromInstance(object, instance);

      // TODO
      case .object:
      case _:
        return UnknownObjectVariable._(object, instance);
      // case .map:
    }
  }

  final CachedObject object;

  // TODO
  List<DerivedCachedObject> get children => const [];
}

// mixin _SelfResolvedVariable<T extends _SelfResolvedVariable<T>> {
//   Future<Byte<T>> resolve(Disposable isAlive) async {
//     if (this is! T) {
//       throw StateError(
//         '_SelfResolvedVariable can only be extended by its generic type T',
//       );
//     }

//     return ByteVariable(this as T);
//   }
// }

final class NullVariable extends ResolvedVariable {
  NullVariable._(super.object);
}

final class BoolVariable extends ResolvedVariable {
  BoolVariable._(super.object, {required this.value});
  BoolVariable._fromInstance(super.object, Instance instance)
    : value = instance.valueAsString == 'true';

  final bool value;
}

final class IntVariable extends ResolvedVariable {
  IntVariable._(super.object, {required this.value});
  IntVariable._fromInstance(super.object, Instance instance)
    : value = int.parse(instance.valueAsString!);

  final int value;
}

final class DoubleVariable extends ResolvedVariable {
  DoubleVariable._(super.object, {required this.value});
  DoubleVariable._fromInstance(super.object, Instance instance)
    : value = double.parse(instance.valueAsString!);

  final double value;
}

final class StringVariable extends ResolvedVariable {
  StringVariable._(super.object, {required this.value});
  StringVariable._fromInstance(super.object, Instance instance)
    : value = instance.valueAsString!;

  final String value;
}

final class TypeVariable extends ResolvedVariable {
  TypeVariable._(super.object, {required this.name});
  TypeVariable._fromInstance(super.object, Instance instance)
    : name = instance.name!;

  final String name;
}

final class RecordVariable extends ResolvedVariable {
  RecordVariable._(super.object, {required this.children});
  RecordVariable._fromInstance(super.object, Instance instance)
    : children = [
        for (final field in instance.fields ?? <BoundField>[])
          DerivedCachedObject.objectField(object, field),
      ];

  @override
  final List<DerivedCachedObject> children;
}

final class ListVariable extends ResolvedVariable {
  ListVariable._(super.object, {required this.children});
  ListVariable._fromInstance(super.object, Instance instance)
    : children = [
        for (final (index, _) in (instance.elements ?? <dynamic>[]).indexed)
          DerivedCachedObject.collectionElement(object, index),
      ];

  @override
  final List<DerivedCachedObject> children;
}

final class SetVariable extends ResolvedVariable {
  SetVariable._(super.object, {required this.children});
  SetVariable._fromInstance(super.object, Instance instance)
    : children = [
        for (final (index, _) in (instance.elements ?? <dynamic>[]).indexed)
          DerivedCachedObject.collectionElement(object, index),
      ];

  @override
  final List<DerivedCachedObject> children;
}

// final class ListVariable extends ResolvedVariable
//     with _SelfResolvedVariable<ListVariable>
//     implements ListVariableRef, VariableRef {
//   ListVariable._(this.ref, EvalFactory eval)
//     : children = [
//         ...ref.elements!
//             .map(Byte.instanceRef)
//             .map(
//               (byte) =>
//                   byte.map((val) => VariableRef.fromInstanceRef(val, eval)),
//             ),
//       ];

//   @override
//   final List<Byte<VariableRef>> children;
//   @override
//   final Instance ref;
// }

// final class RecordVariable extends ResolvedVariable
//     with _SelfResolvedVariable<RecordVariable>
//     implements RecordVariableRef {
//   RecordVariable._(this.ref, EvalFactory eval)
//     : children = [
//         ...ref.fields!
//             .map((field) => _FieldVariableRefImpl(field, eval, object: ref))
//             .map(ByteVariable.new),
//       ];

//   @override
//   final List<Byte<FieldVariableRef>> children;
//   @override
//   final Instance ref;
// }

// final class SetVariable extends ResolvedVariable
//     with _SelfResolvedVariable<SetVariable>
//     implements VariableRef {
//   SetVariable._(this.ref, EvalFactory eval)
//     : children = [
//         ...ref.elements!
//             .map(Byte.instanceRef)
//             .map(
//               (byte) =>
//                   byte.map((val) => VariableRef.fromInstanceRef(val, eval)),
//             ),
//       ];

//   @override
//   final List<Byte<VariableRef>> children;
//   @override
//   final Instance ref;
// }

// final class TypeVariable extends ResolvedVariable
//     with _SelfResolvedVariable<TypeVariable>
//     implements TypeVariableRef {
//   TypeVariable._(this.ref) : name = ref.name!;

//   final String name;
//   @override
//   final InstanceRef ref;
// }

final class UnknownObjectVariable extends ResolvedVariable {
  UnknownObjectVariable._(super.object, Instance ref)
    : type = ref.classRef!.name!,
      identityHashCode = ref.identityHashCode,
      children = [
        for (final field in ref.fields ?? <BoundField>[])
          DerivedCachedObject.objectField(object, field),
      ];

  final String type;
  final int? identityHashCode;
  @override
  final List<DerivedCachedObject> children;
}

// final class UnknownObjectVariable extends ResolvedVariable
//     with _SelfResolvedVariable<UnknownObjectVariable>
//     implements UnknownObjectVariableRef {
//   UnknownObjectVariable._(this.ref, EvalFactory eval)
//     : type = ref.classRef!.name!,
//       identityHashCode = ref.identityHashCode,
//       children = [
//         for (final field in ref.fields ?? <BoundField>[])
//           ByteVariable(_FieldVariableRefImpl(field, eval, object: ref)),
//       ];

//   final String type;
//   final int? identityHashCode;
//   @override
//   final List<ByteVariable<FieldVariableRef>> children;
//   @override
//   final Instance ref;
// }

// final class FieldVariable extends ResolvedVariable
//     with _SelfResolvedVariable<FieldVariable>
//     implements FieldVariableRef {
//   FieldVariable({required this.key, required this.value});

//   final FieldKey key;
//   final Byte<ResolvedVariable> value;

//   @override
//   InstanceRef? get ref => switch (value) {
//     ByteVariable<ResolvedVariable>(:final instance) => instance.ref,
//     ByteSentinel<ResolvedVariable>() => null,
//   };

//   @override
//   List<Byte<VariableRef>> get children => switch (value) {
//     ByteVariable<ResolvedVariable>(:final instance) => instance.children,
//     ByteSentinel<ResolvedVariable>() => const [],
//   };
// }

@immutable
sealed class FieldKey {
  factory FieldKey.from(Object? key) {
    return switch (key) {
      final String value => NamedFieldKey(value),
      final int value => PositionalFieldKey(value),
      _ => throw StateError('Field name is neither String nor int: $key'),
    };
  }

  @override
  @mustBeOverridden
  bool operator ==(Object other);

  @override
  int get hashCode;
}

// ignore: avoid_implementing_value_types, false positive
final class PositionalFieldKey implements FieldKey {
  PositionalFieldKey(this.index);
  final int index;

  @override
  bool operator ==(Object other) =>
      other is PositionalFieldKey && other.index == index;

  @override
  int get hashCode => index.hashCode;
}

// ignore: avoid_implementing_value_types, false positive
final class NamedFieldKey implements FieldKey {
  NamedFieldKey(this.name);
  final String name;

  @override
  bool operator ==(Object other) =>
      other is NamedFieldKey && other.name == name;

  @override
  int get hashCode => name.hashCode;
}
