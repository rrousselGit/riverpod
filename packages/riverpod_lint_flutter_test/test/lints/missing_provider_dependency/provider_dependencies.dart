import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_dependencies.g.dart';

@Riverpod(dependencies: [])
int dep(DepRef ref) => 0;

@Riverpod(dependencies: [])
int dep2(Dep2Ref ref) => 0;

@Riverpod(dependencies: [])
int depFamily(DepFamilyRef ref, int id) => 0;

////////////

@riverpod
int plainAnnotation(PlainAnnotationRef ref) {
  // expect_lint: missing_provider_dependency
  ref.watch(depProvider);
  return 0;
}

@Riverpod(keepAlive: false)
int customAnnotation(CustomAnnotationRef ref) {
  // expect_lint: missing_provider_dependency
  ref.watch(depProvider);
  return 0;
}

@Riverpod(
  keepAlive: false,
)
int customAnnotationWithTrailingComma(
  CustomAnnotationWithTrailingCommaRef ref,
) {
  // expect_lint: missing_provider_dependency
  ref.watch(depProvider);
  return 0;
}

@Riverpod(
  keepAlive: false,
  dependencies: [],
)
int existingDep(ExistingDepRef ref) {
  // expect_lint: missing_provider_dependency
  ref.watch(depProvider);
  return 0;
}

@Riverpod(
  keepAlive: false,
  dependencies: [],
)
int multipleDeps(MultipleDepsRef ref) {
  // expect_lint: missing_provider_dependency
  ref.watch(depProvider);
  // expect_lint: missing_provider_dependency
  ref.watch(dep2Provider);
  return 0;
}

// expect_lint: unused_provider_dependency
@Dependencies([dep])
void depFn() {}

// expect_lint: unused_provider_dependency
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

class Scope extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // expect_lint: missing_provider_dependency
    return DepWidget(
      child: ProviderScope(
        overrides: [depProvider.overrideWithValue(42)],
        child: DepWidget(),
      ),
    );
  }
}

class Scope2 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [depProvider.overrideWithValue(42)],
      // expect_lint: missing_provider_dependency
      child: Text('${ref.watch(depProvider)}'),
    );
  }
}

class ConditionalScope extends ConsumerWidget {
  ConditionalScope({super.key, required this.condition});
  final bool condition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        if (condition) depProvider.overrideWithValue(42),
      ],
      // expect_lint: missing_provider_dependency
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

class SupportsMultipleScopes extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ProviderScope(
      overrides: [depProvider.overrideWith((ref) => 0)],
      // expect_lint: missing_provider_dependency
      child: DepFamily(),
    );

    return ProviderScope(
      overrides: [depFamilyProvider.overrideWith((ref, arg) => 0)],
      // expect_lint: missing_provider_dependency
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
        child: DepFamily(
          child: DepWidget(),
        ),
      ),
    );
  }
}

class IncompleteFamilyOverride extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [depFamilyProvider(42).overrideWith((ref) => 0)],
      // expect_lint: missing_provider_dependency
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
    // ignore: missing_provider_dependency
    ref.watch(depProvider);
    return const Placeholder();
  }
}
