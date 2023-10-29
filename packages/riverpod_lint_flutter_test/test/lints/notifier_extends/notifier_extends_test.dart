import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_lint/src/lints/notifier_extends.dart';

import '../../golden.dart';

void main() {
  testGolden(
    'Verify that @riverpod classes extend the generated typedef',
    'lints/notifier_extends/notifier_extends.json',
    () async {
      final lint = NotifierExtends();
      final fix = lint.getFixes().single as DartFix;
      final file = File(
        'test/lints/notifier_extends/notifier_extends.dart',
      ).absolute;

      final result = await resolveFile2(path: file.path);
      result as ResolvedUnitResult;

      final errors = await lint.testRun(result);
      expect(errors, hasLength(2));

      final changes = await Future.wait([
        for (final error in errors) fix.testRun(result, error, errors),
      ]);

      return changes.flattened;
    },
  );
}
