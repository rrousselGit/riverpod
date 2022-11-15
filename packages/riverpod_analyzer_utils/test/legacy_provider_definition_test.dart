import 'package:analyzer/dart/element/type.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import 'analyser_test_utils.dart';

void main() {
  group('LegacyProviderDefinition.parse', () {
    testSource('Decode name', source: '''
import 'package:riverpod/riverpod.dart';

final first = Provider<int>((ref) => 0);
final second = Provider<int>((ref) => 0);
''', (resolver) async {
      final providers =
          await resolver.parseAllLegacyProviderDefinitions(['first', 'second']);

      expect(providers, {
        'first': isA<LegacyProviderDefinition>()
            .having((e) => e.name, 'name', 'first'),
        'second': isA<LegacyProviderDefinition>()
            .having((e) => e.name, 'name', 'second'),
      });
    });

    testSource('Decodes dependencies', source: '''
import 'package:riverpod/riverpod.dart';

final dep = Provider<int>((ref) => 0);
final family = Provider.family<int, int>((ref, id) => 0);

final alwaysAliveProvider = Provider<int>(
  (ref) => 0,
  dependencies: [dep, family, family(42)],
);
final alwaysAliveFamily = Provider.family<int, int>(
  (ref, id) => 0,
  dependencies: [dep, family, family(42)],
);
final explicitAlwaysAliveFamily = ProviderFamily<int, int>(
  (ref, id) => 0,
  dependencies: [dep, family, family(42)],
);
final autoDisposeProvider = Provider.autoDispose<int>(
  (ref) => 0,
  dependencies: [dep, family, family(42)],
);
final explicitAutoDisposeProvider = AutoDisposeProvider<int>(
  (ref) => 0,
  dependencies: [dep, family, family(42)],
);
final autoDisposeFamily = Provider.autoDispose.family<int, int>(
  (ref, id) => 0,
  dependencies: [dep, family, family(42)],
);
final autoDisposeFamily2 = Provider.family.autoDispose<int, int>(
  (ref, id) => 0,
  dependencies: [dep, family, family(42)],
);
final explicitAutoDisposeFamily = AutoDisposeProviderFamily<int, int>(
  (ref, id) => 0,
  dependencies: [dep, family, family(42)],
);
''', (resolver) async {
      final deps = await resolver.parseAllLegacyProviderDefinitions([
        'dep',
        'family',
      ]);
      final providers = await resolver.parseAllLegacyProviderDefinitions([
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
        // Let's unwrap the type
        final dependencies = provider.value.dependencies!
            as ListLitteralLegacyProviderDependencyList;

        expect(
          dependencies.list,
          hasLength(3),
          reason: '${provider.key} has 3 dependencies',
        );

        expect(
          dependencies.list[0],
          isA<ProviderLegacyProviderDependency>().having(
            (e) => e.definition.value,
            'definition',
            same(deps['dep']),
          ),
          reason: '${provider.key} has "dep" as first dependency',
        );
        expect(
          dependencies.list[1],
          isA<ProviderLegacyProviderDependency>().having(
            (e) => e.definition.value,
            'definition',
            same(deps['family']),
          ),
          reason: '${provider.key} has "family" as second dependency',
        );
        expect(
          dependencies.list[2],
          isA<UnknownLegacyProviderDependency>(),
          reason: '${provider.key} has an unknown third dependency',
        );
      }
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
      final providers = await resolver.parseAllLegacyProviderDefinitions([
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
          provider.value.providerType,
          LegacyProviderType.provider,
          reason: '${provider.key} is a Provider',
        );
      }
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
      final providers = await resolver.parseAllLegacyProviderDefinitions([
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
          provider.value.providerType,
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
      final providers = await resolver.parseAllLegacyProviderDefinitions([
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
          provider.value.providerType,
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
      final providers = await resolver.parseAllLegacyProviderDefinitions([
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
          provider.value.providerType,
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
      final providers = await resolver.parseAllLegacyProviderDefinitions([
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
          provider.value.providerType,
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
      final providers = await resolver.parseAllLegacyProviderDefinitions([
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
          provider.value.providerType,
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
      final providers = await resolver.parseAllLegacyProviderDefinitions([
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
          provider.value.providerType,
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
      final providers = await resolver.parseAllLegacyProviderDefinitions([
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
          provider.value.providerType,
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
      final autoDisposeProviders =
          await resolver.parseAllLegacyProviderDefinitions([
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      final alwaysAliveProviders =
          await resolver.parseAllLegacyProviderDefinitions([
        'alwaysAliveProvider',
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
      ]);

      for (final provider in alwaysAliveProviders.entries) {
        expect(
          provider.value.isAutoDispose,
          false,
          reason: '${provider.key} is not autoDispose',
        );
      }
      for (final provider in autoDisposeProviders.entries) {
        expect(
          provider.value.isAutoDispose,
          true,
          reason: '${provider.key} is autoDispose',
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
      final providers = await resolver.parseAllLegacyProviderDefinitions([
        'alwaysAliveProvider',
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
      ]);

      final families = await resolver.parseAllLegacyProviderDefinitions([
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      for (final provider in providers.entries) {
        expect(
          provider.value.isFamily,
          false,
          reason: '${provider.key} is not a family',
        );
        expect(
          provider.value.familyArgumentType,
          null,
          reason: '${provider.key} has no parameter',
        );
      }
      for (final provider in families.entries) {
        expect(
          provider.value.isFamily,
          true,
          reason: '${provider.key} is a family',
        );
        expect(
          provider.value.familyArgumentType,
          isA<DartType>().having((e) => e.isDartCoreInt, 'is int', true),
          reason: '${provider.key} has int parameters',
        );
      }
    });
  });
}
