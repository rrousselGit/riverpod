import 'dart:io';

import 'package:codemod/codemod.dart';
import 'package:codemod_riverpod/codemod_riverpod.dart';
import 'package:codemod_riverpod/src/version.dart';
import 'package:glob/glob.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

Future<void> main(List<String> args) async {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    stderr.writeln(
        'Pubspec not found! Are you in the root directory of your package / app?');
    return;
  }
  final pubspec = Pubspec.parse(pubspecFile.readAsStringSync());
  final dep = pubspec.dependencies['hooks_riverpod'] ??
      pubspec.dependencies['flutter_riverpod'] ??
      pubspec.dependencies['riverpod'];

  VersionConstraint version;
  if (dep is HostedDependency) {
    version = dep.version;
  }

  await runInteractiveCodemod(
    filePathsFromGlob(Glob('**.dart', recursive: true)),
    aggregate(
      [
        if (version == null ||
            version.intersect(VersionConstraint.parse('>=0.13.0')).isEmpty)
          RiverpodImportAllMigrationSuggestor(),
        if (version == null ||
            version.intersect(VersionConstraint.parse('>=0.14.0')).isEmpty)
          RiverpodNotifierChangesMigrationSuggestor(),
      ],
    ),
    args: args,
  );
  await runInteractiveCodemod(
    filePathsFromGlob(Glob('pubspec.yaml', recursive: true)),
    versionMigrationSuggestor,
    args: args,
  );
}
