import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  testSource('Decode ProviderContainer creations',
      timeout: const Timeout.factor(4), source: '''
import 'package:riverpod/riverpod.dart';

final provider = Provider((ref) => 0);
final family = Provider.family<int, int>((ref, id) => 0);

List<Override> fn() => [];

void main() {
  final container = ProviderContainer();
  ProviderContainer(
    overrides: [
      provider.overrideWith((ref) => 0),
      provider.overrideWithValue(42),
      provider,
      family(42),
      family.overrideWith((ref, id) => 0),
      family(42).overrideWith((ref) => 0),
    ],
  );
  ProviderContainer(
    overrides: fn(),
  );
  ProviderContainer(
    overrides: [
      () {return provider;}(),
    ],
  );
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final provider =
        result.legacyProviderDeclarations.takeAll(['provider']).values.single;
    final family =
        result.legacyProviderDeclarations.takeAll(['family']).values.single;

    final containers = result.providerContainerInstanceCreationExpressions;

    expect(containers, hasLength(4));
    expect(containers[0].node.toSource(), 'ProviderContainer()');
    expect(containers[0].overrides, null);

    expect(
      containers[1].node.toSource(),
      'ProviderContainer(overrides: [provider.overrideWith((ref) => 0), provider.overrideWithValue(42), provider, family(42), family.overrideWith((ref, id) => 0), family(42).overrideWith((ref) => 0)])',
    );
    expect(containers[1].overrides!.overrides, hasLength(6));
    expect(
      containers[1].overrides!.node.toSource(),
      'overrides: [provider.overrideWith((ref) => 0), provider.overrideWithValue(42), provider, family(42), family.overrideWith((ref, id) => 0), family(42).overrideWith((ref) => 0)]',
    );
    {
      expect(
        containers[1].overrides!.overrides![0].providerElement,
        same(provider.providerElement),
      );
      expect(
        containers[1].overrides!.overrides![0].expression.toSource(),
        'provider.overrideWith((ref) => 0)',
      );
      expect(
        containers[1].overrides!.overrides![0].provider!.toSource(),
        'provider',
      );
      expect(containers[1].overrides!.overrides![0].familyArguments, null);
    }
    {
      expect(
        containers[1].overrides!.overrides![1].providerElement,
        same(provider.providerElement),
      );
      expect(
        containers[1].overrides!.overrides![1].expression.toSource(),
        'provider.overrideWithValue(42)',
      );
      expect(
        containers[1].overrides!.overrides![1].provider!.toSource(),
        'provider',
      );
      expect(containers[1].overrides!.overrides![1].familyArguments, null);
    }
    {
      expect(
        containers[1].overrides!.overrides![2].providerElement,
        same(provider.providerElement),
      );
      expect(
        containers[1].overrides!.overrides![2].expression.toSource(),
        'provider',
      );
      expect(
        containers[1].overrides!.overrides![2].provider!.toSource(),
        'provider',
      );
      expect(containers[1].overrides!.overrides![2].familyArguments, null);
    }

    {
      expect(
        containers[1].overrides!.overrides![3].providerElement,
        same(family.providerElement),
      );
      expect(
        containers[1].overrides!.overrides![3].expression.toSource(),
        'family(42)',
      );
      expect(
        containers[1].overrides!.overrides![3].provider!.toSource(),
        'family',
      );
      expect(
        containers[1].overrides!.overrides![3].familyArguments?.toSource(),
        '(42)',
      );
    }
    {
      expect(
        containers[1].overrides!.overrides![4].providerElement,
        same(family.providerElement),
      );
      expect(
        containers[1].overrides!.overrides![4].expression.toSource(),
        'family.overrideWith((ref, id) => 0)',
      );
      expect(
        containers[1].overrides!.overrides![4].provider!.toSource(),
        'family',
      );
      expect(containers[1].overrides!.overrides![4].familyArguments, null);
    }
    {
      expect(
        containers[1].overrides!.overrides![5].providerElement,
        same(family.providerElement),
      );
      expect(
        containers[1].overrides!.overrides![5].expression.toSource(),
        'family(42).overrideWith((ref) => 0)',
      );
      expect(
        containers[1].overrides!.overrides![5].provider!.toSource(),
        'family',
      );
      expect(
        containers[1].overrides!.overrides![5].familyArguments?.toSource(),
        '(42)',
      );
    }

    expect(
      containers[2].node.toSource(),
      'ProviderContainer(overrides: fn())',
    );
    expect(containers[2].overrides!.overrides, null);
    expect(containers[2].overrides!.node.toSource(), 'overrides: fn()');

    expect(
      containers[3].node.toSource(),
      'ProviderContainer(overrides: [() {return provider;}()])',
    );
    expect(containers[3].overrides?.overrides, hasLength(1));
    expect(
      containers[3].overrides!.node.toSource(),
      'overrides: [() {return provider;}()]',
    );
    expect(
      containers[3].overrides?.overrides?.single.expression.toSource(),
      '() {return provider;}()',
    );
    expect(containers[3].overrides?.overrides?.single.providerElement, null);
    expect(containers[3].overrides?.overrides?.single.provider, null);
    expect(containers[3].overrides?.overrides?.single.familyArguments, null);
  });
}
