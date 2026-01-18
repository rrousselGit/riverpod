@TestFor.provider_dependencies
library;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

part 'another.g.dart';

final aProvider = Provider<int>((ref) => 0);

@riverpod
int b(Ref ref) => 0;

@Riverpod(dependencies: [])
int anotherScoped(Ref ref) => 0;

@Riverpod(dependencies: [anotherScoped])
int anotherNonEmptyScoped(Ref ref) {
  ref.watch(anotherScopedProvider);
  return 0;
}
