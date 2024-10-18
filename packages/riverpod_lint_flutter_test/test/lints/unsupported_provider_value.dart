import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unsupported_provider_value.g.dart';

@riverpod
int integer(Ref ref) => 0;

@riverpod
// expect_lint: unsupported_provider_value
MyStateNotifier stateNotifier(Ref ref) => MyStateNotifier();

@riverpod
// expect_lint: unsupported_provider_value
Future<MyStateNotifier> asyncStateNotifier(Ref ref) async {
  return MyStateNotifier();
}

@riverpod
// expect_lint: unsupported_provider_value
class StateNotifierClass extends _$StateNotifierClass {
  MyStateNotifier build() => MyStateNotifier();
}

@riverpod
// expect_lint: unsupported_provider_value
Future<MyStateNotifier> stateNotifierAsync(Ref ref) async => MyStateNotifier();

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
MyChangeNotifier changeNotifier(Ref ref) => MyChangeNotifier();

@riverpod
// expect_lint: unsupported_provider_value
class ChangeNotifierClass extends _$ChangeNotifierClass {
  MyChangeNotifier build() => MyChangeNotifier();
}

class MyChangeNotifier extends ChangeNotifier {}

@riverpod
// expect_lint: unsupported_provider_value
MyNotifier notifier(Ref ref) => MyNotifier();

@riverpod
// expect_lint: unsupported_provider_value
MyAutoDisposeNotifier autoDisposeNotifier(Ref ref) {
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
MyAsyncNotifier asyncNotifier(Ref ref) => MyAsyncNotifier();

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
Raw<MyChangeNotifier> rawNotifier(Ref ref) => MyChangeNotifier();

@riverpod
Raw<Future<MyChangeNotifier>> rawFutureNotifier(
  Ref ref,
) async {
  return MyChangeNotifier();
}

@riverpod
Raw<Stream<MyChangeNotifier>> rawStreamNotifier(
  Ref ref,
) async* {
  yield MyChangeNotifier();
}

@riverpod
Future<Raw<MyChangeNotifier>> futureRawNotifier(
  Ref ref,
) async {
  return MyChangeNotifier();
}

@riverpod
Stream<Raw<MyChangeNotifier>> streamRawNotifier(
  Ref ref,
) async* {
  yield MyChangeNotifier();
}
