import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_mcp/client.dart';
import 'package:riverpod_mcp/riverpod_mcp.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

/// The application of `test/fixtures/app.dart`, running in its own process.
class TestApp {
  TestApp._(this._process, this.uri);

  final Process _process;

  /// The VM service URI, as `dart run` prints it.
  final String uri;

  Future<void> stop() async {
    _process.kill();
    await _process.exitCode;
  }

  /// Evaluates [code] within Riverpod, in the application.
  Future<String?> evalInRiverpod(String code) async {
    final service = await vmServiceConnectUri(
      '${uri.replaceFirst('http', 'ws')}ws',
    );
    try {
      final isolateId = (await service.getVM()).isolates!.first.id!;
      final isolate = await service.getIsolate(isolateId);
      final library = isolate.libraries!.firstWhere(
        (e) => e.uri == 'package:riverpod/src/framework.dart',
      );
      final result = await service.evaluate(isolateId, library.id!, code);
      return (result as InstanceRef).valueAsString;
    } finally {
      await service.dispose();
    }
  }

  /// Closes the sessions of the devtools inspecting the application, as the
  /// application does when it stops hearing from them.
  Future<void> expireDevtoolSessions() async {
    await evalInRiverpod(
      'RiverpodDevtool.instance._sessions.keys.toList()'
      '.forEach(RiverpodDevtool.instance.closeSession)',
    );
  }
}

/// Starts the application named [name] in `test/fixtures`.
///
/// The application is stopped once the current test or group is done.
Future<TestApp> startApp([String name = 'app']) async {
  final process = await Process.start(Platform.resolvedExecutable, [
    '--enable-vm-service=0',
    '--no-dds',
    '--disable-service-auth-codes',
    '--no-serve-devtools',
    '--enable-asserts',
    'test/fixtures/$name.dart',
  ]);
  // Before anything can fail, or the application would outlive the tests.
  addTearDown(() async {
    process.kill();
    await process.exitCode;
  });
  final lines = StreamIterator(
    process.stdout.transform(utf8.decoder).transform(const LineSplitter()),
  );
  final listening = RegExp(r'listening on (http://127\.0\.0\.1:\d+/)');
  String? uri;
  // The application prints "ready" once its providers exist.
  while (await lines.moveNext() && lines.current != 'ready') {
    uri ??= listening.firstMatch(lines.current)?.group(1);
  }

  return TestApp._(process, uri!);
}

/// An MCP client connected to a [RiverpodMcpServer], as an agent would be.
class Agent {
  Agent._(this.server, this.mcp);

  final ServerConnection server;

  /// The server that the agent talks to.
  final RiverpodMcpServer mcp;

  /// Calls a tool and decodes its JSON result.
  ///
  /// Tools that report an error throw its message.
  Future<Object?> call(String tool, [Map<String, Object?>? arguments]) async {
    final result = await server.callTool(
      CallToolRequest(name: tool, arguments: arguments),
    );
    final text = result.content.map((e) => (e as TextContent).text).join();
    if (result.isError ?? false) throw ToolError(text);
    return jsonDecode(text);
  }

  /// The providers of the application, by name.
  Future<Map<String, Map<String, Object?>>> providers() async {
    final result = (await call('list_providers'))! as Map<String, Object?>;
    return {
      for (final provider in result['providers']! as List<Object?>)
        (provider! as Map<String, Object?>)['name']! as String:
            provider as Map<String, Object?>,
    };
  }

  /// The id of the provider named [name].
  Future<String> id(String name) async {
    return (await providers())[name]!['id']! as String;
  }

  /// The value of a provider, as `inspect_provider` describes it.
  Future<Object?> inspect(String name, [Map<String, Object?>? args]) async {
    final result = await call('inspect_provider', {
      'id': await id(name),
      ...?args,
    });
    return (result! as Map<String, Object?>)['value'];
  }
}

class ToolError implements Exception {
  ToolError(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Starts a [RiverpodMcpServer] and connects an [Agent] to it.
Future<Agent> startAgent() async {
  final channel = StreamChannelController<String>();
  final mcp = RiverpodMcpServer(channel.local);
  final client = MCPClient(Implementation(name: 'test', version: '0.0.0'));
  final server = client.connectServer(channel.foreign);
  addTearDown(mcp.shutdown);

  await server.initialize(
    InitializeRequest(
      protocolVersion: ProtocolVersion.latestSupported,
      capabilities: client.capabilities,
      clientInfo: client.implementation,
    ),
  );
  server.notifyInitialized();

  return Agent._(server, mcp);
}

/// Matches tools failing with a message matching [message].
Matcher throwsToolError(Object message) {
  return throwsA(isA<ToolError>().having((e) => e.message, 'message', message));
}
