import 'dart:async';

import 'package:meta/meta.dart';

/// A Future-like class that can emit synchronously.
///
/// This is similar to [FutureOr], but can hold errors.
@internal
abstract class Tenable<T> {
  const Tenable._();

  const factory Tenable.value(T value) = _TenableValue<T>;
  const factory Tenable.error(Object error, StackTrace stacktrace) =
      _TenableError<T>;
  factory Tenable.fromFuture(Future<T> future) = _TenableFromFuture<T>;
  factory Tenable.guardSync(T Function() cb) {
    try {
      return Tenable.value(cb());
    } catch (err, stackTrace) {
      return Tenable.error(err, stackTrace);
    }
  }
  factory Tenable.guardTenable(Tenable<T> Function() cb) {
    try {
      return cb();
    } catch (err, stackTrace) {
      return Tenable.error(err, stackTrace);
    }
  }
  factory Tenable.fromFutureOr(FutureOr<T> Function() cb) {
    try {
      final futureOr = cb();
      if (futureOr is Future<T>) {
        return Tenable.fromFuture(futureOr);
      } else {
        return Tenable.value(futureOr);
      }
    } catch (err, stackTrace) {
      return Tenable.error(err, stackTrace);
    }
  }

  Tenable<R> then<R>(
    FutureOr<R> Function(T value) cb, {
    FutureOr<R> Function(Object error, StackTrace stack)? onError,
  });

  Tenable<void> whenComplete(FutureOr<void> Function() cb) {
    return then(
      (value) => Tenable.fromFutureOr(cb),
      onError: (err, stackTrace) => Tenable.fromFutureOr(cb),
    );
  }
}

class _TenableValue<T> extends Tenable<T> {
  const _TenableValue(this.value) : super._();

  final T value;

  @override
  Tenable<R> then<R>(
    FutureOr<R> Function(T value) cb, {
    FutureOr<R> Function(Object error, StackTrace stack)? onError,
  }) {
    return Tenable<R>.fromFutureOr(() => cb(value));
  }
}

class _TenableError<T> extends Tenable<T> {
  const _TenableError(this.error, this.stackTrace) : super._();

  final Object error;
  final StackTrace stackTrace;

  @override
  Tenable<R> then<R>(
    FutureOr<R> Function(T value) cb, {
    FutureOr<R> Function(Object error, StackTrace stack)? onError,
  }) {
    if (onError == null) return Tenable.error(error, stackTrace);

    return Tenable.fromFutureOr(() => onError(error, stackTrace));
  }
}

class _TenableFromFuture<T> extends Tenable<T> {
  const _TenableFromFuture(this.future) : super._();

  final Future<T> future;

  @override
  Tenable<R> then<R>(
    FutureOr<R> Function(T value) cb, {
    FutureOr<R> Function(Object error, StackTrace stack)? onError,
  }) {
    return Tenable.fromFuture(
      future.then(
        cb,
        onError: onError,
      ),
    );
  }
}

extension OrX<T> on FutureOr<T> {
  Future<R> then<R>(
    FutureOr<R> Function(T value) cb,
  ) {
    final that = this;
    if (that is Future<T>) {
      return that.then(cb);
    } else {
      return Future.sync(() => cb(that));
    }
  }
}
