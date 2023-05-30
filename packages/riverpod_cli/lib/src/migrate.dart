import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:codemod/codemod.dart';
import 'package:glob/glob.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

import 'migrate/errors.dart';
import 'migrate/imports.dart';
import 'migrate/notifiers.dart';
import 'migrate/unified_syntax.dart';
import 'migrate/version.dart';

class MigrateCommand extends Command<void> {
  MigrateCommand() {
    argParser
      ..addFlag(
        'verbose',
        abbr: 'v',
        negatable: false,
        help: 'Outputs all logging to stdout/stderr.',
      )
      ..addFlag(
        'yes-to-all',
        negatable: false,
        help: 'Forces all patches accepted without prompting the user. '
            'Useful for scripts.',
      )
      ..addFlag(
        'fail-on-changes',
        negatable: false,
        help: 'Returns a non-zero exit code if there are changes to be made. '
            'Will not make any changes (i.e. this is a dry-run).',
      )
      ..addFlag(
        'stderr-assume-tty',
        negatable: false,
        help: 'Forces ansi color highlighting of stderr. Useful for debugging.',
      );
  }
  @override
  String get name => 'migrate';

  @override
  String get description =>
      'Analyse a project using Riverpod and migrate it to the latest version available';

  @override
  Future<void> run() async {
    final pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      stderr.writeln(
        'Pubspec not found! Are you in the root directory of your package / app?',
      );
      exit(-1);
    }

    final pubspec = Pubspec.parse(pubspecFile.readAsStringSync());
    final dep = pubspec.dependencies['hooks_riverpod'] ??
        pubspec.dependencies['flutter_riverpod'] ??
        pubspec.dependencies['riverpod'];

    if (dep is! HostedDependency) {
      stderr.writeln(
        'Migrating git and path dependencies can cause issues because of '
        'trying to understand riverpod versioning, please depend on an official package',
      );
      exit(-1);
    }

    if (dep.version.allows(latestVersion)) {
      stderr.writeln(
        'It seems like your project already has Riverpod $latestVersion installed.\n'
        'The migration tool will not work if your project already uses the new '
        'version. To fix, downgrade the version of Riverpod then try again.',
      );
      exit(-1);
    }

    await runInteractiveCodemodSequence(
      filePathsFromGlob(Glob('**.dart', recursive: true)),
      [
        aggregate(
          [
            RiverpodImportAllMigrationSuggestor().call,
            RiverpodNotifierChangesMigrationSuggestor(dep.version).call,
          ],
        ),
        RiverpodProviderUsageInfo(dep.version).call,
        RiverpodUnifiedSyntaxChangesMigrationSuggestor(dep.version).call,
      ],
      args: argResults?.arguments ?? [],
    );

    await runInteractiveCodemod(
      filePathsFromGlob(Glob('pubspec.yaml', recursive: true)),
      versionMigrationSuggestor,
      args: argResults?.arguments ?? [],
    );
    if (errorOccurredDuringMigration) {
      printErrorLogs();
    } else {
      stdout.writeln(
        'Migration finished successfully please run `flutter pub upgrade`',
      );
    }
  }
}
