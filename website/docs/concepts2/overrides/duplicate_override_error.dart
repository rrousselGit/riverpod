// ignore_for_file: unused_local_variable, prefer_const_declarations, invalid_use_of_visible_for_testing_member

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

final authProvider = Provider<Object>((ref) => 'auth');

// Mock classes
class MockAuth {}

class FakeAuth {}

void main() {
  /* SNIPPET START */

  final defaultOverrides = [authProvider.overrideWithValue(MockAuth())];

  test('my test', () {
    final container = ProviderContainer(
      overrides: [
        ...defaultOverrides,
        // ❌ This will throw at runtime!
        // authProvider is already in defaultOverrides
        authProvider.overrideWithValue(FakeAuth()),
      ],
    );
  });

  /* SNIPPET END */
}
