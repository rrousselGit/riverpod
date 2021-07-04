import 'package:codemod/codemod.dart';

/// The lateste version of riverpod that migrated code should be updated to
const latestVersion = '1.0.0-dev.3';

/// Migrates the pubspec to the [latestVersion]
Stream<Patch> versionMigrationSuggestor(FileContext context) async* {
  final matches = RegExp(r'riverpod:[\s\^>=]*\d+[\.]\d+[\.]\d+\s*\n')
      .allMatches(context.sourceText);
  for (final m in matches) {
    yield Patch('riverpod: ^$latestVersion\n', m.start, m.end);
  }
}
