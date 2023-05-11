import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dependencies.dart';

part 'dependencies2.g.dart';

// Regression test for https://github.com/rrousselGit/riverpod/issues/2490
@Riverpod(dependencies: [providerWithDependencies, _private2, public2])
int providerWithDependencies2(ProviderWithDependencies2Ref ref) {
  return 0;
}

@riverpod
int _private2(_Private2Ref ref) => 0;

@riverpod
int public2(Public2Ref ref) => 0;
