import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dart_mcp/server.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' as internals;
import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:vm_service/vm_service.dart' show VmService;
import 'package:vm_service/vm_service_io.dart';

import 'snapshot.dart';

/// The WebSocket URI of a VM service, from any of the forms that tools print.
///
/// `flutter run` and `dart run` print an HTTP URI such as
/// `http://127.0.0.1:8181/token=/`, whereas the VM service is reached at
/// `ws://127.0.0.1:8181/token=/ws`.
@visibleForTesting
Uri vmServiceWebSocketUri(String uri) {
  final parsed = Uri.parse(uri.trim());
  final segments = parsed.pathSegments.where((e) => e.isNotEmpty).toList();
  if (segments.lastOrNull != 'ws') segments.add('ws');

  return parsed.replace(
    scheme: switch (parsed.scheme) {
      'http' => 'ws',
      'https' => 'wss',
      final scheme => scheme,
    },
    pathSegments: segments,
  );
}

/// An error to report to the agent as the result of a tool.
class _ToolException implements Exception {
  _ToolException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// The application that the server is connected to.
class _Session {
  _Session(this.connection)
    : container = ProviderContainer(
        overrides: [appConnectionProvider.overrideWith((ref) => connection)],
        // Agents are told about failures right away, and decide what to do.
        retry: (_, _) => null,
      ) {
    // Inspected values only stay readable while frames are listened to.
    container.listen(framesProvider, (_, _) {});
    container.listen(timeTravelProvider, (_, _) {});
    // Results do not outlive the session of the devtool that evaluated them.
    container.listen(devtoolSessionProvider, (_, _) => previous.clear());
  }

  final VmServiceConnection connection;
  final ProviderContainer container;

  /// The result of the last `evaluate` of every provider, for `$previous`.
  final previous = <internals.ElementId, RootCachedObject>{};

  /// The providers that [read] is waiting for.
  final _reads = <ProviderSubscription<Object?>>{};

  /// The up-to-date value of [provider].
  ///
  /// Fails with a [CancelledException] if [isAlive] is disposed.
  Future<ValueT> read<ValueT>(
    ProviderListenable<AsyncValue<ValueT>> provider,
    Disposable isAlive,
  ) {
    if (isAlive.disposed) return Future.error(CancelledException());

    final result = Completer<ValueT>();
    final subscription = container.listen(provider, fireImmediately: true, (
      _,
      next,
    ) {
      // Rebuilding providers still expose their previous value.
      if (result.isCompleted || next.isLoading) return;
      if (next.error case final error?) {
        result.completeError(error, next.stackTrace);
      } else {
        result.complete(next.requireValue);
      }
    });
    _reads.add(subscription);
    return result.future.whenComplete(() {
      if (_reads.remove(subscription)) subscription.close();
    });
  }

  /// Stops waiting for the providers that a tool which ended was reading.
  ///
  /// Tools run one at a time, so those are all from that tool.
  void cancelReads() {
    for (final subscription in _reads) {
      subscription.close();
    }
    _reads.clear();
  }

  ResolveObject resolve(Disposable isAlive) {
    return (object) => read(resolvedVariableForObjectProvider(object), isAlive);
  }

  /// Waits for the changes that a tool just made to be visible to the next
  /// tools.
  Future<void> sync(Disposable isAlive) async {
    if (isAlive.disposed) throw CancelledException();
    await container.read(framesProvider.notifier).sync();
  }

  Future<void> close() async {
    container.dispose();
    await connection.dispose();
  }
}

/// An MCP server exposing the features of Riverpod's devtool to AI agents.
base class RiverpodMcpServer extends MCPServer with ToolsSupport {
  RiverpodMcpServer(super.channel)
    : super.fromStreamChannel(
        implementation: Implementation(name: 'riverpod', version: '0.0.1'),
        instructions:
            'Inspects the providers of a running Riverpod application, as '
            "Riverpod's devtool does. The application has to run in debug "
            'mode. Start with `connect`, then `list_providers` to find the '
            'id of providers, and `inspect_provider` to read their state.',
      ) {
    registerTool(
      Tool(
        name: 'connect',
        description:
            'Connects to a running Dart or Flutter application that uses '
            'Riverpod, replacing any previous connection. Required before '
            'any other tool.',
        inputSchema: Schema.object(
          properties: {
            'uri': Schema.string(
              description:
                  'The VM service URI of the application, as printed by '
                  '`flutter run` or `dart run --enable-vm-service`, such as '
                  'http://127.0.0.1:8181/AbCdEf=/',
            ),
          },
          required: ['uri'],
        ),
      ),
      _connect,
    );
    registerTool(
      Tool(
        name: 'list_providers',
        description:
            'Lists the providers of the application, with the id to pass '
            'to other tools, where they are defined and what changed in '
            'the frame.',
        inputSchema: Schema.object(
          properties: {
            'search': Schema.string(
              description:
                  'Only lists providers whose name or argument fuzzy-match.',
            ),
            'frame': _frameSchema,
          },
        ),
      ),
      _tool(_listProviders),
    );
    registerTool(
      Tool(
        name: 'inspect_provider',
        description:
            'Reads the state of a provider (or its notifier, or the result '
            'of its last `evaluate`) as a tree of values. Values nested '
            'deeper than `depth`, or past the first $maxDescribedValues '
            'values, are marked as truncated, with the `path` to pass to '
            'inspect them.',
        inputSchema: Schema.object(
          properties: {
            'id': _idSchema,
            'target': Schema.string(
              description: 'What to read. Defaults to "state".',
              enumValues: ['state', 'notifier', 'previous'],
            ),
            'frame': _frameSchema,
            'depth': Schema.int(
              description: 'How many levels of nested values to read.',
              minimum: 0,
            ),
            'path': Schema.list(
              description:
                  'Starts from a nested value: the `path` of a truncated '
                  'value from a previous call. Has to come with the `target` '
                  'and `showPrivateMembers` of that call, which change what '
                  'a path leads to. The paths that `evaluate` returns are '
                  'for the "previous" target.',
              items: Schema.int(),
            ),
            'showPrivateMembers': Schema.bool(
              description:
                  'Also reads the private members of objects that the '
                  "application's package does not define.",
            ),
          },
          required: ['id'],
        ),
      ),
      _tool(_inspectProvider),
    );
    registerTool(
      Tool(
        name: 'list_frames',
        description:
            'Lists the recorded frames and which providers changed in '
            'each. Without time travel, there is a single frame: the '
            'current state of the application.',
        inputSchema: Schema.object(),
      ),
      _tool(_listFrames),
    );
    registerTool(
      Tool(
        name: 'set_time_travel',
        description:
            'Starts or stops recording a frame for every change, to '
            'inspect past states. Stopping discards the recorded frames.',
        inputSchema: Schema.object(
          properties: {'enabled': Schema.bool()},
          required: ['enabled'],
        ),
      ),
      _tool(_setTimeTravel),
    );
    registerTool(
      Tool(
        name: 'invalidate_provider',
        description: 'Invalidates a provider, causing it to rebuild.',
        inputSchema: Schema.object(
          properties: {'id': _idSchema},
          required: ['id'],
        ),
      ),
      _tool(_invalidateProvider),
    );
    registerTool(
      Tool(
        name: 'evaluate',
        description:
            'Evaluates a Dart expression in the application, within the '
            'library that defines the state of a provider. The expression '
            r'can use `$state`, `$notifier` (for Notifiers) and `$previous` '
            '(the result of the previous evaluation for this provider). '
            r'For example `$notifier.increment()` or `$state.length`. '
            'Truncated values of the result are read by passing their '
            '`path` to `inspect_provider`, with the "previous" target. '
            'This can modify the application.',
        inputSchema: Schema.object(
          properties: {
            'id': _idSchema,
            'expression': Schema.string(),
            'depth': Schema.int(
              description: 'How many levels of nested values to read.',
              minimum: 0,
            ),
          },
          required: ['id', 'expression'],
        ),
      ),
      _tool(_evaluate),
    );
  }

  static final _idSchema = Schema.string(
    description: 'The id of a provider, from `list_providers`.',
  );
  static final _frameSchema = Schema.int(
    description:
        'The id of a frame from `list_frames`. Defaults to the latest one.',
  );

  static const _defaultDepth = 2;

  /// How long tools have to complete, before they are stopped.
  @visibleForTesting
  Duration toolTimeout = const Duration(seconds: 30);

  _Session? _session;

  /// The tool that runs, or the last one that did.
  Future<void> _lastTool = Future.value();

  /// Runs tools one at a time, in the order they were called.
  ///
  /// Agents may call tools in parallel, but tools share one application and
  /// its settings.
  Future<CallToolResult> _queue(Future<CallToolResult> Function() tool) {
    final result = _lastTool.then((_) => tool());
    _lastTool = result.then((_) {}, onError: (Object _) {});
    return result;
  }

  CallToolResult _result(Object? json) {
    return CallToolResult(content: [TextContent(text: jsonEncode(json))]);
  }

  CallToolResult _error(String message) {
    return CallToolResult(content: [TextContent(text: message)], isError: true);
  }

  Future<void> _disconnect() async {
    final session = _session;
    _session = null;
    await session?.close();
  }

  @override
  Future<void> shutdown() async {
    await _disconnect();
    await super.shutdown();
  }

  Future<CallToolResult> _connect(CallToolRequest request) {
    return _queue(() async {
      await _disconnect();
      final isAlive = Disposable();
      VmService? service;
      try {
        // Applications may accept the connection and never answer.
        final frames = await () async {
          final uri = vmServiceWebSocketUri(
            request.arguments!['uri']! as String,
          );
          final opened = service = await vmServiceConnectUri(uri.toString());
          // Nothing closes what is opened once connecting took too long.
          if (isAlive.disposed) {
            await opened.dispose();
            throw CancelledException();
          }
          // Fails if taking too long, as the service gets closed.
          final session = _session = _Session(
            await VmServiceConnection.start(opened),
          );

          return session.read(framesProvider, isAlive);
        }().timeout(toolTimeout);
        return _result({
          'connected': true,
          'providers': frames.lastOrNull?.elements.length ?? 0,
        });
      } catch (error) {
        isAlive.dispose();
        await _disconnect();
        await service?.dispose();
        return _error(
          'Could not connect: $error\n'
          'The application has to be running in debug mode and use Riverpod.',
        );
      }
    });
  }

  /// A tool that needs a connected application.
  ///
  /// `isAlive` is disposed once the tool ended, including by taking too long.
  /// Tools stop at their next step when that happens.
  FutureOr<CallToolResult> Function(CallToolRequest) _tool(
    Future<Object?> Function(
      _Session session,
      Map<String, Object?> args,
      Disposable isAlive,
    )
    run,
  ) {
    return (request) => _queue(() async {
      final session = _session;
      if (session == null) {
        return _error(
          'Not connected to an application. Call `connect` first, with the '
          'VM service URI of an application running in debug mode.',
        );
      }
      if (!session.connection.connected) {
        await _disconnect();
        return _error(
          'The application has stopped. Call `connect` again once it runs.',
        );
      }

      final isAlive = Disposable();
      try {
        final result = await run(
          session,
          request.arguments ?? const {},
          isAlive,
        ).timeout(toolTimeout);
        return _result(result);
      } catch (error) {
        return _error('$error');
      } finally {
        isAlive.dispose();
        session.cancelReads();
      }
    });
  }

  Future<FoldedFrame> _frame(
    _Session session,
    Object? id,
    Disposable isAlive,
  ) async {
    final frames = await session.read(framesProvider, isAlive);
    final frame = id == null
        ? frames.lastOrNull
        : frames.firstWhereOrNull((frame) => frame.id == FrameId(id as int));
    if (frame != null) return frame;

    throw _ToolException(
      id == null
          ? 'The application has not created any provider yet.'
          : 'No frame with id $id. Use `list_frames` to list frames.',
    );
  }

  Future<ElementMeta> _element(
    _Session session,
    Map<String, Object?> args,
    Disposable isAlive,
  ) async {
    final frame = await _frame(session, args['frame'], isAlive);
    final id = args['id']! as String;
    final element = frame.elements[internals.ElementId(id)];
    if (element != null) return element;

    throw _ToolException(
      'No provider with id "$id" in frame ${frame.id}. '
      'Use `list_providers` to list providers.',
    );
  }

  Map<String, Object?> _describeProvider(ProviderMeta provider) {
    final trace =
        provider.creationStackTrace ?? provider.origin.creationStackTrace;
    final location = trace == null
        ? null
        : Trace.parse(trace).frames.firstOrNull;

    return {
      'id': provider.elementId,
      'name': provider.origin.toStringValue,
      if (provider.origin.isFamily) 'argument': provider.argToStringValue,
      'container': provider.containerHashValue,
      if (location != null)
        'definedAt': '${location.uri}:${location.line}:${location.column}',
    };
  }

  Future<Object?> _listProviders(
    _Session session,
    Map<String, Object?> args,
    Disposable isAlive,
  ) async {
    final frame = await _frame(session, args['frame'], isAlive);
    final origins = session.container.read(
      filteredProvidersProvider((
        search: args['search'] as String? ?? '',
        frame: frame.id,
      )),
    );

    return {
      'frame': frame.id,
      'providers': [
        for (final origin in origins.values)
          for (final provider in origin.elements)
            {
              ..._describeProvider(provider.element.provider),
              'hasNotifier': provider.element.notifier != null,
              if (provider.status case final status?) 'change': status.name,
            },
      ],
    };
  }

  Future<Object?> _inspectProvider(
    _Session session,
    Map<String, Object?> args,
    Disposable isAlive,
  ) async {
    final element = await _element(session, args, isAlive);
    final target = args['target'] as String? ?? 'state';
    final root = switch (target) {
      'notifier' => element.notifier?.state,
      'previous' => session.previous[element.provider.elementId],
      _ => element.state.state,
    };
    if (root == null) {
      throw _ToolException(
        '${element.provider.origin.toStringValue} has no '
        '${target == 'previous' ? 'evaluation result' : target}.',
      );
    }

    final showPrivateMembers = args['showPrivateMembers'] as bool? ?? false;
    session.container
        .read(inspectorSettingsProvider.notifier)
        .setShowExternalPrivateMembers(value: showPrivateMembers);
    final resolve = session.resolve(isAlive);
    final path = (args['path'] as List<Object?>? ?? const []).cast<int>();
    final CachedObject object;
    try {
      object = await objectAtPath(root, path, resolve: resolve);
    } on FormatException catch (error) {
      throw _ToolException(error.message);
    }

    return {
      'provider': _describeProvider(element.provider),
      'target': target,
      // Reminds of what the paths of truncated values depend on.
      if (showPrivateMembers) 'showPrivateMembers': true,
      'value': await describeObject(
        object,
        resolve: resolve,
        depth: args['depth'] as int? ?? _defaultDepth,
        path: path,
      ),
    };
  }

  /// The provider that [event] changed and how, if it is about a provider.
  (ProviderMeta, ProviderStatusInFrame)? _change(Event event) {
    return switch (event) {
      ProviderElementAddEvent(:final provider) => (
        provider,
        ProviderStatusInFrame.added,
      ),
      ProviderElementUpdateEvent(:final provider) => (
        provider,
        ProviderStatusInFrame.modified,
      ),
      ProviderElementDisposeEvent(:final provider) => (
        provider,
        ProviderStatusInFrame.disposed,
      ),
      _ => null,
    };
  }

  Future<Object?> _listFrames(
    _Session session,
    Map<String, Object?> args,
    Disposable isAlive,
  ) async {
    final frames = await session.read(framesProvider, isAlive);

    return {
      'timeTravel': await session.read(timeTravelProvider, isAlive),
      'frames': [
        for (final frame in frames.where((frame) => frame.hasStateChanges))
          {
            'id': frame.id,
            'timestamp': frame.frame.timestamp.toIso8601String(),
            'changes': [
              // A provider may change more than once in a frame.
              for (final event in frame.frame.events)
                if (_change(event) case (final provider, final change)?)
                  {
                    'id': provider.elementId,
                    'name': provider.origin.toStringValue,
                    if (provider.origin.isFamily)
                      'argument': provider.argToStringValue,
                    'change': change.name,
                  },
            ],
          },
      ],
    };
  }

  Future<Object?> _setTimeTravel(
    _Session session,
    Map<String, Object?> args,
    Disposable isAlive,
  ) async {
    final enabled = args['enabled']! as bool;
    await session.container
        .read(timeTravelProvider.notifier)
        .setEnabled(enabled);
    await session.sync(isAlive);

    return {'timeTravel': await session.read(timeTravelProvider, isAlive)};
  }

  Future<Object?> _invalidateProvider(
    _Session session,
    Map<String, Object?> args,
    Disposable isAlive,
  ) async {
    final element = await _element(session, args, isAlive);
    final eval = await session.read(evalProvider, isAlive);
    await element.invalidate(eval, isAlive: isAlive);
    await session.sync(isAlive);

    return {'invalidated': _describeProvider(element.provider)};
  }

  Future<Object?> _evaluate(
    _Session session,
    Map<String, Object?> args,
    Disposable isAlive,
  ) async {
    final element = await _element(session, args, isAlive);
    final id = element.provider.elementId;
    final eval = await session.read(evalProvider, isAlive);

    final result = await evalInTerminal(
      args['expression']! as String,
      eval,
      state: element.state.state,
      notifier: element.notifier?.state,
      previous: session.previous[id],
      isAlive: isAlive,
    );
    await session.sync(isAlive);

    switch (result) {
      case ByteError(:final error):
        throw _ToolException('$error');
      case ByteVariable(:final instance):
        // Only the latest result is kept in the memory of the application.
        await session.previous[id]?.delete(eval, isAlive: isAlive);
        session.previous[id] = instance;

        return {
          'result': await describeObject(
            instance,
            resolve: session.resolve(isAlive),
            depth: args['depth'] as int? ?? _defaultDepth,
          ),
        };
    }
  }
}
