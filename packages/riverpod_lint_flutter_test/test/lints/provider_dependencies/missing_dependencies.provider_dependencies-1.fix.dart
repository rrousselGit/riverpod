// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// [provider_dependencies?offset=3231,3237,3267,3474]
// ```
//
// // ignore: riverpod_lint/provider_dependencies
// - class Scope2 extends ConsumerWidget {
// + @Dependencies([dep])
// + class Scope2 extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
// ```
@TestFor.provider_dependencies
library;

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/experimental/scope.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

part 'missing_dependencies.provider_dependencies-1.fix.g.dart';

@Riverpod(dependencies: [])
int dep(Ref ref) => 0;

@Riverpod(dependencies: [dep])
int transitiveDep(Ref ref) => ref.watch(depProvider);

@Riverpod(dependencies: [])
int dep2(Ref ref) => 0;

@Riverpod(dependencies: [])
int depFamily(Ref ref, int id) => 0;

// ignore: riverpod_lint/provider_dependencies
@Dependencies([dep])
void depFn() {}

// ignore: riverpod_lint/provider_dependencies
@Dependencies([depFamily])
void depFamilyFn() {}

@Dependencies([dep])
class DepWidget extends StatelessWidget {
  const DepWidget({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    depFn();
    return const Placeholder();
  }
}

// ignore: riverpod_lint/provider_dependencies
@Dependencies([dep])
class UnusedDepWidget extends ConsumerWidget {
  const UnusedDepWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Placeholder();
  }
}

@Dependencies([transitiveDep])
class TransitiveDepWidget extends ConsumerWidget {
  const TransitiveDepWidget({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(transitiveDepProvider);
    return const Placeholder();
  }
}

@Dependencies([depFamily])
class DepFamily extends StatelessWidget {
  const DepFamily({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    depFamilyFn();
    return const Placeholder();
  }
}

////////////

// ignore: riverpod_lint/provider_dependencies
@riverpod
int plainAnnotation(Ref ref) {
  ref.watch(depProvider);
  return 0;
}

// ignore: riverpod_lint/provider_dependencies
@Riverpod(keepAlive: false)
int customAnnotation(Ref ref) {
  ref.watch(depProvider);
  return 0;
}

// ignore: riverpod_lint/provider_dependencies
@Riverpod(keepAlive: false)
int customAnnotationWithTrailingComma(Ref ref) {
  ref.watch(depProvider);
  return 0;
}

@Riverpod(
  keepAlive: false,
  // ignore: riverpod_lint/provider_dependencies
  dependencies: [],
)
int existingDep(Ref ref) {
  ref.watch(depProvider);
  return 0;
}

@Riverpod(
  keepAlive: false,
  // ignore: riverpod_lint/provider_dependencies
  dependencies: [],
)
int multipleDeps(Ref ref) {
  ref.watch(depProvider);
  ref.watch(dep2Provider);
  return 0;
}

class Scope extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [depProvider.overrideWithValue(42)],
      child: DepWidget(),
    );
  }
}

// ignore: riverpod_lint/provider_dependencies
class AboveScope extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DepWidget(
      child: ProviderScope(
        overrides: [depProvider.overrideWithValue(42)],
        child: Container(),
      ),
    );
  }
}

// ignore: riverpod_lint/provider_dependencies
@Dependencies([dep])
class Scope2 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [depProvider.overrideWithValue(42)],
      child: Text('${ref.watch(depProvider)}'),
    );
  }
}

// ignore: riverpod_lint/provider_dependencies
class ConditionalScope extends ConsumerWidget {
  ConditionalScope({super.key, required this.condition});
  final bool condition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [if (condition) depProvider.overrideWithValue(42)],
      child: DepWidget(),
    );
  }
}

class Scope4 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [depFamilyProvider.overrideWith((ref, arg) => 0)],
      child: DepFamily(),
    );
  }
}

class OnlyNeedToOverrideProviderWithEmptyDependencies extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [depProvider.overrideWithValue(42)],
      child: TransitiveDepWidget(),
    );
  }
}

class CanOverrideTransitiveProviderDirectly extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [transitiveDepProvider.overrideWithValue(42)],
      child: TransitiveDepWidget(),
    );
  }
}

class SupportsMultipleScopes extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ProviderScope(
      overrides: [depProvider.overrideWith((ref) => 0)],
      child: DepWidget(),
    );

    return ProviderScope(
      overrides: [depFamilyProvider.overrideWith((ref, arg) => 0)],
      child: DepFamily(),
    );
  }
}

// ignore: riverpod_lint/provider_dependencies
class SupportsMultipleScopes2 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ProviderScope(
      overrides: [depProvider.overrideWith((ref) => 0)],
      child: DepFamily(),
    );

    return ProviderScope(
      overrides: [depFamilyProvider.overrideWith((ref, arg) => 0)],
      child: DepWidget(),
    );
  }
}

class SupportsNestedScopes extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [depFamilyProvider.overrideWith((ref, arg) => 0)],
      child: ProviderScope(
        overrides: [depProvider.overrideWith((ref) => 0)],
        child: DepFamily(child: DepWidget()),
      ),
    );
  }
}

// ignore: riverpod_lint/provider_dependencies
class IncompleteFamilyOverride extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [depFamilyProvider(42).overrideWith((ref) => 0)],
      child: DepFamily(),
    );
  }
}

@Dependencies([dep])
class NotFoundWidget extends ConsumerStatefulWidget {
  @override
  _NotFoundWidgetState createState() => _NotFoundWidgetState();
}

class _NotFoundWidgetState extends ConsumerState<ConsumerStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    ref.watch(depProvider);
    return const Placeholder();
  }
}

/// Random doc to test that identifiers in docs don't trigger the lint.
/// [dep], [DepWidget], [depProvider]
@Riverpod(dependencies: [])
int providerWithDartDoc(Ref ref) => 0;
