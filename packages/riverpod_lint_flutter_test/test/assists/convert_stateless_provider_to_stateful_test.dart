import 'dart:io';

import 'package:riverpod_lint/src/assists/stateless_to_stateful_provider.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

import '../golden.dart';

void main() {
  testGolden(
    'Convert stateless providers to stateful providers',
    'assists/convert_stateless_provider_to_stateful.json',
    () async {
      final assist = StatelessToStatefulProvider();
      final file = File(
        'test/assists/convert_stateless_provider_to_stateful.dart',
      ).absolute;

      final result = await resolveFile2(path: file.path);
      result as ResolvedUnitResult;

      return [
        ...await assist.testRun(result, const SourceRange(145, 0)),
        ...await assist.testRun(result, const SourceRange(148, 0)),
        ...await assist.testRun(result, const SourceRange(156, 0)),
        ...await assist.testRun(result, const SourceRange(167, 0)),
        ...await assist.testRun(result, const SourceRange(180, 0)),
        ...await assist.testRun(result, const SourceRange(224, 0)),
      ];
    },
  );
}
