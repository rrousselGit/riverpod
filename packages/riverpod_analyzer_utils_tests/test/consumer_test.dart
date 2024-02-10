import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

class MyVisitor extends RecursiveAstVisitor<void> {
  @override
  void visitClassDeclaration(ClassDeclaration node) {
    print(node);
    final buffer = StringBuffer();
    for (Token? a = node.documentationComment!.beginToken;
        a != null;
        a = a.next) {
      buffer.write(a);
    }
    print(buffer);
    print('`${node.declaredElement?.documentationComment}`');
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    print(node);
    print('`${node.documentationComment}`');
    print('`${node.declaredElement?.documentationComment}`');
  }
}

void main() {
  testSource('MyTest', source: '''
library foo;
/// Hello world
class Foo {}

/// Hello world
void fn() {}
''', (resolver) async {
    final library = await resolver.requireFindLibraryByName(
      'foo',
      ignoreErrors: true,
    );
    final libraryAst =
        await library.session.getResolvedLibraryByElement(library);
    libraryAst as ResolvedLibraryResult;

    final visitor = MyVisitor();
    libraryAst.units.first.unit.accept(visitor);
  });

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
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final consumerWidget = result.consumerWidgetDeclarations.single;
    expect(consumerWidget, isA<ConsumerWidgetDeclaration>());
    expect(consumerWidget.node.name.toString(), 'ProviderWidget');
    expect(
      consumerWidget.buildMethod!.toSource(),
      '@override Widget build(BuildContext context, WidgetRef ref) {ref.watch(provider); return Container();}',
    );

    expect(consumerWidget.widgetRefInvocations, [
      isA<WidgetRefWatchInvocation>()
          .having((e) => e.node.toSource(), 'node', 'ref.watch(provider)')
          .having(
            (e) => e.provider,
            'provider',
            isA<ProviderListenableExpression>()
                .having((e) => e.node.toSource(), 'node', 'provider')
                .having(
                  (e) => e.providerElement,
                  'providerElement',
                  isA<LegacyProviderDeclarationElement>()
                      .having((e) => e.providerType, 'providerType', null),
                ),
          ),
    ]);

    expect(
      result.resolvedRiverpodLibraryResults.single.unknownWidgetRefInvocations,
      isEmpty,
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
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

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
    final result = await resolver.resolveRiverpodAnalysisResult();

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
    final result = await resolver.resolveRiverpodAnalysisResult();

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
    final result = await resolver.resolveRiverpodAnalysisResult();

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
