part of '../vm_service.dart';

@immutable
sealed class Byte<ValueT> {
  const Byte();
  factory Byte._of(Object? obj) {
    switch (obj) {
      case Sentinel():
        return ByteError(SentinelExceptionType(obj));
      case ValueT():
        return ByteVariable(obj);
      default:
        throw ArgumentError('Object $obj is neither a Sentinel nor a $ValueT');
    }
  }

  static Byte<InstanceRef> instanceRef(Object? ref) => Byte._of(ref);
  static Byte<Instance> instance(Object? instance) => Byte._of(instance);

  ByteVariable<ValueT> get require {
    switch (this) {
      case final ByteVariable<ValueT> that:
        return that;
      case ByteError<ValueT>(:final error):
        throw StateError('Expected value but got error: $error');
    }
  }

  ValueT? get valueOrNull {
    switch (this) {
      case final ByteVariable<ValueT> that:
        return that.instance;
      case ByteError<ValueT>():
        return null;
    }
  }

  Byte<OutT> map<OutT>(OutT Function(ValueT value) fn) {
    switch (this) {
      case final ByteVariable<ValueT> that:
        return ByteVariable(fn(that.instance));
      case ByteError<ValueT>(:final error):
        return ByteError<OutT>(error);
    }
  }
}

final class ByteVariable<ValueT> extends Byte<ValueT> {
  const ByteVariable(this.instance);
  final ValueT instance;

  @override
  String toString() => 'ByteVariable($instance)';

  @override
  bool operator ==(Object other) {
    return other is ByteVariable<ValueT> && other.instance == instance;
  }

  @override
  int get hashCode => instance.hashCode;
}

final class ByteError<ValueT> extends Byte<ValueT> {
  const ByteError(this.error);

  final ByteErrorType error;

  @override
  String toString() => 'ByteError($error)';

  @override
  bool operator ==(Object other) {
    return other is ByteError<ValueT> && other.error == error;
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
  String toString() => 'EvalError: ${error.errorRef.message ?? error}';
}

final class UnknownEvalErrorType extends ByteErrorType {
  const UnknownEvalErrorType(this.message);
  final String message;

  @override
  String toString() => 'UnknownEvalError: $message';
}

final class RPCErrorType extends ByteErrorType {
  const RPCErrorType(this.error);
  final RPCError error;

  @override
  String toString() => 'RPCError: $error';
}
