// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import 'integration/async.dart';
import 'utils.dart';

void main() {
  test(
      'Creates a FutureProvider<T> if @provider is used on a synchronous function',
      () {
    final container = createContainer();

    final AutoDisposeFutureProvider<String> provider = PublicProvider;
    final AsyncValue<String> result = container.read(PublicProvider);

    expect(result, const AsyncData('Hello world'));
  });

  test('Generates .name for providers', () {
    expect(PublicProvider.name, 'PublicProvider');
    expect(privateProvider.name, '_PrivateProvider');

    expect(FamilyProvider.name, 'FamilyProvider');
    expect(FamilyProvider(42, third: .42).name, 'FamilyProvider');
  });

  test('Sets cacheTime/disposeDelay to null on non-autoDispose providers', () {
    expect(PublicProvider.cacheTime, null);
    expect(PublicProvider.disposeDelay, null);

    expect(FamilyProvider.cacheTime, null);
    expect(FamilyProvider.disposeDelay, null);

    expect(FamilyProvider(42, third: .42).cacheTime, null);
    expect(FamilyProvider(42, third: .42).disposeDelay, null);
  });

  test(
      'Creates a Provider.family<T> if @provider is used on a synchronous function with parameters',
      () {
    final container = createContainer();

    final FamilyProviderFamily family = FamilyProvider;

    expect(FamilyProvider(42, third: .42).from, FamilyProvider);

    expect(
      FamilyProvider(42, third: .42),
      FamilyProvider(42, third: .42),
    );
    expect(
      FamilyProvider(42, third: .42),
      isNot(FamilyProvider(42, third: .21)),
    );
    expect(
      FamilyProvider(42, third: .42).hashCode,
      isNot(FamilyProvider(42, third: .21).hashCode),
    );

    // handle defaults
    expect(
      FamilyProvider(42, third: .42),
      FamilyProvider(
        42,
        third: .42,
        // ignore: avoid_redundant_argument_values
        fourth: true,
      ),
    );
    expect(
      FamilyProvider(42, third: .42).hashCode,
      FamilyProvider(
        42,
        third: .42,
        // ignore: avoid_redundant_argument_values
        fourth: true,
      ).hashCode,
    );

    final FamilyProviderProvider provider = FamilyProvider(
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
      FamilyProvider(
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
