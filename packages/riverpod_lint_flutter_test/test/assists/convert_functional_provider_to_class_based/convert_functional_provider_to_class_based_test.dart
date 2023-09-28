import 'dart:io';

import 'package:riverpod_lint/src/assists/functional_to_class_based_provider.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

import '../../golden.dart';

void main() {
  testGolden(
    'Convert functional providers to class-based providers',
    'assists/convert_functional_provider_to_class_based/convert_functional_provider_to_class_based.json',
    () async {
      final assist = FunctionalToClassBasedProvider();
      final file = File(
        'test/assists/convert_functional_provider_to_class_based/convert_functional_provider_to_class_based.dart',
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
