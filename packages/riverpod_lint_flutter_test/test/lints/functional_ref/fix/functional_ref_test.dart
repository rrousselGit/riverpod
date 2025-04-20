import 'package:collection/collection.dart';
import 'package:riverpod_lint/src/lints/functional_ref.dart';

import '../../../test_lint.dart';

void main() {
  testGolden(
    'Verify that @riverpod functions have a Ref',
    'test/lints/functional_ref/fix/functional_ref.diff',
    sourcePath: 'test/lints/functional_ref/functional_ref.dart',
    (result, helper) async {
      const lint = FunctionalRef();
      final fix = lint.getFixes().single;

      final errors = await lint.testRun(result);

      final changes = await Future.wait([
        for (final error in errors) fix.testRun(result, error, errors),
      ]);

      return changes.flattened;
    },
  );
}
