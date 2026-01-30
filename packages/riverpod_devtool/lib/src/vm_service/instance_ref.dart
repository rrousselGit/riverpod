part of '../vm_service.dart';

sealed class VariableRef {
  factory VariableRef.fromInstanceRef(InstanceRef ref) {
    final kind = _SimplifiedInstanceKind.fromInstanceKind(
      _SealedInstanceKind.fromString(ref.kind!),
    );

    switch (kind) {
      case .string:
        return _StringVariableRefImpl._(ref);
      case .int:
        return IntVariable._(ref);
      case .double:
        return DoubleVariable._(ref);
      case .bool:
        return BoolVariable._(ref);
      case .nill:
        return NullVariable._();
      case .type:
        return _TypeVariableRefImpl(ref);
      case .list:
        return _ListVariableRefImpl(ref);
      case .record:
        return _RecordVariableRefImpl(ref);
      case .set:
        return _SetVariableRefImpl(ref);

      case .map:
      // TODO

      case .object:
        return _UnknownObjectVariableRefImpl(ref);
    }
  }

  InstanceRef? get ref;

  Future<Byte<ResolvedVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

base class _EvaluatedVariableRef {
  _EvaluatedVariableRef(this.ref);
  final InstanceRef ref;

  String get _evalUri => ref.classRef!.library!.uri!;

  Future<Byte<T>> _eval<T extends ResolvedVariable>(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
    Future<T> Function(Eval) run,
  ) async {
    final evalInstance = await eval(_evalUri);

    try {
      return ByteVariable(await run(evalInstance));
    } on SentinelException catch (e) {
      return ByteSentinel(e.sentinel);
    }
  }

  Future<Byte<T>> _resolveInstance<T extends ResolvedVariable>(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _eval(eval, isAlive, (evalInstance) async {
      final instance = await evalInstance.instance(ref, isAlive: isAlive);
      final variable = ResolvedVariable.fromInstance(instance);

      if (variable is! T) {
        throw StateError(
          'Expected variable of type $T but got ${variable.runtimeType}',
        );
      }

      return variable;
    });
  }
}

abstract class NullVariableRef implements VariableRef {
  @override
  Future<Byte<NullVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

abstract class BoolVariableRef implements VariableRef {
  bool get value;

  @override
  Future<Byte<BoolVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

abstract class StringVariableRef implements VariableRef {
  String get truncatedValue;
  bool get isTruncated;
  String? get value;

  @override
  Future<Byte<StringVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _StringVariableRefImpl extends _EvaluatedVariableRef
    implements VariableRef {
  _StringVariableRefImpl._(super.ref)
    : truncatedValue = ref.valueAsString!,
      isTruncated = ref.valueAsStringIsTruncated!;

  final String truncatedValue;
  final bool isTruncated;
  String? get value => isTruncated ? null : truncatedValue;

  @override
  Future<Byte<StringVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) async {
    if (!isTruncated) {
      return ByteVariable(StringVariable._2(ref, value: truncatedValue));
    }

    return _resolveInstance(eval, isAlive);
  }
}

abstract class IntVariableRef implements VariableRef {
  int get value;

  @override
  Future<Byte<IntVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

abstract class DoubleVariableRef implements VariableRef {
  double get value;

  @override
  Future<Byte<DoubleVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

abstract class TypeVariableRef implements VariableRef {
  @override
  Future<Byte<TypeVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _TypeVariableRefImpl extends _EvaluatedVariableRef
    implements VariableRef {
  _TypeVariableRefImpl(super.ref);

  @override
  Future<Byte<TypeVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _resolveInstance(eval, isAlive);
  }
}

abstract class ListVariableRef implements VariableRef {
  @override
  Future<Byte<ListVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _ListVariableRefImpl extends _EvaluatedVariableRef
    implements VariableRef {
  _ListVariableRefImpl(super.ref);

  @override
  Future<Byte<ListVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _resolveInstance(eval, isAlive);
  }
}

abstract class RecordVariableRef implements VariableRef {
  @override
  Future<Byte<RecordVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _RecordVariableRefImpl extends _EvaluatedVariableRef
    implements VariableRef {
  _RecordVariableRefImpl(super.ref);

  @override
  Future<Byte<RecordVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _resolveInstance(eval, isAlive);
  }
}

abstract class SetVariableRef implements VariableRef {
  @override
  Future<Byte<SetVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _SetVariableRefImpl extends _EvaluatedVariableRef
    implements VariableRef {
  _SetVariableRefImpl(super.ref);

  @override
  Future<Byte<SetVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _resolveInstance(eval, isAlive);
  }
}

abstract class UnknownObjectVariableRef implements VariableRef {
  @override
  Future<Byte<UnknownObjectVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _UnknownObjectVariableRefImpl extends _EvaluatedVariableRef
    implements VariableRef {
  _UnknownObjectVariableRefImpl(super.ref);

  @override
  Future<Byte<UnknownObjectVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _resolveInstance(eval, isAlive);
  }
}

abstract class FieldVariableRef implements VariableRef {
  @override
  Future<Byte<FieldVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  );
}

final class _FieldVariableRefImpl extends _EvaluatedVariableRef
    implements FieldVariableRef {
  _FieldVariableRefImpl(this._field, {required InstanceRef object})
    : super(object);

  final BoundField _field;

  @override
  Future<Byte<FieldVariable>> resolve(
    Future<Eval> Function(String uri) eval,
    Disposable isAlive,
  ) {
    return _eval(eval, isAlive, (eval) async {
      final value = Byte.instanceRef(_field.value);

      return FieldVariable(
        key: FieldKey.from(_field.name),
        value: switch (value) {
          ByteVariable<InstanceRef>() => await eval.instance2(
            value.instance,
            isAlive: isAlive,
          ),
          ByteSentinel<InstanceRef>() => ByteSentinel(value.sentinel),
        },
      );
    });
  }
}
