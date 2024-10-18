import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_dependencies.g.dart';

@Riverpod(dependencies: [])
int dep(Ref ref) => 0;

@Riverpod(dependencies: [])
int dep2(Ref ref) => 0;

////////////

// expect_lint: provider_dependencies
@riverpod
int plainAnnotation(Ref ref) {
  ref.watch(depProvider);
  return 0;
}

// expect_lint: provider_dependencies
@Riverpod(keepAlive: false)
int customAnnotation(Ref ref) {
  ref.watch(depProvider);
  return 0;
}

// expect_lint: provider_dependencies
@Riverpod(
  keepAlive: false,
)
int customAnnotationWithTrailingComma(
  Ref ref,
) {
  ref.watch(depProvider);
  return 0;
}

@Riverpod(
  keepAlive: false,
  // expect_lint: provider_dependencies
  dependencies: [],
)
int existingDep(Ref ref) {
  ref.watch(depProvider);
  return 0;
}

@Riverpod(
  keepAlive: false,
  // expect_lint: provider_dependencies
  dependencies: [],
)
int multipleDeps(Ref ref) {
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
int extraDep(Ref ref) {
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
int noDep(Ref ref) {
  return 0;
}

@Riverpod(
  dependencies: [
    // expect_lint: provider_dependencies
    dep,
  ],
  keepAlive: false,
)
int dependenciesFirstThenKeepAlive(Ref ref) {
  return 0;
}

@Riverpod(
  dependencies: [
    // expect_lint: provider_dependencies
    dep,
  ],
)
int noDepNoParam(Ref ref) {
  return 0;
}

// expect_lint: provider_dependencies
@Riverpod(keepAlive: false, dependencies: [dep])
int noDepWithoutComma(Ref ref) {
  return 0;
}
