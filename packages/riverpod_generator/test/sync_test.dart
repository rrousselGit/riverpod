// ignore_for_file: omit_local_variable_types, unused_local_variable, require_trailing_commas

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import 'integration/sync.dart';
import 'utils.dart';

void main() {
  // TODO test that the generated providers contain the docs from the annotated element

  group('Supports generics', () {
    test('checks generics in hashCode', () {
      expect(
        genericProvider<int>().hashCode,
        genericProvider<int>().hashCode,
      );
      expect(
        genericProvider<int>().hashCode,
        isNot(genericProvider<double>().hashCode),
      );
      expect(
        genericProvider<int>().hashCode,
        isNot(genericProvider<num>().hashCode),
      );
      expect(
        genericProvider<double>().hashCode,
        isNot(genericProvider<num>().hashCode),
      );
      expect(
        genericProvider<num>().hashCode,
        genericProvider<num>().hashCode,
      );
    });

    test('checks generics in ==', () {
      expect(
        genericProvider<int>(),
        genericProvider<int>(),
      );
      expect(
        genericProvider<int>(),
        isNot(genericProvider<double>()),
      );
      expect(
        genericProvider<int>(),
        isNot(genericProvider<num>()),
      );
      expect(
        genericProvider<double>(),
        isNot(genericProvider<num>()),
      );
      expect(
        genericProvider<num>(),
        genericProvider<num>(),
      );
    });

    test('in simple scenarios', () {
      final container = createContainer();

      expect(
        container.listen(genericProvider<int>(), (p, n) {}).read(),
        [42],
      );
      expect(
        container.listen(genericProvider<double>(), (p, n) {}).read(),
        [3.14],
      );
      expect(
        container.listen(genericProvider<num>(), (p, n) {}).read(),
        [42, 3.14],
      );
    });
  });

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

  test('overrides toString', () {
    expect(publicProvider.toString(), 'publicProvider');
    expect(familyProvider.toString(), 'familyProvider');
    expect(
      familyProvider.call(42, second: 'foo', third: .3).toString(),
      'familyProvider(42, fifth: null, fourth: true, second: foo, third: 0.3)',
    );

    expect(
      publicProvider.overrideWithValue('foo').toString(),
      'publicProvider.overrideWithValue(foo)',
    );
    expect(
      familyProvider.overrideWith((ref) => 'foo').toString(),
      'familyProvider.overrideWith(...)',
    );
    expect(
      familyProvider(42, second: 'foo', third: .3)
          .overrideWith((ref) => '')
          .toString(),
      'familyProvider(42, fifth: null, fourth: true, second: foo, third: 0.3).overrideWith(...)',
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
          (ref, args) => 'Hello world ${args.first} ${args.second} '
              '${args.third} ${args.fourth} ${args.fifth}',
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

    const ProviderBase<Stream<String>> provider = rawStreamProvider;
    final Stream<String> result = container.read(rawStreamProvider);

    await expectLater(result, emits('Hello world'));
  });

  test('Creates a Provider<T> if @riverpod is used on a synchronous function',
      () {
    final container = createContainer();

    const ProviderBase<String> provider = publicProvider;
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
      ),
    );
    expect(
      familyProvider(42, third: .42).hashCode,
      familyProvider(
        42,
        third: .42,
      ).hashCode,
    );

    final FamilyProvider provider = familyProvider(
      42,
      second: 'x42',
      third: .42,
      fourth: false,
      fifth: const ['x42'],
    );

    final ProviderBase<String> futureProvider = provider;

    final argument = provider.argument! as (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    });

    expect(
      argument,
      (
        42,
        second: 'x42',
        third: .42,
        fourth: false,
        fifth: const ['x42'],
      ),
    );

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

  test('can override providers', () {
    final container = createContainer(overrides: [
      publicProvider.overrideWith((ref) => 'test'),
      publicClassProvider.overrideWith(() => PublicClass(42)),
      familyProvider.overrideWith(
        (ref, args) =>
            'test (first: ${args.first}, second: ${args.second}, third: ${args.third}, fourth: ${args.fourth}, fifth: ${args.fifth})',
      ),
      familyClassProvider.overrideWith(() => FamilyClass(42)),
    ]);

    expect(container.read(publicProvider), 'test');
    expect(container.read(publicClassProvider.notifier).param, 42);
    expect(
      container.read(familyProvider(42, second: '42', third: .42)),
      'test (first: 42, second: 42, third: 0.42, fourth: true, fifth: null)',
    );
    expect(
      container
          .read(familyClassProvider(42, second: '42', third: .42).notifier)
          .param,
      42,
    );
  });
}
