<<<<<<< HEAD:packages/codemod_riverpod/test/imports_test.dart
import 'package:codemod/test.dart';
import 'package:codemod_riverpod/codemod_riverpod.dart';
=======
import 'package:codemod/codemod.dart';
import 'package:riverpod_cli/src/migrate/imports.dart';
import 'package:source_span/source_span.dart';
>>>>>>> c654e0550ec0bac033a0fcf78d2ad8e58468b376:packages/riverpod_cli/test/imports_test.dart
import 'package:test/test.dart';

void main() {
  group('ImportAllRenamer', () {
    test('renames imports', () async {
      final sourceFile = await fileContextForTest('test.dart', '''
// Don't touch path
import 'package:path/path.dart';

// Changes required
import 'package:riverpod/all.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:flutter_riverpod/all.dart';
// With double quotes
import "package:flutter_riverpod/all.dart";
''');
      const expectedOutput = '''
// Don't touch path
import 'package:path/path.dart';

// Changes required
import 'package:riverpod/riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// With double quotes
import "package:flutter_riverpod/flutter_riverpod.dart";
''';

      expectSuggestorGeneratesPatches(
          RiverpodImportAllMigrationSuggestor(), sourceFile, expectedOutput);
    });
  });
}
