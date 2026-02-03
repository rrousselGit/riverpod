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

    return runAndRetryOnExpired(
      onRetry: () async {
        final newRef = await _fetchInstance(eval, isAlive);
        switch (newRef) {
          case ByteError():
            return newRef.error;
          case ByteVariable():
            _lastKnownRef = ref = newRef.instance;
            return null;
        }
      },
      () async {
        final byte = await eval.dartCore.instance(ref, isAlive: isAlive);

        _lastKnownRef = switch (byte) {
          ByteVariable() => byte.instance,
          ByteError() => null,
        };

        return byte;
      },
    );
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
    // No retry because retrying <code> could have side-effects.
    final devtoolRef = await eval.factory.riverpodFramework.eval(
      'RiverpodDevtool.instance',
      isAlive: isAlive,
    );
    switch (devtoolRef) {
      case ByteError():
        return ByteError(devtoolRef.error);
      case ByteVariable():
        break;
    }
    final idByte = await eval.eval(
      // Casting to allow assigning `void`
      'RiverpodDevtool.cache(($code) as Object?)',
      isAlive: isAlive,
      scope: {...?scope, 'RiverpodDevtool': devtoolRef.instance.id!},
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
    return eval.riverpodFramework.eval(
      'RiverpodDevtool.instance.getCache("$id")',
      isAlive: isAlive,
    );
  }

  Future<void> delete(EvalFactory eval, {required Disposable isAlive}) async {
    await eval.riverpodFramework.eval(
      'RiverpodDevtool.instance.deleteCache("$id")',
      isAlive: isAlive,
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

  factory DerivedCachedObject.mapAssociationKey(
    CachedObject mapObject,
    int index,
  ) {
    return DerivedCachedObject(
      from: mapObject,
      label: 'key',
      obtainRefFromParentInstance: (obj) {
        final associations = obj.associations;
        if (associations == null || index < 0 || index >= associations.length) {
          throw StateError('Index $index out of bounds for map associations');
        }
        // Return the key from the MapAssociation at this index
        return Byte.instanceRef(associations[index].key);
      },
    );
  }

  factory DerivedCachedObject.mapAssociationValue(
    CachedObject mapObject,
    int index,
  ) {
    return DerivedCachedObject(
      from: mapObject,
      label: 'value',
      obtainRefFromParentInstance: (obj) {
        final associations = obj.associations;
        if (associations == null || index < 0 || index >= associations.length) {
          throw StateError('Index $index out of bounds for map associations');
        }
        // Return the value from the MapAssociation at this index
        return Byte.instanceRef(associations[index].value);
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
