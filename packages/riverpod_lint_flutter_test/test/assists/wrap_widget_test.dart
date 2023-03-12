import 'dart:io';

import 'package:test/test.dart';
import 'package:riverpod_lint/src/assists/wrap_with_consumer.dart';
import 'package:riverpod_lint/src/assists/wrap_with_provider_scope.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

import '../golden.dart';

void main() {
  testGolden(
    'Wrap with consumer',
    'assists/wrap_with_consumer.json',
    () async {
      final assist = WrapWithConsumer();
      final file = File('test/assists/wrap_widget.dart').absolute;

      final result = await resolveFile2(path: file.path);
      result as ResolvedUnitResult;

      var changes = [
        // Map
        ...await assist.testRun(result, const SourceRange(224, 0)),

        // Scaffold
        ...await assist.testRun(result, const SourceRange(245, 0)),

        // Container
        ...await assist.testRun(result, const SourceRange(268, 0)),

        // Between ()
        ...await assist.testRun(result, const SourceRange(273, 0)),
      ];

      expect(changes, hasLength(2));

      return changes;
    },
  );

  testGolden(
    'Wrap with ProviderScope',
    'assists/wrap_with_provider_scope.json',
    () async {
      final assist = WrapWithProviderScope();
      final file = File('test/assists/wrap_widget.dart').absolute;

      final result = await resolveFile2(path: file.path);
      result as ResolvedUnitResult;

      final changes = [
        // Map
        ...await assist.testRun(result, const SourceRange(224, 0)),

        // Scaffold
        ...await assist.testRun(result, const SourceRange(245, 0)),

        // Container
        ...await assist.testRun(result, const SourceRange(268, 0)),

        // Between ()
        ...await assist.testRun(result, const SourceRange(273, 0)),
      ];

      expect(changes, hasLength(2));

      return changes;
    },
  );
}
