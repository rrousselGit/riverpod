// This is a file testing that mixins can be applied on notifiers.
// No need to run anything, just checking that it compiles.

import 'dart:async';

import 'package:riverpod/riverpod.dart';

mixin MyMixin<StateT, ValueT, RandomT> on AnyNotifier<StateT, ValueT> {}

mixin SimpleMixin<StateT, ValueT> on AnyNotifier<StateT, ValueT> {}

class Sync extends Notifier<int> with MyMixin<int, int, int>, SimpleMixin {
  @override
  int build() => 42;
}

class SyncFamily extends FamilyNotifier<int, int>
    with MyMixin<int, int, int>, SimpleMixin {
  @override
  int build(int arg) => 42;

  SimpleMixin<int, int> simpleMixin() => this;
}

class Async extends AsyncNotifier<int>
    with MyMixin<AsyncValue<int>, int, int>, SimpleMixin {
  @override
  FutureOr<int> build() => Future.value(42);

  SimpleMixin<AsyncValue<int>, int> simpleMixin() => this;
}

class AsyncFamily extends FamilyAsyncNotifier<int, int>
    with MyMixin<AsyncValue<int>, int, int>, SimpleMixin {
  @override
  FutureOr<int> build(int arg) => Future.value(42);

  SimpleMixin<AsyncValue<int>, int> simpleMixin() => this;
}

class StreamN extends StreamNotifier<int>
    with MyMixin<AsyncValue<int>, int, int>, SimpleMixin {
  @override
  Stream<int> build() => Stream.value(42);

  SimpleMixin<AsyncValue<int>, int> simpleMixin() => this;
}

class StreamFamily extends FamilyStreamNotifier<int, int>
    with MyMixin<AsyncValue<int>, int, int>, SimpleMixin {
  @override
  Stream<int> build(int arg) => Stream.value(42);

  SimpleMixin<AsyncValue<int>, int> simpleMixin() => this;
}
