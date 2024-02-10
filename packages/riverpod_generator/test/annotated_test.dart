import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:test/test.dart';

void main() async {
  final file = File('test/integration/annotated.g.dart').absolute;
  final result = await resolveFile2(path: file.path) as ResolvedUnitResult;
  final declarations = result.unit.declarations;

  test('Annotations on parameters', () {
    // TODO changelog added support for annotations on family parameters
    final notifier =
        declarations.findNamed(r'_$ClassBased') as ClassDeclaration;
    final id = notifier.members.findNamed('id');
    final family =
        declarations.findNamed('ClassBasedFamily') as ClassDeclaration;
    final call = family.members.findNamed('call') as MethodDeclaration;

    expect(
      id.metadata.toString(),
      "[@Deprecated('field')]",
    );
    expect(
      call.parameters!.parameters
          .firstWhere((e) => e.name!.lexeme == 'id')
          .metadata
          .toString(),
      "[@Deprecated('field')]",
    );
  });

  test('Annotations on generated functionalProvider', () {
    final annotations =
        declarations.findNamed('functionalProvider').metadata.toString();

    expect(
      annotations,
      "[@ProviderFor(functional), @Deprecated('Deprecation message'), @visibleForTesting, @protected]",
    );
  });

  test('Annotations on generated classBasedProvider', () {
    final annotations =
        declarations.findNamed('classBasedProvider').metadata.toString();

    expect(
      annotations,
      "[@ProviderFor(ClassBased), @Deprecated('Deprecation message'), @visibleForTesting, @protected]",
    );
  });

  test('Annotations on generated familyProvider', () {
    final annotations =
        declarations.findNamed('familyProvider').metadata.toString();
    expect(
      annotations,
      "[@ProviderFor(family), @Deprecated('Deprecation message'), @visibleForTesting, @protected]",
    );
  });

  test('Annotations on generated notCopiedFunctionalProvider', () {
    final annotations = declarations
        .findNamed('notCopiedFunctionalProvider')
        .metadata
        .toString();
    expect(
      annotations,
      '[@ProviderFor(notCopiedFunctional)]',
    );
  });

  test('Annotations on generated notCopiedClassBasedProvider', () {
    final annotations = declarations
        .findNamed('notCopiedClassBasedProvider')
        .metadata
        .toString();
    expect(
      annotations,
      '[@ProviderFor(NotCopiedClassBased)]',
    );
  });

  test('Annotations on generated notCopiedFamilyProvider', () {
    final annotations =
        declarations.findNamed('notCopiedFamilyProvider').metadata.toString();
    expect(
      annotations,
      '[@ProviderFor(notCopiedFamily)]',
    );
  });
}

extension TopLevelVariableDeclarationFindNamedX on List<Declaration> {
  Declaration findNamed(String name) {
    return singleWhere((element) {
      switch (element) {
        case TopLevelVariableDeclaration():
          return element.variables.variables.first.name.lexeme == name;
        case FieldDeclaration():
          return element.fields.variables.first.name.lexeme == name;
        case MethodDeclaration():
          return element.name.lexeme == name;
        case NamedCompilationUnitMember():
          return element.name.lexeme == name;
        case ConstructorDeclaration():
          return element.name?.lexeme == name;
        case _:
          throw UnsupportedError(element.runtimeType.toString());
      }
    });
  }
}
