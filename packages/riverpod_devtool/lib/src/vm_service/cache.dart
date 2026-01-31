part of '../vm_service.dart';

extension type CacheId(String value) {}

sealed class CachedObject {
  CachedObject({required this.label});

  final String? label;

  InstanceRef? _lastKnownRef;

  Future<Byte<Instance>> read(
    EvalFactory eval, {
    required Disposable isAlive,
  }) async {
    InstanceRef ref;
    if (_lastKnownRef case final lastKnownRef?) {
      ref = lastKnownRef;
    } else {
      final byte = await _fetchInstance(eval, isAlive);
      switch (byte) {
        case ByteVariable():
          ref = _lastKnownRef = byte.instance;
        case ByteError():
          return ByteError(byte.error);
      }
    }

    const maxRetries = 5;
    var i = 0;
    while (true) {
      i++;

      final byte = await eval.dartCore.instance(ref, isAlive: isAlive);

      _lastKnownRef = null;
      switch (byte) {
        case ByteVariable():
          _lastKnownRef = byte.instance;
          return byte;
        // Non-expire error, return it
        case ByteError(
          error: SentinelExceptionType(
            error: Sentinel(kind: != SentinelKind.kExpired),
          ),
        ):
        // Out of retries, return last error
        case ByteError() when i == maxRetries:
          return byte;
        // Retry
        case _:
          final newRef = await _fetchInstance(eval, isAlive);
          switch (newRef) {
            case ByteError():
              return ByteError(newRef.error);
            case ByteVariable():
              _lastKnownRef = ref = newRef.instance;
          }
      }
    }
  }

  Future<Byte<InstanceRef>> readRef(EvalFactory eval, Disposable isAlive) {
    if (_lastKnownRef case final lastKnownRef?) {
      return Future.value(ByteVariable(lastKnownRef));
    }

    return _fetchInstance(eval, isAlive);
  }

  Future<Byte<InstanceRef>> _fetchInstance(
    EvalFactory eval,
    Disposable isAlive,
  );
}

class RootCachedObject extends CachedObject {
  RootCachedObject(this.id, {super.label});

  static Future<Byte<RootCachedObject>> create(
    String code,
    Eval eval, {
    required Disposable isAlive,
    Map<String, String>? scope,
  }) async {
    final idByte = await eval.eval(
      '\$riverpodDevtool.cache($code)',
      isAlive: isAlive,
      includeRiverpodDevtool: true,
      scope: scope,
    );

    switch (idByte) {
      case ByteError():
        return ByteError(idByte.error);
      case ByteVariable():
        break;
    }

    if (idByte.instance.length! < idByte.instance.valueAsString!.length) {
      throw StateError('CacheId value is truncated');
    }
    return ByteVariable(
      RootCachedObject(CacheId(idByte.instance.valueAsString!)),
    );
  }

  final CacheId id;

  @override
  Future<Byte<InstanceRef>> _fetchInstance(
    EvalFactory eval,
    Disposable isAlive,
  ) {
    return eval.dartCore.eval(
      '\$riverpodDevtool.getCache("$id")',
      isAlive: isAlive,
      includeRiverpodDevtool: true,
    );
  }

  Future<void> delete(EvalFactory eval, {required Disposable isAlive}) async {
    await eval.dartCore.eval(
      '\$riverpodDevtool.deleteCache("$id")',
      isAlive: isAlive,
      includeRiverpodDevtool: true,
    );
  }

  @override
  String toString() => 'CachedObject(id: $id)';
}

final class DerivedCachedObject extends CachedObject {
  DerivedCachedObject({
    required this.from,
    required this.obtainRefFromParentInstance,
    super.label,
  });

  factory DerivedCachedObject.objectField(
    CachedObject object,
    BoundField field,
  ) {
    final name = FieldKey.from(field.name);

    return DerivedCachedObject(
      from: object,
      label: switch (name) {
        PositionalFieldKey() => null,
        NamedFieldKey(:final name) => name,
      },
      obtainRefFromParentInstance: (obj) {
        final field = obj.fields!
            .whereIndexed((index, f) => FieldKey.from(f.name) == name)
            .firstOrNull;
        if (field == null) {
          throw StateError(
            'Field $name not found on object of type ${obj.classRef?.name}',
          );
        }

        return Byte.instanceRef(field.value);
      },
    );
  }

  factory DerivedCachedObject.collectionElement(
    CachedObject object,
    int index,
  ) {
    return DerivedCachedObject(
      from: object,
      obtainRefFromParentInstance: (obj) {
        final elements = obj.elements;
        if (elements == null || index < 0 || index >= elements.length) {
          throw StateError(
            'Index $index out of bounds for object of type ${obj.classRef?.name}',
          );
        }

        return Byte.instanceRef(elements[index]);
      },
    );
  }

  final CachedObject from;
  final Byte<InstanceRef> Function(Instance parent) obtainRefFromParentInstance;

  @override
  Future<Byte<InstanceRef>> _fetchInstance(
    EvalFactory eval,
    Disposable isAlive,
  ) async {
    final parentInstance = await from.read(eval, isAlive: isAlive);

    switch (parentInstance) {
      case ByteError():
        return ByteError(parentInstance.error);
      case ByteVariable():
        return obtainRefFromParentInstance(parentInstance.instance);
    }
  }
}
