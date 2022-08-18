// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import 'integration/sync.dart';
import 'utils.dart';

void main() {
  test('Creates a Provider<T> if @provider is used on a synchronous function',
      () {
    final container = createContainer();

    const Provider<String> provider = PublicProvider;
    final String result = container.read(PublicProvider);

    expect(result, 'Hello world');
  });

  test(
      'Creates a Provider.family<T> if @provider is used on a synchronous function with parameters',
      () {
    final container = createContainer();

    const FamilyExampleFamily provider = FamilyExample;

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

    final String result = container.read(
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
      '(first: 42, second: x42, third: 0.42, forth: false, fifth: [x42])',
    );
  });
}
