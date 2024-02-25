import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_dependencies.g.dart';

@riverpod
int root(RootRef ref) => 0;

@Riverpod(dependencies: [])
int dep(DepRef ref) => 0;

@Riverpod(dependencies: [])
int dep2(Dep2Ref ref) => 0;

////////////

@Riverpod(
  keepAlive: false,
  dependencies: [
    // expect_lint: unused_provider_dependency
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
    // expect_lint: unused_provider_dependency
    dep,
  ],
)
int noDep(NoDepRef ref) {
  return 0;
}

@Riverpod(
  dependencies: [
    // expect_lint: unused_provider_dependency
    dep,
  ],
  keepAlive: false,
)
int dependenciesFirstThenKeepAlive(DependenciesFirstThenKeepAliveRef ref) {
  return 0;
}

@Riverpod(
  dependencies: [
    // expect_lint: unused_provider_dependency
    dep,
  ],
)
int noDepNoParam(NoDepNoParamRef ref) {
  return 0;
}

// expect_lint: unused_provider_dependency
@Riverpod(keepAlive: false, dependencies: [dep])
int noDepWithoutComma(NoDepWithoutCommaRef ref) {
  return 0;
}

@Riverpod(
  keepAlive: false,
  dependencies: [
    // expect_lint: unused_provider_dependency
    root,
  ],
)
int rootDep(RootDepRef ref) => 0;

@Dependencies([
  // expect_lint: unused_provider_dependency
  dep
])
class StateNotFound extends ConsumerStatefulWidget {
  @override
  // Can't track down state due to not typing it as StateNotFoundState
  ConsumerState<ConsumerStatefulWidget> createState() {
    // Throwing to avoid "dep" counting as used indirectly.
    throw UnimplementedError();
  }
}

class StateNotFoundState extends ConsumerState<StateNotFound> {
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

// expect_lint: unused_provider_dependency
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
