import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/test.dart';
import 'package:path/path.dart';
import 'package:custom_lint_core/custom_lint_core.dart';
import 'package:riverpod_lint/src/riverpod_custom_lint.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:collection/collection.dart';

final goldenWrite = bool.parse(Platform.environment[r'goldens'] ?? 'false');

File writeToTemporaryFile(String content) {
  final tempDir = Directory.systemTemp.createTempSync();
  addTearDown(() => tempDir.deleteSync(recursive: true));

  final file = File(join(tempDir.path, 'file.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync(content);

  return file;
}

@isTest
void testLint(
  String description,
  String file,
  RiverpodLintRule lint, {
  required String goldensDirectory,
}) {
  assert(file.endsWith('.dart'));
  final fixesGoldenPath = join(
    goldensDirectory,
    '${basenameWithoutExtension(file)}_fix.diff',
  );
  final lintGoldenPath = join(
    goldensDirectory,
    '${basenameWithoutExtension(file)}_lint.diff',
  );

  test(description, () async {
    final sourcePath = File(normalize(file)).absolute;
    final result = await resolveFile2(path: sourcePath.path);
    result as ResolvedUnitResult;

    final errors = await lint.testRun(result);

    final fixes = await lint.getFixes();
    if (fixes.isNotEmpty) {
      final changes = await Future.wait([
        for (final fix in fixes)
          for (final error in errors) fix.testRun(result, error, errors),
      ]);

      await _expectFixesMatchesGolden(
        fixesGoldenPath,
        changes.flattened,
        source: result.content,
        sourcePath: sourcePath.path,
      );
    }
  });
}

Future<void> _expectFixesMatchesGolden(
  String fileName,
  Iterable<PrioritizedSourceChange> changes, {
  required String source,
  required String sourcePath,
}) async {
  try {
    expect(
      changes,
      matcherNormalizedPrioritizedSourceChangeSnapshot(
        fileName,
        sources: {'**': source},
        relativePath: Directory.current.path,
      ),
    );
  } on TestFailure {
    // ignore: deprecated_member_use_from_same_package, deprecated only to avoid commit
    if (!goldenWrite) rethrow;

    final source = File(sourcePath).readAsStringSync();
    final result = encodePrioritizedSourceChanges(
      changes,
      sources: {'**': source},
      relativePath: Directory.current.path,
    );

    final golden = File('test/$fileName');
    golden
      ..createSync(recursive: true)
      ..writeAsStringSync(result);
    return;
  }
}
