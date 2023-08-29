// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/async.dart';
import 'utils.dart';

void main() {
  test(
      'Creates an AsyncNotifierProvider<T> if @riverpod is used on an async class',
      () {
    final container = createContainer();

    final AutoDisposeAsyncNotifierProvider<PublicClass, String> provider =
        publicClassProvider;
    final AsyncValue<String> result = container.read(publicClassProvider);

    expect(result, const AsyncData('Hello world'));
  });

  test('Generates .name for providers', () {
    expect(publicClassProvider.name, 'publicClassProvider');
    expect(privateClassProvider.name, '_privateClassProvider');

    expect(familyClassProvider.name, 'familyClassProvider');
    expect(familyClassProvider(42, third: .42).name, 'familyClassProvider');
  });

  test('Supports overriding non-family notifiers', () {
    final container = createContainer(
      overrides: [
        publicClassProvider.overrideWith(() => PublicClass('Hello world')),
      ],
    );

    final notifier = container.read(publicClassProvider.notifier);
    expect(notifier.param, 'Hello world');

    expect(notifier.ref, isNotNull);
    expect(notifier.state, isNotNull);
  });

  test('Supports overriding family notifiers', () {
    final container = createContainer(
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

    expect(notifier.ref, isNotNull);
    expect(notifier.state, isNotNull);
  });

  test(
      'Creates a NotifierProvider.family<T> if @riverpod is used on a synchronous function with parameters',
      () async {
    final container = createContainer();

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
        // ignore: avoid_redundant_argument_values
        fourth: true,
      ),
    );
    expect(
      familyClassProvider(42, third: .42).hashCode,
      familyClassProvider(
        42,
        third: .42,
        // ignore: avoid_redundant_argument_values
        fourth: true,
      ).hashCode,
    );

    final FamilyClassProvider provider = familyClassProvider(
      42,
      second: 'x42',
      third: .42,
      fourth: false,
      fifth: const ['x42'],
    );
    // ignore: invalid_use_of_internal_member
    final AutoDisposeAsyncNotifierProviderImpl<FamilyClass, String>
        futureProvider = provider;

    expect(provider.first, 42);
    expect(provider.second, 'x42');
    expect(provider.third, .42);
    expect(provider.fourth, false);
    expect(provider.fifth, same(const ['x42']));

    final sub = container.listen(
      familyClassProvider(
        42,
        second: 'x42',
        third: .42,
        fourth: false,
        fifth: const ['x42'],
      ).future,
      (previous, next) {},
    );
    await sub.read();

    final AsyncValue<String> result = container.read(
      familyClassProvider(
        42,
        second: 'x42',
        third: .42,
        fourth: false,
        fifth: const ['x42'],
      ),
    );

    expect(
      result,
      const AsyncData(
        '(first: 42, second: x42, third: 0.42, fourth: false, fifth: [x42])',
      ),
    );
  });
}
