import 'dart:io';

import 'package:riverpod_lint/src/assists/class_based_to_function_based_provider.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

import '../golden.dart';

void main() {
  testGolden(
    'Convert plain class provider to function-based provider',
    'assists/convert_class_based_provider_to_function_based.json',
    () async {
      final assist = ClassBasedToFunctionBasedProvider();
      final file = File(
        'test/assists/convert_class_based_provider_to_function_based.dart',
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
