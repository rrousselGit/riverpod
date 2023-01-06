import 'dart:convert';
import 'dart:io';

import 'package:cosmic_frontmatter/cosmic_frontmatter.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:path/path.dart' as path;

final englishDocFiles = Glob('docs/**.mdx');

final translatedDocFiles = Glob('i18n/**.mdx');

final outFile = File('./src/outdated_translations.js');

void main() async {
  final outdatedTranslations = findOutdatedTranslations().toList()
    ..sort(
        (a, b) => a.translation.file.path.compareTo(b.translation.file.path));

  final buffer = StringBuffer('export default [');
  for (final outdatedTranslation in outdatedTranslations) {
    buffer
      ..write(jsonEncode(outdatedTranslation.toJson()))
      ..write(',');
  }

  buffer.write(']');

  outFile.writeAsStringSync(buffer.toString());
}

Iterable<OutdatedTranslation> findOutdatedTranslations() sync* {
  final translatedDocs = decodeDocuments(
    translatedDocFiles.listSync().cast<File>(),
  );
  final englishDocs = decodeDocuments(
    englishDocFiles.listSync().cast<File>(),
  ).values.map((e) => e.single);

  for (final englishDoc in englishDocs) {
    for (final translatedDoc in translatedDocs[englishDoc.id] ?? <DocMeta>[]) {
      if (englishDoc.version > translatedDoc.version) {
        yield OutdatedTranslation(
          translation: translatedDoc,
          englishVersion: englishDoc,
        );
      }
    }
  }
}

class OutdatedTranslation {
  OutdatedTranslation({
    required this.translation,
    required this.englishVersion,
  });

  final DocMeta translation;
  final DocMeta englishVersion;

  String get countryCode {
    assert(
      translation.file.path.startsWith('./i18n'),
      'Unknown path ${translation.file.path}',
    );

    return translation.file.uri.pathSegments[1];
  }

  Map<String, Object?> toJson() {
    return {
      'countryCode': countryCode,
      'id': translation.id,
      // ./docs/foo.mdx -> /docs/foo
      'englishPath': path.setExtension(
        englishVersion.file.path.substring(1),
        '',
      ),
    };
  }
}

Map<String, List<DocMeta>> decodeDocuments(Iterable<File> documents) {
  final result = <String, List<DocMeta>>{};
  for (final docFile in documents) {
    final parsedDoc = parseFrontmatter(
      content: docFile.readAsStringSync(),
      frontmatterBuilder: (map) => map,
    );

    final id = parsedDoc.frontmatter['id'] as String? ??
        path.basenameWithoutExtension(docFile.path);

    final list = result[id] ??= [];

    final version = parsedDoc.frontmatter['version'] as int? ?? 0;

    list.add(
      DocMeta(
        id: id,
        file: docFile,
        document: parsedDoc,
        version: version,
      ),
    );
  }

  return result;
}

class DocMeta {
  DocMeta({
    required this.id,
    required this.file,
    required this.document,
    required this.version,
  });

  final String id;
  final File file;
  final int version;
  final Document<Map<String, Object?>> document;
}
