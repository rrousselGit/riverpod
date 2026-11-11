import 'dart:io' as io;

import 'package:dart_mcp/stdio.dart';
import 'package:riverpod_mcp/riverpod_mcp.dart';

void main() {
  RiverpodMcpServer(stdioChannel(input: io.stdin, output: io.stdout));
}
