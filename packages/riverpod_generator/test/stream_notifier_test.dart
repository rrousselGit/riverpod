// ignore_for_file: omit_local_variable_types, unused_local_variable //

import 'package:riverpod/misc.dart' show ProviderBase;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/stream.dart';

void main() {
  test(
    'Creates a StreamNotifierProvider<T> if @riverpod is used on a Stream class',
    () async {
      final container = ProviderContainer.test();

      const ProviderBase<AsyncValue<String>> provider = publicClassProvider;

      expect(
        await container.listen(publicClassProvider.future, (_, __) {}).read(),
        'Hello world',
      );
    },
  );

  test('Generates .name for providers', () {
    expect(publicClassProvider.name, 'publicClassProvider');
    expect(privateClassProvider.name, '_privateClassProvider');

    expect(familyClassProvider.name, 'familyClassProvider');
    expect(familyClassProvider(42, third: .42).name, 'familyClassProvider');
  });

  test('Supports overriding non-family notifiers', () {
    final container = ProviderContainer.test(
      overrides: [
        publicClassProvider.overrideWith(() => PublicClass('Hello world')),
      ],
    );

    final notifier = container.read(publicClassProvider.notifier);
    expect(notifier.param, 'Hello world');

    // ignore: invalid_use_of_protected_member //
    expect(notifier.ref, isNotNull);
    expect(notifier.state, isNotNull);
  });

  test('Supports overriding family notifiers', () {
    final container = ProviderContainer.test(
      overrides: [
        familyClassProvider(
          42,
          third: .42,
        ).overrideWith(() => FamilyClass('Hello world')),
      ],
    );

    final notifier = container.read(
      familyClassProvider(42, third: .42).notifier,
    );
    expect(notifier.param, 'Hello world');
    expect(notifier.first, 42);
    expect(notifier.second, null);
    expect(notifier.third, .42);
    expect(notifier.fourth, true);
    expect(notifier.fifth, null);

    // ignore: invalid_use_of_protected_member //
    expect(notifier.ref, isNotNull);
    expect(notifier.state, isNotNull);
  });

  test(
    'Creates a NotifierProvider.family<T> if @riverpod is used on a synchronous function with parameters',
    () async {
      final container = ProviderContainer.test();

      const FamilyClassFamily family = familyClassProvider;

      expect(familyClassProvider(42, third: .42).from, familyClassProvider);

      expect(
        familyClassProvider(42, third: .42),
        familyClassProvider(42, third: .42),
      );
      expect(
        familyClassProvider(42, third: .42),
        isNot(familyClassProvider(42, third: .21)),
      );
      expect(
        familyClassProvider(42, third: .42).hashCode,
        isNot(familyClassProvider(42, third: .21).hashCode),
      );

      // handle defaults
      expect(
        familyClassProvider(42, third: .42),
        familyClassProvider(42, third: .42),
      );
      expect(
        familyClassProvider(42, third: .42).hashCode,
        familyClassProvider(42, third: .42).hashCode,
      );

      final FamilyClassProvider provider = familyClassProvider(
        42,
        second: 'x42',
        third: .42,
        fourth: false,
        fifth: const ['x42'],
      );
      final ProviderBase<AsyncValue<String>> futureProvider = provider;

      expect(
        await container
            .listen(
              familyClassProvider(
                42,
                second: 'x42',
                third: .42,
                fourth: false,
                fifth: const ['x42'],
              ).future,
              (_, __) {},
            )
            .read(),
        '(first: 42, second: x42, third: 0.42, fourth: false, fifth: [x42])',
      );
    },
  );
}
