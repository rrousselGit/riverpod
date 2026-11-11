import 'package:dart_mcp/client.dart';
import 'package:riverpod_mcp/src/server.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('vmServiceWebSocketUri', () {
    test('converts the URI that tools print', () {
      expect(
        vmServiceWebSocketUri(' http://127.0.0.1:8181/AbCd=/ ').toString(),
        'ws://127.0.0.1:8181/AbCd=/ws',
      );
      expect(
        vmServiceWebSocketUri('https://example.com/token').toString(),
        'wss://example.com/token/ws',
      );
      expect(
        vmServiceWebSocketUri('http://127.0.0.1:8181').toString(),
        'ws://127.0.0.1:8181/ws',
      );
    });

    test('keeps WebSocket URIs as they are', () {
      expect(
        vmServiceWebSocketUri('ws://127.0.0.1:8181/AbCd=/ws').toString(),
        'ws://127.0.0.1:8181/AbCd=/ws',
      );
    });
  });

  group('without an application', () {
    test('exposes the features of the devtool as tools', () async {
      final agent = await startAgent();

      final tools = await agent.server.listTools(ListToolsRequest());

      expect(tools.tools.map((tool) => tool.name), [
        'connect',
        'list_providers',
        'inspect_provider',
        'list_frames',
        'set_time_travel',
        'invalidate_provider',
        'evaluate',
      ]);
    });

    test('tools ask to connect first', () async {
      final agent = await startAgent();

      await expectLater(
        agent.call('list_providers'),
        throwsToolError(startsWith('Not connected to an application.')),
      );
    });

    test('connect reports applications that cannot be reached', () async {
      final agent = await startAgent();

      await expectLater(
        agent.call('connect', {'uri': 'http://127.0.0.1:1/'}),
        throwsToolError(startsWith('Could not connect: ')),
      );
      await expectLater(
        agent.call('list_frames'),
        throwsToolError(startsWith('Not connected to an application.')),
      );
    });
  });

  test('connect rejects applications that do not use Riverpod', () async {
    final app = await startApp('no_riverpod');
    final agent = await startAgent();

    await expectLater(
      agent.call('connect', {'uri': app.uri}),
      throwsToolError(
        allOf(
          startsWith('Could not connect: Library matching package:riverpod/'),
          endsWith('has to be running in debug mode and use Riverpod.'),
        ),
      ),
    );
  });

  test('tools have nothing to list before providers are created', () async {
    final app = await startApp('idle');
    final agent = await startAgent();

    expect(await agent.call('connect', {'uri': app.uri}), {
      'connected': true,
      'providers': 0,
    });
    expect(await agent.call('list_frames'), {
      'timeTravel': false,
      'frames': isEmpty,
    });
    await expectLater(
      agent.call('list_providers'),
      throwsToolError('The application has not created any provider yet.'),
    );
  });

  group('with an application', () {
    late Agent agent;
    setUp(() async {
      final app = await startApp();
      agent = await startAgent();
      expect(await agent.call('connect', {'uri': app.uri}), {
        'connected': true,
        'providers': 4,
      });
    });

    test('list_providers describes the providers', () async {
      final providers = await agent.providers();

      expect(providers.keys, [
        'counterProvider',
        'doubleProvider',
        'userProvider',
        'valuesProvider',
      ]);
      expect(providers['counterProvider'], {
        'id': isA<String>(),
        'name': 'counterProvider',
        'container': isA<String>(),
        'definedAt': matches(r'^file://.*/test/fixtures/app\.dart:\d+:\d+$'),
        'hasNotifier': true,
        'change': 'added',
      });
      expect(providers['doubleProvider'], containsPair('hasNotifier', false));
      expect(providers['userProvider'], containsPair('argument', 'john'));
    });

    test('list_providers filters providers', () async {
      final result = await agent.call('list_providers', {'search': 'john'});

      expect((result! as Map)['providers'], [
        containsPair('name', 'userProvider'),
      ]);
    });

    test('inspect_provider reads states', () async {
      expect(await agent.inspect('counterProvider'), {
        'type': 'int',
        'value': 0,
      });
      expect(await agent.inspect('userProvider'), {
        'type': 'AsyncData',
        'children': [
          {
            'name': 'value',
            'type': 'User',
            'hash': isA<String>(),
            'children': [
              {'name': 'name', 'type': 'String', 'value': 'john'},
              {
                'name': 'tags',
                'type': 'List',
                'size': 2,
                'truncated': true,
                'path': [0, 1],
              },
            ],
          },
        ],
      });
    });

    test('inspect_provider reads nested values from their path', () async {
      expect(
        await agent.inspect('userProvider', {
          'path': [0, 1],
        }),
        {
          'type': 'List',
          'size': 2,
          'children': [
            {'name': '0', 'type': 'String', 'value': 'a'},
            {'name': '1', 'type': 'String', 'value': 'b'},
          ],
        },
      );
      expect(await agent.inspect('userProvider', {'depth': 0}), {
        'type': 'AsyncData',
        'truncated': true,
        'path': <int>[],
      });

      await expectLater(
        agent.inspect('userProvider', {
          'path': [0, 5],
        }),
        throwsToolError(
          'Invalid path [0, 5]: no child at index 5 of [0], '
          'which has 2 children.',
        ),
      );
    });

    test('inspect_provider reads notifiers', () async {
      final notifier =
          (await agent.inspect('counterProvider', {'target': 'notifier'}))!
              as Map<String, Object?>;
      List<Object?> members(Map<String, Object?> value) {
        return [
          for (final child in value['children']! as List<Object?>)
            (child! as Map<String, Object?>)['name'],
        ];
      }

      expect(notifier['type'], 'Counter');
      expect(members(notifier), contains('state'));
      expect(members(notifier), isNot(contains(startsWith('_'))));

      final withPrivate =
          (await agent.inspect('counterProvider', {
                'target': 'notifier',
                'showPrivateMembers': true,
              }))!
              as Map<String, Object?>;
      expect(members(withPrivate), contains(startsWith('_')));

      await expectLater(
        agent.inspect('doubleProvider', {'target': 'notifier'}),
        throwsToolError('doubleProvider has no notifier.'),
      );
    });

    test('tools reject unknown providers and frames', () async {
      await expectLater(
        agent.call('inspect_provider', {'id': 'unknown'}),
        throwsToolError(
          'No provider with id "unknown" in frame 0. '
          'Use `list_providers` to list providers.',
        ),
      );
      await expectLater(
        agent.call('list_providers', {'frame': 42}),
        throwsToolError(
          'No frame with id 42. Use `list_frames` to list frames.',
        ),
      );
    });

    test('evaluate runs code against a provider', () async {
      final id = await agent.id('counterProvider');

      expect(
        await agent.call('evaluate', {'id': id, 'expression': r'$state + 10'}),
        {
          'result': {'type': 'int', 'value': 10},
        },
      );
      expect(
        await agent.call('evaluate', {
          'id': id,
          'expression': r'[$previous, $previous]',
          'depth': 0,
        }),
        {
          'result': {
            'type': 'List',
            'size': 2,
            'truncated': true,
            'path': <int>[],
          },
        },
      );

      await agent.call('evaluate', {
        'id': id,
        'expression': r'$notifier.increment()',
      });

      // Changes made by the evaluation are visible right away.
      expect(await agent.inspect('counterProvider'), {
        'type': 'int',
        'value': 1,
      });
      expect(await agent.inspect('doubleProvider'), {
        'type': 'int',
        'value': 2,
      });
      expect(
        (await agent.providers())['counterProvider'],
        containsPair('change', 'modified'),
      );
    });

    test('evaluate reports code that fails', () async {
      await expectLater(
        agent.call('evaluate', {
          'id': await agent.id('counterProvider'),
          'expression': 'throw StateError("nope")',
        }),
        throwsToolError(contains('nope')),
      );
    });

    test('invalidate_provider rebuilds a provider', () async {
      final id = await agent.id('counterProvider');
      await agent.call('evaluate', {
        'id': id,
        'expression': r'$notifier.increment()',
      });

      expect(await agent.call('invalidate_provider', {'id': id}), {
        'invalidated': containsPair('name', 'counterProvider'),
      });

      expect(await agent.inspect('counterProvider'), {
        'type': 'int',
        'value': 0,
      });
    });

    test('time travel records frames that can be inspected', () async {
      final id = await agent.id('counterProvider');
      expect(await agent.call('list_frames'), {
        'timeTravel': false,
        'frames': [
          {'id': 0, 'timestamp': isA<String>(), 'changes': hasLength(4)},
        ],
      });

      expect(await agent.call('set_time_travel', {'enabled': true}), {
        'timeTravel': true,
      });
      await agent.call('evaluate', {
        'id': id,
        'expression': r'$notifier.increment()',
      });

      final frames = (await agent.call('list_frames'))! as Map<String, Object?>;
      expect(frames['timeTravel'], isTrue);
      expect(frames['frames'], [
        containsPair('id', 0),
        {
          'id': 1,
          'timestamp': isA<String>(),
          'changes': unorderedEquals([
            {'id': id, 'name': 'counterProvider', 'change': 'modified'},
            {
              'id': isA<String>(),
              'name': 'doubleProvider',
              'change': 'modified',
            },
          ]),
        },
      ]);

      // Past states stay readable.
      expect(await agent.inspect('counterProvider', {'frame': 0}), {
        'type': 'int',
        'value': 0,
      });
      expect(await agent.inspect('counterProvider', {'frame': 1}), {
        'type': 'int',
        'value': 1,
      });

      expect(await agent.call('set_time_travel', {'enabled': false}), {
        'timeTravel': false,
      });
      expect(
        ((await agent.call('list_frames'))! as Map<String, Object?>)['frames'],
        hasLength(1),
      );
    });

    test('connect replaces the previous application', () async {
      final id = await agent.id('counterProvider');
      final other = await startApp();

      await agent.call('connect', {'uri': other.uri});

      await expectLater(
        agent.call('inspect_provider', {'id': id}),
        throwsToolError(startsWith('No provider with id')),
      );
      expect(await agent.inspect('counterProvider'), {
        'type': 'int',
        'value': 0,
      });
    });
  });

  test('tools report that the application stopped', () async {
    final app = await startApp();
    final agent = await startAgent();
    await agent.call('connect', {'uri': app.uri});

    await app.stop();
    await pumpEventQueue();

    await expectLater(
      agent.call('list_providers'),
      throwsToolError(startsWith('The application has stopped.')),
    );
    await expectLater(
      agent.call('list_providers'),
      throwsToolError(startsWith('Not connected to an application.')),
    );
  });
}
