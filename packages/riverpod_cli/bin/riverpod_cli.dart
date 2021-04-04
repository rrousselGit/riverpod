import 'package:codemod/codemod.dart';
import 'package:riverpod_cli/riverpod_cli.dart';
import 'package:glob/glob.dart';

void main(List<String> args) {
  runInteractiveCodemod(
    filePathsFromGlob(Glob('**.dart', recursive: true)),
    AggregateSuggestor([RiverpodImportAllMigrationSuggestor()]),
    args: args,
  );
}
