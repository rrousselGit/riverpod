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
            .having((e) => e.name, 'name', 'first'),
        'Counter': isA<NotifierGeneratorProviderDefinition>()
            .having((e) => e.name, 'name', 'Counter'),
      });
    });

    testSource('Decode isAutoDispose', source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
int autoDispose(FirstRef ref) => 0;

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
