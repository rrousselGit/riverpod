import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/expect.dart';
import 'package:test/test.dart';

import '../../analyzer_test_utils.dart';
import '../../matchers.dart';

void main() {
  testSource('Decode generated provider identifiers',
      runGenerator: true, source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';

part 'foo.g.dart';

// Let's define some providers
@riverpod
int a(Ref ref) => 0;

@riverpod
class B extends _$B {
  @override
  int build() => 0;
}

// Using those providers in random places
void main() {
  aProvider;
  bProvider;
}
''', (resolver, unit, units) async {
    final visitor = _FindIdentifiersVisitor();
    unit.accept(visitor);

    expect(visitor.identifiers, hasLength(2));

    expect(
      visitor.identifiers[0],
      isProviderIdentifier(
        node: hasToString('aProvider'),
        providerElement: isFunctionalProviderDeclarationElement(name: 'a'),
      ),
    );
    expect(
      visitor.identifiers[1],
      isProviderIdentifier(
        node: hasToString('bProvider'),
        providerElement: isClassBasedProviderDeclarationElement(name: 'B'),
      ),
    );
  });

  testSource('Decode legacy provider identifiers', source: '''
import 'package:flutter_riverpod/flutter_riverpod.dart';

final provider = Provider<int>((ref) => 0);

void main() {
  provider;
}
''', (resolver, unit, units) async {
    final visitor = _FindIdentifiersVisitor();
    unit.accept(visitor);

    expect(visitor.identifiers, hasLength(1));

    expect(
      visitor.identifiers[0],
      isProviderIdentifier(
        node: hasToString('provider'),
        providerElement: isLegacyProviderDeclarationElement(name: 'provider'),
      ),
    );
  });
}

class _FindIdentifiersVisitor extends RecursiveAstVisitor<void> {
  final List<ProviderIdentifier> identifiers = [];

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    super.visitSimpleIdentifier(node);
    if (node.provider case final provider?) {
      identifiers.add(provider);
    }
  }
}
