import 'package:collection/collection.dart';
import 'package:riverpod_lint/src/migration/missing_legacy_import.dart';

import '../../golden.dart';

void main() {
  testGolden(
    'Verify that `riverpod/legacy.dart` is correctly imported.',
    'migration/missing_legacy_import/missing_legacy_import.diff',
    sourcePath:
        'test/migration/missing_legacy_import/missing_legacy_import.dart',
    (result) async {
      final lint = MissingLegacyImport();
      final fix = lint.getFixes().single;

      final errors = await lint.testRun(result);

      final changes = await Future.wait([
        for (final error in errors) fix.testRun(result, error, errors),
      ]);

      return changes.flattened;
    },
  );
}
