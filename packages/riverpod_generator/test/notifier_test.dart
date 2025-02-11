// ignore_for_file: omit_local_variable_types, unused_local_variable //

import 'package:riverpod/riverpod.dart' show ProviderBase, ProviderContainer;
import 'package:test/test.dart';

import 'integration/sync.dart';

void main() {
  test('Creates a Provider<T> if @riverpod is used on a synchronous function',
      () {
    final container = ProviderContainer.test();

    const ProviderBase<String> provider = publicClassProvider;
    final String result = container.read(publicProvider);

    expect(result, 'Hello world');
  });

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
        familyClassProvider(42, third: .42)
            .overrideWith(() => FamilyClass('Hello world')),
      ],
    );

    final notifier =
        container.read(familyClassProvider(42, third: .42).notifier);
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
      () {
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
      familyClassProvider(
        42,
        third: .42,
      ),
    );
    expect(
      familyClassProvider(42, third: .42).hashCode,
      familyClassProvider(
        42,
        third: .42,
      ).hashCode,
    );

    final FamilyClassProvider provider = familyClassProvider(
      42,
      second: 'x42',
      third: .42,
      fourth: false,
      fifth: ['x42'],
    );
    // ignore: invalid_use_of_internal_member //
    final ProviderBase<String> futureProvider = provider;

    final String result = container.read(
      familyClassProvider(
        42,
        second: 'x42',
        third: .42,
        fourth: false,
        fifth: ['x42'],
      ),
    );

    expect(
      result,
      '(first: 42, second: x42, third: 0.42, fourth: false, fifth: [x42])',
    );
  });
}
