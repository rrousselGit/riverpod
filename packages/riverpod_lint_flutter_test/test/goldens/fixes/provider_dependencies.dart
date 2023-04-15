import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_dependencies.g.dart';

@Riverpod(dependencies: [])
int dep(DepRef ref) => 0;

@Riverpod(dependencies: [])
int dep2(Dep2Ref ref) => 0;

////////////

// expect_lint: provider_dependencies
@riverpod
int plainAnnotation(PlainAnnotationRef ref) {
  ref.watch(depProvider);
  return 0;
}

// expect_lint: provider_dependencies
@Riverpod(keepAlive: false)
int customAnnotation(CustomAnnotationRef ref) {
  ref.watch(depProvider);
  return 0;
}

// expect_lint: provider_dependencies
@Riverpod(
  keepAlive: false,
)
int customAnnotationWithTrailingComma(
  CustomAnnotationWithTrailingCommaRef ref,
) {
  ref.watch(depProvider);
  return 0;
}

@Riverpod(
  keepAlive: false,
  // expect_lint: provider_dependencies
  dependencies: [],
)
int existingDep(ExistingDepRef ref) {
  ref.watch(depProvider);
  return 0;
}

@Riverpod(
  keepAlive: false,
  // expect_lint: provider_dependencies
  dependencies: [],
)
int multipleDeps(MultipleDepsRef ref) {
  ref.watch(depProvider);
  ref.watch(dep2Provider);
  return 0;
}

@Riverpod(
  keepAlive: false,
  dependencies: [
    // expect_lint: provider_dependencies
    dep,
    dep2,
  ],
)
int extraDep(ExtraDepRef ref) {
  ref.watch(dep2Provider);
  return 0;
}

@Riverpod(
  keepAlive: false,
  dependencies: [
    // expect_lint: provider_dependencies
    dep,
  ],
)
int noDep(NoDepRef ref) {
  return 0;
}

@Riverpod(
  dependencies: [
    // expect_lint: provider_dependencies
    dep,
  ],
  keepAlive: false,
)
int dependenciesFirstThenKeepAlive(DependenciesFirstThenKeepAliveRef ref) {
  return 0;
}

@Riverpod(
  dependencies: [
    // expect_lint: provider_dependencies
    dep,
  ],
)
int noDepNoParam(NoDepNoParamRef ref) {
  return 0;
}

// expect_lint: provider_dependencies
@Riverpod(keepAlive: false, dependencies: [dep])
int noDepWithoutComma(NoDepWithoutCommaRef ref) {
  return 0;
}
