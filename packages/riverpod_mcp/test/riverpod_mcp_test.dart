import 'dart:convert';
import 'dart:io';

import 'package:dart_mcp/client.dart';
import 'package:dart_mcp/stdio.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test('the executable serves an application over stdio', () async {
    final app = await startApp();
    final process = await Process.start(Platform.resolvedExecutable, [
      'run',
      'bin/riverpod_mcp.dart',
    ]);
    addTearDown(process.kill);
    final client = MCPClient(Implementation(name: 'test', version: '0.0.0'));
    final server = client.connectServer(
      stdioChannel(input: process.stdout, output: process.stdin),
    );
    addTearDown(server.shutdown);

    final initialized = await server.initialize(
      InitializeRequest(
        protocolVersion: ProtocolVersion.latestSupported,
        capabilities: client.capabilities,
        clientInfo: client.implementation,
      ),
    );
    server.notifyInitialized();
    expect(initialized.serverInfo.name, 'riverpod');

    final connected = await server.callTool(
      CallToolRequest(name: 'connect', arguments: {'uri': app.uri}),
    );

    expect(connected.isError, isNot(true));
    expect(jsonDecode((connected.content.single as TextContent).text), {
      'connected': true,
      'providers': 4,
    });
  });
}
