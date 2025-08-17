// ignore_for_file: avoid_dynamic_calls

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../provider_observer_logger.dart';
import 'functional/codegen.dart';

void main() {
  testWidgets('Example test', (tester) async {
    /* SNIPPET START */
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // highlight-next-line
          userProvider.overrideWith((ref, arg) => User(name: 'User $arg')),
        ],
        child: const MyApp(),
      ),
    );
    /* SNIPPET END */
  });
}
