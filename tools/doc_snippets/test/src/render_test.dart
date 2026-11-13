import 'package:doc_snippets/src/render.dart';
import 'package:test/test.dart';

const _header = '''
// GENERATED from lib/a.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.
''';

void main() {
  group('renderSnippet', () {
    String render(
      String code, {
      String assumptions = '',
      List<String> imports = const [],
    }) {
      return renderSnippet(
        source: 'lib/a.dart',
        code: code,
        assumptions: assumptions,
        imports: imports,
      );
    }

    test('keeps declarations as is', () {
      expect(
        render('final a = 1;\n\nvoid main() {\n  print(a);\n}'),
        '$_header\nfinal a = 1;\n\nvoid main() {\n  print(a);\n}\n',
      );
    });

    test('wraps statements in an async function', () {
      expect(
        render('final a = await b;\nprint(a);'),
        '$_header\n'
        'dynamic snippet() async {\n'
        'final a = await b;\n'
        'print(a);\n'
        '}\n',
      );
    });

    test('returns an expression from an async function', () {
      expect(
        render('ref.watch(provider)'),
        '$_header\ndynamic snippet() async =>\nref.watch(provider)\n;\n',
      );
    });

    test('hoists the directives above what the snippet can assume', () {
      expect(
        render(
          "import 'c.dart';\nimport 'd.dart'\n    show d;\n\nprint(d);",
          assumptions: "import 'b.dart';\n\nlate int b;\n",
          imports: ['package:a/a.dart'],
        ),
        '$_header\n'
        "import 'package:a/a.dart';\n"
        "import 'b.dart';\n"
        "import 'c.dart';\n"
        "import 'd.dart'\n"
        '    show d;\n'
        '\n'
        'late int b;\n'
        '\n'
        'dynamic snippet() async {\n'
        'print(d);\n'
        '}\n',
      );
    });

    test('wraps the statements that follow declarations', () {
      expect(
        render('class A {}\n\nfinal a = A();\n\nprint(a);\nprint(a);'),
        '$_header\n'
        'class A {}\n'
        '\n'
        'final a = A();\n'
        '\n'
        'dynamic snippet() async {\n'
        'print(a);\n'
        'print(a);\n'
        '}\n',
      );
    });

    test('returns the expression that follows declarations', () {
      expect(
        render('class A {}\n\nA(\n)'),
        '$_header\nclass A {}\n\ndynamic snippet() async =>\nA(\n)\n;\n',
      );
    });

    group('edge cases', () {
      test('keeps code that parses as nothing as is', () {
        expect(render('final a = ...;\nprint(a);'), '''
$_header
final a = ...;
print(a);
''');
        // Declarations do not follow statements.
        expect(render('print(1);\nclass A {}'), '''
$_header
print(1);
class A {}
''');
      });

      test('supports snippets with only directives', () {
        expect(render("import 'b.dart';"), "$_header\nimport 'b.dart';\n\n\n");
      });

      test('supports assumptions with only directives or declarations', () {
        expect(
          render('a', assumptions: "import 'b.dart';"),
          "$_header\nimport 'b.dart';\n\ndynamic snippet() async =>\na\n;\n",
        );
        expect(
          render('a', assumptions: 'late int a;'),
          '$_header\nlate int a;\n\ndynamic snippet() async =>\na\n;\n',
        );
      });
    });
  });
}
