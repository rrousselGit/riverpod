@Timeout.factor(2)
library;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import '../analyzer_test_utils.dart';
import '../matchers.dart';

void main() {
  testSource(
    'Decodes Dependencies',
    runGenerator: true,
    source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_annotation/experimental/scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

@riverpod
int a(Ref ref) => 0;

@riverpod
class B extends _$B {
  @override
  int build() => 0;
}

@riverpod
int c(Ref ref, int arg) => 0;

@riverpod
class D extends _$D {
  @override
  int build(int arg) => 0;
}

@Dependencies([a, B, c, D])
class Class {}

@Dependencies([a, B, c, D])
void function() {}

void main() {
  @Dependencies([a, B, c, D])
  var value = 0;
}
''',
    (resolver, unit, units) async {
      final clazz = unit.declarations.findByName('Class');
      final function = unit.declarations.findByName('function');

      final value =
          unit.declarations
              .findByName<FunctionDeclaration>('main')
              .functionExpression
              .body
              .cast<BlockFunctionBody>()!
              .block
              .statements
              .whereType<VariableDeclarationStatement>()
              .single;

      expect(
        clazz.dependencies,
        isDependencies(
          node: hasToString('@Dependencies([a, B, c, D])'),
          dependenciesNode: hasToString('[a, B, c, D]'),
          element: isDependenciesElement(
            element: isA<ElementAnnotation>().having(
              (e) => e.toSource(),
              'toSource',
              '@Dependencies([a, B, c, D])',
            ),
            dependencies: [
              isFunctionalProviderDeclarationElement(name: 'a'),
              isClassBasedProviderDeclarationElement(name: 'B'),
              isFunctionalProviderDeclarationElement(name: 'c'),
              isClassBasedProviderDeclarationElement(name: 'D'),
            ],
          ),
          dependencies: isProviderDependencyList(
            values: [
              isProviderDependency(
                provider: isFunctionalProviderDeclarationElement(name: 'a'),
              ),
              isProviderDependency(
                provider: isClassBasedProviderDeclarationElement(name: 'B'),
              ),
              isProviderDependency(
                provider: isFunctionalProviderDeclarationElement(name: 'c'),
              ),
              isProviderDependency(
                provider: isClassBasedProviderDeclarationElement(name: 'D'),
              ),
            ],
          ),
        ),
      );

      expect(function.dependencies, isDependencies());
      expect(value.variables.dependencies, isDependencies());
    },
  );
}
