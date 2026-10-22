import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:riverpod_analyzer_utils/src/nodes.dart';
import 'package:test/test.dart';

void main() {
  group('ClassMembers.members', () {
    List<ClassMember> membersOf(String source) {
      final unit = parseString(content: source).unit;
      return unit.declarations.whereType<ClassDeclaration>().single.members;
    }

    test('lists the members of a class body', () {
      final members = membersOf('class A { int a = 0; void b() {} }');

      expect(members, [isA<FieldDeclaration>(), isA<MethodDeclaration>()]);
    });

    test('is empty for empty bodies', () {
      expect(membersOf('class A {}'), isEmpty);
    });
  });
}
