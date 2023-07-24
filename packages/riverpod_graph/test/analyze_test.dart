import 'dart:io';

import 'package:riverpod_graph/src/analyze.dart';

import 'package:test/test.dart';

void main() {
  group('flutter graph analyzer tests', () {
    test('throw exception if analysis target directory does not exist', () {
      expect(
        () => verifyRootDirectoryExists('dogfood'),
        throwsA(isA<FileSystemException>()),
      );
    });

    test('returns true if analysis target directory does exist', () {
      expect(verifyRootDirectoryExists('.'), true);
    });
  });
}
