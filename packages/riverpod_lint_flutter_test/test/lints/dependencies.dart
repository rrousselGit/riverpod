// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'another.dart' as import_alias;

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
  // expect_lint: avoid_manual_providers_as_generated_provider_dependency
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
  // expect_lint: avoid_manual_providers_as_generated_provider_dependency
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

// Check "dependencies" specified but missing dependency

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

// Check "dependencies" specified and contains dependency

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
  // expect_lint: avoid_manual_providers_as_generated_provider_dependency
  ref.watch(import_alias.aProvider);
  ref.watch(import_alias.bProvider);
  return 0;
}

// Regression test for https://github.com/rrousselGit/riverpod/issues/2935
@riverpod
class AliasClass extends _$AliasClass {
  // expect_lint: avoid_manual_providers_as_generated_provider_dependency
  late final int _a = ref.read(import_alias.aProvider);
  late final int _b = ref.read(import_alias.bProvider);

  @override
  int build() => 0;
}

// === @Dependencies ===

// Can specify dependencies on top-level declarations
@Dependencies([dep])
class RootDependenciesClass {}

// Specifying @Dependencies on class members requires specifying them on
// the class too:
class MemberDependencies {
  @Dependencies([
    // expect_lint: dependencies
    dep,
  ])
  int build() => 0;
}

@Dependencies([dep])
class MemberDependencies2 {
  @Dependencies([dep])
  int build() => 0;
}

@Dependencies([])
class MemberDependencies3 {
  // expect_lint: dependencies
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
@Dependencies([dep])
void fn() {}

void fn2() {
  // expect_lint: dependencies
  fn();
}

@Dependencies([dep])
void fn3() => fn();

@riverpod
int foo(FooRef ref) {
  // expect_lint: dependencies
  fn();
  return 0;
}

// Handle widget with dependencies
@Dependencies([dep])
class WidgetDependencies extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox();
}

class WidgetDependencies2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // expect_lint: dependencies
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

// expect_lint: dependencies
@Dependencies([])
class Stateful2 extends StatefulWidget {
  const Stateful2({super.key});

  @override
  State<Stateful2> createState() => _Stateful2State();
}

class _Stateful2State extends State<Stateful2> {
  @override
  Widget build(BuildContext context) {
    return WidgetDependencies();
  }
}
