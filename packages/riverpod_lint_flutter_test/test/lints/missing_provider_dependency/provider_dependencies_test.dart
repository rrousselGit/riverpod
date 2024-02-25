import 'package:collection/collection.dart';
import 'package:riverpod_lint/src/lints/provider_dependencies.dart';
import 'package:test/test.dart';

import '../../golden.dart';

void main() {
  testGolden(
    'Verifies if some scoped providers are used but not specified as dependency',
    'lints/missing_dependencies/provider_dependencies.diff',
    sourcePath: 'test/lints/missing_dependencies/provider_dependencies.dart',
    (result) async {
      const lint = ProviderDependencies();
      final fix = lint.getFixes().single;

      final errors = await lint.testRun(result);
      expect(errors, hasLength(10));

      final changes = await Future.wait([
        for (final error in errors) fix.testRun(result, error, errors),
      ]);

      return changes.flattened;
    },
  );
}
