import 'package:test/test.dart';

import 'analyser_test_utils.dart';

void main() {
  testSource('Decode ProviderContainer creations', source: '''
import 'package:riverpod/riverpod.dart';

void main() {
  final container = ProviderContainer();
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalyssiResult();

    final container =
        result.providerContainerInstanceCreationExpressions.single;

    expect(container.node.toSource(), 'ProviderContainer()');
  });
}
