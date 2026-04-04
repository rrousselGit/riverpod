import 'dart:io';

import 'package:test/test.dart';
import 'package:path/path.dart';

File writeToTemporaryFile(String content) {
  final tempDir = Directory.systemTemp.createTempSync();
  addTearDown(() => tempDir.deleteSync(recursive: true));

  final file =
      File(join(tempDir.path, 'file.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync(content);

  return file;
}

/// Utilities to help dealing with paths to common package files.
extension PackageIOUtils on Directory {
  /// Creates a child [File] from a list of path segments.
  File file(
    String name, [
    String? name2,
    String? name3,
    String? name4,
    String? name5,
    String? name6,
  ]) => File(join(path, name, name2, name3, name4, name5, name6));

  /// Creates a child [Directory] from a list of path segments.
  Directory dir(
    String name, [
    String? name2,
    String? name3,
    String? name4,
    String? name5,
    String? name6,
  ]) => Directory(join(path, name, name2, name3, name4, name5, name6));
}
