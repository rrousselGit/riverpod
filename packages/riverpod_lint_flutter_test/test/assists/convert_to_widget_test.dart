import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:riverpod_lint/src/assists/convert_to_stateful_base_widget.dart';
import 'package:riverpod_lint/src/assists/convert_to_stateless_base_widget.dart';
import 'package:riverpod_lint/src/assists/convert_to_widget_utils.dart';
import 'package:riverpod_lint/src/riverpod_custom_lint.dart';
import 'package:test/test.dart';

import '../golden.dart';

void main() {
  final pubspecWithDependencies = Pubspec(
    'test_project',
    dependencies: {
      'hooks_riverpod': HostedDependency(),
      'flutter_hooks': HostedDependency(),
    },
  );

  StatelessBaseWidgetType.values.forEach(
    (targetWidget) {
      _runGoldenTest(
        ConvertToStatelessBaseWidget(
          targetWidget: targetWidget,
        ),
        'Convert widgets to ${targetWidget.name}s with hooks_riverpod and flutter_hooks dependency',
        'assists/convert_to_${targetWidget.name.toSnakeCase()}.json',
        pubspecWithDependencies,
        targetWidget == StatelessBaseWidgetType.statelessWidget ? 6 : 9,
      );
    },
  );

  StatefulBaseWidgetType.values.forEach(
    (targetWidget) {
      _runGoldenTest(
        ConvertToStatefulBaseWidget(
          targetWidget: targetWidget,
        ),
        'Convert widgets to ${targetWidget.name}s with hooks_riverpod and flutter_hooks dependency',
        'assists/convert_to_${targetWidget.name.toSnakeCase()}.json',
        pubspecWithDependencies,
        targetWidget == StatefulBaseWidgetType.statefulWidget ? 6 : 9,
      );
    },
  );

  final pubspecWithoutDependencies = Pubspec(
    'test_project',
  );

  StatelessBaseWidgetType.values.forEach(
    (targetWidget) {
      final int expectedChangeCount;
      switch (targetWidget) {
        case StatelessBaseWidgetType.consumerWidget:
          expectedChangeCount = 9;
          break;
        case StatelessBaseWidgetType.hookWidget:
        case StatelessBaseWidgetType.hookConsumerWidget:
          expectedChangeCount = 0;
          break;
        case StatelessBaseWidgetType.statelessWidget:
          expectedChangeCount = 6;
          break;
      }
      final String goldenFilePath;
      switch (targetWidget) {
        case StatelessBaseWidgetType.hookWidget:
        case StatelessBaseWidgetType.hookConsumerWidget:
          goldenFilePath = 'assists/empty.json';
          break;
        case StatelessBaseWidgetType.consumerWidget:
        case StatelessBaseWidgetType.statelessWidget:
          goldenFilePath =
              'assists/convert_to_${targetWidget.name.toSnakeCase()}.json';
          break;
      }

      _runGoldenTest(
        ConvertToStatelessBaseWidget(
          targetWidget: targetWidget,
        ),
        'Convert widgets to ${targetWidget.name}s without hooks_riverpod and flutter_hooks dependency',
        goldenFilePath,
        pubspecWithoutDependencies,
        expectedChangeCount,
      );
    },
  );

  StatefulBaseWidgetType.values.forEach(
    (targetWidget) {
      final int expectedChangeCount;
      switch (targetWidget) {
        case StatefulBaseWidgetType.consumerStatefulWidget:
          expectedChangeCount = 9;
          break;
        case StatefulBaseWidgetType.statefulHookWidget:
        case StatefulBaseWidgetType.statefulHookConsumerWidget:
          expectedChangeCount = 0;
          break;
        case StatefulBaseWidgetType.statefulWidget:
          expectedChangeCount = 6;
          break;
      }
      final String goldenFilePath;
      switch (targetWidget) {
        case StatefulBaseWidgetType.statefulHookWidget:
        case StatefulBaseWidgetType.statefulHookConsumerWidget:
          goldenFilePath = 'assists/empty.json';
          break;
        case StatefulBaseWidgetType.consumerStatefulWidget:
        case StatefulBaseWidgetType.statefulWidget:
          goldenFilePath =
              'assists/convert_to_${targetWidget.name.toSnakeCase()}.json';
          break;
      }

      _runGoldenTest(
        ConvertToStatefulBaseWidget(
          targetWidget: targetWidget,
        ),
        'Convert widgets to ${targetWidget.name}s without hooks_riverpod and flutter_hooks dependency',
        goldenFilePath,
        pubspecWithoutDependencies,
        expectedChangeCount,
      );
    },
  );
}

extension _StringX on String {
  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => '_${match.group(1)!.toLowerCase()}',
    );
  }
}

void _runGoldenTest(
  RiverpodAssist assist,
  String description,
  String goldenFilePath,
  Pubspec pubspec,
  int expectedChangeCount,
) {
  testGolden(
    description,
    goldenFilePath,
    () async {
      final file = File(
        'test/assists/convert_to_widget.dart',
      ).absolute;

      final result = await resolveFile2(path: file.path);
      result as ResolvedUnitResult;

      final changes = [
        // Stateless
        ...await assist.testRun(result, const SourceRange(163, 0),
            pubspec: pubspec),
        ...await assist.testRun(result, const SourceRange(174, 0),
            pubspec: pubspec),
        ...await assist.testRun(result, const SourceRange(185, 0),
            pubspec: pubspec),

        // StatelessWithComma
        ...await assist.testRun(result, const SourceRange(350, 0),
            pubspec: pubspec),

        // Hook
        ...await assist.testRun(result, const SourceRange(524, 0),
            pubspec: pubspec),

        // HookConsumer
        ...await assist.testRun(result, const SourceRange(690, 0),
            pubspec: pubspec),

        // Stateful
        ...await assist.testRun(result, const SourceRange(884, 0),
            pubspec: pubspec),

        // ExplicitCreateState
        ...await assist.testRun(result, const SourceRange(1208, 0),
            pubspec: pubspec),

        // HookStateful
        ...await assist.testRun(result, const SourceRange(1553, 0),
            pubspec: pubspec),

        // ConsumerStateful
        ...await assist.testRun(result, const SourceRange(1863, 0),
            pubspec: pubspec),

        // HookConsumerStateful
        ...await assist.testRun(result, const SourceRange(2214, 0),
            pubspec: pubspec),

        // ConsumerWidget
        ...await assist.testRun(result, const SourceRange(2582, 0),
            pubspec: pubspec),
      ];

      expect(changes, hasLength(expectedChangeCount));

      return changes;
    },
  );
}
