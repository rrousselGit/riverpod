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
int emptyDependenciesStateless(EmptyDependenciesStatelessRef ref) => 0;

@Riverpod(dependencies: [])
class EmptyDependenciesStateful extends _$EmptyDependenciesStateful {
  @override
  int build() => 0;
}
