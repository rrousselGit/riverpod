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
class StateNotifierClass extends _$StateNotifierClass {
  MyStateNotifier build() => MyStateNotifier();
}

@riverpod
// expect_lint: unsupported_provider_value
Future<MyStateNotifier> stateNotifierAsync(StateNotifierAsyncRef ref) async =>
    MyStateNotifier();

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
class NotifierClass extends _$NotifierClass {
  MyNotifier build() => MyNotifier();
}

class MyNotifier extends Notifier<int> {
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
