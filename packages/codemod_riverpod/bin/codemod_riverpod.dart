import 'dart:io';

import 'package:codemod/codemod.dart';
import 'package:codemod_riverpod/codemod_riverpod.dart';
import 'package:glob/glob.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

Future<void> main(List<String> args) async {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    stderr.writeln(
        'Pubspec not found! Are you in the root directory of your package / app?');
    return;
  }
  HostedDependency dep;
  final pubspec = Pubspec.parse(pubspecFile.readAsStringSync());
  if (pubspec.dependencies.containsKey('riverpod') &&
      pubspec.dependencies['riverpod'] is HostedDependency) {
    dep = pubspec.dependencies['riverpod'] as HostedDependency;
  }
  if (pubspec.dependencies.containsKey('hooks_riverpod') &&
      pubspec.dependencies['hooks_riverpod'] is HostedDependency) {
    dep = pubspec.dependencies['hooks_riverpod'] as HostedDependency;
  }
  if (pubspec.dependencies.containsKey('flutter_riverpod') &&
      pubspec.dependencies['flutter_riverpod'] is HostedDependency) {
    dep = pubspec.dependencies['flutter_riverpod'] as HostedDependency;
  }

  await runInteractiveCodemod(
    filePathsFromGlob(Glob('**.dart', recursive: true)),
    aggregate(
      [
        RiverpodImportAllMigrationSuggestor(),
        if (!dep.version.allows(Version.parse('^0.15.0')))
          RiverpodNotifierChangesMigrationSuggestor()
      ],
    ),
    args: args,
  );
}
