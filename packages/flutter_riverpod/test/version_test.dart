import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final packageOffsetInPath =
      Directory.current.path.lastIndexOf('/flutter_riverpod/');
  final baseDir = Directory.current.path
      .substring(0, packageOffsetInPath + '/flutter_riverpod/'.length);

  final flutterPubspec = File('$baseDir/pubspec.yaml');
  final dartPubspec = File('$baseDir/../riverpod/pubspec.yaml');

  test('flutter_riverpod version matches with riverpod', () async {
    final dartVersion = await flutterPubspec.readAsString().then((pub) {
      return RegExp(r'\briverpod:\s*\^{0,1}([0-9]+\.[0-9]+\.[0-9]+)')
          .firstMatch(pub)
          .group(1);
    });
    final actualDartVersion = await dartPubspec.readAsString().then((pub) {
      return RegExp(r'\bversion:\s*([0-9]+\.[0-9]+\.[0-9]+)')
          .firstMatch(pub)
          .group(1);
    });

    expect(dartVersion, actualDartVersion);
  }, skip: !flutterPubspec.existsSync() || !dartPubspec.existsSync());
}
