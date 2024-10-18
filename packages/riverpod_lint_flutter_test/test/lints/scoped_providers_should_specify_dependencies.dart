// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart' hide runApp;
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scoped_providers_should_specify_dependencies.g.dart';

@Riverpod(dependencies: [])
int scoped(Ref ref) => 0;

@riverpod
external int unimplementedScoped();

@riverpod
int root(Ref ref) => 0;

// A fake runApp to check that we lint only on the official Flutter's runApp
void runApp(Widget widget) {}

void main() {
  final rootContainer = ProviderContainer(
    overrides: [
      scopedProvider.overrideWith((ref) => 0),
      unimplementedScopedProvider.overrideWith((ref) => 0),
      rootProvider.overrideWith((ref) => 0),
    ],
  );

  final scopedContainer = ProviderContainer(
    parent: rootContainer,
    overrides: [
      scopedProvider.overrideWith((ref) => 0),
      unimplementedScopedProvider.overrideWith((ref) => 0),
      // expect_lint: scoped_providers_should_specify_dependencies
      rootProvider.overrideWith((ref) => 0),
    ],
  );

  flutter.runApp(
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
      overrides: [
        scopedProvider.overrideWith((ref) => 0),
        unimplementedScopedProvider.overrideWith((ref) => 0),
        // This is not a Flutter's runApp, so the ProviderScope is considered scoped
        // expect_lint: scoped_providers_should_specify_dependencies
        rootProvider.overrideWith((ref) => 0),
      ],
      child: Container(),
    ),
  );

  flutter.runApp(
    ProviderScope(
      // ignore: deprecated_member_use
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

// Regression tests for https://github.com/rrousselGit/riverpod/issues/2340
void definitelyNotAMain() {
  final rootContainer = ProviderContainer(
    overrides: [
      scopedProvider.overrideWith((ref) => 0),
      unimplementedScopedProvider.overrideWith((ref) => 0),
      rootProvider.overrideWith((ref) => 0),
    ],
  );

  final scopedContainer = ProviderContainer(
    parent: rootContainer,
    overrides: [
      scopedProvider.overrideWith((ref) => 0),
      unimplementedScopedProvider.overrideWith((ref) => 0),
      // expect_lint: scoped_providers_should_specify_dependencies
      rootProvider.overrideWith((ref) => 0),
    ],
  );

  flutter.runApp(
    ProviderScope(
      overrides: [
        scopedProvider.overrideWith((ref) => 0),
        unimplementedScopedProvider.overrideWith((ref) => 0),
        rootProvider.overrideWith((ref) => 0),
      ],
      child: Container(),
    ),
  );

  flutter.runApp(
    ProviderScope(
      // ignore: deprecated_member_use
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

void someTestFunction() {
  final rootContainer = ProviderContainer(
    overrides: [
      scopedProvider.overrideWith((ref) => 0),
      unimplementedScopedProvider.overrideWith((ref) => 0),
      rootProvider.overrideWith((ref) => 0),
    ],
  );

  testWidgets('override repositoryProvider in test', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          scopedProvider.overrideWith((ref) => 0),
          unimplementedScopedProvider.overrideWith((ref) => 0),
          rootProvider.overrideWith((ref) => 0),
        ],
        child: Container(),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        // ignore: deprecated_member_use
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

    await tester.pumpWidget(
      Container(
        child: ProviderScope(
          overrides: [
            scopedProvider.overrideWith((ref) => 0),
            unimplementedScopedProvider.overrideWith((ref) => 0),
            // expect_lint: scoped_providers_should_specify_dependencies
            rootProvider.overrideWith((ref) => 0),
          ],
          child: Container(),
        ),
      ),
    );
  });
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
