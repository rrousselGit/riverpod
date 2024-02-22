import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  testSource('Handles consumers with a ProviderBase inside', source: '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ProviderWidget<T> extends ConsumerWidget {
  const ProviderWidget({super.key, required this.provider});

  final ProviderBase<AsyncValue<T>> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provider);
    return Container();
  }
}
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final consumerWidget = result.consumerWidgetDeclarations.single;
    expect(consumerWidget, isA<ConsumerWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'ProviderWidget');
    expect(
      consumerWidget.buildMethod!.toSource(),
      '@override Widget build(BuildContext context, WidgetRef ref) {ref.watch(provider); return Container();}',
    );
  });

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
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final consumerWidget = result.consumerWidgetDeclarations.single;
    expect(consumerWidget, isA<ConsumerWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'MyConsumerWidget');
    expect(
      consumerWidget.buildMethod!.toSource(),
      '@override Widget build(BuildContext context, WidgetRef ref) {ref.watch(provider); return Container();}',
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
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final consumerWidget = result.hookConsumerWidgetDeclarations.single;
    expect(consumerWidget, isA<HookConsumerWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'MyConsumerWidget');
    expect(
      consumerWidget.buildMethod!.toSource(),
      '@override Widget build(BuildContext context, WidgetRef ref) {ref.watch(provider); return Container();}',
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
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final consumerWidget = result.consumerStatefulWidgetDeclarations.single;
    final consumerState = result.consumerStateDeclarations.single;

    expect(consumerWidget, isA<ConsumerStatefulWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'MyConsumerWidget');

    expect(consumerState, isA<ConsumerStateDeclaration>());
    expect(consumerState.node.name.toString(), 'MyConsumerState');
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
    return Container();
  }
}
''', (resolver, unit, units) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final consumerWidget = result.statefulHookConsumerWidgetDeclarations.single;
    final consumerState = result.consumerStateDeclarations.single;

    expect(consumerWidget, isA<StatefulHookConsumerWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'MyConsumerWidget');

    expect(consumerState, isA<ConsumerStateDeclaration>());
    expect(consumerState.node.name.toString(), 'MyConsumerState');
  });
}
