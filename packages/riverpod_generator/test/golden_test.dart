// Runs the generator in-process on test/integration, so that its coverage is
// collected, and checks it produces the checked-in .g.dart files.
@Tags(['golden'])
// Resolving every fixture takes over 30s on CI, with coverage.
@Timeout.factor(4)
library;

import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:riverpod_generator/builder.dart';
import 'package:source_gen/builder.dart';
import 'package:test/test.dart';

void main() {
  test('generates the checked-in test/integration/**.g.dart files', () async {
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

    for (final file in files.where((file) => file.path.endsWith('.g.dart'))) {
      expect(
        readerWriter.testing.readString(id(file)),
        file.readAsStringSync(),
        reason:
            '${file.path} is outdated. Regenerate it with: '
            'scripts/generate.sh packages/riverpod_generator',
      );
    }
  });
}
