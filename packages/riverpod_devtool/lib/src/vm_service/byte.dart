part of '../vm_service.dart';

@immutable
sealed class Byte<T> {
  const Byte();
  factory Byte._of(Object? obj) {
    switch (obj) {
      case Sentinel():
        return ByteSentinel(obj);
      case T():
        return ByteVariable(obj);
      default:
        throw ArgumentError('Object $obj is neither a Sentinel nor a $T');
    }
  }

  static Byte<InstanceRef> instanceRef(Object? ref) => Byte._of(ref);
  static Byte<Instance> instance(Object? instance) => Byte._of(instance);

  ByteVariable<T> get require {
    switch (this) {
      case final ByteVariable<T> that:
        return that;
      case ByteSentinel<T>(:final sentinel):
        throw StateError('Expected VariableRef but got Sentinel: $sentinel');
    }
  }

  T? get valueOrNull {
    switch (this) {
      case final ByteVariable<T> that:
        return that.instance;
      case ByteSentinel<T>():
        return null;
    }
  }

  Byte<R> map<R>(R Function(T value) fn) {
    switch (this) {
      case final ByteVariable<T> that:
        return ByteVariable(fn(that.instance));
      case ByteSentinel<T>(:final sentinel):
        return ByteSentinel<R>(sentinel);
    }
  }
}

final class ByteVariable<T> extends Byte<T> {
  const ByteVariable(this.instance);
  final T instance;

  @override
  String toString() => 'ByteVariableRef($instance)';

  @override
  bool operator ==(Object other) {
    return other is ByteVariable<T> && other.instance == instance;
  }

  @override
  int get hashCode => instance.hashCode;
}

final class ByteSentinel<T> extends Byte<T> {
  const ByteSentinel(this.sentinel);
  final Sentinel sentinel;

  @override
  String toString() => 'ByteSentinel($sentinel)';

  @override
  bool operator ==(Object other) {
    return other is ByteSentinel<T> && other.sentinel == sentinel;
  }

  @override
  int get hashCode => sentinel.hashCode;
}
