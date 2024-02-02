import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dependencies.g.dart';

@riverpod
int dep(DepRef ref) => 0;

@riverpod
int family(DepRef ref, int id) => 0;

@riverpod
class Dep2 extends _$Dep2 {
  @override
  int build() => 0;
}

@riverpod
class Family2 extends _$Family2 {
  @override
  int build(int id) => 0;
}

@Riverpod(dependencies: [dep, family, Dep2, Family2])
int provider(ProviderRef ref) => 0;

@Riverpod(dependencies: [dep, family, Dep2, Family2])
int provider2(Provider2Ref ref) => 0;

@Riverpod(dependencies: [dep, family, Dep2, Family2])
class Provider3 extends _$Provider3 {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [dep, family, Dep2, Family2])
class Provider4 extends _$Provider4 {
  @override
  int build(int id) => 0;
}

@Riverpod(dependencies: [provider])
int transitiveDependencies(TransitiveDependenciesRef ref) => 0;

@Riverpod(dependencies: [dep, family, Dep2])
int smallTransitiveDependencyCount(SmallTransitiveDependencyCountRef ref) => 0;

@Riverpod(dependencies: [])
int emptyDependenciesFunctional(EmptyDependenciesFunctionalRef ref) => 0;

@Riverpod(dependencies: [])
class EmptyDependenciesClassBased extends _$EmptyDependenciesClassBased {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [_privateDep, publicDep])
int providerWithDependencies(ProviderWithDependenciesRef ref) {
  return 0;
}

@riverpod
int _privateDep(_PrivateDepRef ref) => 0;

@riverpod
int publicDep(PublicDepRef ref) => 0;
