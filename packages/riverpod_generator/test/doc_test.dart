import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:riverpod_generator/src/riverpod_generator.dart';
import 'package:test/test.dart';

import 'annotated_test.dart';

void main() async {
  final file = File('test/integration/documented.g.dart').absolute;
  final result = await resolveFile2(path: file.path) as ResolvedUnitResult;
  final topLevelDeclarations = result.unit.declarations.toList();

  final variables = [
    topLevelDeclarations.findNamed('functionalProvider'),
    topLevelDeclarations.findNamed('classBasedProvider'),
    topLevelDeclarations.findNamed('familyProvider'),
    topLevelDeclarations.findNamed('classFamilyBasedProvider'),
  ];
  final providers = [
    topLevelDeclarations.findNamed('FunctionalProvider'),
    topLevelDeclarations.findNamed('ClassBasedProvider'),
    topLevelDeclarations.findNamed('FamilyFamily'),
    topLevelDeclarations.findNamed('ClassFamilyBasedProvider'),
  ];
  final family = [
    topLevelDeclarations.findNamed('FamilyFamily'),
    topLevelDeclarations.findNamed('ClassFamilyBasedFamily'),
  ];
  final familyFields = [
    (topLevelDeclarations.findNamed(r'_$ClassFamilyBased') as ClassDeclaration)
        .members
        .findNamed('id'),
  ];

  final annotationTargets = [
    ...variables,
    ...providers,
    ...family,
    for (final family in family)
      (family as ClassDeclaration).members.findNamed('call'),
    ...familyFields,
  ];

  test('Includes dartdoc', () async {
    for (final target in annotationTargets) {
      expect(
        target.doc,
        '/// Hello world\n// Foo\n',
        reason: 'Expected doc comment for $target',
      );
    }
  });

  test('Includes annotations excluding Riverpod', () {
    for (final target in annotationTargets) {
      final annotations = target.metadata.map((e) => e.toSource()).toList();

      expect(
        annotations,
        unorderedMatches([
          '@annotation',
          if (variables.contains(target)) contains('@ProviderFor('),
        ]),
        reason: 'Expected @annotation for $target',
      );
    }
  });
}
