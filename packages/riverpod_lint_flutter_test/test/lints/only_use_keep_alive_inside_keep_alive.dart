@TestFor.only_use_keep_alive_inside_keep_alive
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_annotation.dart';

part 'only_use_keep_alive_inside_keep_alive.g.dart';

@Riverpod(keepAlive: true)
int keepAlive(Ref ref) => 42;

@Riverpod(keepAlive: true)
class KeepAliveClass extends _$KeepAliveClass {
  int build() => 0;
}

@riverpod
int autoDispose(Ref ref) => 42;

@riverpod
class AutoDisposeClass extends _$AutoDisposeClass {
  int build() => 0;
}

@Riverpod(keepAlive: true)
int fn(Ref ref) {
  ref.watch(keepAliveProvider);
  ref.watch(keepAliveClassProvider);

  // ignore: riverpod_lint/only_use_keep_alive_inside_keep_alive
  ref.watch(autoDisposeProvider);
  // ignore: riverpod_lint/only_use_keep_alive_inside_keep_alive
  ref.watch(autoDisposeClassProvider);

  return 0;
}
