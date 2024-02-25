// ignore_for_file: unused_field, avoid_manual_providers_as_generated_provider_dependency

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../another.dart' as import_alias;

part 'dependencies.g.dart';

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
  return ref.watch(scoped);
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
  return ref.watch(root);
}

@riverpod
int watchGeneratedRootButNoDependencies(
  WatchGeneratedRootButNoDependenciesRef ref,
) {
  return ref.watch(generatedRootProvider);
}

// Check "dependencies" specified but missing dependency
@Riverpod(dependencies: [])
int watchScopedButEmptyDependencies(WatchScopedButEmptyDependenciesRef ref) {
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
  return ref.watch(root);
}

@Riverpod(dependencies: [])
int watchGeneratedRootButEmptyDependencies(
  WatchGeneratedRootButEmptyDependenciesRef ref,
) {
  return ref.watch(generatedRootProvider);
}

// Check "dependencies" specified and contains dependency
@Riverpod(dependencies: [generatedScoped])
int watchGeneratedScopedAndContainsDependency(
  WatchGeneratedScopedAndContainsDependencyRef ref,
) {
  return ref.watch(generatedScopedProvider);
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

// Regression for https://github.com/rrousselGit/riverpod/issues/2909
@Riverpod(dependencies: [dep])
int familyDep(FamilyDepRef ref, int p) {
  final test = ref.watch(depProvider);
  return test * p;
}

@Riverpod(dependencies: [familyDep])
int familyDep2(FamilyDep2Ref ref, int p) {
  final test = ref.watch(familyDepProvider(0));
  return test * p;
}

// Regression test for https://github.com/rrousselGit/riverpod/issues/2935
@riverpod
int alias(AliasRef ref) {
  ref.watch(import_alias.aProvider);
  ref.watch(import_alias.bProvider);
  return 0;
}

// Regression test for https://github.com/rrousselGit/riverpod/issues/2935
@riverpod
class AliasClass extends _$AliasClass {
  late final int _a = ref.read(import_alias.aProvider);
  late final int _b = ref.read(import_alias.bProvider);

  @override
  int build() => 0;
}

// === @Dependencies ===

// Can specify dependencies on top-level declarations
@Dependencies([dep])
class RootDependenciesClass {
  void foo() {
    fn();
  }
}

// Specifying @Dependencies on class members requires specifying them on
// the class too:
class MemberDependencies {
  // expect_lint: provider_dependencies
  @Dependencies([dep])
  int build() => 0;
}

@Dependencies([])
class MemberDependencies3 {
  // expect_lint: provider_dependencies
  @Dependencies([dep])
  int build() => 0;
}

// Counts @Riverpod dependencies too
@Riverpod(dependencies: [dep])
class RiverpodDependencies extends _$RiverpodDependencies {
  @Dependencies([dep])
  @override
  int build() {
    ref.watch(depProvider);
    return 0;
  }
}

// Handle identifiers with dependencies
// expect_lint: provider_dependencies
@Dependencies([dep])
void fn() {}

// expect_lint: provider_dependencies
void fn2() {
  fn();
}

@Dependencies([dep])
void fn3() => fn();

// expect_lint: provider_dependencies
@riverpod
int foo(FooRef ref) {
  fn();
  return 0;
}

// Handle widget with dependencies
@Dependencies([dep])
class WidgetDependencies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    fn();
    return const SizedBox();
  }
}

// expect_lint: provider_dependencies
class WidgetDependencies2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetDependencies();
  }
}

@Dependencies([dep])
class WidgetDependencies3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetDependencies();
  }
}

@Dependencies([dep])
class Stateful extends StatefulWidget {
  const Stateful({super.key});

  @override
  State<Stateful> createState() => _StatefulState();
}

class _StatefulState extends State<Stateful> {
  @override
  Widget build(BuildContext context) {
    return WidgetDependencies();
  }
}

@Dependencies([])
class Stateful2 extends StatefulWidget {
  const Stateful2({super.key});

  @override
  State<Stateful2> createState() => _Stateful2State();
}

// expect_lint: provider_dependencies
class _Stateful2State extends State<Stateful2> {
  @override
  Widget build(BuildContext context) {
    return WidgetDependencies();
  }
}

// expect_lint: provider_dependencies
class Stateful3 extends StatefulWidget {
  const Stateful3({super.key});

  @override
  State<Stateful3> createState() => _Stateful3State();
}

// expect_lint: provider_dependencies
@Dependencies([dep])
class _Stateful3State extends State<Stateful3> {
  @override
  Widget build(BuildContext context) => Container();
}
