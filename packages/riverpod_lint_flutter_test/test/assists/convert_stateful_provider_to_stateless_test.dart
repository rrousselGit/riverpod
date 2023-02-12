import 'dart:io';

import 'package:riverpod_lint/src/assists/stateful_to_stateless_provider.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

import '../golden.dart';

void main() {
  testGolden(
    'Convert plain class provider to stateless provider',
    'assists/convert_stateful_provider_to_stateless.json',
    () async {
      final assist = StatefulToStatelessProvider();
      final file = File(
        'test/assists/convert_stateful_provider_to_stateless.dart',
      ).absolute;

      final result = await resolveFile2(path: file.path);
      result as ResolvedUnitResult;

      return [
        ...await assist.testRun(result, const SourceRange(145, 0)),
        ...await assist.testRun(result, const SourceRange(149, 0)),
        ...await assist.testRun(result, const SourceRange(156, 0)),
        ...await assist.testRun(result, const SourceRange(165, 0)),
        ...await assist.testRun(result, const SourceRange(174, 0)),
        ...await assist.testRun(result, const SourceRange(190, 0)),
        ...await assist.testRun(result, const SourceRange(258, 0)),
      ];
    },
  );
}
