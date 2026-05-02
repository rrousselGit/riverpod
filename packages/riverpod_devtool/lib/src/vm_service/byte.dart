part of '../vm_service.dart';

@immutable
sealed class Byte<ValueT> {
  const Byte();
  static Byte<ValueT>? _ofOrNull<ValueT>(Object? obj) {
    switch (obj) {
      case Sentinel():
        return ByteError(SentinelExceptionType(obj));
      case ValueT():
        return ByteVariable(obj);
      default:
        return null;
    }
  }

  static Byte<ValueT> _requireOf<ValueT>(Object? obj) {
    if (Byte._ofOrNull<ValueT>(obj) case final byte?) return byte;

    throw ArgumentError('Object $obj is neither a Sentinel nor a $ValueT');
  }

  static Byte<VmInstanceRef> requireInstanceRef(Object? ref) =>
      Byte._requireOf(ref);
  static Byte<VmInstance> requireInstance(Object? instance) =>
      Byte._requireOf(instance);
  static Byte<VmInstanceRef>? instanceRefOrNull(Object? ref) =>
      Byte._ofOrNull(ref);
  static Byte<VmInstance>? instanceOrNull(Object? instance) =>
      Byte._ofOrNull(instance);

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
  // ignore: prefer_const_constructors_in_immutables, errors are never const
  ByteError(this.error);

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

sealed class SentinelExceptionType extends ByteErrorType {
  factory SentinelExceptionType(Sentinel error) {
    return switch (error.kind) {
      SentinelKind.kExpired => ExpiredSentinelExceptionType(error),
      _ => GenericSentinelExceptionType(error),
    };
  }

  const SentinelExceptionType._(this.error);

  final Sentinel error;

  @override
  String toString() =>
      error.valueAsString ?? '<unknown sentinel error ${error.kind}>';
}

final class ExpiredSentinelExceptionType extends SentinelExceptionType {
  const ExpiredSentinelExceptionType(super.error) : super._();
}

final class GenericSentinelExceptionType extends SentinelExceptionType {
  const GenericSentinelExceptionType(super.error) : super._();
}

final class EvalErrorType extends ByteErrorType {
  const EvalErrorType(this.error);
  final EvalErrorException error;

  @override
  String toString() => 'EvalError: ${error.errorRef.message ?? error}';
}

final class UnknownEvalErrorType extends ByteErrorType {
  // ignore: prefer_const_constructors_in_immutables, errors are never const
  UnknownEvalErrorType(this.message);
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
