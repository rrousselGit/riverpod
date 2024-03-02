import 'dart:io';

import 'package:test/test.dart';
import 'package:path/path.dart';
import 'package:custom_lint_core/custom_lint_core.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

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
  Future<Iterable<PrioritizedSourceChange>> Function(ResolvedUnitResult unit)
      body, {
  required String sourcePath,
}) {
  test(description, () async {
    final file = File(sourcePath).absolute;

    final result = await resolveFile2(path: file.path);
    result as ResolvedUnitResult;

    final changes = await body(result).then((value) => value.toList());
    final source = file.readAsStringSync();

    try {
      expect(
        changes,
        matcherNormalizedPrioritizedSourceChangeSnapshot(
          fileName,
          sources: {'**': source},
          relativePath: Directory.current.path,
        ),
      );
    } on TestFailure {
      // ignore: deprecated_member_use_from_same_package
      if (!goldenWrite) rethrow;

      final source = File(sourcePath).readAsStringSync();
      final result = encodePrioritizedSourceChanges(
        changes,
        sources: {'**': source},
        relativePath: Directory.current.path,
      );

      final golden = File('test/$fileName');
      golden
        ..createSync(recursive: true)
        ..writeAsStringSync(result);
      return;
    }
  });
}
