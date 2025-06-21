import 'dart:async';

import 'package:meta/meta.dart';

/// A Future-like class that can emit synchronously.
///
/// This is similar to [FutureOr], but can hold errors.
@internal
sealed class Tenable<ValueT> {
  const Tenable._();

  const factory Tenable.value(ValueT value) = _TenableValue<ValueT>;
  const factory Tenable.error(Object error, StackTrace stacktrace) =
      _TenableError<ValueT>;
  factory Tenable.fromFuture(Future<ValueT> future) = _TenableFromFuture<ValueT>;
  factory Tenable.guardSync(ValueT Function() cb) {
    try {
      return Tenable.value(cb());
    } catch (err, stackTrace) {
      return Tenable.error(err, stackTrace);
    }
  }
  factory Tenable.guardTenable(Tenable<ValueT> Function() cb) {
    try {
      return cb();
    } catch (err, stackTrace) {
      return Tenable.error(err, stackTrace);
    }
  }
  factory Tenable.fromFutureOr(FutureOr<ValueT> Function() cb) {
    try {
      final futureOr = cb();
      if (futureOr is Future<ValueT>) {
        return Tenable.fromFuture(futureOr);
      } else {
        return Tenable.value(futureOr);
      }
    } catch (err, stackTrace) {
      return Tenable.error(err, stackTrace);
    }
  }

  Tenable<NewT> then<NewT>(
    FutureOr<NewT> Function(ValueT value) cb, {
    FutureOr<NewT> Function(Object error, StackTrace stack)? onError,
  });

  Tenable<void> whenComplete(FutureOr<void> Function() cb) {
    return then(
      (value) => Tenable.fromFutureOr(cb),
      onError: (err, stackTrace) => Tenable.fromFutureOr(cb),
    );
  }
}

class _TenableValue<ValueT> extends Tenable<ValueT> {
  const _TenableValue(this.value) : super._();

  final ValueT value;

  @override
  Tenable<NewT> then<NewT>(
    FutureOr<NewT> Function(ValueT value) cb, {
    FutureOr<NewT> Function(Object error, StackTrace stack)? onError,
  }) {
    return Tenable<NewT>.fromFutureOr(() => cb(value));
  }
}

class _TenableError<ValueT> extends Tenable<ValueT> {
  const _TenableError(this.error, this.stackTrace) : super._();

  final Object error;
  final StackTrace stackTrace;

  @override
  Tenable<NewT> then<NewT>(
    FutureOr<NewT> Function(ValueT value) cb, {
    FutureOr<NewT> Function(Object error, StackTrace stack)? onError,
  }) {
    if (onError == null) return Tenable.error(error, stackTrace);

    return Tenable.fromFutureOr(() => onError(error, stackTrace));
  }
}

class _TenableFromFuture<ValueT> extends Tenable<ValueT> {
  const _TenableFromFuture(this.future) : super._();

  final Future<ValueT> future;

  @override
  Tenable<NewT> then<NewT>(
    FutureOr<NewT> Function(ValueT value) cb, {
    FutureOr<NewT> Function(Object error, StackTrace stack)? onError,
  }) {
    return Tenable.fromFuture(
      future.then(
        cb,
        onError: onError,
      ),
    );
  }
}

@internal
extension OrX<ValueT> on FutureOr<ValueT> {
  FutureOr<NewT> then<NewT>(
    FutureOr<NewT> Function(ValueT value) cb,
  ) {
    final that = this;
    if (that is Future<ValueT>) {
      return that.then(cb);
    } else {
      try {
        return cb(that);
      } catch (err) {
        return Future.error(err);
      }
    }
  }
}
