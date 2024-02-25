import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'missing_dependencies.g.dart';

@Riverpod(dependencies: [])
int dep(DepRef ref) => 0;

@Riverpod(dependencies: [])
int dep2(Dep2Ref ref) => 0;

@Riverpod(dependencies: [])
int depFamily(DepFamilyRef ref, int id) => 0;

// expect_lint: provider_dependencies
@Dependencies([dep])
void depFn() {}

// expect_lint: provider_dependencies
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

class Scope extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [depProvider.overrideWithValue(42)],
      child: DepWidget(),
    );
  }
}

// expect_lint: provider_dependencies
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

// expect_lint: provider_dependencies
class Scope2 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [depProvider.overrideWithValue(42)],
      child: Text('${ref.watch(depProvider)}'),
    );
  }
}

// expect_lint: provider_dependencies
class ConditionalScope extends ConsumerWidget {
  ConditionalScope({super.key, required this.condition});
  final bool condition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        if (condition) depProvider.overrideWithValue(42),
      ],
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
      child: DepWidget(),
    );

    return ProviderScope(
      overrides: [depFamilyProvider.overrideWith((ref, arg) => 0)],
      child: DepFamily(),
    );
  }
}

// expect_lint: provider_dependencies
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
        child: DepFamily(
          child: DepWidget(),
        ),
      ),
    );
  }
}

// expect_lint: provider_dependencies
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
