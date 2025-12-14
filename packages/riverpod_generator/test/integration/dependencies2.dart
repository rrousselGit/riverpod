import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dependencies.dart';

part 'dependencies2.g.dart';

// Regression test for https://github.com/rrousselGit/riverpod/issues/2490
@Riverpod(dependencies: [providerWithDependencies, _private2, public2])
int providerWithDependencies2(Ref ref) {
  ref.watch(providerWithDependenciesProvider);
  ref.watch(_private2Provider);
  ref.watch(public2Provider);
  return 0;
}

@Riverpod(dependencies: [providerWithDependencies, _private2, public2])
int familyWithDependencies2(Ref ref, {int? id}) {
  ref.watch(providerWithDependenciesProvider);
  ref.watch(_private2Provider);
  ref.watch(public2Provider);
  return 0;
}

@Riverpod(dependencies: [providerWithDependencies, _private2, public2])
class NotifierWithDependencies extends _$NotifierWithDependencies {
  @override
  int build() {
    ref.watch(providerWithDependenciesProvider);
    ref.watch(_private2Provider);
    ref.watch(public2Provider);
    return 0;
  }
}

@Riverpod(dependencies: [providerWithDependencies, _private2, public2])
class NotifierFamilyWithDependencies extends _$NotifierFamilyWithDependencies {
  @override
  int build({int? id}) {
    ref.watch(providerWithDependenciesProvider);
    ref.watch(_private2Provider);
    ref.watch(public2Provider);
    return 0;
  }
}

@Riverpod(dependencies: [])
int _private2(Ref ref) => 0;

const private2 = _private2;

@Riverpod(dependencies: [])
int public2(Ref ref) => 0;
