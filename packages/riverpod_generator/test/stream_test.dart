// ignore_for_file: omit_local_variable_types, unused_local_variable //

import 'package:riverpod/riverpod.dart' show ProviderBase;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/stream.dart';

void main() {
  test('Creates a StreamProvider<T> if @riverpod is used on a Stream function',
      () async {
    final container = ProviderContainer.test();

    const ProviderBase<AsyncValue<String>> provider = publicProvider;

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
    final container = ProviderContainer.test(
      overrides: [
        publicProvider.overrideWith((ref) => Stream.value('Hello world')),
      ],
    );

    final result = container.listen(publicProvider.future, (a, b) {}).read();
    expect(await result, 'Hello world');
  });

  test('Supports overriding family providers', () async {
    final container = ProviderContainer.test(
      overrides: [
        familyProvider.overrideWith(
          (ref, args) => Stream.value(
            'Hello world ${args.$1} ${args.second} '
            '${args.third} ${args.fourth} ${args.fifth}',
          ),
        ),
        familyProvider(21, third: .21).overrideWith(
          (ref) => Stream.value('Override'),
        ),
      ],
    );

    expect(
      await container
          .listen(familyProvider(42, third: .42).future, (a, b) {})
          .read(),
      'Hello world 42 null 0.42 true null',
    );
    expect(
      await container
          .listen(familyProvider(21, third: .21).future, (a, b) {})
          .read(),
      'Override',
    );
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

    expect(
      await container
          .listen(
            familyProvider(
              42,
              second: 'x42',
              third: .42,
              fourth: false,
              fifth: const ['x42'],
            ).future,
            (_, __) {},
          )
          .read(),
      '(first: 42, second: x42, third: 0.42, fourth: false, fifth: [x42])',
    );
  });

  test('can overrideWith', () async {
    final container = ProviderContainer.test(
      overrides: [
        publicProvider.overrideWith((ref) => Stream.value('test')),
        publicClassProvider.overrideWith(() => PublicClass(42)),
        familyProvider.overrideWith(
          (ref, args) {
            return Stream.value(
              'test (first: ${args.$1}, second: ${args.second}, third: ${args.third}, fourth: ${args.fourth}, fifth: ${args.fifth})',
            );
          },
        ),
        familyClassProvider.overrideWith(FamilyClass.new),
      ],
    );

    expect(
      await container.listen(publicProvider.future, (a, b) {}).read(),
      'test',
    );
    expect(container.read(publicClassProvider.notifier).param, 42);
    expect(
      await container
          .listen(
            familyProvider(42, second: '42', third: .42).future,
            (a, b) {},
          )
          .read(),
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
