// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:riverpod_graph/riverpod_graph.dart';

Future<void> main(List<String> args) {
  final rootDirectory = args.isNotEmpty
      ? path.normalize(path.absolute(args.first))
      : Directory.current.absolute.path;
  return analyze(rootDirectory);
}
