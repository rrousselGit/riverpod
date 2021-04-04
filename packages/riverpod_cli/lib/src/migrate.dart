import 'package:args/command_runner.dart';
import 'package:codemod/codemod.dart';
import 'package:glob/glob.dart';
import 'migrate/imports.dart';

class MigrateCommand extends Command<void> {
  @override
  String get name => 'migrate';

  @override
  String get description =>
      'Analyse a project using Riverpod and migrate it to the latest version available';

  @override
  void run() {
    runInteractiveCodemod(
      filePathsFromGlob(Glob('**.dart', recursive: true)),
      AggregateSuggestor([RiverpodImportAllMigrationSuggestor()]),
      args: argResults.arguments,
    );
  }
}
