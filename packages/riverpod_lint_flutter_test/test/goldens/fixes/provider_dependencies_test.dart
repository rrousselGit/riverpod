import 'dart:io';

import 'package:collection/collection.dart';
import 'package:riverpod_lint/src/lints/provider_dependencies.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:test/test.dart';

import '../../golden.dart';

void main() {
  testGolden(
    'Verify that @riverpod classes extend the generated typedef',
    'goldens/fixes/provider_dependencies.json',
    () async {
      const lint = ProviderDependencies();
      final fix = lint.getFixes().single;
      final file = File(
        'test/goldens/fixes/provider_dependencies.dart',
      ).absolute;

      final result = await resolveFile2(path: file.path);
      result as ResolvedUnitResult;

      final errors = await lint.testRun(result);
      expect(errors, hasLength(10));

      final changes = await Future.wait([
        for (final error in errors) fix.testRun(result, error, errors),
      ]);

      return changes.flattened;
    },
  );
}
