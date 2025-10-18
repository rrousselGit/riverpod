// ignore_for_file: unused_local_variable, prefer_const_declarations, invalid_use_of_visible_for_testing_member

import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

// Mock objects for examples
final customAuth = 'customAuth';
final defaultAuth = 'defaultAuth';
final customUser = 'customUser';
final defaultUser = 'defaultUser';
final defaultSettings = 'defaultSettings';

final authProvider = Provider<String>((ref) => 'auth');
final userFamily = Provider.family<String, String>(
  (ref, userId) => 'user-$userId',
);
final settingsProvider = Provider<String>((ref) => 'settings');

void main() {
  /* SNIPPET START */

  // Default overrides used across multiple tests
  final defaultOverrides = <Override>[
    authProvider.overrideWithValue(defaultAuth),
    userFamily.overrideWith((ref, userId) => defaultUser),
    settingsProvider.overrideWithValue(defaultSettings),
  ];

  test('uses test-specific overrides with defaults as fallback', () {
    // Test-specific overrides take priority
    final testOverrides = <Override>[
      authProvider.overrideWithValue(customAuth),
      userFamily.overrideWith((ref, userId) => customUser),
    ];

    // ✅ Add default overrides only if not already present in test overrides
    for (final defaultOverride in defaultOverrides) {
      if (!testOverrides.containsOverride(defaultOverride)) {
        testOverrides.add(defaultOverride);
      }
    }

    // settingsProvider was added from defaults, but auth and user use test-specific values
    expect(testOverrides.length, 3);
  });

  /* SNIPPET END */
}
