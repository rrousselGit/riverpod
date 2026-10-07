import 'package:analyzer/dart/ast/ast.dart';
import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  // Identical library names and relative imports must not reuse another
  // test's source or constant values in the shared analysis context.
  for (final value in [1, 2]) {
    testSource(
      'isolates relative imports for fixture $value',
      source: '''
import 'dependency.dart';
const answer = value;
''',
      files: {'dependency.dart': 'const value = $value;'},
      (resolver, unit, units) async {
        final variable = unit.declarations
            .whereType<TopLevelVariableDeclaration>()
            .single
            .variables
            .variables
            .single;
        expect(
          variable.declaredFragment!.element
              .computeConstantValue()!
              .toIntValue(),
          value,
        );
      },
    );
  }

  testSource(
    'reports compiler errors in the current fixture',
    source: 'const int value = "invalid";',
    (resolver, unit, units) async {
      await expectLater(
        resolver.resolveRiverpodAnalysisResult(),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('The parsed library has compiler errors'),
          ),
        ),
      );
    },
  );
}
