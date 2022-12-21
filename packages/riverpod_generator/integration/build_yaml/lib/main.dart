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
