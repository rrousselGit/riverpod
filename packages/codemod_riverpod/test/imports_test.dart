import 'package:codemod/codemod.dart';
import 'package:codemod_riverpod/codemod_riverpod.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

void main() {
  group('ImportAllRenamer', () {
    test('renames imports', () {
      final sourceFile = SourceFile.fromString('''
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

      final patches =
          RiverpodImportAllMigrationSuggestor().generatePatches(sourceFile);
      expect(patches, hasLength(4));
      expect(applyPatches(sourceFile, patches), expectedOutput);
    });
  });
}
