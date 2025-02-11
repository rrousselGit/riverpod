// ignore_for_file: omit_local_variable_types, unused_local_variable // Just checking

import 'package:riverpod/riverpod.dart' show ProviderBase;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/async.dart';

void main() {
  test(
      'Creates a FutureProvider<T> if @riverpod is used on a FutureOr function',
      () {
    final container = ProviderContainer.test();

    const ProviderBase<AsyncValue<String>> provider = publicProvider;
    final AsyncValue<String> result = container.read(publicProvider);

    expect(result, const AsyncData('Hello world'));
  });

  test('Generates .name for providers', () {
    expect(publicProvider.name, 'publicProvider');
    expect(privateProvider.name, '_privateProvider');

    expect(familyProvider.name, 'familyProvider');
    expect(familyProvider(42, third: .42).name, 'familyProvider');
  });

  test('Supports overriding non-family providers', () async {
    final container = ProviderContainer.test(
      overrides: [
        publicProvider.overrideWith((ref) => Future.value('Hello world')),
      ],
    );

    final result = container.read(publicProvider.future);
    expect(await result, 'Hello world');
  });

  test('Supports overriding family providers', () async {
    final container = ProviderContainer.test(
      overrides: [
        familyProvider(21, third: .21).overrideWith(
          (ref) => Future.value('Override'),
        ),
        familyProvider.overrideWith(
          (ref, args) => Future.value(
            'Hello world ${args.$1} ${args.second} '
            '${args.third} ${args.fourth} ${args.fifth}',
          ),
        ),
      ],
    );

    final result = container.read(familyProvider(42, third: .42).future);
    expect(await result, 'Hello world 42 null 0.42 true null');

    final result2 = container.read(familyProvider(21, third: .21).future);
    expect(await result2, 'Override');
  });

  test(
      'Creates a Provider.family<T> if @riverpod is used on a synchronous function with parameters',
      () async {
    final container = ProviderContainer.test();

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
    final ProviderBase<AsyncValue<String>> futureProvider = provider;

    final sub = container.listen(
      familyProvider(
        42,
        second: 'x42',
        third: .42,
        fourth: false,
        fifth: const ['x42'],
      ).future,
      (previous, next) {},
    );
    await sub.read();

    final AsyncValue<String> result = container.read(
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
      const AsyncData(
        '(first: 42, second: x42, third: 0.42, fourth: false, fifth: [x42])',
      ),
    );
  });

  test('can overrideWith', () {
    final container = ProviderContainer.test(
      overrides: [
        publicProvider.overrideWith((ref) {
          const FutureOr<String> result = 'test';
          return result;
        }),
        publicClassProvider.overrideWith(() => PublicClass(42)),
        familyProvider.overrideWith(
          (ref, args) {
            final FutureOr<String> result =
                'test (first: ${args.$1}, second: ${args.second}, third: ${args.third}, fourth: ${args.fourth}, fifth: ${args.fifth})';
            return result;
          },
        ),
        familyClassProvider.overrideWith(FamilyClass.new),
      ],
    );

    expect(container.read(publicProvider).requireValue, 'test');
    expect(container.read(publicClassProvider.notifier).param, 42);
    expect(
      container.read(familyProvider(42, second: '42', third: .42)).requireValue,
      'test (first: 42, second: 42, third: 0.42, fourth: true, fifth: null)',
    );
    expect(
      container
          .read(familyClassProvider(42, second: '42', third: .42).notifier)
          .param,
      (42, second: '42', third: 0.42, fourth: true, fifth: null),
    );
  });

  test('can overrideWithValue providers ', () {
    final container = ProviderContainer.test(
      overrides: [
        publicProvider.overrideWithValue(const AsyncData('test')),
      ],
    );

    expect(container.read(publicProvider), const AsyncData('test'));
    expect(container.read(publicProvider.future), completion('test'));
  });
}
