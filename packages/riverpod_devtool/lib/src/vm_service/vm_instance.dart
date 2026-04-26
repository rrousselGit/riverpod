part of '../vm_service.dart';

extension type VmInstanceRef._(InstanceRef _raw) implements InstanceRef {
  VmInstanceRef(InstanceRef raw) : this._(raw);

  @visibleForTesting
  VmInstanceRef.string(String value, {String? id})
    : this(
        InstanceRef(
          id: id ?? value,
          kind: InstanceKind.kString,
          valueAsString: value,
          length: value.length,
        ),
      );

  @visibleForTesting
  VmInstanceRef.int(int value, {String? id})
    : this(
        InstanceRef(
          id: id ?? '$value',
          kind: InstanceKind.kInt,
          valueAsString: '$value',
        ),
      );

  static VmInstanceRef? nullable(InstanceRef? raw) {
    if (raw == null) return null;
    return VmInstanceRef(raw);
  }

  static VmInstanceRef fromObject(Object? raw) {
    return switch (raw) {
      final InstanceRef instance => VmInstanceRef(instance),
      _ => throw StateError('Expected Instance/InstanceRef, got $raw'),
    };
  }

  InstanceRef get raw => _raw;

  VmInstance? get asInstance {
    return switch (_raw) {
      final Instance instance => VmInstance(instance),
      _ => null,
    };
  }

  VmInstance get requireInstance {
    final instance = asInstance;
    if (instance != null) return instance;

    throw StateError('Expected a loaded Instance for ${_raw.id}');
  }

  bool get isLoaded => _raw is Instance;
}

extension type VmInstance._(Instance _raw) implements Instance {
  VmInstance(Instance raw) : this._(raw);

  @visibleForTesting
  VmInstance.string(String value)
    : this(
        Instance(
          id: 'string-$value',
          kind: InstanceKind.kString,
          valueAsString: value,
          length: value.length,
        ),
      );

  @visibleForTesting
  VmInstance.int(int value)
    : this(
        Instance(
          id: 'int-$value',
          kind: InstanceKind.kInt,
          valueAsString: '$value',
        ),
      );

  @visibleForTesting
  VmInstance.double(double value)
    : this(
        Instance(
          id: 'double-$value',
          kind: InstanceKind.kDouble,
          valueAsString: '$value',
        ),
      );

  @visibleForTesting
  VmInstance.bool({required bool value})
    : this(
        Instance(
          id: 'bool-$value',
          kind: InstanceKind.kBool,
          valueAsString: '$value',
        ),
      );

  @visibleForTesting
  VmInstance.null_() : this(Instance(id: 'null', kind: InstanceKind.kNull));

  @visibleForTesting
  VmInstance.type(String name)
    : this(Instance(id: 'type-$name', kind: InstanceKind.kType, name: name));

  @visibleForTesting
  VmInstance.unknownKind(String kind)
    : this(Instance(id: 'unknown-$kind', kind: kind));

  static VmInstance fromObject(Object? raw) {
    return switch (raw) {
      final Instance instance => VmInstance(instance),
      _ => throw StateError('Expected Instance, got $raw'),
    };
  }

  VmInstanceRef get ref => VmInstanceRef(_raw);
}
