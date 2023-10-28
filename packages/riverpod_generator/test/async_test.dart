// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/async.dart';
import 'utils.dart';

void main() {
  test(
      'Creates a FutureProvider<T> if @riverpod is used on a FutureOr function',
      () {
    final container = createContainer();

    final AutoDisposeFutureProvider<String> provider = publicProvider;
    final AsyncValue<String> result = container.read(publicProvider);

    expect(result, const AsyncData('Hello world'));
  });

  test('Generates .name for providers', () {
    expect(publicProvider.name, 'publicProvider');
    expect(privateProvider.name, '_privateProvider');

    expect(familyProvider.name, 'familyProvider');
    expect(familyProvider(42, third: .42).name, 'familyProvider');
  });

  test('Supports overriding non-family providers', () async {
    final container = createContainer(
      overrides: [
        publicProvider.overrideWith((ref) => Future.value('Hello world')),
      ],
    );

    final result = container.read(publicProvider.future);
    expect(await result, 'Hello world');
  });

  test('Supports overriding family providers', () async {
    final container = createContainer(
      overrides: [
        familyProvider(42, third: .42).overrideWith(
          (ref) => Future.value(
            'Hello world ${ref.first} ${ref.second} '
            '${ref.third} ${ref.fourth} ${ref.fifth}',
          ),
        ),
      ],
    );

    final result = container.read(familyProvider(42, third: .42).future);
    expect(await result, 'Hello world 42 null 0.42 true null');
  });

  test(
      'Creates a Provider.family<T> if @riverpod is used on a synchronous function with parameters',
      () async {
    final container = createContainer();

    const FamilyFamily family = familyProvider;

    expect(familyProvider(42, third: .42).from, familyProvider);

    expect(
      familyProvider(42, third: .42),
      familyProvider(42, third: .42),
    );
    expect(
      familyProvider(42, third: .42),
      isNot(familyProvider(42, third: .21)),
    );
    expect(
      familyProvider(42, third: .42).hashCode,
      isNot(familyProvider(42, third: .21).hashCode),
    );

    // handle defaults
    expect(
      familyProvider(42, third: .42),
      familyProvider(
        42,
        third: .42,
        // ignore: avoid_redundant_argument_values
        fourth: true,
      ),
    );
    expect(
      familyProvider(42, third: .42).hashCode,
      familyProvider(
        42,
        third: .42,
        // ignore: avoid_redundant_argument_values
        fourth: true,
      ).hashCode,
    );

    final FamilyProvider provider = familyProvider(
      42,
      second: 'x42',
      third: .42,
      fourth: false,
      fifth: const ['x42'],
    );
    final AutoDisposeFutureProvider<String> futureProvider = provider;

    expect(provider.first, 42);
    expect(provider.second, 'x42');
    expect(provider.third, .42);
    expect(provider.fourth, false);
    expect(provider.fifth, same(const ['x42']));

    final sub = container.listen(
      familyProvider(
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
      familyProvider(
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
