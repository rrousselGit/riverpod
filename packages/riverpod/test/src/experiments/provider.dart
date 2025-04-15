import 'dart:async';

import 'package:riverpod/src/framework.dart';

class TestProvider<T> with Provider2<T> {
  TestProvider(this._value);

  @override
  bool get isAutoDispose => true;

  final T Function(SyncRef<T> ref) _value;

  @override
  T build(ref) => _value(ref);

  @override
  Mutation<R> mutation<R>([Symbol? symbol]) => super.mutation(symbol);

  @override
  Call<Future<R>> mutate<R>(
    Mutation<R> mutation,
    FutureOr<R> Function(SyncRef<T> ref) cb,
  ) {
    return super.mutate(mutation, cb);
  }

  @override
  Call<R> run<R>(R Function(SyncRef<T> ref) callback) => super.run(callback);
}

class TestAsyncProvider<T> with AsyncProvider<T> {
  TestAsyncProvider(this._value);

  @override
  bool get isAutoDispose => true;

  final FutureOr<T> Function(AsyncRef<T> ref) _value;

  @override
  FutureOr<T> build(ref) => _value(ref);

  @override
  Call<R> run<R>(R Function(AsyncRef<T> ref) callback) => super.run(callback);

  @override
  Call<Future<R>> mutate<R>(
    Mutation<R> mutation,
    FutureOr<R> Function(AsyncRef<T> ref) cb,
  ) =>
      super.mutate(mutation, cb);

  @override
  Mutation<R> mutation<R>([Symbol? symbol]) => super.mutation(symbol);
}
