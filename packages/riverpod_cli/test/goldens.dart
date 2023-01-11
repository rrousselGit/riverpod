import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:codemod/codemod.dart';
import 'package:codemod/test.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

final _formatter = DartFormatter();
final _root = p.canonicalize('./fixtures');
// Shared analysis context to speed up tests, (analyzer only has to analyze shared dependencies once)
final _collection = AnalysisContextCollection(includedPaths: [_root]);

/// Utility to get file context for a golden file path
Future<FileContext> fileContextForInput(String name) async {
  final file = p.canonicalize(name);
  return FileContext(file, _collection, root: _root);
}

/// Uses [suggestor] to generate a stream of patches for [context] and returns
/// what the resulting file contents would be after applying all of them.
///
/// Like [expectSuggestorGeneratesPatches] (from codemod/test) except this
/// also formats the file with the patches to make it match the golden
/// expected output after formatting applied. Note this is only for tests, and
/// formatting doesn't actually occur during the generation of the patches.
Future<void> expectSuggestorGeneratesFormattedPatches(
  Suggestor suggestor,
  FileContext context,
  String resultMatcher,
) async {
  await expectLater(
    Future(() async {
      final patches = await suggestor(context).toList();
      return _formatter.format(applyPatches(context.sourceFile, patches));
    }),
    completion(FileMatcher(resultMatcher)),
  );
}

/// Uses [suggestors] to generate a stream of patches for [context] and returns
/// what the resulting file contents would be after applying all of them.
///
/// Like [expectSuggestorGeneratesPatches] (from codemod/test) except this
/// also formats the file with the patches to make it match the golden
/// expected output after formatting applied. Note this is only for tests, and
/// formatting doesn't actually occur during the generation of the patches.
Future<void> expectSuggestorSequenceGeneratesFormattedPatches(
  List<Suggestor> suggestors,
  FileContext context,
  String resultMatcher,
) async {
  await expectLater(
    Future(() async {
      final patches = <Patch>[];
      for (final suggestor in suggestors) {
        patches.addAll(await suggestor(context).toList());
      }
      return _formatter.format(applyPatches(context.sourceFile, patches));
    }),
    completion(FileMatcher(resultMatcher)),
  );
}

class FileMatcher extends Matcher {
  FileMatcher(this.expected);

  final String expected;
  late final String item;
  @override
  Description describe(Description description) {
    // TODO: Diff matcher only prints a pretty diff for linux / macos systems
    if (Platform.isLinux || Platform.isMacOS) {
      File('/tmp/riverpod_diff').writeAsStringSync(item);
      File('/tmp/riverpod_expected').writeAsStringSync(expected);
      final result = Process.runSync(
        'diff',
        ['/tmp/riverpod_diff', '/tmp/riverpod_expected'],
        runInShell: true,
      );
      description.add('${result.stdout}\n\n');
    }
    return description;
  }

  @override
  bool matches(dynamic item, Map<Object?, Object?> matchState) {
    this.item = item as String;
    return expected == item;
  }
}
