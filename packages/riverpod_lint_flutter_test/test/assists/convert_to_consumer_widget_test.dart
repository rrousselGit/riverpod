import 'dart:io';

import 'package:test/test.dart';
import 'package:riverpod_lint/src/assists/convert_to_consumer_widget.dart';
import 'package:riverpod_lint/src/assists/convert_to_consumer_stateful_widget.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

import '../golden.dart';

void main() {
  goldenWrite = true;

  testGolden(
    'Convert widgets to consumerwidgets',
    'assists/convert_to_consumer_widget.json',
    () async {
      final assist = ConvertToConsumerWidget();
      final file = File(
        'test/assists/convert_to_consumer_widget.dart',
      ).absolute;

      final result = await resolveFile2(path: file.path);
      result as ResolvedUnitResult;

      var changes = [
        // Stateless
        ...await assist.testRun(result, const SourceRange(163, 0)),
        ...await assist.testRun(result, const SourceRange(174, 0)),
        ...await assist.testRun(result, const SourceRange(185, 0)),

        // StatelessWithComma
        ...await assist.testRun(result, const SourceRange(350, 0)),

        // Hook
        ...await assist.testRun(result, const SourceRange(524, 0)),

        // HookConsumer
        ...await assist.testRun(result, const SourceRange(690, 0)),

        // Stateful
        ...await assist.testRun(result, const SourceRange(884, 0)),

        // ExplicitCreateState
        ...await assist.testRun(result, const SourceRange(1208, 0)),

        // HookStateful
        ...await assist.testRun(result, const SourceRange(1553, 0)),

        // ConsumerStateful
        ...await assist.testRun(result, const SourceRange(1863, 0)),

        // HookConsumerStateful
        ...await assist.testRun(result, const SourceRange(2214, 0)),

        // ConsumerWidget
        ...await assist.testRun(result, const SourceRange(2582, 0)),
      ];

      expect(changes, hasLength(9));

      return changes;
    },
  );

  testGolden(
    'Convert widgets to stateful consumers',
    'assists/convert_to_consumer_stateful_widget.json',
    () async {
      final assist = ConvertToConsumerStatefulWidget();
      final file = File(
        'test/assists/convert_to_consumer_widget.dart',
      ).absolute;

      final result = await resolveFile2(path: file.path);
      result as ResolvedUnitResult;

      final changes = [
        // Stateless
        ...await assist.testRun(result, const SourceRange(163, 0)),
        ...await assist.testRun(result, const SourceRange(174, 0)),
        ...await assist.testRun(result, const SourceRange(185, 0)),

        // StatelessWithComma
        ...await assist.testRun(result, const SourceRange(350, 0)),

        // Hook
        ...await assist.testRun(result, const SourceRange(524, 0)),

        // HookConsumer
        ...await assist.testRun(result, const SourceRange(690, 0)),

        // Stateful
        ...await assist.testRun(result, const SourceRange(884, 0)),

        // ExplicitCreateState
        ...await assist.testRun(result, const SourceRange(1208, 0)),

        // HookStateful
        ...await assist.testRun(result, const SourceRange(1553, 0)),

        // ConsumerStateful
        ...await assist.testRun(result, const SourceRange(1863, 0)),

        // HookConsumerStateful
        ...await assist.testRun(result, const SourceRange(2214, 0)),

        // ConsumerWidget
        ...await assist.testRun(result, const SourceRange(2582, 0)),
      ];

      expect(changes, hasLength(9));

      return changes;
    },
  );
}
