import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

import '../../old/utils.dart';

void main() {
  group('ProviderOverride', () {
    test('TransitiveOverride.toString', () {
      final provider = Provider((_) => 42);

      expect(
        TransitiveProviderOverride(provider).toString(),
        equalsIgnoringHashCodes('Provider<int>#00000'),
      );
    });

    group('overrideWith', () {
      test('toString', () {
        final namelessProvider = Provider<int>((_) => 42);
        final namelessFamily = Provider.family<int, int>((_, __) => 42);
        final provider = Provider<int>((_) => 42, name: 'myName');
        final family = Provider.family<int, int>((_, __) => 42, name: 'myName');

        expect(
          namelessProvider.overrideWith((ref) => 42).toString(),
          equalsIgnoringHashCodes('Provider<int>#00000.overrideWith(...)'),
        );
        expect(
          namelessFamily(42).overrideWith((ref) => 42).toString(),
          equalsIgnoringHashCodes('Provider<int>#00000(42).overrideWith(...)'),
        );

        expect(
          provider.overrideWith((ref) => 42).toString(),
          'myName.overrideWith(...)',
        );
        expect(
          family(42).overrideWith((ref) => 42).toString(),
          'myName(42).overrideWith(...)',
        );
      });

      test('exposes origin in tests', () {
        final provider = Provider<int>((_) => 42);
        final override = provider.overrideWith((ref) => 42);

        expect(override.origin, provider);
      });
    });

    group('overrideWithValue', () {
      test('toString', () {
        final namelessProvider = Provider<int>((_) => 42);
        final namelessFamily = Provider.family<int, int>((_, __) => 42);
        final provider = Provider<int>((_) => 42, name: 'myName');
        final family = Provider.family<int, int>((_, __) => 42, name: 'myName');

        expect(
          namelessProvider.overrideWithValue(21).toString(),
          equalsIgnoringHashCodes('Provider<int>#00000.overrideWithValue(21)'),
        );
        expect(
          namelessFamily(42).overrideWithValue(21).toString(),
          equalsIgnoringHashCodes(
            'Provider<int>#00000(42).overrideWithValue(21)',
          ),
        );

        expect(
          provider.overrideWithValue(21).toString(),
          'myName.overrideWithValue(21)',
        );
        expect(
          family(42).overrideWithValue(21).toString(),
          'myName(42).overrideWithValue(21)',
        );
      });

      test('exposes origin in tests', () {
        final provider = Provider<int>((_) => 42);
        final override = provider.overrideWithValue(21);

        expect(override.origin, provider);
      });
    });
  });

  group('FamilyOverride', () {
    test('TransitiveOverride.toString', () {
      const f = Provider.family;

      final provider = Provider.family<int, int>((_, b) => 42);
      final provider2 = f.call<int, int>((_, b) => 42);

      expect(
        TransitiveFamilyOverride(provider2).toString(),
        equalsIgnoringHashCodes('ProviderFamily<int, int>#00000'),
      );
    });

    group('overrideWith', () {
      test('toString', () {
        final namelessFamily = Provider.family<int, int>((_, __) => 42);
        final family = Provider.family<int, int>((_, __) => 42, name: 'myName');

        expect(
          namelessFamily.overrideWith((ref, arg) => 42).toString(),
          equalsIgnoringHashCodes(
            'ProviderFamily<int, int>#00000.overrideWith(...)',
          ),
        );

        expect(
          family.overrideWith((ref, _) => 42).toString(),
          'myName.overrideWith(...)',
        );
      });

      test('exposes origin in tests', () {
        final family = Provider.family<int, int>((_, __) => 42);
        final override = family.overrideWith((ref, _) => 42);

        expect(override.origin, family);
      });
    });
  });
}
