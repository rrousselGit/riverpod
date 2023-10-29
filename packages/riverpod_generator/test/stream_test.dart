// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/stream.dart';
import 'utils.dart';

void main() {
  test('Creates a StreamProvider<T> if @riverpod is used on a Stream function',
      () async {
    final container = createContainer();

    final AutoDisposeStreamProvider<String> provider = publicProvider;

    expect(
      await container.listen(publicProvider.future, (_, __) {}).read(),
      'Hello world',
    );
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
        publicProvider.overrideWith((ref) => Stream.value('Hello world')),
      ],
    );

    final result = container.read(publicProvider.future);
    expect(await result, 'Hello world');
  });

  test('Supports overriding family providers', () async {
    final container = createContainer(
      overrides: [
        familyProvider(42, third: .42).overrideWith(
          (ref) => Stream.value(
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
      fifth: ['x42'],
    );
    final AutoDisposeStreamProvider<String> futureProvider = provider;

    expect(provider.first, 42);
    expect(provider.second, 'x42');
    expect(provider.third, .42);
    expect(provider.fourth, false);
    expect(provider.fifth, ['x42']);

    expect(
      await container
          .listen(
            familyProvider(
              42,
              second: 'x42',
              third: .42,
              fourth: false,
              fifth: ['x42'],
            ).future,
            (_, __) {},
          )
          .read(),
      '(first: 42, second: x42, third: 0.42, fourth: false, fifth: [x42])',
    );
  });
}
