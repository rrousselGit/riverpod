import 'package:codemod/codemod.dart';
import 'package:codemod_riverpod/codemod_riverpod.dart';
import 'package:glob/glob.dart';

Future<void> main(List<String> args) async {
  await runInteractiveCodemod(
    filePathsFromGlob(Glob('**.dart', recursive: true)),
    RiverpodImportAllMigrationSuggestor(),
    args: args,
  );
}
