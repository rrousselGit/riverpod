import 'dart:io';

import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/test.dart';
import 'package:path/path.dart';
import 'package:riverpod_lint/src/riverpod_custom_lint.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:collection/collection.dart';

import 'encoders.dart';

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
    '${basenameWithoutExtension(file)}_lint.md',
  );

  test(description, () async {
    final sourcePath = File(normalize(file)).absolute;
    final result = await resolveFile2(path: sourcePath.path);
    result as ResolvedUnitResult;

    final errors = await lint.testRun(result);
    expect(
      errors,
      matchesAnalysisErrorGoldens(lintGoldenPath),
    );

    final fixes = await lint.getFixes();
    final changes = await Future.wait([
      for (final fix in fixes)
        for (final error in errors) fix.testRun(result, error, errors),
    ]);

    expect(
      changes.flattened,
      matchesPrioritizedSourceChangesGolden(
        fixesGoldenPath,
        source: result.content,
        sourcePath: sourcePath.path,
      ),
    );
  });
}

@isTest
void testGolden(
  String description,
  String file,
  Future<Iterable<PrioritizedSourceChange>> Function(ResolvedUnitResult)
      testRun, {
  required String sourcePath,
}) {
  assert(sourcePath.endsWith('.dart'));
  test(description, () async {
    final absoluteSourcePath = File(normalize(sourcePath)).absolute;
    final result = await resolveFile2(path: absoluteSourcePath.path);
    result as ResolvedUnitResult;

    expect(
      await testRun(result),
      matchesPrioritizedSourceChangesGolden(
        file,
        source: result.content,
        sourcePath: sourcePath,
      ),
    );
  });
}
