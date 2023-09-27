import 'dart:io';

import 'package:collection/collection.dart';
import 'package:riverpod_lint/src/lints/notifier_build.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

import '../../../golden.dart';

void main() {
  testGolden(
    'Verify that @riverpod classes has the build method',
    'goldens/fixes/notifier_build.json',
    () async {
      const lint = NotifierBuild();
      final fix = lint.getFixes().single;
      final file = File(
        'test/lints/notifier_build/fix/notifier_build.dart',
      ).absolute;

      final result = await resolveFile2(path: file.path);
      result as ResolvedUnitResult;

      final errors = await lint.testRun(result);

      final changes = await Future.wait([
        for (final error in errors) fix.testRun(result, error, errors),
      ]);

      return changes.flattened;
    },
  );
}
