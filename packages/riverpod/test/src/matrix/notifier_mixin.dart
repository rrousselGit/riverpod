// This is a file testing that mixins can be applied on notifiers.
// No need to run anything, just checking that it compiles.

import 'dart:async';

import 'package:riverpod/riverpod.dart';

mixin MyMixin<A, B> on NotifierBase<A> {}

class Sync extends Notifier<int> with MyMixin<int, int> {
  @override
  int build() => 42;
}

class SyncFamily extends FamilyNotifier<int, int> with MyMixin<int, int> {
  @override
  int build(int arg) => 42;
}

class Async extends AsyncNotifier<int> with MyMixin<AsyncValue<int>, int> {
  @override
  FutureOr<int> build() => Future.value(42);
}

class AsyncFamily extends FamilyAsyncNotifier<int, int>
    with MyMixin<AsyncValue<int>, int> {
  @override
  FutureOr<int> build(int arg) => Future.value(42);
}

class StreamN extends StreamNotifier<int> with MyMixin<AsyncValue<int>, int> {
  @override
  Stream<int> build() => Stream.value(42);
}

class StreamFamily extends FamilyStreamNotifier<int, int>
    with MyMixin<AsyncValue<int>, int> {
  @override
  Stream<int> build(int arg) => Stream.value(42);
}
