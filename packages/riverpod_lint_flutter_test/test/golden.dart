import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:path/path.dart';
import 'package:custom_lint_core/custom_lint_core.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';

@Deprecated('Do not commit')
var goldenWrite = false;

File writeToTemporaryFile(String content) {
  final tempDir = Directory.systemTemp.createTempSync();
  addTearDown(() => tempDir.deleteSync(recursive: true));

  final file = File(join(tempDir.path, 'file.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync(content);

  return file;
}

void testGolden(
  String description,
  String fileName,
  Future<Iterable<PrioritizedSourceChange>> Function() body,
) {
  test(description, () async {
    final changes = await body().then((value) => value.toList());

    try {
      expect(
        changes,
        matcherNormalizedPrioritizedSourceChangeSnapshot(fileName),
      );
    } on TestFailure {
      // ignore: deprecated_member_use_from_same_package
      if (!goldenWrite) rethrow;

      final file = File('test/$fileName');

      final changesJson = changes.map((e) => e.toJson()).toList();
      // Remove all "file" references from the json.
      for (final change in changesJson) {
        final changeMap = change['change']! as Map<String, Object?>;
        final edits = changeMap['edits']! as List;
        for (final edit in edits.cast<Map<String, Object?>>()) {
          edit.remove('file');
        }
      }

      file
        ..createSync(recursive: true)
        ..writeAsStringSync(jsonEncode(changesJson));
      return;
    }
  });
}
