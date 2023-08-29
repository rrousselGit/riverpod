// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/sync.dart';
import 'utils.dart';

void main() {
  // TODO test that the generated providers contain the docs from the annotated element

  test('Supports Raw', () async {
    final container = createContainer();

    expect(
      container.read(rawFutureProvider),
      isA<Future<String>>(),
    );
    expect(
      container.read(rawFutureClassProvider),
      isA<Future<String>>(),
    );
    expect(
      container.read(rawFutureClassProvider.notifier),
      isA<RawFutureClass>(),
    );

    expect(
      container.read(rawStreamProvider),
      isA<Stream<String>>(),
    );
    expect(
      container.read(rawStreamClassProvider),
      isA<Stream<String>>(),
    );
    expect(
      container.read(rawStreamClassProvider.notifier),
      isA<RawStreamClass>(),
    );

    expect(
      container.read(rawFamilyFutureProvider(0)),
      isA<Future<String>>(),
    );
    expect(
      container.read(rawFamilyFutureClassProvider(0)),
      isA<Future<String>>(),
    );
    expect(
      container.read(rawFamilyFutureClassProvider(0).notifier),
      isA<RawFamilyFutureClass>(),
    );

    expect(
      container.read(rawFamilyStreamProvider(0)),
      isA<Stream<String>>(),
    );
    expect(
      container.read(rawFamilyStreamClassProvider(0)),
      isA<Stream<String>>(),
    );
    expect(
      container.read(rawFamilyStreamClassProvider(0).notifier),
      isA<RawFamilyStreamClass>(),
    );
  });

  test('Supports overriding non-family providers', () {
    final container = createContainer(
      overrides: [
        publicProvider.overrideWith((ref) => 'Hello world'),
      ],
    );

    final result = container.read(publicProvider);
    expect(result, 'Hello world');
  });

  test('Supports overriding family providers', () {
    final container = createContainer(
      overrides: [
        familyProvider(42, third: .42).overrideWith(
          (ref) => 'Hello world ${ref.first} ${ref.second} '
              '${ref.third} ${ref.fourth} ${ref.fifth}',
        ),
      ],
    );

    final result = container.read(familyProvider(42, third: .42));
    expect(result, 'Hello world 42 null 0.42 true null');
  });

  test(
      'Creates a Provider<T> if @riverpod is used on an stream function wrapped in Raw',
      () async {
    final container = createContainer();

    final AutoDisposeProvider<Stream<String>> provider = rawStreamProvider;
    final Stream<String> result = container.read(rawStreamProvider);

    await expectLater(result, emits('Hello world'));
  });

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
