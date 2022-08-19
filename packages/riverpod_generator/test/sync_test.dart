// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import 'integration/sync.dart';
import 'utils.dart';

void main() {
  // TODO test that the generated providers contain the docs from the annotated element

  test('Creates a Provider<T> if @provider is used on a synchronous function',
      () {
    final container = createContainer();

    const AutoDisposeProvider<String> provider = PublicProvider;
    final String result = container.read(PublicProvider);

    expect(result, 'Hello world');
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

    const FamilyProviderFamily family = FamilyProvider;

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
        forth: true,
      ),
    );
    expect(
      FamilyProvider(42, third: .42).hashCode,
      FamilyProvider(
        42,
        third: .42,
        // ignore: avoid_redundant_argument_values
        forth: true,
      ).hashCode,
    );

    final FamilyProviderProvider provider = FamilyProvider(
      42,
      second: 'x42',
      third: .42,
      forth: false,
      fifth: ['x42'],
    );
    final AutoDisposeProvider<String> futureProvider = provider;

    expect(provider.first, 42);
    expect(provider.second, 'x42');
    expect(provider.third, .42);
    expect(provider.forth, false);
    expect(provider.fifth, ['x42']);

    final String result = container.read(
      FamilyProvider(
        42,
        second: 'x42',
        third: .42,
        forth: false,
        fifth: ['x42'],
      ),
    );

    expect(
      result,
      '(first: 42, second: x42, third: 0.42, forth: false, fifth: [x42])',
    );
  });
}
