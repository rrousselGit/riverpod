import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'only_use_keep_alive_inside_keep_alive.g.dart';

@Riverpod(keepAlive: true)
int keepAlive(KeepAliveRef ref) => 42;

@Riverpod(keepAlive: true)
class KeepAliveClass extends _$KeepAliveClass {
  int build() => 0;
}

@riverpod
int autoDispose(AutoDisposeRef ref) => 42;

@riverpod
class AutoDisposeClass extends _$AutoDisposeClass {
  int build() => 0;
}

@Riverpod(keepAlive: true)
int fn(FnRef ref) {
  ref.watch(keepAliveProvider);
  ref.watch(keepAliveClassProvider);

  // expect_lint: only_use_keep_alive_inside_keep_alive
  ref.watch(autoDisposeProvider);
  // expect_lint: only_use_keep_alive_inside_keep_alive
  ref.watch(autoDisposeClassProvider);

  return 0;
}
