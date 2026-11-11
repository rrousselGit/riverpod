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
  }

  final VmServiceConnection connection;
  final ProviderContainer container;

  /// The result of the last `evaluate` of every provider, for `$previous`.
  final previous = <internals.ElementId, RootCachedObject>{};

  /// The up-to-date value of [provider].
  Future<ValueT> read<ValueT>(ProviderListenable<AsyncValue<ValueT>> provider) {
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
    return result.future.whenComplete(subscription.close);
  }

  Future<Byte<ResolvedVariable>> resolve(CachedObject object) {
    return read(resolvedVariableForObjectProvider(object));
  }

  /// Waits for the changes that a tool just made to be visible to the next
  /// tools.
  Future<void> sync() => container.read(framesProvider.notifier).sync();

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
            'Reads the state of a provider (or its notifier) as a tree of '
            'values. Values nested deeper than `depth` are marked as '
            'truncated, with the `path` to pass to inspect them.',
        inputSchema: Schema.object(
          properties: {
            'id': _idSchema,
            'target': Schema.string(
              description: 'What to read. Defaults to "state".',
              enumValues: ['state', 'notifier'],
            ),
            'frame': _frameSchema,
            'depth': Schema.int(
              description: 'How many levels of nested values to read.',
              minimum: 0,
            ),
            'path': Schema.list(
              description:
                  'Starts from a nested value: the `path` of a truncated '
                  'value from a previous call.',
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

  _Session? _session;

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

  Future<CallToolResult> _connect(CallToolRequest request) async {
    await _disconnect();
    try {
      final uri = vmServiceWebSocketUri(request.arguments!['uri']! as String);
      final service = await vmServiceConnectUri(uri.toString());
      final session = _session = _Session(
        await VmServiceConnection.start(service),
      );

      final frames = await session
          .read(framesProvider)
          .timeout(const Duration(seconds: 30));
      return _result({
        'connected': true,
        'providers': frames.lastOrNull?.elements.length ?? 0,
      });
    } catch (error) {
      await _disconnect();
      return _error(
        'Could not connect: $error\n'
        'The application has to be running in debug mode and use Riverpod.',
      );
    }
  }

  /// A tool that needs a connected application.
  FutureOr<CallToolResult> Function(CallToolRequest) _tool(
    Future<Object?> Function(_Session session, Map<String, Object?> args) run,
  ) {
    return (request) async {
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

      try {
        final result = await run(
          session,
          request.arguments ?? const {},
        ).timeout(const Duration(seconds: 30));
        return _result(result);
      } catch (error) {
        return _error('$error');
      }
    };
  }

  Future<FoldedFrame> _frame(_Session session, Object? id) async {
    final frames = await session.read(framesProvider);
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
  ) async {
    final frame = await _frame(session, args['frame']);
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
  ) async {
    final frame = await _frame(session, args['frame']);
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
  ) async {
    final element = await _element(session, args);
    final target = args['target'] as String? ?? 'state';
    final root = switch (target) {
      'notifier' => element.notifier?.state,
      _ => element.state.state,
    };
    if (root == null) {
      throw _ToolException(
        '${element.provider.origin.toStringValue} has no notifier.',
      );
    }

    session.container
        .read(inspectorSettingsProvider.notifier)
        .setShowExternalPrivateMembers(
          value: args['showPrivateMembers'] as bool? ?? false,
        );
    final path = (args['path'] as List<Object?>? ?? const []).cast<int>();
    final CachedObject object;
    try {
      object = await objectAtPath(root, path, resolve: session.resolve);
    } on FormatException catch (error) {
      throw _ToolException(error.message);
    }

    return {
      'provider': _describeProvider(element.provider),
      'target': target,
      'value': await describeObject(
        object,
        resolve: session.resolve,
        depth: args['depth'] as int? ?? _defaultDepth,
        path: path,
      ),
    };
  }

  Future<Object?> _listFrames(
    _Session session,
    Map<String, Object?> args,
  ) async {
    final frames = await session.read(framesProvider);

    return {
      'timeTravel': await session.read(timeTravelProvider),
      'frames': [
        for (final frame in frames.where((frame) => frame.hasStateChanges))
          {
            'id': frame.id,
            'timestamp': frame.frame.timestamp.toIso8601String(),
            'changes': [
              for (final event in frame.frame.events)
                if (event
                    case ProviderElementAddEvent(:final provider) ||
                        ProviderElementUpdateEvent(:final provider) ||
                        ProviderElementDisposeEvent(:final provider))
                  {
                    'id': provider.elementId,
                    'name': provider.origin.toStringValue,
                    if (provider.origin.isFamily)
                      'argument': provider.argToStringValue,
                    'change': frame.statusOf(provider.elementId)!.name,
                  },
            ],
          },
      ],
    };
  }

  Future<Object?> _setTimeTravel(
    _Session session,
    Map<String, Object?> args,
  ) async {
    final enabled = args['enabled']! as bool;
    await session.container
        .read(timeTravelProvider.notifier)
        .setEnabled(enabled);
    await session.sync();

    return {'timeTravel': await session.read(timeTravelProvider)};
  }

  Future<Object?> _invalidateProvider(
    _Session session,
    Map<String, Object?> args,
  ) async {
    final element = await _element(session, args);
    final eval = await session.read(evalProvider);
    await element.invalidate(eval, isAlive: Disposable());
    await session.sync();

    return {'invalidated': _describeProvider(element.provider)};
  }

  Future<Object?> _evaluate(_Session session, Map<String, Object?> args) async {
    final element = await _element(session, args);
    final id = element.provider.elementId;
    final eval = await session.read(evalProvider);
    final isAlive = Disposable();

    final result = await evalInTerminal(
      args['expression']! as String,
      eval,
      state: element.state.state,
      notifier: element.notifier?.state,
      previous: session.previous[id],
      isAlive: isAlive,
    );
    await session.sync();

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
            resolve: session.resolve,
            depth: args['depth'] as int? ?? _defaultDepth,
          ),
        };
    }
  }
}
