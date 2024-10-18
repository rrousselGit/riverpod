import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dependencies.g.dart';

@riverpod
int dep(Ref ref) => 0;

@riverpod
int family(Ref ref, int id) => 0;

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
int provider(Ref ref) => 0;

@Riverpod(dependencies: [dep, family, Dep2, Family2])
int provider2(Ref ref) => 0;

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
int transitiveDependencies(Ref ref) => 0;

@Riverpod(dependencies: [dep, family, Dep2])
int smallTransitiveDependencyCount(Ref ref) => 0;

@Riverpod(dependencies: [])
int emptyDependenciesFunctional(Ref ref) => 0;

@Riverpod(dependencies: [])
class EmptyDependenciesClassBased extends _$EmptyDependenciesClassBased {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [_privateDep, publicDep])
int providerWithDependencies(Ref ref) {
  return 0;
}

@riverpod
int _privateDep(Ref ref) => 0;

@riverpod
int publicDep(Ref ref) => 0;
