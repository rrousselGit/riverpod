import 'dart:io';

import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:custom_lint_core/custom_lint_core.dart';
import 'package:matcher/matcher.dart';
import 'package:test/test.dart';

import 'golden.dart';

Matcher matchesPrioritizedSourceChangesGolden(
  String fileName, {
  required String source,
  required String sourcePath,
}) {
  return matchersGoldenFile<Iterable<PrioritizedSourceChange>>(
    File(fileName),
    encode: (changes) {
      return encodePrioritizedSourceChanges(
        changes,
        sources: {'**': source},
        relativePath: Directory.current.path,
      );
    },
  );
}
