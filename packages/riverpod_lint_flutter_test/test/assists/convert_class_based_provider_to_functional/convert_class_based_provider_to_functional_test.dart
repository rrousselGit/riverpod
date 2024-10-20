import 'package:riverpod_lint/src/assists/class_based_to_functional_provider.dart';

import '../../golden.dart';

void main() {
  testGolden(
    'Convert plain class provider to functional provider',
    'assists/convert_class_based_provider_to_functional/convert_class_based_provider_to_functional.diff',
    sourcePath:
        'test/assists/convert_class_based_provider_to_functional/convert_class_based_provider_to_functional.dart',
    (result, helper) async {
      final assist = ClassBasedToFunctionalProvider();

      final cursors = helper.rangesForString(r'''
@rive<>rpod<>
class <>Example e<>xtends _$<>Example {
  @ove<>rride
  int build() => 0;
}

/// Some comment
@riverpod
class Exampl<>eFamily extends _$ExampleFamily {
''');

      return helper.runAssist(assist, result, cursors);
    },
  );
}
