import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dependencies.g.dart';

final scoped = Provider((ref) => 0, dependencies: []);

@Riverpod(dependencies: [])
int generatedScoped(GeneratedScopedRef ref) => 0;

final root = Provider((ref) => 0);

@riverpod
int generatedRoot(GeneratedRootRef ref) => 0;

// ........

// expect_lint: provider_dependencies
@riverpod
int dependsOnScopedButNoDependencies(DependsOnScopedButNoDependenciesRef ref) {
  return ref.watch(scoped);
}
