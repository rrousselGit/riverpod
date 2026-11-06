import 'dart:convert';

import 'package:repo_checks/src/mutation_scope.dart';
import 'package:test/test.dart';

/// The state dart_mutant leaves in `.dart_tool/dart_mutant/incremental.json`,
/// with a file of [source] at `lib/a.dart` and [mutants] in it, as
/// `(offset, end, status)`.
String _state(String source, List<(int, int, String)> mutants) {
  return jsonEncode({
    'files': {
      'lib/a.dart': {
        'input': {'source': source, 'tests': <String, String>{}},
        'mutants': [
          for (final (offset, end, status) in mutants)
            {
              'mutator': 'X',
              'offset': offset,
              'end': end,
              'replacement': 'y',
              'status': status,
            },
        ],
      },
    },
  });
}

List<(String, String?)> _statuses(String state) {
  final mutants = switch (jsonDecode(state)) {
    {'files': {'lib/a.dart': {'mutants': final List<Object?> mutants}}} =>
      mutants,
    _ => throw StateError('Not a state'),
  };
  return [
    for (final mutant in mutants.cast<Map<String, Object?>>())
      (mutant['status']! as String, mutant['reason'] as String?),
  ];
}

void main() {
  group('parseChangedLines', () {
    test('lists the added lines of each file, by their new number', () {
      expect(
        parseChangedLines('''
diff --git a/lib/a.dart b/lib/a.dart
index 1..2 100644
--- a/lib/a.dart
+++ b/lib/a.dart
@@ -2 +2,2 @@ void a() {
-  old();
+  x();
+  y();
@@ -10,0 +12 @@ void a() {
+  z();
diff --git a/lib/b.dart b/lib/b.dart
new file mode 100644
--- /dev/null
+++ b/lib/b.dart
@@ -0,0 +1,2 @@
+void b() {}
+void c() {}
'''),
        {
          'lib/a.dart': {2, 3, 12},
          'lib/b.dart': {1, 2},
        },
      );
    });

    group('edge cases', () {
      test('skips blank and comment lines, and files left without lines', () {
        expect(
          parseChangedLines('''
--- a/lib/a.dart
+++ b/lib/a.dart
@@ -1,0 +1,4 @@
+/// Docs
+
+  // A comment
+  x(); // Trailing
--- a/lib/b.dart
+++ b/lib/b.dart
@@ -3 +3 @@
-/// Old docs
+/// New docs
'''),
          {
            'lib/a.dart': {4},
          },
        );
      });

      test('skips deleted files and files with only removed lines', () {
        expect(
          parseChangedLines('''
--- a/lib/a.dart
+++ /dev/null
@@ -1 +0,0 @@
-void a() {}
--- a/lib/b.dart
+++ b/lib/b.dart
@@ -3 +2,0 @@
-  x();
'''),
          isEmpty,
        );
      });

      test('reads a hunk header without a count', () {
        expect(parseChangedLines('+++ b/a.dart\n@@ -7 +9 @@\n-x\n+y\n'), {
          'a.dart': {9},
        });
      });
    });
  });

  group('linesOf', () {
    test('gives the lines a range spans, without its end', () {
      const source = 'ab\ncd\nef\n';
      expect(linesOf(source, 0, 2), (first: 1, last: 1));
      expect(linesOf(source, 1, 7), (first: 1, last: 3));
      // Up to the line break of line 2, which is still on line 2.
      expect(linesOf(source, 3, 6), (first: 2, last: 2));
    });

    test('gives the line of an empty range', () {
      expect(linesOf('ab\ncd', 4, 4), (first: 2, last: 2));
    });
  });

  group('touches', () {
    test('is true when a line of the range is changed', () {
      expect(touches((first: 2, last: 4), {4}), isTrue);
      expect(touches((first: 2, last: 4), {2}), isTrue);
      expect(touches((first: 2, last: 4), {1, 5}), isFalse);
    });
  });

  group('scopeMutants', () {
    test('leaves out the pending mutants on no changed line', () {
      // Lines 1, 2 and 3 start at 0, 7 and 14.
      const source = 'a = 1;\nb = 2;\nc = 3;\n';
      final result = scopeMutants(
        _state(source, [
          (4, 5, 'Pending'),
          (11, 12, 'Pending'),
          (7, 20, 'Pending'),
          (11, 12, 'CompileError'),
          (18, 19, 'Pending'),
        ]),
        {
          'lib/a.dart': {2},
          'lib/other.dart': {1},
        },
      );

      expect(_statuses(result.incremental), [
        ('CompileError', outOfScopeReason),
        ('Pending', null),
        ('Pending', null),
        ('CompileError', null),
        ('CompileError', outOfScopeReason),
      ]);
      expect(result.counts, {'lib/a.dart': (left: 2, all: 5)});
    });

    group('edge cases', () {
      test('leaves the files without changed lines as they are', () {
        final state = _state('a;\n', [(0, 1, 'Pending')]);

        final result = scopeMutants(state, {});

        expect(_statuses(result.incremental), [('Pending', null)]);
        expect(result.counts, isEmpty);
      });

      test('rejects a state that is not one', () {
        expect(() => scopeMutants('[]', {}), throwsFormatException);
        expect(
          () => scopeMutants(
            jsonEncode({
              'files': {
                'lib/a.dart': {'mutants': <Object?>[]},
              },
            }),
            {
              'lib/a.dart': {1},
            },
          ),
          throwsFormatException,
        );
        expect(
          () => scopeMutants(
            jsonEncode({
              'files': {
                'lib/a.dart': {
                  'input': {'source': 'a'},
                  'mutants': [
                    {'status': 'Pending'},
                  ],
                },
              },
            }),
            {
              'lib/a.dart': {1},
            },
          ),
          throwsFormatException,
        );
      });
    });
  });
}
