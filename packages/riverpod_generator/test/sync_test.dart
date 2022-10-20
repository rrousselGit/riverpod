// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/sync.dart';
import 'utils.dart';

void main() {
  // TODO test that the generated providers contain the docs from the annotated element

  test('Creates a Provider<T> if @riverpod is used on a synchronous function',
      () {
    final container = createContainer();

    final AutoDisposeProvider<String> provider = publicProvider;
    final String result = container.read(publicProvider);

    expect(result, 'Hello world');
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

    final FamilyFamily family = familyProvider;

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
    final AutoDisposeProvider<String> futureProvider = provider;

    expect(provider.first, 42);
    expect(provider.second, 'x42');
    expect(provider.third, .42);
    expect(provider.fourth, false);
    expect(provider.fifth, ['x42']);

    final String result = container.read(
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
      '(first: 42, second: x42, third: 0.42, fourth: false, fifth: [x42])',
    );
  });
}
