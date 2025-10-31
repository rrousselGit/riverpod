// ignore_for_file: omit_local_variable_types, unused_local_variable //

import 'package:riverpod/misc.dart' show ProviderBase;
import 'package:riverpod/riverpod.dart' show ProviderContainer;
import 'package:test/test.dart';

import 'integration/sync.dart';

void main() {
  group('Supports generics', () {
    test('checks generics in hashCode', () {
      expect(genericProvider<int>().hashCode, genericProvider<int>().hashCode);
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
      expect(genericProvider<num>().hashCode, genericProvider<num>().hashCode);
    });

    test('checks generics in ==', () {
      expect(genericProvider<int>(), genericProvider<int>());
      expect(genericProvider<int>(), isNot(genericProvider<double>()));
      expect(genericProvider<int>(), isNot(genericProvider<num>()));
      expect(genericProvider<double>(), isNot(genericProvider<num>()));
      expect(genericProvider<num>(), genericProvider<num>());
    });

    test('in simple scenarios', () {
      final container = ProviderContainer.test();

      expect(container.listen(genericProvider<int>(), (p, n) {}).read(), [42]);
      expect(container.listen(genericProvider<double>(), (p, n) {}).read(), [
        3.14,
      ]);
      expect(container.listen(genericProvider<num>(), (p, n) {}).read(), [
        42,
        3.14,
      ]);
    });

    test('Using class+family', () {
      final container = ProviderContainer.test();

      expect(container.read(genericClassProvider<int>(42)), <int>[42]);
    });
  });

  test('Supports Raw', () async {
    final container = ProviderContainer.test();

    expect(container.read(rawFutureProvider), isA<Future<String>>());
    expect(container.read(rawFutureClassProvider), isA<Future<String>>());
    expect(
      container.read(rawFutureClassProvider.notifier),
      isA<RawFutureClass>(),
    );

    expect(container.read(rawStreamProvider), isA<Stream<String>>());
    expect(container.read(rawStreamClassProvider), isA<Stream<String>>());
    expect(
      container.read(rawStreamClassProvider.notifier),
      isA<RawStreamClass>(),
    );

    expect(container.read(rawFamilyFutureProvider(0)), isA<Future<String>>());
    expect(
      container.read(rawFamilyFutureClassProvider(0)),
      isA<Future<String>>(),
    );
    expect(
      container.read(rawFamilyFutureClassProvider(0).notifier),
      isA<RawFamilyFutureClass>(),
    );

    expect(container.read(rawFamilyStreamProvider(0)), isA<Stream<String>>());
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
      familyProvider.overrideWith((ref, _) => 'foo').toString(),
      'familyProvider.overrideWith(...)',
    );
    expect(
      familyProvider(
        42,
        second: 'foo',
        third: .3,
      ).overrideWith((ref) => '').toString(),
      'familyProvider(42, fifth: null, fourth: true, second: foo, third: 0.3).overrideWith(...)',
    );

    expect(
      complexGenericProvider<int, String>(param: 42).toString(),
      'complexGenericProvider<int, String>(otherParam: null, param: 42)',
    );
    expect(
      rawFamilyStreamProvider(42).toString(),
      'rawFamilyStreamProvider(42)',
    );
    expect(
      supports$InFnNameProvider<int>().toString(),
      r'supports$InFnNameProvider<int>()',
    );
    expect(
      supports$InClassNameProvider<int>().toString(),
      r'supports$InClassNameProvider<int>()',
    );
  });

  test('Supports overriding non-family providers', () {
    final container = ProviderContainer.test(
      overrides: [publicProvider.overrideWith((ref) => 'Hello world')],
    );

    final result = container.read(publicProvider);
    expect(result, 'Hello world');
  });

  test('Supports overriding family providers', () {
    final container = ProviderContainer.test(
      overrides: [
        familyProvider.overrideWith(
          (ref, args) =>
              'Hello world ${args.$1} ${args.second} '
              '${args.third} ${args.fourth} ${args.fifth}',
        ),
        familyProvider(42, third: .42).overrideWith((ref) => 'Override'),
      ],
    );

    expect(
      container.read(familyProvider(21, third: .21)),
      'Hello world 21 null 0.21 true null',
    );

    expect(container.read(familyProvider(42, third: .42)), 'Override');
  });

  test(
    'Creates a Provider<T> if @riverpod is used on an stream function wrapped in Raw',
    () async {
      final container = ProviderContainer.test();

      final ProviderBase<Stream<String>> provider = rawStreamProvider;
      final Stream<String> result = container.read(rawStreamProvider);

      await expectLater(result, emits('Hello world'));
    },
  );

  test(
    'Creates a Provider<T> if @riverpod is used on a synchronous function',
    () {
      final container = ProviderContainer.test();

      final ProviderBase<String> provider = publicProvider;
      final String result = container.read(publicProvider);

      expect(result, 'Hello world');
    },
  );

  test('Generates .name for providers', () {
    expect(publicProvider.name, 'publicProvider');
    expect(privateProvider.name, '_privateProvider');

    expect(familyProvider.name, 'familyProvider');
    expect(familyProvider(42, third: .42).name, 'familyProvider');
  });

  test('Supports advanced default value syntax', () {
    final container = ProviderContainer.test();

    expect(container.read(localStaticDefaultProvider()), 'Hello world');
  });

  test(
    'Creates a Provider.family<T> if @riverpod is used on a synchronous function with parameters',
    () {
      final container = ProviderContainer.test();

      final FamilyFamily family = familyProvider;

      expect(familyProvider(42, third: .42).from, familyProvider);

      expect(familyProvider(42, third: .42), familyProvider(42, third: .42));
      expect(
        familyProvider(42, third: .42),
        isNot(familyProvider(42, third: .21)),
      );
      expect(
        familyProvider(42, third: .42).hashCode,
        isNot(familyProvider(42, third: .21).hashCode),
      );

      // handle defaults
      expect(familyProvider(42, third: .42), familyProvider(42, third: .42));
      expect(
        familyProvider(42, third: .42).hashCode,
        familyProvider(42, third: .42).hashCode,
      );

      final FamilyProvider provider = familyProvider(
        42,
        second: 'x42',
        third: .42,
        fourth: false,
        fifth: const ['x42'],
      );

      final ProviderBase<String> futureProvider = provider;

      final argument =
          provider.argument!
              as (
                int, {
                String? second,
                double third,
                bool fourth,
                List<String>? fifth,
              });

      expect(argument, (
        42,
        second: 'x42',
        third: .42,
        fourth: false,
        fifth: const ['x42'],
      ));

      final String result = container.read(
        familyProvider(
          42,
          second: 'x42',
          third: .42,
          fourth: false,
          fifth: const ['x42'],
        ),
      );

      expect(
        result,
        '(first: 42, second: x42, third: 0.42, fourth: false, fifth: [x42])',
      );
    },
  );

  test('can override providers', () {
    final container = ProviderContainer.test(
      overrides: [
        publicProvider.overrideWith((ref) => 'test'),
        publicClassProvider.overrideWith(() => PublicClass(42)),
        familyProvider.overrideWith(
          (ref, args) =>
              'test (first: ${args.$1}, second: ${args.second}, third: ${args.third}, fourth: ${args.fourth}, fifth: ${args.fifth})',
        ),
        familyProvider(21, third: .21).overrideWithValue('Override'),
        familyClassProvider.overrideWith(() => FamilyClass(42)),
      ],
    );
    final container2 = ProviderContainer.test(
      overrides: [
        publicClassProvider.overrideWithBuild((ref, notifier) => 'Hello world'),
        familyClassProvider.overrideWithBuild((ref, notifier) {
          return 'FamilyClass';
        }),
        familyClassProvider(21, third: .21).overrideWithBuild((ref, notifier) {
          return 'Override';
        }),
      ],
    );

    expect(container.read(publicProvider), 'test');
    expect(container.read(publicClassProvider.notifier).param, 42);
    expect(
      container.read(familyProvider(42, second: '42', third: .42)),
      'test (first: 42, second: 42, third: 0.42, fourth: true, fifth: null)',
    );
    expect(container.read(familyProvider(21, third: .21)), 'Override');
    expect(
      container
          .read(familyClassProvider(42, second: '42', third: .42).notifier)
          .param,
      42,
    );

    expect(container2.read(publicClassProvider), 'Hello world');
    expect(container2.read(familyClassProvider(42, third: .42)), 'FamilyClass');
    expect(container2.read(familyClassProvider(21, third: .21)), 'Override');
  });
}
