import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

@riverpod
int count(CountRef ref) {
  return 1;
}

@riverpod
FutureOr<int> countFuture(CountFutureRef ref) {
  return 1;
}

@riverpod
Stream<int> countStream(CountStreamRef ref) {
  return Stream.value(1);
}

@riverpod
class CountNotifier extends _$CountNotifier {
  @override
  int build() {
    return 1;
  }
}

@riverpod
class CountAsyncNotifier extends _$CountAsyncNotifier {
  @override
  FutureOr<int> build() {
    return 1;
  }
}

@riverpod
class CountStreamNotifier extends _$CountStreamNotifier {
  @override
  Stream<int> build() {
    return Stream.value(1);
  }
}

@riverpod
int count2(Count2Ref ref, int a) {
  return 1;
}

@riverpod
FutureOr<int> countFuture2(CountFuture2Ref ref, int a) {
  return 1;
}

@riverpod
Stream<int> countStream2(CountStream2Ref ref, int a) {
  return Stream.value(1);
}

@riverpod
class CountNotifier2 extends _$CountNotifier2 {
  @override
  int build(int a) {
    return 1;
  }
}

@riverpod
class CountAsyncNotifier2 extends _$CountAsyncNotifier2 {
  @override
  FutureOr<int> build(int a) {
    return 1;
  }
}

@riverpod
class CountStreamNotifier2 extends _$CountStreamNotifier2 {
  @override
  Stream<int> build(int a) {
    return Stream.value(1);
  }
}
