import 'package:analyzer/dart/element/type.dart';
import 'package:riverpod_analyzer_utils/src/riverpod_ast.dart';
import 'package:riverpod_analyzer_utils/src/riverpod_element.dart';
import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  group('LegacyProviderDefinition.parse', () {
    testSource(
      'Handles unsupported function expressions',
      source: '''
import 'package:riverpod/riverpod.dart';

final provider = Provider<int>((ref) => 0);

Provider<int> create() => Provider((ref) => 0);
final unknown = create();

class Callable {
  Provider<int> call() => Provider((ref) => 0);
}

abstract class A {
  static Provider<int> create() => Provider((ref) => 0);
  static final callable = Callable();
}

final unknown2 = A.create();
final unknown3 = A.callable();
final unknown4 = (() => 42)();

Provider<int> Function() get getter => () => Provider((ref) => 0);

final unknown5 = getter();
''',
      (resolver) async {
        // Regression test for https://github.com/rrousselGit/riverpod/issues/2313
        final result = await resolver.resolveRiverpodAnalysisResult();

        expect(result.legacyProviderDeclarations, hasLength(1));
        expect(result.generatorProviderDeclarations, isEmpty);
        expect(
          result.legacyProviderDeclarations.first.node.toSource(),
          'provider = Provider<int>((ref) => 0)',
        );
      },
    );

    testSource('Does not try to parse generated providers',
        runGenerator: true, source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

final legacy = Provider<int>((ref) => 0);

@riverpod
int simple(SimpleRef ref) => 0;

// Regression test for https://github.com/rrousselGit/riverpod/issues/2194
@riverpod
int complex(ComplexRef ref, {int? id, String? another}) => 0;
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();

      expect(result.legacyProviderDeclarations, hasLength(1));
      expect(result.generatorProviderDeclarations, hasLength(2));
    });

    testSource('Decode name', source: '''
import 'package:riverpod/riverpod.dart';

final first = Provider<int>((ref) => 0);
final second = Provider<int>((ref) => 0);
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final providers =
          result.legacyProviderDeclarations.takeAll(['first', 'second']);

      expect(providers, {
        'first': isA<LegacyProviderDeclaration>()
            .having((e) => e.name.toString(), 'name', 'first')
            .having((e) => e.node.name.toString(), 'node.name', 'first'),
        'second': isA<LegacyProviderDeclaration>()
            .having((e) => e.name.toString(), 'name', 'second')
            .having((e) => e.node.name.toString(), 'node.name', 'second'),
      });
    });

    testSource('Decodes dependencies', runGenerator: true, source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

final dep = Provider<int>((ref) => 0);
final family = Provider.family<int, int>((ref, id) => 0);

@Riverpod(keepAlive: true)
int dep2(Dep2Ref ref) => 0;
@Riverpod(keepAlive: true)
int family2(Family2Ref ref, int id) => 0;

final explicitDep = Provider<int>((ref) => 0, dependencies: []);
final explicitFamily = Provider.family<int, int>((ref, id) => 0, dependencies: []);

List<ProviderOrFamily> getDeps() => [];
final unknownDependencies = Provider<int>((ref) => 0, dependencies: getDeps());

final generatorDependencies = Provider<int>(
  (ref) => 0,
  dependencies: [dep2Provider, family2Provider],
);
final alwaysAliveProvider = Provider<int>(
  (ref) => 0,
  dependencies: [dep, family, family(42), ...getDeps()],
);
final alwaysAliveFamily = Provider.family<int, int>(
  (ref, id) => 0,
  dependencies: [dep, family, family(42), ...getDeps()],
);
final explicitAlwaysAliveFamily = ProviderFamily<int, int>(
  (ref, id) => 0,
  dependencies: [dep, family, family(42), ...getDeps()],
);
final autoDisposeProvider = Provider.autoDispose<int>(
  (ref) => 0,
  dependencies: [dep, family, family(42), ...getDeps()],
);
final explicitAutoDisposeProvider = AutoDisposeProvider<int>(
  (ref) => 0,
  dependencies: [dep, family, family(42), ...getDeps()],
);
final autoDisposeFamily = Provider.autoDispose.family<int, int>(
  (ref, id) => 0,
  dependencies: [dep, family, family(42), ...getDeps()],
);
final autoDisposeFamily2 = Provider.family.autoDispose<int, int>(
  (ref, id) => 0,
  dependencies: [dep, family, family(42), ...getDeps()],
);
final explicitAutoDisposeFamily = AutoDisposeProviderFamily<int, int>(
  (ref, id) => 0,
  dependencies: [dep, family, family(42), ...getDeps()],
);
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final deps = result.legacyProviderDeclarations.takeAll([
        'dep',
        'family',
      ]);
      final explicitDeps = result.legacyProviderDeclarations.takeAll([
        'explicitDep',
        'explicitFamily',
      ]);
      final unknownDependencies =
          result.legacyProviderDeclarations.findByName('unknownDependencies');

      final generatorDependencies =
          result.legacyProviderDeclarations.findByName('generatorDependencies');
      final providers = result.legacyProviderDeclarations.takeAll([
        'alwaysAliveProvider',
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      for (final provider in deps.entries) {
        expect(
          provider.value.dependencies,
          null,
          reason: '${provider.key} has no dependency',
        );
      }

      expect(unknownDependencies.dependencies, isNotNull);
      expect(unknownDependencies.dependencies?.dependencies, isNull);
      expect(
        unknownDependencies.dependencies?.dependenciesNode.toSource(),
        'dependencies: getDeps()',
      );

      for (final provider in explicitDeps.entries) {
        expect(
          provider.value.dependencies?.dependencies,
          isEmpty,
          reason: '${provider.key} has no dependency',
        );
        expect(
          provider.value.dependencies?.dependenciesNode.toSource(),
          'dependencies: []',
        );
      }

      for (final provider in providers.entries) {
        expect(
          provider.value.dependencies?.dependencies,
          hasLength(4),
          reason: '${provider.key} has 4 dependencies',
        );

        expect(
          provider.value.dependencies?.dependenciesNode.toSource(),
          'dependencies: [dep, family, family(42), ...getDeps()]',
        );

        expect(
          provider.value.dependencies?.dependencies?[0],
          isA<LegacyProviderDependency>()
              .having((e) => e.node.toSource(), 'node', 'dep')
              .having(
                (e) => e.provider?.providerElement,
                'provider',
                same(deps['dep']?.providerElement),
              ),
          reason: '${provider.key} has "dep" as first dependency',
        );
        expect(
          provider.value.dependencies?.dependencies?[1],
          isA<LegacyProviderDependency>()
              .having((e) => e.node.toSource(), 'node', 'family')
              .having(
                (e) => e.provider?.providerElement,
                'provider',
                same(deps['family']?.providerElement),
              ),
          reason: '${provider.key} has "family" as second dependency',
        );
        expect(
          provider.value.dependencies?.dependencies?[2],
          isA<LegacyProviderDependency>()
              .having((e) => e.node.toSource(), 'node', 'family(42)')
              .having(
                (e) => e.provider?.providerElement,
                'provider',
                same(deps['family']?.providerElement),
              ),
          reason: '${provider.key} has a family expression as third dependency',
        );
        expect(
          provider.value.dependencies?.dependencies?[3],
          isA<LegacyProviderDependency>()
              .having((e) => e.node.toSource(), 'node', '...getDeps()')
              .having((e) => e.provider?.providerElement, 'provider', null),
          reason:
              '${provider.key} has an unknown expression as fourth dependency',
        );
      }

      expect(
        generatorDependencies.dependencies?.dependencies,
        hasLength(2),
      );
      expect(
        generatorDependencies.dependencies?.dependenciesNode.toSource(),
        'dependencies: [dep2Provider, family2Provider]',
      );
      expect(
        generatorDependencies.dependencies?.dependencies?[0],
        isA<LegacyProviderDependency>()
            .having((e) => e.node.toSource(), 'node', 'dep2Provider')
            .having(
              (e) => e.provider?.providerElement,
              'provider',
              same(
                result.generatorProviderDeclarations
                    .findByName('dep2')
                    .providerElement,
              ),
            ),
      );
      expect(
        generatorDependencies.dependencies?.dependencies?[1],
        isA<LegacyProviderDependency>()
            .having((e) => e.node.toSource(), 'node', 'family2Provider')
            .having(
              (e) => e.provider?.providerElement,
              'provider',
              same(
                result.generatorProviderDeclarations
                    .findByName('family2')
                    .providerElement,
              ),
            ),
      );
    });

    testSource('Decode LegacyProviderType.provider', source: '''
import 'package:riverpod/riverpod.dart';

final alwaysAliveProvider = Provider<int>((ref) => 0);
final alwaysAliveFamily = Provider.family<int, int>((ref, id) => 0);
final explicitAlwaysAliveFamily = ProviderFamily<int, int>((ref, id) => 0);
final autoDisposeProvider = Provider.autoDispose<int>((ref) => 0);
final explicitAutoDisposeProvider = AutoDisposeProvider<int>((ref) => 0);
final autoDisposeFamily = Provider.autoDispose.family<int, int>((ref, id) => 0);
final autoDisposeFamily2 = Provider.family.autoDispose<int, int>((ref, id) => 0);
final explicitAutoDisposeFamily = AutoDisposeProviderFamily<int, int>((ref, id) => 0);
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final providers = result.legacyProviderDeclarations.takeAll([
        'alwaysAliveProvider',
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      for (final provider in providers.entries) {
        expect(
          provider.value.providerElement.providerType,
          LegacyProviderType.provider,
          reason: '${provider.key} is a Provider',
        );
      }
    });

    testSource('Decode various key AstNodes', source: '''
import 'package:riverpod/riverpod.dart';

final inferred = Provider((ref) => 0);
final inferredFamily = Provider.family((ref, int id) => 0);

final provider = Provider<int>((ref) => 0, name: 'foo');
final family = Provider.family<int, int>((ref, id) => 0, name: 'bar');

final autoDisposeFamily = Provider.autoDispose.family<int, int>((ref, id) => 0);
final explicitAutoDisposeFamily = AutoDisposeProviderFamily<int, int>((ref, id) => 0);

final weird = Provider<int>(name: 'foo', dependencies: [], (ref) => 0);
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final providers = result.legacyProviderDeclarations.takeAll([
        'inferred',
        'inferredFamily',
        'provider',
        'family',
        'autoDisposeFamily',
        'explicitAutoDisposeFamily',
        'weird',
      ]);

      expect(
        providers['provider']?.argumentList.toSource(),
        "((ref) => 0, name: 'foo')",
      );
      expect(
        providers['family']?.argumentList.toSource(),
        "((ref, id) => 0, name: 'bar')",
      );

      expect(providers['autoDisposeFamily']?.provider.toString(), 'Provider');
      expect(
        providers['explicitAutoDisposeFamily']?.provider.toString(),
        'AutoDisposeProviderFamily',
      );

      expect(
        providers['autoDisposeFamily']?.familyModifier?.toSource(),
        'family',
      );
      expect(providers['explicitAutoDisposeFamily']?.familyModifier, null);

      expect(
        providers['autoDisposeFamily']?.autoDisposeModifier?.toSource(),
        'autoDispose',
      );
      expect(providers['explicitAutoDisposeFamily']?.autoDisposeModifier, null);

      expect(
        providers['autoDisposeFamily']?.build.toSource(),
        '(ref, id) => 0',
      );
      expect(
        providers['provider']?.build.toSource(),
        '(ref) => 0',
      );

      expect(
        providers['autoDisposeFamily']?.typeArguments?.toSource(),
        '<int, int>',
      );
      expect(
        providers['provider']?.typeArguments?.toSource(),
        '<int>',
      );
      expect(providers['inferred']?.typeArguments, null);
      expect(providers['inferredFamily']?.typeArguments, null);

      expect(
        providers['weird']?.argumentList.toSource(),
        "(name: 'foo', dependencies: [], (ref) => 0)",
      );
      expect(
        providers['weird']?.dependencies?.dependenciesNode.toSource(),
        'dependencies: []',
      );
      expect(providers['weird']?.build.toSource(), '(ref) => 0');
    });

    testSource('Decode LegacyProviderType.futureProvider', source: '''
import 'package:riverpod/riverpod.dart';

final alwaysAliveProvider = FutureProvider<int>((ref) => 0);
final alwaysAliveFamily = FutureProvider.family<int, int>((ref, id) => 0);
final explicitAlwaysAliveFamily = FutureProviderFamily<int, int>((ref, id) => 0);
final autoDisposeProvider = FutureProvider.autoDispose<int>((ref) => 0);
final explicitAutoDisposeProvider = AutoDisposeFutureProvider<int>((ref) => 0);
final autoDisposeFamily = FutureProvider.autoDispose.family<int, int>((ref, id) => 0);
final autoDisposeFamily2 = FutureProvider.family.autoDispose<int, int>((ref, id) => 0);
final explicitAutoDisposeFamily = AutoDisposeFutureProviderFamily<int, int>((ref, id) => 0);
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final providers = result.legacyProviderDeclarations.takeAll([
        'alwaysAliveProvider',
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      for (final provider in providers.entries) {
        expect(
          provider.value.providerElement.providerType,
          LegacyProviderType.futureProvider,
          reason: '${provider.key} is a FutureProvider',
        );
      }
    });

    testSource('Decode LegacyProviderType.stateProvider', source: '''
import 'package:riverpod/riverpod.dart';

final alwaysAliveProvider = StateProvider<int>((ref) => 0);
final alwaysAliveFamily = StateProvider.family<int, int>((ref, id) => 0);
final explicitAlwaysAliveFamily = StateProviderFamily<int, int>((ref, id) => 0);
final autoDisposeProvider = StateProvider.autoDispose<int>((ref) => 0);
final explicitAutoDisposeProvider = AutoDisposeStateProvider<int>((ref) => 0);
final autoDisposeFamily = StateProvider.autoDispose.family<int, int>((ref, id) => 0);
final autoDisposeFamily2 = StateProvider.family.autoDispose<int, int>((ref, id) => 0);
final explicitAutoDisposeFamily = AutoDisposeStateProviderFamily<int, int>((ref, id) => 0);
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final providers = result.legacyProviderDeclarations.takeAll([
        'alwaysAliveProvider',
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      for (final provider in providers.entries) {
        expect(
          provider.value.providerElement.providerType,
          LegacyProviderType.stateProvider,
          reason: '${provider.key} is a StateProvider',
        );
      }
    });

    testSource('Decode LegacyProviderType.streamProvider', source: '''
import 'package:riverpod/riverpod.dart';

final alwaysAliveProvider = StreamProvider<int>((ref) => Stream.empty());
final alwaysAliveFamily = StreamProvider.family<int, int>((ref, id) => Stream.empty());
final explicitAlwaysAliveFamily = StreamProviderFamily<int, int>((ref, id) => Stream.empty());
final autoDisposeProvider = StreamProvider.autoDispose<int>((ref) => Stream.empty());
final explicitAutoDisposeProvider = AutoDisposeStreamProvider<int>((ref) => Stream.empty());
final autoDisposeFamily = StreamProvider.autoDispose.family<int, int>((ref, id) => Stream.empty());
final autoDisposeFamily2 = StreamProvider.family.autoDispose<int, int>((ref, id) => Stream.empty());
final explicitAutoDisposeFamily = AutoDisposeStreamProviderFamily<int, int>((ref, id) => Stream.empty());
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final providers = result.legacyProviderDeclarations.takeAll([
        'alwaysAliveProvider',
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      for (final provider in providers.entries) {
        expect(
          provider.value.providerElement.providerType,
          LegacyProviderType.streamProvider,
          reason: '${provider.key} is a StreamProvider',
        );
      }
    });

    testSource('Decode LegacyProviderType.notifierProvider', source: '''
import 'package:riverpod/riverpod.dart';

final alwaysAliveProvider = NotifierProvider<Notifier<int>, int>(() => throw UnimplementedError());
final alwaysAliveFamily = NotifierProvider.family<FamilyNotifier<int, int>, int, int>(() => throw UnimplementedError());
final explicitAlwaysAliveFamily = NotifierProviderFamily<FamilyNotifier<int, int>, int, int>(() => throw UnimplementedError());
final autoDisposeProvider = NotifierProvider.autoDispose<AutoDisposeNotifier<int>, int>(() => throw UnimplementedError());
final explicitAutoDisposeProvider = AutoDisposeNotifierProvider<AutoDisposeNotifier<int>, int>(() => throw UnimplementedError());
final autoDisposeFamily = NotifierProvider.autoDispose.family<AutoDisposeFamilyNotifier<int, int>, int, int>(() => throw UnimplementedError());
final autoDisposeFamily2 = NotifierProvider.family.autoDispose<AutoDisposeFamilyNotifier<int, int>, int, int>(() => throw UnimplementedError());
final explicitAutoDisposeFamily = AutoDisposeNotifierProviderFamily<AutoDisposeFamilyNotifier<int, int>, int, int>(() => throw UnimplementedError());
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final providers = result.legacyProviderDeclarations.takeAll([
        'alwaysAliveProvider',
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      for (final provider in providers.entries) {
        expect(
          provider.value.providerElement.providerType,
          LegacyProviderType.notifierProvider,
          reason: '${provider.key} is a NotifierProvider',
        );
      }
    });

    testSource('Decode LegacyProviderType.asyncNotifierProvider', source: '''
import 'package:riverpod/riverpod.dart';

final alwaysAliveProvider = AsyncNotifierProvider<AsyncNotifier<int>, int>(() => throw UnimplementedError());
final alwaysAliveFamily = AsyncNotifierProvider.family<FamilyAsyncNotifier<int, int>, int, int>(() => throw UnimplementedError());
final explicitAlwaysAliveFamily = AsyncNotifierProviderFamily<FamilyAsyncNotifier<int, int>, int, int>(() => throw UnimplementedError());
final autoDisposeProvider = AsyncNotifierProvider.autoDispose<AutoDisposeAsyncNotifier<int>, int>(() => throw UnimplementedError());
final explicitAutoDisposeProvider = AutoDisposeAsyncNotifierProvider<AutoDisposeAsyncNotifier<int>, int>(() => throw UnimplementedError());
final autoDisposeFamily = AsyncNotifierProvider.autoDispose.family<AutoDisposeFamilyAsyncNotifier<int, int>, int, int>(() => throw UnimplementedError());
final autoDisposeFamily2 = AsyncNotifierProvider.family.autoDispose<AutoDisposeFamilyAsyncNotifier<int, int>, int, int>(() => throw UnimplementedError());
final explicitAutoDisposeFamily = AutoDisposeAsyncNotifierProviderFamily<AutoDisposeFamilyAsyncNotifier<int, int>, int, int>(() => throw UnimplementedError());
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final providers = result.legacyProviderDeclarations.takeAll([
        'alwaysAliveProvider',
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      for (final provider in providers.entries) {
        expect(
          provider.value.providerElement.providerType,
          LegacyProviderType.asyncNotifierProvider,
          reason: '${provider.key} is an AsyncNotifierProvider',
        );
      }
    });

    testSource('Decode LegacyProviderType.changeNotifierProvider', source: '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final alwaysAliveProvider = ChangeNotifierProvider<ValueNotifier<int>>((ref) => ValueNotifier(0));
final alwaysAliveFamily = ChangeNotifierProvider.family<ValueNotifier<int>, int>((ref, id) => ValueNotifier(0));
final explicitAlwaysAliveFamily = ChangeNotifierProviderFamily<ValueNotifier<int>, int>((ref, id) => ValueNotifier(0));
final autoDisposeProvider = ChangeNotifierProvider.autoDispose<ValueNotifier<int>>((ref) => ValueNotifier(0));
final explicitAutoDisposeProvider = AutoDisposeChangeNotifierProvider<ValueNotifier<int>>((ref) => ValueNotifier(0));
final autoDisposeFamily = ChangeNotifierProvider.autoDispose.family<ValueNotifier<int>, int>((ref, id) => ValueNotifier(0));
final autoDisposeFamily2 = ChangeNotifierProvider.family.autoDispose<ValueNotifier<int>, int>((ref, id) => ValueNotifier(0));
final explicitAutoDisposeFamily = AutoDisposeChangeNotifierProviderFamily<ValueNotifier<int>, int>((ref, id) => ValueNotifier(0));
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final providers = result.legacyProviderDeclarations.takeAll([
        'alwaysAliveProvider',
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      for (final provider in providers.entries) {
        expect(
          provider.value.providerElement.providerType,
          LegacyProviderType.changeNotifierProvider,
          reason: '${provider.key} is a ChangeNotifierProvider',
        );
      }
    });

    testSource('Decode LegacyProviderType.stateNotifierProvider', source: '''
import 'package:riverpod/riverpod.dart';

final alwaysAliveProvider = StateNotifierProvider<StateController<int>, int>((ref) => StateController(0));
final alwaysAliveFamily = StateNotifierProvider.family<StateController<int>, int, int>((ref, id) => StateController(0));
final explicitAlwaysAliveFamily = StateNotifierProviderFamily<StateController<int>, int, int>((ref, id) => StateController(0));
final autoDisposeProvider = StateNotifierProvider.autoDispose<StateController<int>, int>((ref) => StateController(0));
final explicitAutoDisposeProvider = AutoDisposeStateNotifierProvider<StateController<int>, int>((ref) => StateController(0));
final autoDisposeFamily = StateNotifierProvider.autoDispose.family<StateController<int>, int, int>((ref, id) => StateController(0));
final autoDisposeFamily2 = StateNotifierProvider.family.autoDispose<StateController<int>, int, int>((ref, id) => StateController(0));
final explicitAutoDisposeFamily = AutoDisposeStateNotifierProviderFamily<StateController<int>, int, int>((ref, id) => StateController(0));
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final providers = result.legacyProviderDeclarations.takeAll([
        'alwaysAliveProvider',
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      for (final provider in providers.entries) {
        expect(
          provider.value.providerElement.providerType,
          LegacyProviderType.stateNotifierProvider,
          reason: '${provider.key} is a StreamProvider',
        );
      }
    });

    testSource('Decode isAutoDispose', source: '''
import 'package:riverpod/riverpod.dart';

final alwaysAliveProvider = Provider<int>((ref) => 0);
final alwaysAliveFamily = Provider.family<int, int>((ref, id) => 0);
final explicitAlwaysAliveFamily = ProviderFamily<int, int>((ref, id) => 0);

final autoDisposeProvider = Provider.autoDispose<int>((ref) => 0);
final explicitAutoDisposeProvider = AutoDisposeProvider<int>((ref) => 0);
final autoDisposeFamily = Provider.autoDispose.family<int, int>((ref, id) => 0);
final autoDisposeFamily2 = Provider.family.autoDispose<int, int>((ref, id) => 0);
final explicitAutoDisposeFamily = AutoDisposeProviderFamily<int, int>((ref, id) => 0);
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final autoDisposeProviders = result.legacyProviderDeclarations.takeAll([
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      final alwaysAliveProviders = result.legacyProviderDeclarations.takeAll([
        'alwaysAliveProvider',
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
      ]);

      for (final provider in autoDisposeProviders.entries) {
        expect(
          provider.value.providerElement.isAutoDispose,
          true,
          reason: '${provider.key} is autoDispose',
        );
      }
      for (final provider in alwaysAliveProviders.entries) {
        expect(
          provider.value.providerElement.isAutoDispose,
          false,
          reason: '${provider.key} is not autoDispose',
        );
      }
    });

    testSource('Decode families', source: '''
import 'package:riverpod/riverpod.dart';

final alwaysAliveProvider = Provider<int>((ref) => 0);
final autoDisposeProvider = Provider.autoDispose<int>((ref) => 0);
final explicitAutoDisposeProvider = AutoDisposeProvider<int>((ref) => 0);

final alwaysAliveFamily = Provider.family<int, int>((ref, id) => 0);
final explicitAlwaysAliveFamily = ProviderFamily<int, int>((ref, id) => 0);
final autoDisposeFamily = Provider.autoDispose.family<int, int>((ref, id) => 0);
final autoDisposeFamily2 = Provider.family.autoDispose<int, int>((ref, id) => 0);
final explicitAutoDisposeFamily = AutoDisposeProviderFamily<int, int>((ref, id) => 0);
''', (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();
      final providers = result.legacyProviderDeclarations.takeAll([
        'alwaysAliveProvider',
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
      ]);

      final families = result.legacyProviderDeclarations.takeAll([
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      for (final provider in providers.entries) {
        expect(
          provider.value.providerElement.familyElement,
          isNull,
          reason: '${provider.key} is not a family',
        );
      }
      for (final provider in families.entries) {
        expect(
          provider.value.providerElement.familyElement?.parameterType,
          isA<DartType>().having((e) => e.isDartCoreInt, 'is int', true),
          reason: '${provider.key} has int parameters',
        );
      }
    });
  });
}
