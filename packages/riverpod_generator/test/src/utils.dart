import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:riverpod_generator/builder.dart';
import 'package:source_gen/builder.dart';
import 'package:test/test.dart';

/// Runs the generator on `main.dart`, one of the [sources] given by file name,
/// and returns `main.g.dart` without its whitespaces.
Future<String> generate(Map<String, String> sources) async {
  const main = 'riverpod_generator|test/src/generate/main.dart';
  final readerWriter = TestReaderWriter(
    rootPackage: 'riverpod_generator',
    flattenOutput: true,
  );
  await readerWriter.testing.loadIsolateSources();
  final result = await testBuilders(
    [riverpodBuilder(BuilderOptions.empty), combiningBuilder()],
    {
      for (final MapEntry(:key, :value) in sources.entries)
        'riverpod_generator|test/src/generate/$key': value,
    },
    generateFor: {main},
    rootPackage: 'riverpod_generator',
    readerWriter: readerWriter,
    flattenOutput: true,
  );
  expect(result.succeeded, isTrue, reason: result.errors.join('\n'));

  return readerWriter.testing
      .readString(AssetId.parse(main).changeExtension('.g.dart'))
      // The formatter splits long lines, adding trailing commas.
      .replaceAll(RegExp(r'\s'), '')
      .replaceAll(',)', ')')
      .replaceAll(',]', ']');
}
