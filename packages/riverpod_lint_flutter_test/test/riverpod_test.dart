import 'dart:io';

import 'package:custom_lint_core/custom_lint_core.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:riverpod_lint/riverpod_lint.dart';
import 'package:riverpod_lint/src/riverpod_custom_lint.dart';
import 'package:test/test.dart';

import 'test_lint.dart';

void main() {
  final plugin = createPlugin();

  for (final lint in plugin.getLintRules(CustomLintConfigs.empty)) {
    final code = lint.code;
    lint as RiverpodLintRule;

    group(code.name, () {
      final filesToTest = [
        File('test/lints/${code.name}.dart'),
        ...Glob('test/lints/${code.name}/*.dart').listSync(),
      ]
          .whereType<File>()
          .where((e) =>
              !e.path.endsWith('_test.dart') && !e.path.endsWith('.g.dart'))
          .where((e) => e.existsSync())
          .toList();

      if (filesToTest.isEmpty) {
        stderr.writeln('Missing test source for ${code.name}');
      }

      for (final file in filesToTest) {
        testLint(
          'for ${file.path}',
          file.path,
          lint,
          goldensDirectory: 'test/lints/goldens/${code.name}',
        );
      }
    });
  }
}
