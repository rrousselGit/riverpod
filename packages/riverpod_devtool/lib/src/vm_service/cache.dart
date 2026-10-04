part of '../vm_service.dart';

extension type CacheId(String value) {}

sealed class CachedObject {
  CachedObject({required this.label});

  final String? label;

  VmInstanceRef? _lastKnownRef;

  String? get _sessionId => null;
  bool get _reuseRef => true;

  bool _sessionExpired(EvalFactory eval) {
    final sessionId = _sessionId;
    return sessionId != null && sessionId != eval.sessionId;
  }

  Future<ByteErrorType?> _validateCachedSession(
    EvalFactory eval,
    Disposable isAlive,
  ) async {
    if (_sessionExpired(eval)) return const ExpiredDevtoolSessionType();
    if (_sessionId == null || _lastKnownRef == null) return null;
    // Cached children must still validate their root's remote lease, without
    // rerunning getters just to recover an already inspected value.
    var root = this;
    while (root is DerivedCachedObject) {
      root = root.from;
    }
    if (root == this) return null;
    return switch (await root.readRef(eval, isAlive)) {
      ByteError(:final error) => error,
      ByteVariable() => null,
    };
  }

  Future<Byte<VmInstance>> read(
    EvalFactory eval, {
    required Disposable isAlive,
  }) async {
    final sessionError = await _validateCachedSession(eval, isAlive);
    if (sessionError != null) return ByteError(sessionError);
    VmInstanceRef ref;
    if (_reuseRef && _lastKnownRef != null) {
      final lastKnownRef = _lastKnownRef!;
      ref = lastKnownRef;
    } else {
      final byte = await _fetchInstance(eval, isAlive);
      switch (byte) {
        case ByteVariable():
          ref = _lastKnownRef = byte.instance;
        case ByteError(error: final ExpiredSentinelExceptionType error):
          _lastKnownRef = null;
          return ByteError(error);
        case ByteError(:final error):
          return ByteError(error);
      }
    }

    return runAndRetryOnExpired(
      onRetry: () async {
        final newRef = await _fetchInstance(eval, isAlive);
        switch (newRef) {
          case ByteError(error: final ExpiredSentinelExceptionType error):
            _lastKnownRef = null;
            return error;
          case ByteError(:final error):
            return error;
          case ByteVariable():
            _lastKnownRef = ref = newRef.instance;
            return null;
        }
      },
      () async {
        final byte = await eval.dartCore.instance(ref, isAlive: isAlive);

        switch (byte) {
          case ByteVariable():
            _lastKnownRef = byte.instance.ref;
          case ByteError(error: ExpiredSentinelExceptionType()):
            _lastKnownRef = null;
          case ByteError():
        }

        return byte;
      },
    );
  }

  Future<Byte<VmInstanceRef>> readRef(
    EvalFactory eval,
    Disposable isAlive,
  ) async {
    final sessionError = await _validateCachedSession(eval, isAlive);
    if (sessionError != null) return ByteError(sessionError);
    if (_reuseRef && _lastKnownRef != null) {
      return ByteVariable(_lastKnownRef!);
    }

    return _fetchInstance(eval, isAlive);
  }

  Future<Byte<VmInstanceRef>> _fetchInstance(
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
    final sessionId = eval.factory.sessionId;
    if (sessionId == null) return ByteError(const ExpiredDevtoolSessionType());
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
      '() { RiverpodDevtool.validateSession("$sessionId"); '
      'return RiverpodDevtool.cache(($code) as Object?, '
      'sessionId: "$sessionId"); }()',
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
  String? get _sessionId {
    final separator = id.value.indexOf(':');
    return separator == -1 ? null : id.value.substring(0, separator);
  }

  // Session-owned roots must check the application-side lease even if the VM
  // object ID is still valid. Expired terminal expressions are never replayed.
  @override
  bool get _reuseRef => _sessionId == null;

  @override
  Future<Byte<VmInstanceRef>> _fetchInstance(
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

abstract class DerivedCachedObject extends CachedObject {
  DerivedCachedObject({super.label});

  factory DerivedCachedObject.getter(
    CachedObject from, {
    required String name,
    required Uri uri,
  }) = _GetterCachedObject;

  factory DerivedCachedObject.objectField(CachedObject object, FieldKey name) =
      _DelegatingDerivedCachedObject.objectField;

  factory DerivedCachedObject.collectionElement(
    CachedObject object,
    int index,
  ) = _DelegatingDerivedCachedObject.collectionElement;

  factory DerivedCachedObject.mapAssociationKey(
    CachedObject mapObject,
    int index,
  ) = _DelegatingDerivedCachedObject.mapAssociationKey;

  factory DerivedCachedObject.mapAssociationValue(
    CachedObject mapObject,
    int index,
  ) = _DelegatingDerivedCachedObject.mapAssociationValue;

  CachedObject get from;

  @override
  String? get _sessionId => from._sessionId;
}

final class _GetterCachedObject extends DerivedCachedObject {
  _GetterCachedObject(this.from, {required this.name, required this.uri})
    : super(label: name);

  @override
  final CachedObject from;
  final String name;
  final Uri uri;

  @override
  Future<Byte<VmInstanceRef>> _fetchInstance(
    EvalFactory evalFactory,
    Disposable isAlive,
  ) async {
    final parentInstance = await from.read(evalFactory, isAlive: isAlive);

    return runAndRetryOnExpired(() async {
      final eval = evalFactory.forLibrary(uri.toString());

      switch (parentInstance) {
        case ByteError():
          return ByteError(parentInstance.error);
        case ByteVariable():
          return eval.eval(
            'that.$name',
            isAlive: isAlive,
            scope: {'that': parentInstance.instance.ref.id!},
          );
      }
    });
  }
}

final class _DelegatingDerivedCachedObject extends DerivedCachedObject {
  _DelegatingDerivedCachedObject({
    required this.from,
    required this.obtainRefFromParentInstance,
    super.label,
  });

  factory _DelegatingDerivedCachedObject.objectField(
    CachedObject object,
    FieldKey name,
  ) {
    return _DelegatingDerivedCachedObject(
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

        return Byte.requireInstanceRef(field.value);
      },
    );
  }

  factory _DelegatingDerivedCachedObject.collectionElement(
    CachedObject object,
    int index,
  ) {
    return _DelegatingDerivedCachedObject(
      from: object,
      obtainRefFromParentInstance: (obj) {
        final elements = obj.elements;
        if (elements == null || index < 0 || index >= elements.length) {
          throw StateError(
            'Index $index out of bounds for object of type ${obj.classRef?.name}',
          );
        }

        return Byte.requireInstanceRef(elements[index]);
      },
    );
  }

  factory _DelegatingDerivedCachedObject.mapAssociationKey(
    CachedObject mapObject,
    int index,
  ) {
    return _DelegatingDerivedCachedObject(
      from: mapObject,
      label: 'key',
      obtainRefFromParentInstance: (obj) {
        final associations = obj.associations;
        if (associations == null || index < 0 || index >= associations.length) {
          throw StateError('Index $index out of bounds for map associations');
        }
        // Return the key from the MapAssociation at this index
        return Byte.requireInstanceRef(associations[index].key);
      },
    );
  }

  factory _DelegatingDerivedCachedObject.mapAssociationValue(
    CachedObject mapObject,
    int index,
  ) {
    return _DelegatingDerivedCachedObject(
      from: mapObject,
      label: 'value',
      obtainRefFromParentInstance: (obj) {
        final associations = obj.associations;
        if (associations == null || index < 0 || index >= associations.length) {
          throw StateError('Index $index out of bounds for map associations');
        }
        // Return the value from the MapAssociation at this index
        return Byte.requireInstanceRef(associations[index].value);
      },
    );
  }

  @override
  final CachedObject from;
  final Byte<VmInstanceRef> Function(VmInstance parent)
  obtainRefFromParentInstance;

  @override
  Future<Byte<VmInstanceRef>> _fetchInstance(
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
