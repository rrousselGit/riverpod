// Runs the generator in-process on test/integration, so that its coverage is
// collected, and checks it produces the checked-in .g.dart files.
@Tags(['golden'])
library;

import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:riverpod_generator/builder.dart';
import 'package:source_gen/builder.dart';
import 'package:test/test.dart';

void main() {
  final files = Directory('test/integration')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();
  AssetId id(File file) => AssetId('riverpod_generator', file.path);

  final readerWriter = TestReaderWriter(
    rootPackage: 'riverpod_generator',
    flattenOutput: true,
  );

  setUpAll(() async {
    await readerWriter.testing.loadIsolateSources();
    final result = await testBuilders(
      [riverpodBuilder(BuilderOptions.empty), combiningBuilder()],
      {
        for (final file in files)
          if (!file.path.endsWith('.g.dart'))
            id(file).toString(): file.readAsStringSync(),
      },
      rootPackage: 'riverpod_generator',
      readerWriter: readerWriter,
      flattenOutput: true,
    );
    expect(result.succeeded, isTrue, reason: result.errors.join('\n'));
  });

  for (final file in files.where((file) => file.path.endsWith('.g.dart'))) {
    test(file.path, () {
      expect(
        readerWriter.testing.readString(id(file)),
        file.readAsStringSync(),
        reason:
            'Regenerate it with: scripts/generate.sh packages/riverpod_generator',
      );
    });
  }
}
