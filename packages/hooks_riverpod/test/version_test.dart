import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final packageOffsetInPath =
      Directory.current.path.lastIndexOf('/hooks_riverpod');
  final baseDir = Directory.current.path
      .substring(0, packageOffsetInPath + '/hooks_riverpod'.length);

  final hooksPubspec = File('$baseDir/pubspec.yaml');
  final flutterPubspec = File('$baseDir/../flutter_riverpod/pubspec.yaml');
  final dartPubspec = File('$baseDir/../riverpod/pubspec.yaml');

  final gettingStartedDoc =
      File('$baseDir/../../website/docs/getting_started.mdx');

  test('getting started doc includes the correct version', () async {
    final gettingStarted = await gettingStartedDoc.readAsString();

    final dartVersion = await dartPubspec.readAsString().then((pub) {
      return RegExp(r'\bversion:\s*([0-9]+\.[0-9]+\.[0-9]+)')
          .firstMatch(pub)
          .group(1);
    });
    final hooksVersion = await hooksPubspec.readAsString().then((pub) {
      return RegExp(r'\bversion:\s*([0-9]+\.[0-9]+\.[0-9]+)')
          .firstMatch(pub)
          .group(1);
    });
    final flutterVersion = await flutterPubspec.readAsString().then((pub) {
      return RegExp(r'\bversion:\s*([0-9]+\.[0-9]+\.[0-9]+)')
          .firstMatch(pub)
          .group(1);
    });

    expect(
      gettingStarted,
      matches('\\bflutter_riverpod: \\^$flutterVersion'),
    );
    expect(
      gettingStarted,
      matches('\\bhooks_riverpod: \\^$hooksVersion'),
    );
    expect(
      gettingStarted,
      matches('\\briverpod: \\^$dartVersion'),
    );
  });

  test('hooks_riverpod version matches with riverpod', () async {
    final dartVersion = await hooksPubspec.readAsString().then((pub) {
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
  }, skip: !hooksPubspec.existsSync() || !dartPubspec.existsSync());
  test('hooks_riverpod version matches with flutter_riverpod', () async {
    final dartVersion = await hooksPubspec.readAsString().then((pub) {
      return RegExp(r'\bflutter_riverpod:\s*\^{0,1}([0-9]+\.[0-9]+\.[0-9]+)')
          .firstMatch(pub)
          .group(1);
    });
    final actualDartVersion = await flutterPubspec.readAsString().then((pub) {
      return RegExp(r'\bversion:\s*([0-9]+\.[0-9]+\.[0-9]+)')
          .firstMatch(pub)
          .group(1);
    });

    expect(dartVersion, actualDartVersion);
  }, skip: !hooksPubspec.existsSync() || !flutterPubspec.existsSync());
}
