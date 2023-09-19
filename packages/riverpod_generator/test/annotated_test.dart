import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:test/test.dart';

void main() async {
  final file = File('test/integration/annotated.g.dart').absolute;
  final result = await resolveFile2(path: file.path) as ResolvedUnitResult;
  final topLevelDeclarations = result.unit.declarations
      .whereType<TopLevelVariableDeclaration>()
      .toList();

  test('Annotations on generated functionalProvider', () async {
    final annotations = topLevelDeclarations
        .findNamed('functionalProvider')
        .metadata
        .toString();

    expect(
      annotations,
      "[@ProviderFor(functional), @Deprecated('Deprecation message'), @@visibleForTesting, @protected]",
    );
  });

  test('Annotations on generated classBasedProvider', () async {
    final annotations = topLevelDeclarations
        .findNamed('classBasedProvider')
        .metadata
        .toString();

    expect(
      annotations,
      "[@ProviderFor(ClassBased), @Deprecated('Deprecation message'), @@visibleForTesting, @protected]",
    );
  });

  test('Annotations on generated familyProvider', () async {
    final annotations =
        topLevelDeclarations.findNamed('familyProvider').metadata.toString();
    expect(
      annotations,
      "[@ProviderFor(family), @Deprecated('Deprecation message'), @@visibleForTesting, @protected]",
    );
  });

  test('Annotations on generated notCopiedFunctionalProvider', () async {
    final annotations = topLevelDeclarations
        .findNamed('notCopiedFunctionalProvider')
        .metadata
        .toString();
    expect(
      annotations,
      '[@ProviderFor(notCopiedFunctional)]',
    );
  });

  test('Annotations on generated notCopiedClassBasedProvider', () async {
    final annotations = topLevelDeclarations
        .findNamed('notCopiedClassBasedProvider')
        .metadata
        .toString();
    expect(
      annotations,
      '[@ProviderFor(NotCopiedClassBased)]',
    );
  });

  test('Annotations on generated notCopiedFamilyProvider', () async {
    final annotations = topLevelDeclarations
        .findNamed('notCopiedFamilyProvider')
        .metadata
        .toString();
    expect(
      annotations,
      '[@ProviderFor(notCopiedFamily)]',
    );
  });
}

extension TopLevelVariableDeclarationFindNamedX
    on List<TopLevelVariableDeclaration> {
  TopLevelVariableDeclaration findNamed(String name) {
    return singleWhere((element) {
      return element.variables.variables.first.name.lexeme == name;
    });
  }
}
