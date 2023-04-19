import 'dart:io';

import 'package:path/path.dart';
import 'package:test/test.dart';

extension PackageIOUtils on Directory {
  /// Creates a child [File] from a list of path segments.
  File file(
    String name, [
    String? name2,
    String? name3,
    String? name4,
    String? name5,
    String? name6,
  ]) =>
      File(join(path, name, name2, name3, name4, name5, name6));

  /// Creates a child [Directory] from a list of path segments.
  Directory dir(
    String name, [
    String? name2,
    String? name3,
    String? name4,
    String? name5,
    String? name6,
  ]) =>
      Directory(join(path, name, name2, name3, name4, name5, name6));

  /// The `analysis_options.yaml` file.
  File get analysisOptions => file('analysis_options.yaml');

  /// The `pubspec.yaml` file.
  File get pubspec => file('pubspec.yaml');

  /// The `.dart_tool/package_config.json` file.
  File get packageConfig => file('.dart_tool', 'package_config.json');

  /// Returns a path relative to the given [other].
  String relativeTo(FileSystemEntity other) {
    return normalize(relative(path, from: other.path));
  }
}

/// Creates a temporary directory for testing.
Directory createTempDir() {
  final tempDir = Directory.current
      .dir('.dart_tool')
      .createTempSync('flutter_riverpod_test');
  addTearDown(() {
    print('Delete');
    tempDir.deleteSync(recursive: true);
  });

  tempDir.createSync(recursive: true);

  return tempDir;
}

void writeFile(File file, String content) {
  file.createSync(recursive: true);
  file.writeAsStringSync(content);
}
