part of '../vm_service.dart';

@immutable
sealed class Byte<T> {
  const Byte();
  factory Byte._of(Object? obj) {
    switch (obj) {
      case Sentinel():
        return ByteError(SentinelExceptionType(obj));
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
      case ByteError<T>(:final error):
        throw StateError('Expected value but got error: $error');
    }
  }

  T? get valueOrNull {
    switch (this) {
      case final ByteVariable<T> that:
        return that.instance;
      case ByteError<T>():
        return null;
    }
  }

  Byte<R> map<R>(R Function(T value) fn) {
    switch (this) {
      case final ByteVariable<T> that:
        return ByteVariable(fn(that.instance));
      case ByteError<T>(:final error):
        return ByteError<R>(error);
    }
  }
}

final class ByteVariable<T> extends Byte<T> {
  const ByteVariable(this.instance);
  final T instance;

  @override
  String toString() => 'ByteVariable($instance)';

  @override
  bool operator ==(Object other) {
    return other is ByteVariable<T> && other.instance == instance;
  }

  @override
  int get hashCode => instance.hashCode;
}

final class ByteError<T> extends Byte<T> {
  const ByteError(this.error);

  final ByteErrorType error;

  @override
  String toString() => 'ByteError($error)';

  @override
  bool operator ==(Object other) {
    return other is ByteError<T> && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

@immutable
sealed class ByteErrorType {
  const ByteErrorType();
}

final class SentinelExceptionType extends ByteErrorType {
  const SentinelExceptionType(this.error);
  final Sentinel error;

  @override
  String toString() =>
      error.valueAsString ?? '<unknown sentinel error ${error.kind}>';
}

final class EvalErrorType extends ByteErrorType {
  const EvalErrorType(this.error);
  final EvalErrorException error;

  @override
  String toString() => 'EvalError: ${error.errorRef.message ?? '<no message>'}';
}

final class UnknownEvalErrorType extends ByteErrorType {
  const UnknownEvalErrorType(this.message);
  final String message;

  @override
  String toString() => 'UnknownEvalError: $message';
}

final class RPCErrorType extends ByteErrorType {
  const RPCErrorType(this.code, this.message);
  final int code;
  final String message;

  @override
  String toString() => 'RPCError(code: $code, message: $message)';
}
