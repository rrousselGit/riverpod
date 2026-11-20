import 'dart:async';
import 'dart:io';

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

  test('connect gives up on applications that do not answer', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    var closed = Completer<void>();
    var acceptAfter = Duration.zero;
    server.listen((request) async {
      await Future<void>.delayed(acceptAfter);
      final socket = await WebSocketTransformer.upgrade(request);
      socket.listen(
        (_) {},
        onDone: () async {
          await socket.close();
          closed.complete();
        },
      );
    });
    final agent = await startAgent();
    agent.mcp.toolTimeout = const Duration(milliseconds: 200);

    // Whether the connection is accepted before or after giving up.
    for (final delay in [Duration.zero, const Duration(milliseconds: 500)]) {
      closed = Completer<void>();
      acceptAfter = delay;

      await expectLater(
        agent
            .call('connect', {'uri': 'ws://127.0.0.1:${server.port}/ws'})
            .timeout(const Duration(seconds: 5)),
        throwsToolError(startsWith('Could not connect: TimeoutException')),
      );
      // The connection that was opened is closed.
      await closed.future.timeout(const Duration(seconds: 5));
    }
    await expectLater(
      agent.call('list_providers'),
      throwsToolError(startsWith('Not connected to an application.')),
    );
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
    late TestApp app;
    setUp(() async {
      app = await startApp();
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
    });

    test('inspect_provider tells what its paths depend on', () async {
      final id = await agent.id('counterProvider');

      // Private members change the position of the others.
      expect(
        await agent.call('inspect_provider', {
          'id': id,
          'target': 'notifier',
          'showPrivateMembers': true,
        }),
        containsPair('showPrivateMembers', true),
      );
      expect(
        await agent.call('inspect_provider', {'id': id, 'target': 'notifier'}),
        isNot(contains('showPrivateMembers')),
      );
    });

    test('inspect_provider reports missing targets', () async {
      await expectLater(
        agent.inspect('doubleProvider', {'target': 'notifier'}),
        throwsToolError('doubleProvider has no notifier.'),
      );
      await expectLater(
        agent.inspect('doubleProvider', {'target': 'previous'}),
        throwsToolError('doubleProvider has no evaluation result.'),
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
      // The paths of a result lead to its values.
      expect(
        await agent.inspect('counterProvider', {
          'target': 'previous',
          'path': <int>[],
        }),
        {
          'type': 'List',
          'size': 2,
          'children': [
            {'name': '0', 'type': 'int', 'value': 10},
            {'name': '1', 'type': 'int', 'value': 10},
          ],
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

    test('evaluate reads private members only when asked to', () async {
      final id = await agent.id('counterProvider');
      Future<Map<String, Object?>> evaluate([
        Map<String, Object?> args = const {},
      ]) async {
        final result = await agent.call('evaluate', {
          'id': id,
          'expression': r'$notifier',
          ...args,
        });
        return result! as Map<String, Object?>;
      }

      List<Object?> members(Map<String, Object?> evaluation) {
        final result = evaluation['result']! as Map<String, Object?>;
        return [
          for (final child in result['children']! as List<Object?>)
            (child! as Map<String, Object?>)['name'],
        ];
      }

      // What another tool asked for does not change what the paths lead to.
      await agent.inspect('counterProvider', {
        'target': 'notifier',
        'showPrivateMembers': true,
      });
      final byDefault = await evaluate();
      expect(byDefault, isNot(contains('showPrivateMembers')));
      expect(members(byDefault), isNot(contains(startsWith('_'))));

      final withPrivate = await evaluate({'showPrivateMembers': true});
      expect(withPrivate, containsPair('showPrivateMembers', true));
      expect(members(withPrivate), contains(startsWith('_')));
    });

    test(r'evaluate forgets $previous once it expired', () async {
      final id = await agent.id('counterProvider');
      await agent.call('evaluate', {'id': id, 'expression': '42'});

      await app.expireDevtoolSessions();
      // The expiration is noticed by trying to use the session.
      await expectLater(
        agent.call('evaluate', {'id': id, 'expression': r'$state'}),
        throwsToolError(anything),
      );

      // Results of the expired session cannot be read anymore.
      expect(
        await agent.call('evaluate', {'id': id, 'expression': r'$state + 1'}),
        {
          'result': {'type': 'int', 'value': 1},
        },
      );
      await expectLater(
        agent.call('evaluate', {'id': id, 'expression': r'$previous'}),
        completion({
          'result': {'type': 'int', 'value': 1},
        }),
      );
    });

    test('tools called at once run one after the other', () async {
      final id = await agent.id('counterProvider');

      final results = await Future.wait([
        agent.call('evaluate', {
          'id': id,
          'expression': r'$notifier.increment()',
        }),
        agent.call('inspect_provider', {'id': id}),
        agent.call('connect', {'uri': app.uri}),
        agent.call('list_providers'),
      ]);

      // The second tool sees the changes of the first one.
      expect(results[1], containsPair('value', {'type': 'int', 'value': 1}));
      // The last tool uses the connection that the third one made.
      expect(results[2], {'connected': true, 'providers': 4});
      expect(results[3], containsPair('providers', hasLength(4)));
    });

    test('tools that take too long are stopped', () async {
      final id = await agent.id('counterProvider');
      await agent.call('evaluate', {'id': id, 'expression': '1'});

      agent.mcp.toolTimeout = const Duration(milliseconds: 100);
      await expectLater(
        agent.call('evaluate', {
          'id': id,
          'expression':
              '() { final stopwatch = Stopwatch()..start(); '
              'while (stopwatch.elapsedMilliseconds < 400) {} '
              'return 2; }()',
        }),
        throwsToolError(startsWith('TimeoutException')),
      );
      agent.mcp.toolTimeout = const Duration(seconds: 30);

      // The application still completes the evaluation.
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // The agent never saw the result of the evaluation that was stopped.
      expect(
        await agent.call('evaluate', {'id': id, 'expression': r'$previous'}),
        {
          'result': {'type': 'int', 'value': 1},
        },
      );
    });

    test('list_frames tells every change of a provider in a frame', () async {
      final id = await agent.id('counterProvider');
      await agent.call('set_time_travel', {'enabled': true});

      await agent.call('evaluate', {
        'id': id,
        'expression': r'$notifier.addAndUpdate()',
      });
      final frames = (await agent.call('list_frames'))! as Map<String, Object?>;
      final changes = [
        for (final frame in frames['frames']! as List<Object?>)
          ...(frame! as Map<String, Object?>)['changes']! as List<Object?>,
      ].cast<Map<String, Object?>>();
      expect(
        changes
            .where((change) => change['name'] == 'extraProvider')
            .map((change) => change['change']),
        ['added', 'modified'],
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

      // The session of the previous application does not wait to expire.
      expect(
        await app.evalInRiverpod(
          'RiverpodDevtool.instance._sessions.length.toString()',
        ),
        '0',
      );
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

  test('tools stop waiting for values once they took too long', () async {
    final app = await startApp('slow');
    final agent = await startAgent();
    await agent.call('connect', {'uri': app.uri});
    final id = await agent.id('slowProvider');

    agent.mcp.toolTimeout = const Duration(milliseconds: 100);
    await expectLater(
      agent.call('inspect_provider', {'id': id}),
      throwsToolError(startsWith('TimeoutException')),
    );
    agent.mcp.toolTimeout = const Duration(seconds: 30);

    // Once it has the time to, the value can be read.
    expect(
      await agent.inspect('slowProvider'),
      containsPair('children', [
        {'name': 'value', 'type': 'int', 'value': 42},
      ]),
    );
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
