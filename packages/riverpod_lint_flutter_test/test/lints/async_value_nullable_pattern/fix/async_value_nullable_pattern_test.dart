import 'package:collection/collection.dart';
import 'package:riverpod_lint/src/lints/async_value_nullable_pattern.dart';

import '../../../golden.dart';

void main() {
  testGolden(
    'Verify that @riverpod classes has the build method',
    'lints/async_value_nullable_pattern/fix/async_value_nullable_pattern.diff',
    sourcePath:
        'test/lints/async_value_nullable_pattern/fix/async_value_nullable_pattern.dart',
    (result, helper) async {
      const lint = AsyncValueNullablePattern();
      final fix = lint.getFixes().single;

      final errors = await lint.testRun(result);

      final changes = await Future.wait([
        for (final error in errors) fix.testRun(result, error, errors),
      ]);

      return changes.flattened;
    },
  );
}
