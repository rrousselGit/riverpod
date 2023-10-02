import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unsupported_provider_value.g.dart';

@riverpod
int integer(IntegerRef ref) => 0;

@riverpod
// expect_lint: unsupported_provider_value
MyStateNotifier stateNotifier(StateNotifierRef ref) => MyStateNotifier();

@riverpod
// expect_lint: unsupported_provider_value
Future<MyStateNotifier> asyncStateNotifier(AsyncStateNotifierRef ref) async {
  return MyStateNotifier();
}

@riverpod
// expect_lint: unsupported_provider_value
class StateNotifierClass extends _$StateNotifierClass {
  MyStateNotifier build() => MyStateNotifier();
}

@riverpod
// expect_lint: unsupported_provider_value
Future<MyStateNotifier> stateNotifierAsync(StateNotifierAsyncRef ref) async =>
    MyStateNotifier();

// Regression tests for https://github.com/rrousselGit/riverpod/issues/2302
@riverpod
class SelfNotifier extends _$SelfNotifier {
  Future<SelfNotifier> build() async => this;
}

// Regression tests for https://github.com/rrousselGit/riverpod/issues/2302
@riverpod
class SyncSelfNotifier extends _$SyncSelfNotifier {
  SyncSelfNotifier build() => this;
}

// Regression tests for https://github.com/rrousselGit/riverpod/issues/2302
@riverpod
class StreamSelfNotifier extends _$StreamSelfNotifier {
  Stream<StreamSelfNotifier> build() => Stream.value(this);
}

@riverpod
// expect_lint: unsupported_provider_value
class StateNotifierClassAsync extends _$StateNotifierClassAsync {
  Future<MyStateNotifier> build() async => MyStateNotifier();
}

class MyStateNotifier extends StateNotifier<int> {
  MyStateNotifier() : super(0);
}

@riverpod
// expect_lint: unsupported_provider_value
MyChangeNotifier changeNotifier(ChangeNotifierRef ref) => MyChangeNotifier();

@riverpod
// expect_lint: unsupported_provider_value
class ChangeNotifierClass extends _$ChangeNotifierClass {
  MyChangeNotifier build() => MyChangeNotifier();
}

class MyChangeNotifier extends ChangeNotifier {}

@riverpod
// expect_lint: unsupported_provider_value
MyNotifier notifier(NotifierRef ref) => MyNotifier();

@riverpod
// expect_lint: unsupported_provider_value
MyAutoDisposeNotifier autoDisposeNotifier(AutoDisposeNotifierRef ref) {
  return MyAutoDisposeNotifier();
}

@riverpod
// expect_lint: unsupported_provider_value
class NotifierClass extends _$NotifierClass {
  MyNotifier build() => MyNotifier();
}

class MyNotifier extends Notifier<int> {
  @override
  int build() => 0;
}

class MyAutoDisposeNotifier extends AutoDisposeNotifier<int> {
  @override
  int build() => 0;
}

@riverpod
// expect_lint: unsupported_provider_value
MyAsyncNotifier asyncNotifier(AsyncNotifierRef ref) => MyAsyncNotifier();

@riverpod
// expect_lint: unsupported_provider_value
class AsyncNotifierClass extends _$AsyncNotifierClass {
  MyAsyncNotifier build() => MyAsyncNotifier();
}

class MyAsyncNotifier extends AsyncNotifier<int> {
  @override
  int build() => 0;
}

@riverpod
Raw<MyChangeNotifier> rawNotifier(RawNotifierRef ref) => MyChangeNotifier();

@riverpod
Raw<Future<MyChangeNotifier>> rawFutureNotifier(
  RawFutureNotifierRef ref,
) async {
  return MyChangeNotifier();
}

@riverpod
Raw<Stream<MyChangeNotifier>> rawStreamNotifier(
  RawStreamNotifierRef ref,
) async* {
  yield MyChangeNotifier();
}

@riverpod
Future<Raw<MyChangeNotifier>> futureRawNotifier(
  FutureRawNotifierRef ref,
) async {
  return MyChangeNotifier();
}

@riverpod
Stream<Raw<MyChangeNotifier>> streamRawNotifier(
  StreamRawNotifierRef ref,
) async* {
  yield MyChangeNotifier();
}
