// ignore_for_file: unknown_scoped_usage
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unused_dependency.g.dart';

@riverpod
int root(RootRef ref) => 0;

@Riverpod(dependencies: [])
int dep(DepRef ref) => 0;

@Riverpod(dependencies: [])
int dep2(Dep2Ref ref) => 0;

////////////

@Riverpod(
  keepAlive: false,
  // expect_lint: provider_dependencies
  dependencies: [
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
  // expect_lint: provider_dependencies
  dependencies: [
    dep,
  ],
)
int noDep(NoDepRef ref) {
  return 0;
}

@Riverpod(
  // expect_lint: provider_dependencies
  dependencies: [
    dep,
  ],
  keepAlive: false,
)
int dependenciesFirstThenKeepAlive(DependenciesFirstThenKeepAliveRef ref) {
  return 0;
}

@Riverpod(
  // expect_lint: provider_dependencies
  dependencies: [
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

@Riverpod(
  keepAlive: false,
  // expect_lint: provider_dependencies
  dependencies: [
    root,
  ],
)
int rootDep(RootDepRef ref) => 0;

// expect_lint: provider_dependencies
@Dependencies([dep])
class StateNotFound extends ConsumerStatefulWidget {
  @override
  // Can't track down state due to not typing it as StateNotFoundState
  ConsumerState<ConsumerStatefulWidget> createState() {
    // Throwing to avoid "dep" counting as used indirectly.
    throw UnimplementedError();
  }
}

// Hijack generic too to prevent finding the state from the State<T>.
class StateNotFoundState extends ConsumerState<ConsumerStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    ref.watch(depProvider);
    return const Placeholder();
  }
}

// Count the state too for determining if a dependency is unused
@Dependencies([dep])
class IndirectlyUsed extends ConsumerStatefulWidget {
  IndirectlyUsed({super.key, this.child});
  final Widget? child;

  @override
  IndirectlyUsedState createState() => IndirectlyUsedState();
}

class IndirectlyUsedState extends ConsumerState<IndirectlyUsed> {
  @override
  Widget build(BuildContext context) {
    ref.watch(depProvider);
    return const Placeholder();
  }
}

// expect_lint: provider_dependencies
@Dependencies([dep])
void fn() {}

@Dependencies([dep])
class Identifiers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    fn();
    return const Placeholder();
  }
}

// expect_lint: provider_dependencies
@Dependencies([dep2, dep])
void secondUnused() {
  dep2Provider;
}

// expect_lint: provider_dependencies
@Dependencies([
  dep2,
  dep,
])
void secondUnusedWithTrailingComma() {
  dep2Provider;
}
