@Timeout.factor(2)
library;

import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  testSource(
    'Decode ProviderScope creations',
    source: '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
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
''',
    (resolver, unit, units) async {
      final result = await resolver.resolveRiverpodAnalysisResult();

      final scopes = result.providerScopeInstanceCreationExpressions;

      final provider =
          result.manualProviderDeclarations.takeAll(['provider']).values.single;
      final family =
          result.manualProviderDeclarations.takeAll(['family']).values.single;

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
        '[provider.overrideWith((ref) => 0), provider.overrideWithValue(42), provider, family(42), family.overrideWith((ref, id) => 0), family(42).overrideWith((ref) => 0)]',
      );
      {
        expect(
          scopes[1].overrides!.overrides![0].provider?.providerElement,
          same(provider.providerElement),
        );
        expect(
          scopes[1].overrides!.overrides![0].node.toSource(),
          'provider.overrideWith((ref) => 0)',
        );
        expect(
          scopes[1].overrides!.overrides![0].provider!.node.toSource(),
          'provider',
        );
        expect(scopes[1].overrides!.overrides![0].familyArguments, null);
      }
      {
        expect(
          scopes[1].overrides!.overrides![1].provider?.providerElement,
          same(provider.providerElement),
        );
        expect(
          scopes[1].overrides!.overrides![1].node.toSource(),
          'provider.overrideWithValue(42)',
        );
        expect(
          scopes[1].overrides!.overrides![1].provider!.node.toSource(),
          'provider',
        );
        expect(scopes[1].overrides!.overrides![1].familyArguments, null);
      }
      {
        expect(
          scopes[1].overrides!.overrides![2].provider?.providerElement,
          same(provider.providerElement),
        );
        expect(scopes[1].overrides!.overrides![2].node.toSource(), 'provider');
        expect(
          scopes[1].overrides!.overrides![2].provider!.node.toSource(),
          'provider',
        );
        expect(scopes[1].overrides!.overrides![2].familyArguments, null);
      }

      {
        expect(
          scopes[1].overrides!.overrides![3].provider?.providerElement,
          same(family.providerElement),
        );
        expect(
          scopes[1].overrides!.overrides![3].node.toSource(),
          'family(42)',
        );
        expect(
          scopes[1].overrides!.overrides![3].provider!.node.toSource(),
          'family',
        );
        expect(
          scopes[1].overrides!.overrides![3].familyArguments?.toSource(),
          '(42)',
        );
      }
      {
        expect(
          scopes[1].overrides!.overrides![4].provider?.providerElement,
          same(family.providerElement),
        );
        expect(
          scopes[1].overrides!.overrides![4].node.toSource(),
          'family.overrideWith((ref, id) => 0)',
        );
        expect(
          scopes[1].overrides!.overrides![4].provider!.node.toSource(),
          'family',
        );
        expect(scopes[1].overrides!.overrides![4].familyArguments, null);
      }
      {
        expect(
          scopes[1].overrides!.overrides![5].provider?.providerElement,
          same(family.providerElement),
        );
        expect(
          scopes[1].overrides!.overrides![5].node.toSource(),
          'family(42).overrideWith((ref) => 0)',
        );
        expect(
          scopes[1].overrides!.overrides![5].provider!.node.toSource(),
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
      expect(scopes[2].overrides!.node.toSource(), 'fn()');

      expect(
        scopes[3].node.toSource(),
        'ProviderScope(overrides: [() {return provider;}()], child: Container())',
      );
      expect(scopes[3].overrides?.overrides, hasLength(1));
      expect(scopes[3].overrides!.node.toSource(), '[() {return provider;}()]');
      expect(
        scopes[3].overrides?.overrides?.single.node.toSource(),
        '() {return provider;}()',
      );
      expect(
        scopes[3].overrides?.overrides?.single.provider?.providerElement,
        null,
      );
      expect(scopes[3].overrides!.overrides!.single.provider, null);
      expect(scopes[3].overrides!.overrides!.single.familyArguments, null);

      expect(scopes[4].node.toSource(), "ProviderScope(child: Text('foo'))");
      expect(scopes[4].overrides, null);
    },
  );
}
