// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_graph/src/analyze.dart';

Future<void> main(List<String> args) {
  final parser = ArgParser();
  parser.addOption(
    'format',
    abbr: 'f',
    defaultsTo: 'mermaid',
    help: 'output format. [mermaid(default), d2]',
  );

  final parsedArgs = parser.parse(args);

  final rootDirectory = parsedArgs.arguments.isNotEmpty
      ? path.normalize(path.absolute(parsedArgs.arguments.first))
      : Directory.current.absolute.path;

  final format = SupportFormat.values.byName(parsedArgs['format'].toString());

  return analyze(rootDirectory, format: format);
}
