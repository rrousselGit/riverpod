import 'package:riverpod_lint/src/assists/class_based_to_functional_provider.dart';
import 'package:analyzer/source/source_range.dart';

import '../../golden.dart';

void main() {
  testGolden(
    'Convert plain class provider to functional provider',
    'assists/convert_class_based_provider_to_functional/convert_class_based_provider_to_functional.diff',
    sourcePath:
        'test/assists/convert_class_based_provider_to_functional/convert_class_based_provider_to_functional.dart',
    (result) async {
      final assist = ClassBasedToFunctionalProvider();

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
