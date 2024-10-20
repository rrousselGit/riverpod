import 'package:collection/collection.dart';
import 'package:riverpod_lint/src/lints/functional_ref.dart';

import '../../../golden.dart';

void main() {
  testGolden(
    'Verify that @riverpod functions have a Ref',
    'lints/functional_ref/fix/functional_ref.diff',
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

  testGolden(
    'The Ref fix should add imports',
    'lints/functional_ref/fix/auto_import.diff',
    sourcePath: 'test/lints/functional_ref/fix/auto_import.dart',
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

  testGolden(
    'Supports prefixes',
    'lints/functional_ref/fix/use_prefix.diff',
    sourcePath: 'test/lints/functional_ref/fix/use_prefix.dart',
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
