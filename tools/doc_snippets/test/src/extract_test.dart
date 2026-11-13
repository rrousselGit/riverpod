import 'package:doc_snippets/src/extract.dart';
import 'package:test/test.dart';

void main() {
  group('extractMarkdownSnippets', () {
    test('finds the dart snippets, with the line of their fence', () {
      final source = extractMarkdownSnippets('''
Some text.

```dart
final a = 1;

final b = 2;
```

```yaml
key: value
```

```dart
print(a);
```
''');

      expect(source.assumptions, isEmpty);
      expect(source.snippets, hasLength(2));
      expect(source.snippets[0].line, 3);
      expect(source.snippets[0].code, 'final a = 1;\n\nfinal b = 2;');
      expect(source.snippets[0].name, isNull);
      expect(source.snippets[0].isSkipped, isFalse);
      expect(source.snippets[0].isContinued, isFalse);
      expect(source.snippets[1].line, 13);
      expect(source.snippets[1].code, 'print(a);');
    });

    test('reads the flags of the info string', () {
      final source = extractMarkdownSnippets('''
```dart no-analyze
a
```
```dart title="main.dart" name=counter continued
b
```
''');

      expect(source.snippets[0].isSkipped, isTrue);
      expect(source.snippets[0].isContinued, isFalse);
      expect(source.snippets[0].name, isNull);
      expect(source.snippets[1].isSkipped, isFalse);
      expect(source.snippets[1].isContinued, isTrue);
      expect(source.snippets[1].name, 'counter');
    });

    test('reads what the snippets can assume from the HTML comments', () {
      final source = extractMarkdownSnippets('''
<!-- Examples can assume:
import 'dart:async';

late int a;
-->

```dart
print(a);
```

<!-- A comment -->

  <!--  Examples can assume:
  late int b;
  -->
''');

      expect(
        source.assumptions,
        "import 'dart:async';\n\nlate int a;\n  late int b;",
      );
      expect(source.snippets.single.line, 7);
      expect(source.snippets.single.code, 'print(a);');
    });

    group('edge cases', () {
      test('removes the indentation of the fence from the code', () {
        final source = extractMarkdownSnippets('''
- A list:

  ```dart
  void main() {
    print(1);
 }

  }
  ```
''');

        expect(
          source.snippets.single.code,
          'void main() {\n  print(1);\n}\n\n}',
        );
      });

      test('only closes a block with a fence of its kind and length', () {
        final source = extractMarkdownSnippets('''
````dart
```
~~~~
```dart
````
~~~Dart
```
~~~ dart
~~~
''');

        expect(source.snippets, hasLength(2));
        expect(source.snippets[0].code, '```\n~~~~\n```dart');
        expect(source.snippets[1].line, 6);
        expect(source.snippets[1].code, '```\n~~~ dart');
      });

      test('does not mistake the dart fences of other blocks', () {
        final source = extractMarkdownSnippets('''
````md
```dart
a
```
````
```dartdoc
b
```
```
c
```
''');

        expect(source.snippets, isEmpty);
      });

      test('ends an unclosed block with the file', () {
        final source = extractMarkdownSnippets('```dart\na\n\n');

        expect(source.snippets.single.code, 'a\n\n');
        expect(extractMarkdownSnippets('```md\na').snippets, isEmpty);
      });

      test('supports CRLF line endings', () {
        final source = extractMarkdownSnippets(
          '<!-- Examples can assume:\r\nlate int a;\r\n-->\r\n'
          '```dart\r\nprint(a);\r\n```\r\n',
        );

        expect(source.assumptions, 'late int a;');
        expect(source.snippets.single.code, 'print(a);');
      });

      test('does not extract the fences of what the snippets can assume', () {
        final source = extractMarkdownSnippets('''
<!-- Examples can assume:
```dart
a
```
-->
''');

        expect(source.snippets, isEmpty);
        expect(source.assumptions, '```dart\na\n```');
      });
      test('does not read what the snippets can assume from code blocks', () {
        final source = extractMarkdownSnippets('''
```md
<!-- Examples can assume:
late int a;
-->
```
```dart
print(a);
```
''');

        expect(source.assumptions, isEmpty);
        expect(source.snippets.single.code, 'print(a);');
      });

      test('does not read the HTML comments of doc comments', () {
        final source = extractDartSnippets('''
/// <!-- Examples can assume:
/// late int a;
/// -->
/// ```dart
/// print(a);
/// ```
''');

        expect(source.assumptions, isEmpty);
        expect(source.snippets.single.code, 'print(a);');
      });
    });
  });

  group('extractDartSnippets', () {
    test('finds the dart snippets of the doc comments', () {
      final source = extractDartSnippets('''
/// A class.
///
/// ```dart
/// final a = A();
///
/// a.method();
/// ```
class A {
  /// A method.
  ///
  /// ```sh
  /// run
  /// ```
  ///
  ///   ```dart name=method
  ///   a.method();
  ///   ```
  void method() {}
}
''');

      expect(source.assumptions, isEmpty);
      expect(source.snippets, hasLength(2));
      expect(source.snippets[0].line, 3);
      expect(source.snippets[0].code, 'final a = A();\n\na.method();');
      expect(source.snippets[1].line, 15);
      expect(source.snippets[1].code, 'a.method();');
      expect(source.snippets[1].name, 'method');
    });

    test('reads what the snippets can assume from the comments', () {
      final source = extractDartSnippets('''
// Examples can assume:
// import 'dart:async';
//
// class B {
//   int? b;
// }

// Not assumed.

/// ```dart
/// B();
/// ```
class A {}

  // Examples can assume:
  // late A a;
  /// Ends what the snippets can assume.
  // Not assumed either.
''');

      expect(
        source.assumptions,
        "import 'dart:async';\n\nclass B {\n  int? b;\n}\nlate A a;",
      );
      expect(source.snippets.single.code, 'B();');
    });

    group('edge cases', () {
      test('does not extract the fences of other comments and strings', () {
        final source = extractDartSnippets('''
// ```dart
// a
// ```
const a = \'''
```dart
b
```
\''';
''');

        expect(source.snippets, isEmpty);
      });

      test('ends a snippet with its doc comment', () {
        final source = extractDartSnippets('''
/// ```dart
/// a
class A {}

/// b
/// ```
class B {}
''');

        expect(source.snippets.single.line, 1);
        expect(source.snippets.single.code, 'a');
      });

      test('ends a snippet with the file', () {
        final source = extractDartSnippets('/// ```dart\n/// a');

        expect(source.snippets.single.code, 'a');
      });

      test('keeps the indentation of the code, but for the first space', () {
        final source = extractDartSnippets('''
/// ```dart
///void main() {
///   print(1);
/// }
/// ```
''');

        expect(source.snippets.single.code, 'void main() {\n  print(1);\n}');
      });
    });
  });
}
