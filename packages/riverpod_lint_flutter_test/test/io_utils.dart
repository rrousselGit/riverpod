import 'dart:io';

import 'package:test/test.dart';
import 'package:path/path.dart';

File writeToTemporaryFile(String content) {
  final tempDir = Directory.systemTemp.createTempSync();
  addTearDown(() => tempDir.deleteSync(recursive: true));

  final file = File(join(tempDir.path, 'file.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync(content);

  return file;
}
