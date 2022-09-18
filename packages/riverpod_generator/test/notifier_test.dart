// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/sync.dart';
import 'utils.dart';

void main() {
  test('Creates a Provider<T> if @provider is used on a synchronous function',
      () {
    final container = createContainer();

    final AutoDisposeNotifierProvider<PublicClass, String> provider =
        PublicClassProvider;
    final String result = container.read(PublicProvider);

    expect(result, 'Hello world');
  });

  test('Generates .name for providers', () {
    expect(PublicClassProvider.name, 'PublicClassProvider');
    expect(privateClassProvider.name, '_PrivateClassProvider');

    expect(FamilyClassProvider.name, 'FamilyClassProvider');
    expect(FamilyClassProvider(42, third: .42).name, 'FamilyClassProvider');
  });

  test('Sets cacheTime/disposeDelay to null on non-autoDispose providers', () {
    expect(PublicClassProvider.cacheTime, null);
    expect(PublicClassProvider.disposeDelay, null);

    expect(FamilyClassProvider.cacheTime, null);
    expect(FamilyClassProvider.disposeDelay, null);

    expect(FamilyClassProvider(42, third: .42).cacheTime, null);
    expect(FamilyClassProvider(42, third: .42).disposeDelay, null);
  });

  test(
      'Creates a NotifierProvider.family<T> if @provider is used on a synchronous function with parameters',
      () {
    final container = createContainer();

    final FamilyClassProviderFamily family = FamilyClassProvider;

    expect(FamilyClassProvider(42, third: .42).from, FamilyClassProvider);

    expect(
      FamilyClassProvider(42, third: .42),
      FamilyClassProvider(42, third: .42),
    );
    expect(
      FamilyClassProvider(42, third: .42),
      isNot(FamilyClassProvider(42, third: .21)),
    );
    expect(
      FamilyClassProvider(42, third: .42).hashCode,
      isNot(FamilyClassProvider(42, third: .21).hashCode),
    );

    // handle defaults
    expect(
      FamilyClassProvider(42, third: .42),
      FamilyClassProvider(
        42,
        third: .42,
        // ignore: avoid_redundant_argument_values
        fourth: true,
      ),
    );
    expect(
      FamilyClassProvider(42, third: .42).hashCode,
      FamilyClassProvider(
        42,
        third: .42,
        // ignore: avoid_redundant_argument_values
        fourth: true,
      ).hashCode,
    );

    final FamilyClassProviderProvider provider = FamilyClassProvider(
      42,
      second: 'x42',
      third: .42,
      fourth: false,
      fifth: ['x42'],
    );
    // ignore: invalid_use_of_internal_member
    final AutoDisposeNotifierProviderImpl<FamilyClass, String> futureProvider =
        provider;

    expect(provider.first, 42);
    expect(provider.second, 'x42');
    expect(provider.third, .42);
    expect(provider.fourth, false);
    expect(provider.fifth, ['x42']);

    final String result = container.read(
      FamilyClassProvider(
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
