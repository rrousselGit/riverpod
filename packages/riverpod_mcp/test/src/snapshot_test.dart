import 'package:riverpod/riverpod.dart';
import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';
import 'package:riverpod_mcp/src/snapshot.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service_io.dart';

import '../utils.dart';

void main() {
  late ResolveObject resolve;
  late CachedObject values;

  // The entry of `valuesProvider` named [name], described on its own.
  Future<Map<String, Object?>> describe(String name, {int depth = 1}) async {
    final map = await describeObject(values, resolve: resolve, depth: 1);
    final entries = map['entries']! as List<Map<String, Object?>>;
    final entry = entries.firstWhere(
      (entry) => (entry['key']! as Map)['value'] == name,
    );
    final path = [entries.indexOf(entry) * 2 + 1];

    return describeObject(
      await objectAtPath(values, path, resolve: resolve),
      resolve: resolve,
      depth: depth,
      path: path,
    );
  }

  setUpAll(() async {
    final app = await startApp();
    final connection = await VmServiceConnection.start(
      await vmServiceConnectUri('${app.uri.replaceFirst('http', 'ws')}ws'),
    );
    addTearDown(connection.dispose);
    final container = ProviderContainer(
      overrides: [appConnectionProvider.overrideWith((ref) => connection)],
    );
    addTearDown(container.dispose);
    container.listen(framesProvider, (_, _) {});

    final frames = await container.read(framesProvider.future);
    values = frames.last.elements.values
        .firstWhere((e) => e.provider.origin.toStringValue == 'valuesProvider')
        .state
        .state;
    resolve = (object) async {
      final provider = resolvedVariableForObjectProvider(object);
      final subscription = container.listen(provider, (_, _) {});
      try {
        return await container.read(provider.future);
      } finally {
        subscription.close();
      }
    };
  });

  group('describeObject', () {
    test('describes maps as entries', () async {
      final map = await describeObject(values, resolve: resolve, depth: 1);

      expect(map['type'], 'Map');
      expect(map['size'], 7);
      expect(map['entries'], hasLength(7));
      expect((map['entries']! as List).first, {
        'key': {'type': 'String', 'value': 'nan'},
        'value': {'type': 'double', 'value': 'NaN'},
      });
    });

    test('describes values without children', () async {
      expect(await describe('type'), {'type': 'Type', 'value': 'int'});
      expect(await describe('nothing'), {'type': 'Null', 'value': null});
      expect(await describe('empty'), {'type': 'List', 'size': 0});
    });

    test('names the children of collections after their position', () async {
      expect(await describe('record'), {
        'type': 'Record',
        'size': 2,
        'children': [
          {'name': '0', 'type': 'double', 'value': 1.5},
          {'name': 'name', 'type': 'String', 'value': 'named'},
        ],
      });
      expect(await describe('set'), {
        'type': 'Set',
        'size': 1,
        'children': [
          {'name': '0', 'type': 'bool', 'value': true},
        ],
      });
    });

    test('stops at the requested depth, with the path to continue', () async {
      expect(await describeObject(values, resolve: resolve, depth: 0), {
        'type': 'Map',
        'size': 7,
        'truncated': true,
        'path': <int>[],
      });
      expect(await describe('record', depth: 0), {
        'type': 'Record',
        'size': 2,
        'truncated': true,
        'path': [5],
      });
    });

    test(
      'stops after a number of values, with the paths to continue',
      () async {
        final map = await describeObject(
          values,
          resolve: resolve,
          depth: 5,
          maxValues: 4,
        );

        // The map, then its first key, value and second key.
        expect(map['entries'], hasLength(7));
        expect((map['entries']! as List).take(3), [
          {
            'key': {'type': 'String', 'value': 'nan'},
            'value': {'type': 'double', 'value': 'NaN'},
          },
          {
            'key': {'type': 'String', 'value': isA<String>()},
            'value': {
              'truncated': true,
              'path': [3],
            },
          },
          {
            'key': {
              'truncated': true,
              'path': [4],
            },
            'value': {
              'truncated': true,
              'path': [5],
            },
          },
        ]);
      },
    );

    test('omits the children of large collections past a limit', () async {
      final big = await describe('big');

      expect(big['size'], 150);
      expect(big['children'], hasLength(maxDescribedChildren));
      expect(big['omitted'], 150 - maxDescribedChildren);
      expect((big['children']! as List).last, {
        'name': '99',
        'type': 'int',
        'value': 99,
      });
    });

    test('describes values that cannot be read as errors', () async {
      expect(
        await describeObject(
          RootCachedObject(CacheId('unknown-session:gone')),
          resolve: resolve,
          depth: 1,
        ),
        {'error': 'DevTools session expired'},
      );
    });
  });

  group('objectAtPath', () {
    test('returns the root for empty paths', () async {
      expect(await objectAtPath(values, [], resolve: resolve), same(values));
    });

    test('rejects paths that lead nowhere', () async {
      Future<void> at(List<int> path) {
        return objectAtPath(values, path, resolve: resolve);
      }

      await expectLater(
        at([99]),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'Invalid path [99]: no child at index 99 of [], '
                'which has 14 children.',
          ),
        ),
      );
      await expectLater(at([-1]), throwsFormatException);
      // Values without children.
      await expectLater(at([0, 0]), throwsFormatException);
    });

    test('reports values of the path that cannot be read', () async {
      await expectLater(
        objectAtPath(RootCachedObject(CacheId('unknown-session:gone')), [
          0,
        ], resolve: resolve),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            startsWith(
              'Cannot follow path [0]: the value at [] cannot be read. ',
            ),
          ),
        ),
      );
    });
  });
}
