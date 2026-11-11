import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_devtool_core/src/connection.dart';
import 'package:riverpod_devtool_core/src/inspector.dart';
import 'package:riverpod_devtool_core/src/package_name_provider.dart';
import 'package:riverpod_devtool_core/src/vm_service.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('InspectorSettings hides external private members by default', () {
    const settings = InspectorSettings();

    expect(settings.showExternalPrivateMembers, isFalse);
    expect(settings.copyWith().showExternalPrivateMembers, isFalse);
    expect(
      settings
          .copyWith(showExternalPrivateMembers: true)
          .showExternalPrivateMembers,
      isTrue,
    );
  });

  group('resolvedVariableForObjectProvider', () {
    late TestApp app;
    setUpAll(() async => app = await startApp());

    test('reads the state of a provider', () async {
      final container = app.container();
      final provider = await container.element('doubleProvider');

      expect(
        (await container.resolve(provider.state.state)).require.instance,
        isA<IntVariable>().having((e) => e.value, 'value', 0),
      );
    });

    test('exposes the content of collections', () async {
      final container = app.container();
      final values = await container.element('valuesProvider');
      final map = (await container.resolve(
        values.state.state,
      )).require.instance;

      final entries = <String, ResolvedVariable>{};
      for (final [key, value] in map.children.slices(2)) {
        final name = (await container.resolve(key)).require.instance;
        entries[(name as StringVariable).value] = (await container.resolve(
          value,
        )).require.instance;
      }

      expect(entries, {
        'record': isA<RecordVariable>().having(
          (e) => e.children.map((e) => e.label),
          'fields',
          [null, 'name'],
        ),
        'set': isA<SetVariable>().having(
          (e) => e.children,
          'items',
          hasLength(1),
        ),
        'type': isA<TypeVariable>().having((e) => e.name, 'name', 'int'),
        'null': isA<NullVariable>(),
        'bool': isA<BoolVariable>().having((e) => e.value, 'value', isTrue),
        // Kinds without a dedicated rendering are inspected as objects.
        'closure': isA<UnknownObjectVariable>(),
        'user': isA<UnknownObjectVariable>(),
        'loading': isA<AsyncValueVariable>().having(
          (e) => e.children.map((e) => e.label),
          'children',
          ['progress', 'isLoading'],
        ),
        'error': isA<AsyncValueVariable>().having(
          (e) => e.children.map((e) => e.label),
          'children',
          ['error', 'stackTrace', 'retrying'],
        ),
      });
      final name = entries['user']!.children.firstWhere(
        (e) => e.label == 'name',
      );
      expect(
        (await container.resolve(name)).require.instance,
        isA<StringVariable>().having((e) => e.value, 'value', 'jane'),
      );
      final item = (entries['set']! as SetVariable).children.single;
      expect(
        (await container.resolve(item)).require.instance,
        isA<DoubleVariable>().having((e) => e.value, 'value', 1.5),
      );
    });

    test(
      'exposes the status of AsyncValues and the members of objects',
      () async {
        final container = app.container();
        final user = await container.element('userProvider');

        final async = (await container.resolve(
          user.state.state,
        )).require.instance;
        expect(
          async,
          isA<AsyncValueVariable>()
              .having((e) => e.type, 'type', 'AsyncData')
              .having((e) => e.children.map((e) => e.label), 'children', [
                'value',
              ]),
        );

        final object = (await container.resolve(
          async.children.single,
        )).require.instance;
        expect(
          object,
          isA<UnknownObjectVariable>()
              .having((e) => e.type, 'type', 'User')
              .having(
                (e) => e.children.map((e) => e.label),
                'members',
                unorderedEquals(['greeting', 'name', 'tags', '_secret']),
              ),
        );

        final greeting = object.children.firstWhere(
          (e) => e.label == 'greeting',
        );
        expect(
          (await container.resolve(greeting)).require.instance,
          isA<StringVariable>().having(
            (e) => e.value,
            'value',
            'Hello john (42)',
          ),
        );
      },
    );

    test('hides private members of other packages unless asked', () async {
      final container = app.container();
      final counter = await container.element('counterProvider');
      final notifier = counter.notifier!.state;

      Future<Iterable<String?>> members() async {
        final object = (await container.resolve(notifier)).require.instance;
        return object.children.map((e) => e.label);
      }

      // The fixture is not part of a package, unlike Notifier's internals.
      expect(await members(), isNot(contains(startsWith('_'))));

      container
          .read(inspectorSettingsProvider.notifier)
          .setShowExternalPrivateMembers(value: true);

      expect(await members(), contains(startsWith('_')));
    });

    test('only shows the private members of the inspected package', () async {
      Future<Iterable<String?>> members(String package) async {
        final container = ProviderContainer.test(
          overrides: [
            appConnectionProvider.overrideWith((ref) => app.connection),
            currentPackageNameProvider.overrideWith((ref) => package),
          ],
        );
        final counter = await container.element('counterProvider');
        final notifier = await container.resolve(counter.notifier!.state);
        return notifier.require.instance.children.map((e) => e.label);
      }

      expect(await members('my_app'), isNot(contains(startsWith('_'))));
      expect(await members('riverpod'), contains(startsWith('_')));
    });

    test('reports values that are no longer retained', () async {
      final container = app.container();
      await container.element('counterProvider');
      final eval = await container.read(evalProvider.future);

      final result = await container.resolve(
        RootCachedObject(CacheId('${eval.sessionId}:gone')),
      );

      expect(
        result,
        isA<ByteError<ResolvedVariable>>().having(
          (e) => e.error.toString(),
          'error',
          contains('no longer retained'),
        ),
      );
    });
  });
}
