import 'package:codemod/codemod.dart';
import 'package:codemod_riverpod/codemod_riverpod.dart';
import 'package:test/test.dart';

import 'analysis_helpers.dart';

void main() {
  analysisGroup('Notifier Changes', 'test/files/notifiers', (assistant) {
    assistant.testResolvedFile(
      'StateProvider',
      'state_provider',
      (sourceFile, unit) {
        final patches = RiverpodNotifierChangesMigrationSuggestor()
            .generatePatches(sourceFile, compilationUnit: unit);
        expect(patches, hasLength(1));
        expect(applyPatches(sourceFile, patches),
            assistant.getGolden('state_provider'));
      },
    );

    assistant.testResolvedFile(
      'StateNotifierProvider',
      'state_notifier_provider',
      (sourceFile, unit) {
        final patches = RiverpodNotifierChangesMigrationSuggestor()
            .generatePatches(sourceFile, compilationUnit: unit);
        expect(patches, hasLength(1));
        expect(applyPatches(sourceFile, patches),
            assistant.getGolden('state_notifier_provider'));
      },
    );

    assistant.testResolvedFile(
      'ChangeNotifierProvider',
      'change_notifier_provider',
      (sourceFile, unit) {
        final patches = RiverpodNotifierChangesMigrationSuggestor()
            .generatePatches(sourceFile, compilationUnit: unit);
        expect(patches, hasLength(0));
        expect(applyPatches(sourceFile, patches),
            assistant.getGolden('change_notifier_provider'));
      },
    );
  });
}
