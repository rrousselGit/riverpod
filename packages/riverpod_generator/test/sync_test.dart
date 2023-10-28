// ignore_for_file: omit_local_variable_types, unused_local_variable, require_trailing_commas

import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart';
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

  test('Marks getProviderOverride as @visibleForOverriding', () async {
    final file = File('test/integration/sync.dart');
    final path = normalize(file.absolute.path);

    final library = await resolveFile2(path: path);
    library as ResolvedUnitResult;

    final clazz = library.libraryElement.getClass('FamilyClassFamily')!;
    final method = clazz.getMethod('getProviderOverride')!;

    expect(method.hasVisibleForOverriding, isTrue);
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
      fifth: const ['x42'],
    );
    final AutoDisposeProvider<String> futureProvider = provider;

    expect(provider.first, 42);
    expect(provider.second, 'x42');
    expect(provider.third, .42);
    expect(provider.fourth, false);
    expect(provider.fifth, ['x42']);

    final (
      int, {
      String? second,
      double third,
      bool fourth,
      List<String>? fifth,
    }) argument = provider.argument;

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
        (ref) =>
            'test (first: ${ref.first}, second: ${ref.second}, third: ${ref.third}, fourth: ${ref.fourth}, fifth: ${ref.fifth})',
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
