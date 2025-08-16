// ignore_for_file: avoid_dynamic_calls, invalid_use_of_visible_for_testing_member, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'storage/codegen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();
}

void main() {
  /* SNIPPET START */
  testWidgets('Widget test example', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override the `storageProvider` so that our application
          // uses an in-memory storage.
          storageProvider.overrideWith((ref) {
            // Create an in-memory storage.
            final storage = Storage<String, String>.inMemory();
            // Initialize it with some data.
            storage.write(
              'todo_list',
              '{"task": "Eat a cookie"}',
              const StorageOptions(),
            );

            return storage;
          }),
        ],
        child: const MyApp(),
      ),
    );
  });

  test('Pure dart example', () async {
    final container = ProviderContainer.test(
      // Same as above, we override the `storageProvider`
      overrides: [
        storageProvider.overrideWith(
          (ref) => Storage<String, String>.inMemory(),
        ),
      ],
    );

    // TODO use container to interact with providers by hand.
  });
  /* SNIPPET END */
}
