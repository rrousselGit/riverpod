import 'package:test/test.dart';

import 'analyser_test_utils.dart';

void main() {
  testSource('Decode ProviderScope creations', source: '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ProviderScope(child: Container()));
}

class Example extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(child: Text('foo'));
  }
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalyssiResult();

    final scopes = result.providerScopeInstanceCreationExpressions;
    final consumer = result.consumerWidgetDeclarations.single;

    expect(scopes, hasLength(2));

    expect(scopes[0].node.toSource(), 'ProviderScope(child: Container())');
    expect(scopes[1].node.toSource(), "ProviderScope(child: Text('foo'))");

    expect(consumer.providerScopeInstanceCreateExpressions, hasLength(1));
    expect(
      consumer.providerScopeInstanceCreateExpressions.single.node.toSource(),
      "ProviderScope(child: Text('foo'))",
    );
  });
}
