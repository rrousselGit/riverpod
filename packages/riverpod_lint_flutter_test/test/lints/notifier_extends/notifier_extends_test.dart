import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_lint/src/lints/notifier_extends.dart';
import 'package:test/test.dart';

import '../../golden.dart';

void main() {
  testGolden(
    'Verify that @riverpod classes extend the generated typedef',
    'lints/notifier_extends/notifier_extends.diff',
    sourcePath: 'test/lints/notifier_extends/notifier_extends.dart',
    (result, helper) async {
      final lint = NotifierExtends();
      final fix = lint.getFixes().single as DartFix;

      final errors = await lint.testRun(result);
      expect(errors, hasLength(2));

      final changes = await Future.wait([
        for (final error in errors) fix.testRun(result, error, errors),
      ]);

      return changes.flattened;
    },
  );
}
