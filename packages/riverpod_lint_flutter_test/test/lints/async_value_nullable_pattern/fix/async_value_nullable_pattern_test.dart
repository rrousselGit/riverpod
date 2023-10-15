import 'dart:io';

import 'package:collection/collection.dart';
import 'package:riverpod_lint/src/lints/async_value_nullable_pattern.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

import '../../../golden.dart';

void main() {
  testGolden(
    'Verify that @riverpod classes has the build method',
    'lints/async_value_nullable_pattern/fix/async_value_nullable_pattern.json',
    () async {
      const lint = AsyncValueNullablePattern();
      final fix = lint.getFixes().single;
      final file = File(
        'test/lints/async_value_nullable_pattern/fix/async_value_nullable_pattern.dart',
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
