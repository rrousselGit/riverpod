import 'package:doc_snippets/src/generate.dart';
import 'package:doc_snippets/src/render.dart';
import 'package:test/test.dart';

void main() {
  group('SnippetPolicy.parse', () {
    test('reads the ignored globs and the unchecked files', () {
      final policy = SnippetPolicy.parse('''
ignored:
  - "**/CHANGELOG.md"
  - i18n/**
unchecked:
  - lib/a.dart
''');

      expect(policy.isIgnored('CHANGELOG.md'), isTrue);
      expect(policy.isIgnored('packages/a/CHANGELOG.md'), isTrue);
      expect(policy.isIgnored('i18n/fr/a.md'), isTrue);
      expect(policy.isIgnored('README.md'), isFalse);
      expect(policy.unchecked, {'lib/a.dart'});
    });

    test('defaults to checking every file', () {
      final policy = SnippetPolicy.parse('{}');

      expect(policy.ignored, isEmpty);
      expect(policy.unchecked, isEmpty);
    });

    test('rejects malformed content', () {
      for (final content in [
        '- a',
        'unknown: []',
        'ignored: a',
        'ignored: [1]',
        'unchecked: {a: 1}',
      ]) {
        expect(
          () => SnippetPolicy.parse(content),
          throwsFormatException,
          reason: content,
        );
      }
    });
  });

  group('generateSnippets', () {
    SnippetGeneration generate(
      Map<String, String> files, {
      String policy = '{}',
    }) {
      return generateSnippets(
        policy: SnippetPolicy.parse(policy),
        files: files.keys.toList(),
        read: (path) => files[path]!,
      );
    }

    test('renders the snippets of the Dart, Markdown and MDX files', () {
      final generation = generate({
        'README.md': '''
<!-- Examples can assume:
late int a;
-->
```dart
print(a);
```
''',
        'docs/intro.mdx': '''
```dart
final a = 1;
```
```dart
final b = 2;
```
''',
        'lib/src/a.dart': '''
// Examples can assume:
// late A a;

/// ```dart
/// a.method();
/// ```
class A {}
''',
        'lib/a.txt': '```dart\na\n```',
      });

      expect(generation.problems, isEmpty);
      expect(generation.files, {
        'README_md/snippet_1.dart': renderSnippet(
          source: 'README.md',
          code: 'print(a);',
          assumptions: 'late int a;',
        ),
        'docs/intro_mdx/snippet_1.dart': renderSnippet(
          source: 'docs/intro.mdx',
          code: 'final a = 1;',
        ),
        'docs/intro_mdx/snippet_2.dart': renderSnippet(
          source: 'docs/intro.mdx',
          code: 'final b = 2;',
        ),
        'lib/src/a_dart/snippet_1.dart': renderSnippet(
          source: 'lib/src/a.dart',
          code: 'a.method();',
          assumptions: 'late A a;',
        ),
      });
    });

    test('imports the main library of the package of the snippet', () {
      final generation = generate({
        'pubspec.yaml': 'name: root',
        'README.md': '```dart\na\n```',
        'packages/a/pubspec.yaml': 'name: a',
        'packages/a/lib/a.dart': '/// ```dart\n/// a\n/// ```',
        'packages/a/lib/src/b.dart': '/// ```dart\n/// b\n/// ```',
        'packages/a/example/pubspec.yaml': 'name: a_example',
        'packages/a/example/README.md': '```dart\nc\n```',
        'packages/b/pubspec.yaml': '- not a pubspec',
        'packages/b/README.md': '```dart\nd\n```',
      });

      expect(generation.problems, isEmpty);
      expect(generation.files, {
        'README_md/snippet_1.dart': renderSnippet(
          source: 'README.md',
          code: 'a',
        ),
        'packages/a/lib/a_dart/snippet_1.dart': renderSnippet(
          source: 'packages/a/lib/a.dart',
          code: 'a',
          imports: ['package:a/a.dart'],
        ),
        'packages/a/lib/src/b_dart/snippet_1.dart': renderSnippet(
          source: 'packages/a/lib/src/b.dart',
          code: 'b',
          imports: ['package:a/a.dart'],
        ),
        // The example has no main library, but is part of the package.
        'packages/a/example/README_md/snippet_1.dart': renderSnippet(
          source: 'packages/a/example/README.md',
          code: 'c',
          imports: ['package:a/a.dart'],
        ),
        'packages/b/README_md/snippet_1.dart': renderSnippet(
          source: 'packages/b/README.md',
          code: 'd',
        ),
      });
    });

    test('names, skips and continues snippets as their fence says', () {
      final generation = generate({
        'a.md': '''
```dart name=first
final a = 1;
```
```dart no-analyze continued
final b = ...;
```
```dart continued
final c = 3;
```
```dart continued name=last
print(a);
```
''',
      });

      expect(generation.problems, isEmpty);
      expect(generation.files, {
        'a_md/first.dart': renderSnippet(source: 'a.md', code: 'final a = 1;'),
        // Numbered by its position among all the snippets, so that it keeps
        // its path when another snippet gets a name or stops being skipped.
        'a_md/snippet_3.dart': renderSnippet(
          source: 'a.md',
          // Follows the last snippet that was not skipped.
          code: 'final a = 1;\n\nfinal c = 3;',
        ),
        'a_md/last.dart': renderSnippet(
          source: 'a.md',
          code: 'final a = 1;\n\nfinal c = 3;\n\nprint(a);',
        ),
      });
    });

    test('skips the ignored, unchecked and generated files', () {
      const snippet = '/// ```dart\n/// a\n/// ```\n';
      final generation = generate(
        {
          'CHANGELOG.md': '```dart\na\n```',
          'lib/unchecked.dart': snippet,
          'lib/a.g.dart': snippet,
          'lib/a.freezed.dart': snippet,
          'lib/generated.dart': '// GENERATED CODE\n$snippet',
          // Only Dart files are generated.
          'GENERATED.md': 'GENERATED\n```dart\na\n```',
        },
        policy: '''
ignored: [CHANGELOG.md]
unchecked: [lib/unchecked.dart]
''',
      );

      expect(generation.problems, isEmpty);
      expect(generation.files.keys, ['GENERATED_md/snippet_1.dart']);
    });

    group('edge cases', () {
      test('reports the unchecked files that need not be', () {
        final generation = generate(
          {
            'ignored.md': '```dart\na\n```',
            'none.md': 'No snippet',
            'skipped.md': '```dart no-analyze\na\n```',
          },
          policy: '''
ignored: [ignored.md]
unchecked: [ignored.md, missing.md, none.md, skipped.md]
''',
        );

        expect(generation.files, isEmpty);
        expect(generation.problems, [
          'ignored.md: in `unchecked`, but ignored.',
          'missing.md: in `unchecked`, but no longer exists.',
          'none.md: in `unchecked`, but has no snippet to extract. '
              'Remove it from baselines/snippets.yaml.',
          'skipped.md: in `unchecked`, but has no snippet to extract. '
              'Remove it from baselines/snippets.yaml.',
        ]);
      });

      test('reports the names that are not file names', () {
        final generation = generate({
          'a.md': '''
```dart name=../a
a
```
```dart name=Counter
b
```
```dart name=
c
```
```dart name=counter_2
d
```
''',
        });

        expect(generation.files.keys, ['a_md/counter_2.dart']);
        expect(generation.problems, [
          'a.md:1: the name of a snippet must be in snake_case, '
              'but is "../a".',
          'a.md:4: the name of a snippet must be in snake_case, '
              'but is "Counter".',
          'a.md:7: the name of a snippet must be in snake_case, but is "".',
        ]);
      });

      test('reports the snippets extracted to the same file', () {
        final generation = generate({
          'a.md': '''
```dart name=a
a
```
```dart name=a
b
```
```dart name=snippet_4
c
```
```dart
d
```
''',
        });

        expect(generation.files, {
          'a_md/a.dart': renderSnippet(source: 'a.md', code: 'a'),
          'a_md/snippet_4.dart': renderSnippet(source: 'a.md', code: 'c'),
        });
        expect(generation.problems, [
          'a.md:4: another snippet of this file is extracted to '
              'a_md/a.dart. Rename one of them.',
          'a.md:10: another snippet of this file is extracted to '
              'a_md/snippet_4.dart. Rename one of them.',
        ]);
      });

      test('reports a first snippet that is continued', () {
        final generation = generate({
          'a.md': '```dart continued\na\n```',
          'lib/a.dart': '''
/// ```dart
/// a
/// ```
class A {}

/// ```dart continued
/// b
/// ```
class B {}
''',
        });

        expect(generation.problems, [
          'a.md:1: `continued`, but the first snippet of its file.',
        ]);
        // Extracted nonetheless, as the analyzer may have more to say.
        expect(generation.files, {
          'a_md/snippet_1.dart': renderSnippet(source: 'a.md', code: 'a'),
          'lib/a_dart/snippet_1.dart': renderSnippet(
            source: 'lib/a.dart',
            code: 'a',
          ),
          'lib/a_dart/snippet_2.dart': renderSnippet(
            source: 'lib/a.dart',
            code: 'a\n\nb',
          ),
        });
      });
    });
  });
}
