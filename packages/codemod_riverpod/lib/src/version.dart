import 'package:codemod/codemod.dart';

/// The lateste version of riverpod that migrated code should be updated to
const latestVersion = '0.14.0';

/// Migrates the pubspec to the [latestVersion]
Stream<Patch> versionMigrationSuggestor(FileContext context) async* {
  final matches = context.sourceText.allMatches('riverpod:.*');
  for (final m in matches) {
    yield Patch('riverpod: ^$latestVersion', m.start, m.end);
  }
}
