// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'create_container.dart';
import 'full_widget_test.dart';
import 'provider_to_mock/raw.dart';

void main() {
  testWidgets('Some description', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: YourWidgetYouWantToTest()),
    );
    /* SNIPPET START */
    // {@template container}
    // In unit tests, by reusing our previous "createContainer" utility.
    // {@endtemplate}
    final container = createContainer(
      // {@template providers}
      // We can specify a list of providers to mock:
      // {@endtemplate}
      overrides: [
        // {@template exampleProvider}
        // In this case, we are mocking "exampleProvider".
        // {@endtemplate}
        exampleProvider.overrideWith((ref) {
          // {@template note}
          // This function is the typical initialization function of a provider.
          // This is where you normally call "ref.watch" and return the initial state.

          // Let's replace the default "Hello world" with a custom value.
          // Then, interacting with `exampleProvider` will return this value.
          // {@endtemplate}
          return 'Hello from tests';
        }),
      ],
    );

    // {@template providerScope}
    // We can also do the same thing in widget tests using ProviderScope:
    // {@endtemplate}
    await tester.pumpWidget(
      ProviderScope(
        // {@template overrides}
        // ProviderScopes have the exact same "overrides" parameter
        // {@endtemplate}
        overrides: [
          // {@template sameAsBefore}
          // Same as before
          // {@endtemplate}
          exampleProvider.overrideWith((ref) => 'Hello from tests'),
        ],
        child: const YourWidgetYouWantToTest(),
      ),
    );
    /* SNIPPET END */
  });
}
