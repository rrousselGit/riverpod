import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'another.g.dart';

final aProvider = Provider<int>((ref) => 0);

@riverpod
int b(BRef ref) => 0;

@Riverpod(dependencies: [])
int anotherScoped(AnotherScopedRef ref) => 0;

@Riverpod(dependencies: [anotherScoped])
int anotherNonEmptyScoped(AnotherNonEmptyScopedRef ref) {
  ref.watch(anotherScopedProvider);
  return 0;
}
