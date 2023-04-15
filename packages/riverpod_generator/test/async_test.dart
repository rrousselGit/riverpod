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

  test(
      'Creates a Provider.family<T> if @riverpod is used on a synchronous function with parameters',
      () {
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
      fifth: ['x42'],
    );
    final AutoDisposeFutureProvider<String> futureProvider = provider;

    expect(provider.first, 42);
    expect(provider.second, 'x42');
    expect(provider.third, .42);
    expect(provider.fourth, false);
    expect(provider.fifth, ['x42']);

    final AsyncValue<String> result = container.read(
      familyProvider(
        42,
        second: 'x42',
        third: .42,
        fourth: false,
        fifth: ['x42'],
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
