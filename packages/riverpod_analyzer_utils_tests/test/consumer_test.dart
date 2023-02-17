import 'package:riverpod_analyzer_utils/src/riverpod_ast.dart';
import 'package:test/test.dart';

import 'analyser_test_utils.dart';

void main() {
  testSource('Decode ConsumerWidget declarations', source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class MyConsumerWidget extends ConsumerWidget {
  const MyConsumerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalyssiResult();

    final consumerWidget = result.consumerWidgetDeclarations.single;
    expect(consumerWidget, isA<ConsumerWidgetDeclaration>());
    expect(
      consumerWidget.buildMethod!.toSource(),
      '''
@override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
''',
    );
  });
}
