import 'dart:io';

import 'package:codemod/test.dart';
import 'package:codemod_riverpod/codemod_riverpod.dart';
import 'package:test/test.dart';

import 'goldens.dart';

void main() {
  group('notifiers', () {
    setUpAll((){
      
    });
    test('ChangeNotifier', () async {
      final sourceFile = await fileContextForGoldenInput(
          './test/files/notifiers/input/change_notifier_provider.dart');
      final expected =
          File('./test/files/notifiers/golden/change_notifier_provider.dart')
              .readAsStringSync();

      expectSuggestorGeneratesPatches(
          RiverpodNotifierChangesMigrationSuggestor(), sourceFile, expected);
    });

    test('StateNotifier', () async {
      final sourceFile = await fileContextForGoldenInput(
          './test/files/notifiers/input/state_notifier_provider.dart');
      final expected =
          File('./test/files/notifiers/golden/state_notifier_provider.dart')
              .readAsStringSync();

      expectSuggestorGeneratesPatches(
          RiverpodNotifierChangesMigrationSuggestor(), sourceFile, expected);
    });

    test('StateProvider', () async {
      final sourceFile = await fileContextForGoldenInput(
          './test/files/notifiers/input/state_provider.dart');
      final expected = File('./test/files/notifiers/golden/state_provider.dart')
          .readAsStringSync();

      expectSuggestorGeneratesPatches(
          RiverpodNotifierChangesMigrationSuggestor(), sourceFile, expected);
    });
  });
}
