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

  test('Doc on generated variables', () async {
    final doc = topLevelDeclarations.findNamed('functionalProvider').doc;

    expect(doc, '/// Hello world\n// Foo\n');
  });

  test('Doc on generated provider', () async {
    final doc = topLevelDeclarations.findNamed('FunctionalProvider').doc;

    expect(doc, '/// Hello world\n// Foo\n');
  });

  test('Doc on generated family', () async {
    final family =
        topLevelDeclarations.findNamed('FamilyFamily') as ClassDeclaration;

    expect(
      family.members.findNamed('call').doc,
      '/// Hello world\n// Foo\n',
    );

    expect(family.doc, '/// Hello world\n// Foo\n');
  });

  test('Doc on generated class', () async {
    final classBased = topLevelDeclarations.findNamed(r'_$ClassFamilyBased')
        as ClassDeclaration;

    expect(
      classBased.members.findNamed('id').doc,
      '/// Hello world\n// Foo\n',
    );
  });
}
