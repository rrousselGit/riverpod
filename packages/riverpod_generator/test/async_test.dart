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

    const FutureProvider<String> provider = PublicProvider;
    final AsyncValue<String> result = container.read(PublicProvider);

    expect(result, const AsyncData('Hello world'));
  });

  test('Generates .name for providers', () {
    expect(PublicProvider.name, 'PublicProvider');
    expect(privateProvider.name, '_PrivateProvider');

    expect(FamilyExample.name, 'FamilyExample');
    expect(FamilyExample(42, third: .42).name, 'FamilyExample');
  });

  test('Sets cacheTime/disposeDelay to null on non-autoDispose providers', () {
    expect(PublicProvider.cacheTime, null);
    expect(PublicProvider.disposeDelay, null);

    expect(FamilyExample.cacheTime, null);
    expect(FamilyExample.disposeDelay, null);

    expect(FamilyExample(42, third: .42).cacheTime, null);
    expect(FamilyExample(42, third: .42).disposeDelay, null);
  });

  test(
      'Creates a Provider.family<T> if @provider is used on a synchronous function with parameters',
      () {
    final container = createContainer();

    const FamilyExampleFamily family = FamilyExample;

    expect(FamilyExample(42, third: .42).from, FamilyExample);

    expect(
      FamilyExample(42, third: .42),
      FamilyExample(42, third: .42),
    );
    expect(
      FamilyExample(42, third: .42),
      isNot(FamilyExample(42, third: .21)),
    );
    expect(
      FamilyExample(42, third: .42).hashCode,
      isNot(FamilyExample(42, third: .21).hashCode),
    );

    // handle defaults
    expect(
      FamilyExample(42, third: .42),
      FamilyExample(
        42,
        third: .42,
        // ignore: avoid_redundant_argument_values
        forth: true,
      ),
    );
    expect(
      FamilyExample(42, third: .42).hashCode,
      FamilyExample(
        42,
        third: .42,
        // ignore: avoid_redundant_argument_values
        forth: true,
      ).hashCode,
    );

    final FamilyExampleProvider provider = FamilyExample(
      42,
      second: 'x42',
      third: .42,
      forth: false,
      fifth: ['x42'],
    );
    final FutureProvider<String> futureProvider = provider;

    expect(provider.first, 42);
    expect(provider.second, 'x42');
    expect(provider.third, .42);
    expect(provider.forth, false);
    expect(provider.fifth, ['x42']);

    final AsyncValue<String> result = container.read(
      FamilyExample(
        42,
        second: 'x42',
        third: .42,
        forth: false,
        fifth: ['x42'],
      ),
    );

    expect(
      result,
      const AsyncData(
          '(first: 42, second: x42, third: 0.42, forth: false, fifth: [x42])'),
    );
  });
}
