import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

void main() {
  group('ProviderDefinition.parse', () {
    testSource('Decode name', source: '''
import 'package:riverpod/riverpod.dart';

final first = Provider<int>((ref) => 0);
final second = Provider<int>((ref) => 0);
''', (resolver) async {
      final providers =
          await resolver.parseAllProviderDefinitions(['first', 'second']);

      expect(providers, {
        'first':
            isA<ProviderDefinition>().having((e) => e.name, 'name', 'first'),
        'second':
            isA<ProviderDefinition>().having((e) => e.name, 'name', 'second'),
      });
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
      final providers = await resolver.parseAllProviderDefinitions([
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
        final value = provider.value as LegacyProviderDefinition;
        expect(
          value.providerType,
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
      final providers = await resolver.parseAllProviderDefinitions([
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
        final value = provider.value as LegacyProviderDefinition;
        expect(
          value.providerType,
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
      final providers = await resolver.parseAllProviderDefinitions([
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
        final value = provider.value as LegacyProviderDefinition;
        expect(
          value.providerType,
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
      final providers = await resolver.parseAllProviderDefinitions([
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
        final value = provider.value as LegacyProviderDefinition;
        expect(
          value.providerType,
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
      final providers = await resolver.parseAllProviderDefinitions([
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
        final value = provider.value as LegacyProviderDefinition;
        expect(
          value.providerType,
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
      final providers = await resolver.parseAllProviderDefinitions([
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
        final value = provider.value as LegacyProviderDefinition;
        expect(
          value.providerType,
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
      final providers = await resolver.parseAllProviderDefinitions([
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
        final value = provider.value as LegacyProviderDefinition;
        expect(
          value.providerType,
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
      final providers = await resolver.parseAllProviderDefinitions([
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
        final value = provider.value as LegacyProviderDefinition;
        expect(
          value.providerType,
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
      final autoDisposeProviders = await resolver.parseAllProviderDefinitions([
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      final alwaysAliveProviders = await resolver.parseAllProviderDefinitions([
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
      final providers = await resolver.parseAllProviderDefinitions([
        'alwaysAliveProvider',
        'autoDisposeProvider',
        'explicitAutoDisposeProvider',
      ]);

      final families = await resolver.parseAllProviderDefinitions([
        'alwaysAliveFamily',
        'explicitAlwaysAliveFamily',
        'autoDisposeFamily',
        'autoDisposeFamily2',
        'explicitAutoDisposeFamily',
      ]);

      for (final provider in providers.entries) {
        final value = provider.value as LegacyProviderDefinition;
        expect(
          value.isFamily,
          false,
          reason: '${provider.key} is not a family',
        );
        expect(
          value.familyArgumentType,
          null,
          reason: '${provider.key} has no parameter',
        );
      }
      for (final provider in families.entries) {
        final value = provider.value as LegacyProviderDefinition;
        expect(
          value.isFamily,
          true,
          reason: '${provider.key} is a family',
        );
        expect(
          value.familyArgumentType,
          isA<DartType>().having((e) => e.isDartCoreInt, 'is int', true),
          reason: '${provider.key} has int parameters',
        );
      }
    });
  });
}

/// Due to [resolveSource] throwing if trying to interact with the resolver
/// after the future completed, we change the syntax to make sure our test
/// executes within the resolver scope.
void testSource(
  String description,
  Future<void> Function(Resolver resolver) run, {
  required String source,
}) {
  test(
    description,
    () {
      final enclosingZone = Zone.current;

      return resolveSource('library foo;$source', (resolver) {
        return runZoned(
          () => run(resolver),
          zoneSpecification: ZoneSpecification(
            // Somehow prints are captured inside the callback. Let's restore them
            print: (self, parent, zone, line) => enclosingZone.print(line),
          ),
        );
      });
    },
  );
}

extension on Resolver {
  Future<Map<String, ProviderDefinition>> parseAllProviderDefinitions(
    List<String> names, {
    String libraryName = 'foo',
  }) async {
    final library = await requireFindLibraryByName(libraryName);
    final definitions = await Future.wait([
      for (final name in names)
        ProviderDefinition.parse(
          library.findElementWithName(name),
          resolver: astNodeFor,
        ),
    ]);

    return {
      for (var i = 0; i < names.length; i++) names[i]: definitions[i],
    };
  }

  Future<LibraryElement> requireFindLibraryByName([
    String libraryName = 'foo',
  ]) async {
    final library = await findLibraryByName(libraryName);

    if (library == null) {
      throw StateError('No library found or name "$libraryName"');
    }

    final errorResult = await library.session
        .getErrors('/_resolve_source/lib/_resolve_source.dart');

    if (errorResult is ErrorsResult && errorResult.errors.isNotEmpty) {
      throw StateError('''
The parsed library has errors:
${errorResult.errors.map((e) => '- $e\n').join()}
''');
    }

    return library;
  }
}

extension on LibraryElement {
  Element findElementWithName(String name) {
    return topLevelElements.singleWhere(
      (element) => !element.isSynthetic && element.name == name,
      orElse: () => throw StateError('No element found with name "$name"'),
    );
  }
}
