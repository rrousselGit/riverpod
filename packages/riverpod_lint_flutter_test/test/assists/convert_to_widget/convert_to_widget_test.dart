import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:riverpod_lint/src/assists/convert_to_stateful_base_widget.dart';
import 'package:riverpod_lint/src/assists/convert_to_stateless_base_widget.dart';
import 'package:riverpod_lint/src/assists/convert_to_widget_utils.dart';
import 'package:riverpod_lint/src/riverpod_custom_lint.dart';
import 'package:test/test.dart';

import '../../golden.dart';

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
      final int expectedChangeCount;
      switch (targetWidget) {
        case StatelessBaseWidgetType.hookConsumerWidget:
          expectedChangeCount = 11;
          break;
        case StatelessBaseWidgetType.hookWidget:
        case StatelessBaseWidgetType.consumerWidget:
          expectedChangeCount = 12;
          break;
        case StatelessBaseWidgetType.statelessWidget:
          expectedChangeCount = 8;
          break;
      }
      _runGoldenTest(
        ConvertToStatelessBaseWidget(
          targetWidget: targetWidget,
        ),
        'Convert widgets to ${targetWidget.name}s with hooks_riverpod and flutter_hooks dependency',
        'assists/convert_to_widget/convert_to_${targetWidget.name.toSnakeCase()}.diff',
        pubspecWithDependencies,
        expectedChangeCount,
      );
    },
  );

  StatefulBaseWidgetType.values.forEach(
    (targetWidget) {
      final int expectedChangeCount;
      switch (targetWidget) {
        case StatefulBaseWidgetType.statefulHookConsumerWidget:
        case StatefulBaseWidgetType.statefulHookWidget:
          expectedChangeCount = 12;
          break;
        case StatefulBaseWidgetType.consumerStatefulWidget:
          expectedChangeCount = 11;
          break;
        case StatefulBaseWidgetType.statefulWidget:
          expectedChangeCount = 8;
          break;
      }
      _runGoldenTest(
        ConvertToStatefulBaseWidget(
          targetWidget: targetWidget,
        ),
        'Convert widgets to ${targetWidget.name}s with hooks_riverpod and flutter_hooks dependency',
        'assists/convert_to_widget/convert_to_${targetWidget.name.toSnakeCase()}.diff',
        pubspecWithDependencies,
        expectedChangeCount,
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
          expectedChangeCount = 12;
          break;
        case StatelessBaseWidgetType.hookWidget:
        case StatelessBaseWidgetType.hookConsumerWidget:
          expectedChangeCount = 0;
          break;
        case StatelessBaseWidgetType.statelessWidget:
          expectedChangeCount = 8;
          break;
      }
      final String goldenFilePath;
      switch (targetWidget) {
        case StatelessBaseWidgetType.hookWidget:
        case StatelessBaseWidgetType.hookConsumerWidget:
          goldenFilePath = 'assists/empty.diff';
          break;
        case StatelessBaseWidgetType.consumerWidget:
        case StatelessBaseWidgetType.statelessWidget:
          goldenFilePath =
              'assists/convert_to_widget/convert_to_${targetWidget.name.toSnakeCase()}.diff';
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
          expectedChangeCount = 11;
          break;
        case StatefulBaseWidgetType.statefulHookWidget:
        case StatefulBaseWidgetType.statefulHookConsumerWidget:
          expectedChangeCount = 0;
          break;
        case StatefulBaseWidgetType.statefulWidget:
          expectedChangeCount = 8;
          break;
      }
      final String goldenFilePath;
      switch (targetWidget) {
        case StatefulBaseWidgetType.statefulHookWidget:
        case StatefulBaseWidgetType.statefulHookConsumerWidget:
          goldenFilePath = 'assists/empty.diff';
          break;
        case StatefulBaseWidgetType.consumerStatefulWidget:
        case StatefulBaseWidgetType.statefulWidget:
          goldenFilePath =
              'assists/convert_to_widget/convert_to_${targetWidget.name.toSnakeCase()}.diff';
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
    sourcePath: 'test/assists/convert_to_widget/convert_to_widget.dart',
    (result, helper) async {
      final cursors = [
        ...helper.rangesForString('''
class Stateless ext<>ends Statel<>essWidget {<>
  const Stateless({super.key});
'''),
        ...helper.rangesForString('''
class StatelessWithComma extends Stateles<>sWidget {
  const StatelessWithComma({super.key});
'''),
        ...helper.rangesForString('''
class Hook extends Hook<>Widget {
  const Hook({super.key});
'''),
        ...helper.rangesForString('''
class HookConsumer extends HookConsumer<>Widget {
  const HookConsumer({super.key});
'''),
        ...helper.rangesForString('''
class Stateful extends Stateful<>Widget {
  const Stateful({super.key});
'''),
        ...helper.rangesForString('''
class ExplicitCreateState extends State<>fulWidget {
  const ExplicitCreateState({super.key});
'''),
        ...helper.rangesForString('''
class HookStateful extends StatefulH<>ookWidget {
  const HookStateful({super.key});
'''),
        ...helper.rangesForString('''
class ConsumerStateful extends ConsumerStat<>efulWidget {
  const ConsumerStateful({super.key});
'''),
        ...helper.rangesForString('''
class HookConsumerStateful extends StatefulHo<>okConsumerWidget {
  const HookConsumerStateful({super.key});
'''),
        ...helper.rangesForString('''
class Consumer extends Consume<>rWidget {
  const Consumer({super.key});
'''),
        ...helper.rangesForString('''
class StatelessWithField extends Stateless<>Widget {
  const StatelessWithField({
'''),
        ...helper.rangesForString('''
class HookConsumerWithField extends HookConsumer<>Widget {
  const HookConsumerWithField({
'''),
        ...helper.rangesForString('''
class ConsumerStatefulWithField extends ConsumerStateful<>Widget {
  const ConsumerStatefulWithField({
'''),
      ];

      final changes = await helper.runAssist(
        assist,
        result,
        cursors,
        pubspec: pubspec,
      );

      expect(changes, hasLength(expectedChangeCount));

      return changes;
    },
  );
}
