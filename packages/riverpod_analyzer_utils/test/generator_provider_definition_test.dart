import 'package:analyzer/dart/element/element.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import 'analyser_test_utils.dart';

void main() {
  group('ProviderDefinition.parse', () {
    testSource('Decode name', source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
int first(FirstRef ref) => 0;

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
}
''', (resolver) async {
      final providers = await resolver
          .parseAllGeneratorProviderDefinitions(['first', 'Counter']);

      expect(providers, {
        'first': isA<FunctionalGeneratorProviderDefinition>()
            .having((e) => e.isNotifier, 'isNotifier', false)
            .having((e) => e.isFunctional, 'isFunctional', true)
            .having((e) => e.name, 'name', 'first'),
        'Counter': isA<NotifierGeneratorProviderDefinition>()
            .having((e) => e.isNotifier, 'isNotifier', true)
            .having((e) => e.isFunctional, 'isFunctional', false)
            .having((e) => e.name, 'name', 'Counter'),
      });
    });

    testSource('Decodes docs', source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Hello world
@riverpod
int first(FirstRef ref) => 0;

@riverpod
int second(FirstRef ref) => 0;

/// Hello world
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
}

@riverpod
class Counter2 extends _$Counter2 {
  @override
  int build() => 0;
}
''', (resolver) async {
      final helloWorldDocs = await resolver
          .parseAllGeneratorProviderDefinitions(['first', 'Counter']);
      final noDocs = await resolver
          .parseAllGeneratorProviderDefinitions(['second', 'Counter2']);

      for (final provider in helloWorldDocs.entries) {
        expect(
          provider.value.docs,
          '/// Hello world',
          reason: '${provider.key} has "Hello world" for docs',
        );
      }
      for (final provider in noDocs.entries) {
        expect(
          provider.value.docs,
          null,
          reason: '${provider.key} has no docs',
        );
      }
    });

    testSource('Decode isAutoDispose', source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
int autoDispose(AutoDisposeRef ref) => 0;

@Riverpod(keepAlive: true)
int keepAlive(KeepAliveRef ref) => 0;

@riverpod
class AutoDisposeNotifier extends _$AutoDisposeNotifier {
  @override
  int build() => 0;
}

@Riverpod(keepAlive: true)
class KeepAliveNotifier extends _$KeepAliveNotifier {
  @override
  int build() => 0;
}
''', (resolver) async {
      final autoDispose = await resolver.parseAllGeneratorProviderDefinitions([
        'autoDispose',
        'AutoDisposeNotifier',
      ]);
      final keepAlive = await resolver.parseAllGeneratorProviderDefinitions([
        'keepAlive',
        'KeepAliveNotifier',
      ]);

      for (final provider in autoDispose.entries) {
        expect(
          provider.value.isAutoDispose,
          true,
          reason: '${provider.key} is a Provider',
        );
      }
      for (final provider in keepAlive.entries) {
        expect(
          provider.value.isAutoDispose,
          false,
          reason: '${provider.key} is a Provider',
        );
      }
    });

    testSource('Decode dependencies', source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
int root(RootRef ref) => 0;

@riverpod
class RootNotifier extends _$RootNotifier {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [])
int empty(EmptyRef ref) => 0;

@Riverpod(dependencies: [])
class EmptyNotifier extends _$EmptyNotifier {
  @override
  int build() => 0;
}

@Riverpod(dependencies: ['emptyProvider'])
int string(StringRef ref) => 0;

@Riverpod(dependencies: ['emptyProvider'])
class StringNotifier extends _$StringNotifier {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [empty, EmptyNotifier])
int providerDependency(ProviderDependencyRef ref) => 0;

@Riverpod(dependencies: [empty, EmptyNotifier])
class ProviderDependencyNotifier extends _$ProviderDependencyNotifier {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [providerDependency, ProviderDependencyNotifier])
int nestedDependency(NestedDependencyRef ref) => 0;

@Riverpod(dependencies: [providerDependency, ProviderDependencyNotifier])
class NestedDependencyNotifier extends _$NestedDependencyNotifier {
  @override
  int build() => 0;
}
''', (resolver) async {
      final roots = await resolver.parseAllGeneratorProviderDefinitions([
        'root',
        'RootNotifier',
      ]);
      final empty = await resolver.parseAllGeneratorProviderDefinitions([
        'empty',
        'EmptyNotifier',
      ]);
      final string = await resolver.parseAllGeneratorProviderDefinitions([
        'string',
        'StringNotifier',
      ]);
      final providers = await resolver.parseAllGeneratorProviderDefinitions([
        'providerDependency',
        'ProviderDependencyNotifier',
      ]);
      final nesteds = await resolver.parseAllGeneratorProviderDefinitions([
        'nestedDependency',
        'NestedDependencyNotifier',
      ]);

      for (final provider in roots.entries) {
        expect(
          provider.value.dependencies,
          null,
          reason: '${provider.key} has no dependency',
        );
      }
      for (final provider in empty.entries) {
        expect(
          provider.value.dependencies,
          isEmpty,
          reason: '${provider.key} has an empty list of dependencies',
        );
      }
      for (final provider in string.entries) {
        expect(
          provider.value.dependencies,
          [
            isA<StringGeneratorProviderDependency>()
                .having((e) => e.value, 'value', 'emptyProvider')
          ],
          reason:
              '${provider.key} has a unique string dependency on emptyProvider',
        );
      }

      for (final provider in providers.entries) {
        expect(
          provider.value.dependencies,
          hasLength(2),
          reason: '${provider.key} has two explicit dependencies',
        );
        expect(
          provider.value.dependencies?[0],
          isA<ProviderGeneratorProviderDependency>().having(
            (e) => e.definition,
            'definition',
            same(empty['empty']),
          ),
          reason: '${provider.key} has `empty` as first dependency',
        );
        expect(
          provider.value.dependencies?[1],
          isA<ProviderGeneratorProviderDependency>().having(
            (e) => e.definition,
            'definition',
            same(empty['EmptyNotifier']),
          ),
          reason: '${provider.key} has `EmptyNotifier` as second dependency',
        );
      }

      for (final provider in nesteds.entries) {
        expect(
          provider.value.dependencies,
          hasLength(2),
          reason: '${provider.key} has two explicit dependencies',
        );
        expect(
          provider.value.dependencies?[0],
          isA<ProviderGeneratorProviderDependency>().having(
            (e) => e.definition,
            'definition',
            same(providers['providerDependency']),
          ),
          reason:
              '${provider.key} has `providerDependency` as first dependency',
        );
        expect(
          provider.value.dependencies?[1],
          isA<ProviderGeneratorProviderDependency>().having(
            (e) => e.definition,
            'definition',
            same(providers['ProviderDependencyNotifier']),
          ),
          reason:
              '${provider.key} has `ProviderDependencyNotifier` as second dependency',
        );
      }
    });

    testSource('Decodes arguments', source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';

@riverpod
int plain(IntegerRef ref) => 0;

@riverpod
class PlainNotifier extends _$PlainNotifier {
  @override
  int build() => 0;
}

@riverpod
int family1(IntegerRef ref, int a, {String? b, double c = 42}) => 0;

@riverpod
class FamilyNotifier1 extends _$FamilyNotifier1 {
  @override
  int build(int a, {String? b, double c = 42}) => 0;
}

@riverpod
int family2(IntegerRef ref, int a, [String? b, double c = 42]) => 0;

@riverpod
class FamilyNotifier2 extends _$FamilyNotifier2 {
  @override
  int build(int a, [String? b, double c = 42]) => 0;
}
''', (resolver) async {
      final typeProvider =
          await resolver.libraries.first.then((value) => value.typeProvider);

      final plain = await resolver.parseAllGeneratorProviderDefinitions([
        'plain',
        'PlainNotifier',
      ]);
      final namedParams = await resolver.parseAllGeneratorProviderDefinitions([
        'family1',
        'FamilyNotifier1',
      ]);
      final positionalParams =
          await resolver.parseAllGeneratorProviderDefinitions([
        'family2',
        'FamilyNotifier2',
      ]);

      for (final provider in plain.entries) {
        expect(
          provider.value.parameters,
          isEmpty,
          reason: '${provider.key} has no param',
        );
      }
      for (final provider in namedParams.entries) {
        expect(
          provider.value.parameters,
          [
            isA<ParameterElement>()
                .having((e) => e.name, 'name', 'a')
                .having((e) => e.type, 'type', typeProvider.intType)
                .having(
                  (e) => e.isRequiredPositional,
                  'isRequiredPositional',
                  true,
                )
                .having((e) => e.hasDefaultValue, 'hasDefaultValue', false),
            isA<ParameterElement>()
                .having((e) => e.name, 'name', 'b')
                .having(
                  (e) => e.isOptionalNamed,
                  'isOptionalNamed',
                  true,
                )
                .having((e) => e.hasDefaultValue, 'hasDefaultValue', false),
            isA<ParameterElement>()
                .having((e) => e.name, 'name', 'c')
                .having((e) => e.type, 'type', typeProvider.doubleType)
                .having(
                  (e) => e.isOptionalNamed,
                  'isOptionalNamed',
                  true,
                )
                .having((e) => e.hasDefaultValue, 'hasDefaultValue', true),
          ],
          reason: '${provider.key} has no param',
        );
      }
      for (final provider in positionalParams.entries) {
        expect(
          provider.value.parameters,
          [
            isA<ParameterElement>()
                .having((e) => e.name, 'name', 'a')
                .having((e) => e.type, 'type', typeProvider.intType)
                .having(
                  (e) => e.isRequiredPositional,
                  'isRequiredPositional',
                  true,
                )
                .having((e) => e.hasDefaultValue, 'hasDefaultValue', false),
            isA<ParameterElement>()
                .having((e) => e.name, 'name', 'b')
                .having(
                  (e) => e.isOptionalPositional,
                  'isOptionalPositional',
                  true,
                )
                .having((e) => e.hasDefaultValue, 'hasDefaultValue', false),
            isA<ParameterElement>()
                .having((e) => e.name, 'name', 'c')
                .having((e) => e.type, 'type', typeProvider.doubleType)
                .having(
                  (e) => e.isOptionalPositional,
                  'isOptionalPositional',
                  true,
                )
                .having((e) => e.hasDefaultValue, 'hasDefaultValue', true),
          ],
          reason: '${provider.key} has no param',
        );
      }
    });

    testSource('Decodes stateType', source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';

@riverpod
int integer(IntegerRef ref) => 0;

@riverpod
FutureOr<int> futureOrInt(FutureOrIntRef ref) => 0;

@riverpod
Future<int> futureInt(FutureIntRef ref) async => 0;

@riverpod
class Integer extends _$Integer {
  @override
  int build() => 0;
}

@riverpod
class FutureOrInt extends _$FutureOrInt {
  @override
  FutureOr<int> build() => 0;
}

@riverpod
class FutureInt extends _$FutureInt {
  @override
  Future<int> build() async => 0;
}
''', (resolver) async {
      final typeProvider =
          await resolver.libraries.first.then((value) => value.typeProvider);

      final integers = await resolver.parseAllGeneratorProviderDefinitions([
        'integer',
        'Integer',
      ]);
      final futures = await resolver.parseAllGeneratorProviderDefinitions([
        'futureInt',
        'FutureInt',
      ]);
      final futureOrs = await resolver.parseAllGeneratorProviderDefinitions([
        'futureOrInt',
        'FutureOrInt',
      ]);

      final all = {...integers, ...futures, ...futureOrs};

      for (final provider in all.entries) {
        expect(
          provider.value.type.stateType,
          typeProvider.intType,
          reason: '${provider.key} has an int type',
        );
      }

      for (final provider in integers.entries) {
        expect(
          provider.value.type.createdType,
          typeProvider.intType,
          reason: '${provider.key} creates an int',
        );
      }
      for (final provider in futureOrs.entries) {
        expect(
          provider.value.type.createdType.isDartAsyncFutureOr,
          true,
          reason: '${provider.key} creates a FutureOr<int>',
        );
        expect(
          provider.value.type.createdType.toString(),
          'FutureOr<int>',
          reason: '${provider.key} creates a FutureOr<int>',
        );
      }
      for (final provider in futures.entries) {
        expect(
          provider.value.type.createdType.toString(),
          'Future<int>',
          reason: '${provider.key} creates a Future<int>',
        );
        expect(
          provider.value.type.createdType.isDartAsyncFuture,
          true,
          reason: '${provider.key} creates a Future<int>',
        );
      }
    });
  });
}
