import 'package:riverpod_analyzer_utils/src/riverpod_ast.dart';
import 'package:test/test.dart';

import 'analyser_test_utils.dart';

void main() {
  testSource('Decode ConsumerWidget declarations', source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final provider = Provider<int>((ref) => 0);

class MyConsumerWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provider);
    return Container();
  }
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalyssiResult();

    final consumerWidget = result.consumerWidgetDeclarations.single;
    expect(consumerWidget, isA<ConsumerWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'MyConsumerWidget');
    expect(
      consumerWidget.buildMethod!.toSource(),
      '@override Widget build(BuildContext context, WidgetRef ref) {ref.watch(provider); return Container();}',
    );

    expect(
      result.resolvedRiverpodLibraryResults.single.unknownWidgetRefInvocations,
      isEmpty,
    );

    expect(consumerWidget.widgetRefInvocations, hasLength(1));
    expect(
      consumerWidget.widgetRefInvocations.single,
      isA<WidgetRefInvocation>(),
    );
  });

  testSource('Decode HookConsumerWidgetDeclaration declarations', source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

final provider = Provider<int>((ref) => 0);

class MyConsumerWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provider);
    return Container();
  }
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalyssiResult();

    final consumerWidget = result.hookConsumerWidgetDeclaration.single;
    expect(consumerWidget, isA<HookConsumerWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'MyConsumerWidget');
    expect(
      consumerWidget.buildMethod!.toSource(),
      '@override Widget build(BuildContext context, WidgetRef ref) {ref.watch(provider); return Container();}',
    );

    expect(
      result.resolvedRiverpodLibraryResults.single.unknownWidgetRefInvocations,
      isEmpty,
    );

    expect(consumerWidget.widgetRefInvocations, hasLength(1));
    expect(
      consumerWidget.widgetRefInvocations.single,
      isA<WidgetRefInvocation>(),
    );
  });

  testSource('Decode ConsumerStatefulWidgetDeclarations declarations',
      source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

final provider = Provider<int>((ref) => 0);
final provider2 = Provider<int>((ref) => 0);

class MyConsumerWidget extends ConsumerStatefulWidget {
  @override
  MyConsumerState createState() => MyConsumerState();
}

class MyConsumerState extends ConsumerState<MyConsumerWidget> {
  @override
  void initState() {
    ref.watch(provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(provider2);
    return Container();
  }
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalyssiResult();

    final consumerWidget = result.consumerStatefulWidgetDeclarations.single;
    final consumerState = result.consumerStateDeclarations.single;

    expect(consumerWidget, isA<ConsumerStatefulWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'MyConsumerWidget');

    expect(consumerState, isA<ConsumerStateDeclaration>());
    expect(consumerState.node.name.toString(), 'MyConsumerState');

    expect(
      result.resolvedRiverpodLibraryResults.single.unknownWidgetRefInvocations,
      isEmpty,
    );

    expect(consumerState.widgetRefInvocations, hasLength(2));
    expect(
      consumerState.widgetRefInvocations[0],
      isA<WidgetRefInvocation>()
          .having((e) => e.node.toSource(), 'node', 'ref.watch(provider)'),
    );
    expect(
      consumerState.widgetRefInvocations[1],
      isA<WidgetRefInvocation>()
          .having((e) => e.node.toSource(), 'node', 'ref.watch(provider2)'),
    );
  });

  testSource('Decode StatefulHookConsumerWidgetDeclaration declarations',
      source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

final provider = Provider<int>((ref) => 0);
final provider2 = Provider<int>((ref) => 0);

class MyConsumerWidget extends StatefulHookConsumerWidget {
  @override
  MyConsumerState createState() => MyConsumerState();
}

class MyConsumerState extends ConsumerState<MyConsumerWidget> {
  @override
  void initState() {
    ref.watch(provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(provider2);
    return Container();
  }
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalyssiResult();

    final consumerWidget = result.statefulHookConsumerWidgetDeclaration.single;
    final consumerState = result.consumerStateDeclarations.single;

    expect(consumerWidget, isA<StatefulHookConsumerWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'MyConsumerWidget');

    expect(consumerState, isA<ConsumerStateDeclaration>());
    expect(consumerState.node.name.toString(), 'MyConsumerState');

    expect(
      result.resolvedRiverpodLibraryResults.single.unknownWidgetRefInvocations,
      isEmpty,
    );

    expect(consumerState.widgetRefInvocations, hasLength(2));
    expect(
      consumerState.widgetRefInvocations[0],
      isA<WidgetRefInvocation>()
          .having((e) => e.node.toSource(), 'node', 'ref.watch(provider)'),
    );
    expect(
      consumerState.widgetRefInvocations[1],
      isA<WidgetRefInvocation>()
          .having((e) => e.node.toSource(), 'node', 'ref.watch(provider2)'),
    );
  });
}
