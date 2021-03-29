import 'package:codemod/codemod.dart';

const _latestVersion = '0.14.0';
Stream<Patch> VersionMigrationSuggestor(FileContext context) async* {
  final matches = context.sourceText.allMatches('riverpod:.*');
  for (final m in matches) {
    yield Patch('riverpod: ^$_latestVersion', m.start, m.end);
  }
}
