import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  testSource('Handles consumers with a ProviderBase inside', source: '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
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

    final consumerWidget = result.widgetDeclarations.single;
    expect(consumerWidget, isA<StatelessWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'ProviderWidget');
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

    final consumerWidget = result.widgetDeclarations.single;
    expect(consumerWidget, isA<StatelessWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'MyConsumerWidget');
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

    final consumerWidget = result.widgetDeclarations.single;
    expect(consumerWidget, isA<StatelessWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'MyConsumerWidget');
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

    final consumerWidget =
        result.widgetDeclarations.single as StatefulWidgetDeclaration;
    final consumerState = result.stateDeclarations.single;

    expect(consumerWidget.node.name.toString(), 'MyConsumerWidget');
    expect(consumerWidget.state, consumerState.element);

    expect(consumerState.node.name.toString(), 'MyConsumerState');
    expect(consumerState.widget, consumerWidget.element);
    expect(consumerState.element.widget, consumerWidget.element);
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

    final consumerWidget =
        result.widgetDeclarations.single as StatefulWidgetDeclaration;
    final consumerState = result.stateDeclarations.single;

    expect(consumerWidget.node.name.toString(), 'MyConsumerWidget');
    expect(consumerWidget.state, consumerState.element);

    expect(consumerState.node.name.toString(), 'MyConsumerState');
    expect(consumerState.widget, consumerWidget.element);
    expect(consumerState.element.widget, consumerWidget.element);
  });
}
