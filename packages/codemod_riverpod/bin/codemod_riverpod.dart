import 'package:codemod/codemod.dart';
import 'package:codemod_riverpod/codemod_riverpod.dart';

import 'package:glob/glob.dart';

void main(List<String> args) {
  runInteractiveCodemod(
    filePathsFromGlob(Glob('**.dart', recursive: true)),
    AggregateSuggestor([RiverpodImportAllMigrationSuggestor()]),
    args: args,
  );
}
