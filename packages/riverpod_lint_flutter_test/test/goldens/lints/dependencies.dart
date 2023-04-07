import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dependencies.g.dart';

@riverpod
external int unimplementedScoped();

@Riverpod(dependencies: [])
int dep(DepRef ref) => 0;

final scoped = Provider((ref) => 0, dependencies: []);

@Riverpod(dependencies: [])
int generatedScoped(GeneratedScopedRef ref) => 0;

final root = Provider((ref) => 0);

@riverpod
int generatedRoot(GeneratedRootRef ref) => 0;

// dep no "dependencies"

@riverpod
int watchScopedButNoDependencies(WatchScopedButNoDependenciesRef ref) {
  // expect_lint: avoid_manual_providers_as_generated_provider_dependency
  return ref.watch(scoped);
}

// expect_lint: provider_dependencies
@riverpod
int watchExternalButNoDependencies(WatchExternalButNoDependenciesRef ref) {
  return ref.watch(unimplementedScopedProvider);
}

// expect_lint: provider_dependencies
@riverpod
int watchGeneratedScopedButNoDependencies(
  WatchGeneratedScopedButNoDependenciesRef ref,
) {
  return ref.watch(generatedScopedProvider);
}

@riverpod
int watchRootButNoDependencies(WatchRootButNoDependenciesRef ref) {
  // expect_lint: avoid_manual_providers_as_generated_provider_dependency
  return ref.watch(root);
}

@riverpod
int watchGeneratedRootButNoDependencies(
  WatchGeneratedRootButNoDependenciesRef ref,
) {
  return ref.watch(generatedRootProvider);
}

// Check "dependencies" specfied but missing dependency

@Riverpod(dependencies: [])
int watchScopedButEmptyDependencies(WatchScopedButEmptyDependenciesRef ref) {
  // expect_lint: avoid_manual_providers_as_generated_provider_dependency
  return ref.watch(scoped);
}

// expect_lint: provider_dependencies
@Riverpod(dependencies: [])
int watchGeneratedScopedButEmptyDependencies(
  WatchGeneratedScopedButEmptyDependenciesRef ref,
) {
  return ref.watch(generatedScopedProvider);
}

@Riverpod(dependencies: [])
int watchRootButEmptyDependencies(WatchRootButEmptyDependenciesRef ref) {
  // expect_lint: avoid_manual_providers_as_generated_provider_dependency
  return ref.watch(root);
}

@Riverpod(dependencies: [])
int watchGeneratedRootButEmptyDependencies(
  WatchGeneratedRootButEmptyDependenciesRef ref,
) {
  return ref.watch(generatedRootProvider);
}

// Check "dependencies" specfied but missing dependency

@Riverpod(dependencies: [dep])
int watchScopedButMissingDependencies(
  WatchScopedButMissingDependenciesRef ref,
) {
  ref.watch(depProvider);
  // expect_lint: avoid_manual_providers_as_generated_provider_dependency
  return ref.watch(scoped);
}

// expect_lint: provider_dependencies
@Riverpod(dependencies: [dep])
int watchGeneratedScopedButMissingDependencies(
  WatchGeneratedScopedButMissingDependenciesRef ref,
) {
  ref.watch(depProvider);
  return ref.watch(generatedScopedProvider);
}

@Riverpod(dependencies: [dep])
int watchRootButMissingDependencies(WatchRootButMissingDependenciesRef ref) {
  ref.watch(depProvider);
  // expect_lint: avoid_manual_providers_as_generated_provider_dependency
  return ref.watch(root);
}

@Riverpod(dependencies: [dep])
int watchGeneratedRootButMissingDependencies(
  WatchGeneratedRootButMissingDependenciesRef ref,
) {
  ref.watch(depProvider);
  return ref.watch(generatedRootProvider);
}

// Check "dependencies" specfied and contains dependency

@Riverpod(dependencies: [generatedScoped])
int watchGeneratedScopedAndContainsDependency(
  WatchGeneratedScopedAndContainsDependencyRef ref,
) {
  return ref.watch(generatedScopedProvider);
}

@Riverpod(dependencies: [
  // The dependency is redundant because it is not a scoped provider
  // expect_lint: provider_dependencies
  generatedRoot,
])
int watchGeneratedRootAndContainsDependency(
  WatchGeneratedRootAndContainsDependencyRef ref,
) {
  return ref.watch(generatedRootProvider);
}

// A dependency is specified but never used

@Riverpod(dependencies: [
  dep,
  // expect_lint: provider_dependencies
  generatedRoot,
])
int specifiedDependencyButNeverUsed(SpecifiedDependencyButNeverUsedRef ref) {
  ref.watch(depProvider);
  return 0;
}

// Works with classes too

@Riverpod(dependencies: [])
class ClassWatchGeneratedRootButMissingDependencies
    extends _$ClassWatchGeneratedRootButMissingDependencies {
  @override
  int build() {
    return ref.watch(generatedRootProvider);
  }
}

// expect_lint: provider_dependencies
@Riverpod(dependencies: [])
class ClassWatchGeneratedScopedButMissingDependencies
    extends _$ClassWatchGeneratedScopedButMissingDependencies {
  @override
  int build() {
    return ref.watch(generatedScopedProvider);
  }
}

@Riverpod(dependencies: [generatedScoped])
int regression2348(Regression2348Ref ref) {
  ref..watch(generatedScopedProvider);
  return 0;
}

@Riverpod(dependencies: [generatedScoped])
class Regression2417 extends _$Regression2417 {
  @override
  int build() => 0;

  void method() {
    ref.watch(generatedScopedProvider);
  }
}
