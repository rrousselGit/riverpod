import 'package:collection/collection.dart';
import 'package:riverpod_lint/src/lints/notifier_build.dart';

import '../../../golden.dart';

void main() {
  testGolden(
    'Verify that @riverpod classes has the build method',
    'lints/notifier_build/fix/notifier_build.diff',
    sourcePath: 'test/lints/notifier_build/fix/notifier_build.dart',
    (result, helper) async {
      const lint = NotifierBuild();
      final fix = lint.getFixes().single;

      final errors = await lint.testRun(result);

      final changes = await Future.wait([
        for (final error in errors) fix.testRun(result, error, errors),
      ]);

      return changes.flattened;
    },
  );
}
