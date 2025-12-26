import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dependencies.g.dart';

@riverpod
int empty(Ref ref) => 0;

@riverpod
int emptyFamily(Ref ref, int id) => 0;

@riverpod
class Empty2 extends _$Empty2 {
  @override
  int build() => 0;
}

@riverpod
class EmptyFamily2 extends _$EmptyFamily2 {
  @override
  int build(int id) => 0;
}

@Riverpod(dependencies: [])
int dep(Ref ref) => 0;

@Riverpod(dependencies: [])
int family(Ref ref, int id) => 0;

@Riverpod(dependencies: [])
class Dep2 extends _$Dep2 {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [])
class Family2 extends _$Family2 {
  @override
  int build(int id) => 0;
}

@Riverpod(dependencies: [dep, family, Dep2, Family2])
int provider(Ref ref) {
  ref.watch(depProvider);
  ref.watch(familyProvider(1));
  ref.watch(dep2Provider);
  ref.watch(family2Provider(1));
  return 0;
}

@Riverpod(dependencies: [dep, family, Dep2, Family2])
int provider2(Ref ref) {
  ref.watch(depProvider);
  ref.watch(familyProvider(1));
  ref.watch(dep2Provider);
  ref.watch(family2Provider(1));
  return 0;
}

@Riverpod(dependencies: [dep, family, Dep2, Family2])
class Provider3 extends _$Provider3 {
  @override
  int build() {
    ref.watch(depProvider);
    ref.watch(familyProvider(1));
    ref.watch(dep2Provider);
    ref.watch(family2Provider(1));
    return 0;
  }
}

@Riverpod(dependencies: [dep, family, Dep2, Family2])
class Provider4 extends _$Provider4 {
  @override
  int build(int id) {
    ref.watch(depProvider);
    ref.watch(familyProvider(id));
    ref.watch(dep2Provider);
    ref.watch(family2Provider(id));
    return 0;
  }
}

@Riverpod(dependencies: [provider])
int transitiveDependencies(Ref ref) {
  ref.watch(providerProvider);
  return 0;
}

@Riverpod(dependencies: [dep, family, Dep2])
int smallTransitiveDependencyCount(Ref ref) {
  ref.watch(depProvider);
  ref.watch(familyProvider(1));
  ref.watch(dep2Provider);
  return 0;
}

@Riverpod(dependencies: [])
int emptyDependenciesFunctional(Ref ref) => 0;

@Riverpod(dependencies: [])
class EmptyDependenciesClassBased extends _$EmptyDependenciesClassBased {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [_privateDep, publicDep])
int providerWithDependencies(Ref ref) {
  ref.watch(_privateDepProvider);
  ref.watch(publicDepProvider);
  return 0;
}

@Riverpod(dependencies: [])
int _privateDep(Ref ref) => 0;

@Riverpod(dependencies: [])
int publicDep(Ref ref) => 0;

@Riverpod(dependencies: [dep, dep, Dep2, Dep2])
int duplicateDependencies(Ref ref) {
  ref.watch(depProvider);
  ref.watch(depProvider);
  ref.watch(dep2Provider);
  ref.watch(dep2Provider);
  return 0;
}

@Riverpod(dependencies: [family, family, Family2, Family2])
int duplicateDependencies2(Ref ref) {
  ref.watch(familyProvider(1));
  ref.watch(familyProvider(1));
  ref.watch(family2Provider(1));
  ref.watch(family2Provider(1));
  return 0;
}

@Riverpod(dependencies: [duplicateDependencies, duplicateDependencies2])
int transitiveDuplicateDependencies(Ref ref) {
  ref.watch(duplicateDependenciesProvider);
  ref.watch(duplicateDependencies2Provider);
  return 0;
}
