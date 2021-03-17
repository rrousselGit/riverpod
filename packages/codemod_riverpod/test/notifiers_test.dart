import 'dart:io';

import 'package:codemod/test.dart';
import 'package:codemod_riverpod/codemod_riverpod.dart';
import 'package:test/test.dart';

import 'goldens.dart';

final path = Platform.script.toFilePath();
void main() {
  group('notifiers', () {
    test('change notifier', () async {
      final sourceFile = await fileContextForGolden(
          '$path/notifiers/input/change_notifier_provider.dart');
      final expected =
          File('$path/notifiers/golden/change_notifier_provider.dart')
              .readAsStringSync();

      expectSuggestorGeneratesPatches(
          RiverpodNotifierChangesMigrationSuggestor(), sourceFile, expected);
    });
  });
}
