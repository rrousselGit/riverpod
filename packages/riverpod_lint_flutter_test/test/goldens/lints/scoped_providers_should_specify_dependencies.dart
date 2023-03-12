import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scoped_providers_should_specify_dependencies.g.dart';

@Riverpod(dependencies: [])
int scoped(ScopedRef ref) => 0;

@riverpod
external int unimplementedScoped();

@riverpod
int root(RootRef ref) => 0;

void main() {
  final rootContainer = ProviderContainer(
    overrides: [
      scopedProvider.overrideWith((ref) => 0),
      unimplementedScopedProvider.overrideWith((ref) => 0),
      rootProvider.overrideWith((ref) => 0),
    ],
  );

  // ignore: unused_local_variable
  final scopedContainer = ProviderContainer(
    parent: rootContainer,
    overrides: [
      scopedProvider.overrideWith((ref) => 0),
      unimplementedScopedProvider.overrideWith((ref) => 0),
      // expect_lint: scoped_providers_should_specify_dependencies
      rootProvider.overrideWith((ref) => 0),
    ],
  );

  runApp(
    ProviderScope(
      overrides: [
        scopedProvider.overrideWith((ref) => 0),
        unimplementedScopedProvider.overrideWith((ref) => 0),
        rootProvider.overrideWith((ref) => 0),
      ],
      child: Container(),
    ),
  );

  runApp(
    ProviderScope(
      parent: rootContainer,
      overrides: [
        scopedProvider.overrideWith((ref) => 0),
        unimplementedScopedProvider.overrideWith((ref) => 0),
        // expect_lint: scoped_providers_should_specify_dependencies
        rootProvider.overrideWith((ref) => 0),
      ],
      child: Container(),
    ),
  );
}

Widget fn() {
  return ProviderScope(
    overrides: [
      scopedProvider.overrideWith((ref) => 0),
      unimplementedScopedProvider.overrideWith((ref) => 0),
      // expect_lint: scoped_providers_should_specify_dependencies
      rootProvider.overrideWith((ref) => 0),
    ],
    child: Container(),
  );
}

void showModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return ProviderScope(
        overrides: [
          scopedProvider.overrideWith((ref) => 0),
          unimplementedScopedProvider.overrideWith((ref) => 0),
          // expect_lint: scoped_providers_should_specify_dependencies
          rootProvider.overrideWith((ref) => 0),
        ],
        child: Container(),
      );
    },
  );
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        scopedProvider.overrideWith((ref) => 0),
        unimplementedScopedProvider.overrideWith((ref) => 0),
        // expect_lint: scoped_providers_should_specify_dependencies
        rootProvider.overrideWith((ref) => 0),
      ],
      child: Container(),
    );
  }
}
