import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  testSource('Decode ProviderScope creations', source: '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final provider = Provider((ref) => 0);
final family = Provider.family<int, int>((ref, id) => 0);

List<Override> fn() => [];

void main() {
  runApp(ProviderScope(child: Container()));
  ProviderScope(
    overrides: [
      provider.overrideWith((ref) => 0),
      provider.overrideWithValue(42),
      provider,
      family(42),
      family.overrideWith((ref, id) => 0),
      family(42).overrideWith((ref) => 0),
    ],
    child: Container(),
  );
  ProviderScope(
    overrides: fn(),
    child: Container(),
  );
  ProviderScope(
    overrides: [
      () {return provider;}(),
    ],
    child: Container(),
  );
}

class Example extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(child: Text('foo'));
  }
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final scopes = result.providerScopeInstanceCreationExpressions;
    final consumer = result.consumerWidgetDeclarations.single;

    final provider =
        result.legacyProviderDeclarations.takeAll(['provider']).values.single;
    final family =
        result.legacyProviderDeclarations.takeAll(['family']).values.single;

    expect(scopes, hasLength(5));

    expect(scopes[0].node.toSource(), 'ProviderScope(child: Container())');
    expect(scopes[0].overrides, null);

    expect(
      scopes[1].node.toSource(),
      'ProviderScope(overrides: [provider.overrideWith((ref) => 0), provider.overrideWithValue(42), provider, family(42), family.overrideWith((ref, id) => 0), family(42).overrideWith((ref) => 0)], child: Container())',
    );
    expect(scopes[1].overrides!.overrides, hasLength(6));
    expect(
      scopes[1].overrides!.node.toSource(),
      'overrides: [provider.overrideWith((ref) => 0), provider.overrideWithValue(42), provider, family(42), family.overrideWith((ref, id) => 0), family(42).overrideWith((ref) => 0)]',
    );
    {
      expect(
        scopes[1].overrides!.overrides![0].providerElement,
        same(provider.providerElement),
      );
      expect(
        scopes[1].overrides!.overrides![0].expression.toSource(),
        'provider.overrideWith((ref) => 0)',
      );
      expect(
        scopes[1].overrides!.overrides![0].provider!.toSource(),
        'provider',
      );
      expect(scopes[1].overrides!.overrides![0].familyArguments, null);
    }
    {
      expect(
        scopes[1].overrides!.overrides![1].providerElement,
        same(provider.providerElement),
      );
      expect(
        scopes[1].overrides!.overrides![1].expression.toSource(),
        'provider.overrideWithValue(42)',
      );
      expect(
        scopes[1].overrides!.overrides![1].provider!.toSource(),
        'provider',
      );
      expect(scopes[1].overrides!.overrides![1].familyArguments, null);
    }
    {
      expect(
        scopes[1].overrides!.overrides![2].providerElement,
        same(provider.providerElement),
      );
      expect(
        scopes[1].overrides!.overrides![2].expression.toSource(),
        'provider',
      );
      expect(
        scopes[1].overrides!.overrides![2].provider!.toSource(),
        'provider',
      );
      expect(scopes[1].overrides!.overrides![2].familyArguments, null);
    }

    {
      expect(
        scopes[1].overrides!.overrides![3].providerElement,
        same(family.providerElement),
      );
      expect(
        scopes[1].overrides!.overrides![3].expression.toSource(),
        'family(42)',
      );
      expect(
        scopes[1].overrides!.overrides![3].provider!.toSource(),
        'family',
      );
      expect(
        scopes[1].overrides!.overrides![3].familyArguments?.toSource(),
        '(42)',
      );
    }
    {
      expect(
        scopes[1].overrides!.overrides![4].providerElement,
        same(family.providerElement),
      );
      expect(
        scopes[1].overrides!.overrides![4].expression.toSource(),
        'family.overrideWith((ref, id) => 0)',
      );
      expect(
        scopes[1].overrides!.overrides![4].provider!.toSource(),
        'family',
      );
      expect(scopes[1].overrides!.overrides![4].familyArguments, null);
    }
    {
      expect(
        scopes[1].overrides!.overrides![5].providerElement,
        same(family.providerElement),
      );
      expect(
        scopes[1].overrides!.overrides![5].expression.toSource(),
        'family(42).overrideWith((ref) => 0)',
      );
      expect(
        scopes[1].overrides!.overrides![5].provider!.toSource(),
        'family',
      );
      expect(
        scopes[1].overrides!.overrides![5].familyArguments?.toSource(),
        '(42)',
      );
    }

    expect(
      scopes[2].node.toSource(),
      'ProviderScope(overrides: fn(), child: Container())',
    );
    expect(scopes[2].overrides!.overrides, null);
    expect(scopes[2].overrides!.node.toSource(), 'overrides: fn()');

    expect(
      scopes[3].node.toSource(),
      'ProviderScope(overrides: [() {return provider;}()], child: Container())',
    );
    expect(scopes[3].overrides?.overrides, hasLength(1));
    expect(
      scopes[3].overrides!.node.toSource(),
      'overrides: [() {return provider;}()]',
    );
    expect(
      scopes[3].overrides?.overrides?.single.expression.toSource(),
      '() {return provider;}()',
    );
    expect(scopes[3].overrides?.overrides?.single.providerElement, null);
    expect(scopes[3].overrides?.overrides?.single.provider, null);
    expect(scopes[3].overrides?.overrides?.single.familyArguments, null);

    expect(scopes[4].node.toSource(), "ProviderScope(child: Text('foo'))");
    expect(scopes[4].overrides, null);
    expect(consumer.providerScopeInstanceCreateExpressions, hasLength(1));
    expect(
      consumer.providerScopeInstanceCreateExpressions.single,
      same(scopes[4]),
    );
  });
}
