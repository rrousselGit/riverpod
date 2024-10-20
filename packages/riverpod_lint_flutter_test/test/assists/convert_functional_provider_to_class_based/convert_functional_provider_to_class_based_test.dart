import 'package:riverpod_lint/src/assists/functional_to_class_based_provider.dart';

import '../../golden.dart';

void main() {
  testGolden(
    'Convert functional providers to class-based providers',
    'assists/convert_functional_provider_to_class_based/convert_functional_provider_to_class_based.diff',
    sourcePath:
        'test/assists/convert_functional_provider_to_class_based/convert_functional_provider_to_class_based.dart',
    (result, helper) async {
      final assist = FunctionalToClassBasedProvider();

      final cursors = helper.rangesForString('''
@rive<>rpo<>d
int ex<>ample(R<>ef ref) =><> 0;

/// Some comment
@riverpod
int exampleF<>amily(Ref ref, {required int a, String b = '42'}) {
''');

      return helper.runAssist(assist, result, cursors);
    },
  );
}
