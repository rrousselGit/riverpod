import 'dart:convert';

import 'package:repo_checks/src/mutation_check.dart';
import 'package:test/test.dart';

/// A report in the mutation-testing-elements schema, with a file of
/// [source] at `lib/a.dart` and [mutants] in it.
String _report(String source, List<Map<String, Object?>> mutants) {
  return jsonEncode({
    'schemaVersion': '2',
    'files': {
      'lib/a.dart': {'language': 'dart', 'source': source, 'mutants': mutants},
    },
  });
}

Map<String, Object?> _mutant(
  String status, {
  required (int, int) start,
  required (int, int) end,
  String mutatorName = 'Equality',
  String replacement = '!=',
}) {
  return {
    'id': 'lib/a.dart#1',
    'mutatorName': mutatorName,
    'replacement': replacement,
    'location': {
      'start': {'line': start.$1, 'column': start.$2},
      'end': {'line': end.$1, 'column': end.$2},
    },
    'status': status,
  };
}

Survivor _survivor(
  int line, {
  int? lastLine,
  String original = '==',
  String mutator = 'X',
}) {
  return (
    line: line,
    column: 1,
    lastLine: lastLine ?? line,
    mutator: mutator,
    original: original,
    replacement: '!=',
  );
}

void main() {
  group('parseMutationBaseline', () {
    test('reads the counts of the files', () {
      expect(
        parseMutationBaseline('''
# A comment
baseline:
  packages/a/lib/a.dart: 2
  packages/a/lib/b.dart: 1
'''),
        {'packages/a/lib/a.dart': 2, 'packages/a/lib/b.dart': 1},
      );
    });

    test('reads an empty baseline', () {
      expect(parseMutationBaseline('baseline: {}'), isEmpty);
      expect(parseMutationBaseline('baseline:'), isEmpty);
    });

    group('edge cases', () {
      test('rejects unknown keys', () {
        expect(
          () => parseMutationBaseline('baseline: {}\nignored: []'),
          throwsFormatException,
        );
      });

      test('rejects counts that are not positive numbers', () {
        for (final count in ['0', '-1', 'two', '[]']) {
          expect(
            () => parseMutationBaseline('baseline:\n  a.dart: $count'),
            throwsFormatException,
            reason: count,
          );
        }
      });

      test('rejects a file that is not a map', () {
        expect(() => parseMutationBaseline('- a'), throwsFormatException);
        expect(
          () => parseMutationBaseline('baseline: [a]'),
          throwsFormatException,
        );
      });
    });
  });

  group('updateMutationBaseline', () {
    test('sets, adds and removes entries, sorted, under the comments', () {
      expect(
        updateMutationBaseline(
          '''
# A comment
#  baseline: in a comment
baseline:
  c.dart: 3
  a.dart: 2
  b.dart: 1
''',
          {'a.dart': 1, 'b.dart': 0, 'd.dart': 4},
        ),
        '''
# A comment
#  baseline: in a comment
baseline:
  a.dart: 1
  c.dart: 3
  d.dart: 4
''',
      );
    });

    test('writes an empty map when no entry is left', () {
      expect(
        updateMutationBaseline('# A comment\nbaseline:\n  a.dart: 2\n', {
          'a.dart': 0,
        }),
        '# A comment\nbaseline: {}\n',
      );
    });
  });

  group('parseMutationReport', () {
    test('keeps the survivors, with the text they replace', () {
      final report = _report('final a = 1 == 2;\nfinal b = 3 +\n  4;\n', [
        _mutant('Survived', start: (1, 13), end: (1, 15)),
        _mutant('Killed', start: (1, 13), end: (1, 15)),
        _mutant('Timeout', start: (1, 13), end: (1, 15)),
        _mutant('CompileError', start: (1, 13), end: (1, 15)),
        _mutant(
          'Survived',
          start: (2, 11),
          end: (3, 4),
          mutatorName: 'Arithmetic',
          replacement: '3 - 4',
        ),
      ]);

      expect(parseMutationReport(report, package: 'packages/a'), {
        'packages/a/lib/a.dart': [
          (
            line: 1,
            column: 13,
            lastLine: 1,
            mutator: 'Equality',
            original: '==',
            replacement: '!=',
          ),
          (
            line: 2,
            column: 11,
            lastLine: 3,
            mutator: 'Arithmetic',
            original: '3 +\n  4',
            replacement: '3 - 4',
          ),
        ],
      });
    });

    test('includes files without survivors', () {
      final report = _report('final a = 1;\n', [
        _mutant('Killed', start: (1, 11), end: (1, 12)),
      ]);

      expect(parseMutationReport(report, package: 'packages/a'), {
        'packages/a/lib/a.dart': isEmpty,
      });
    });

    group('edge cases', () {
      test('rejects a report without files', () {
        expect(
          () => parseMutationReport('{}', package: 'a'),
          throwsFormatException,
        );
        expect(
          () => parseMutationReport('[]', package: 'a'),
          throwsFormatException,
        );
      });

      test('rejects a file without source or mutants', () {
        expect(
          () => parseMutationReport(
            jsonEncode({
              'files': {
                'lib/a.dart': {'mutants': <Object?>[]},
              },
            }),
            package: 'a',
          ),
          throwsFormatException,
        );
      });

      test('rejects a survivor with a malformed location', () {
        final mutant = _mutant('Survived', start: (1, 1), end: (1, 2))
          ..['location'] = {
            'start': {'line': 1, 'column': 1},
            'end': {'line': 'one'},
          };

        expect(
          () => parseMutationReport(
            _report('final a = 1;\n', [mutant]),
            package: 'a',
          ),
          throwsFormatException,
        );
      });
    });
  });

  group('parseLcovLines', () {
    test('reads the lines, by path relative to the package', () {
      expect(
        parseLcovLines('''
SF:/repo/packages/a/lib/a.dart
DA:1,0
DA:2,3
end_of_record
SF:lib/b.dart
DA:5,1
end_of_record
''', packageRoot: '/repo/packages/a'),
        {
          'lib/a.dart': {1: false, 2: true},
          'lib/b.dart': {5: true},
        },
      );
    });

    test('hits a line hit by any listing of its file', () {
      expect(
        parseLcovLines('''
SF:lib/a.dart
DA:1,0
DA:2,1
end_of_record
SF:lib/a.dart
DA:1,2
DA:2,0
end_of_record
''', packageRoot: '/repo'),
        {
          'lib/a.dart': {1: true, 2: true},
        },
      );
    });
  });

  group('checkMutations', () {
    List<String> check({
      Map<String, int> baseline = const {},
      required Map<String, List<Survivor>> survivors,
      Set<int> neverRun = const {},
      Set<String> missing = const {},
      Map<String, Set<int>>? changed,
    }) {
      return checkMutations(
        baseline: baseline,
        survivors: survivors,
        neverRun: (_, line) => neverRun.contains(line),
        exists: (path) => !missing.contains(path),
        changed: changed,
      );
    }

    test('accepts as many survivors as the baseline lists', () {
      expect(
        check(
          baseline: {'a.dart': 2},
          survivors: {
            'a.dart': [_survivor(1), _survivor(2)],
            'b.dart': [],
          },
        ),
        isEmpty,
      );
    });

    test('lists the survivors of a file that has more, and why', () {
      expect(
        check(
          baseline: {'a.dart': 1},
          survivors: {
            'a.dart': [_survivor(1), _survivor(2, original: 'x', mutator: 'Y')],
            'b.dart': [_survivor(3)],
          },
          neverRun: {2},
        ),
        [
          'a.dart: 2 surviving mutants, but baselines/mutation.yaml allows 1:',
          '  a.dart:1:1 X: `==` → `!=` (its test does not check this)',
          '  a.dart:2:1 Y: `x` → `!=` (its test never runs this line)',
          'b.dart: 1 surviving mutants, but baselines/mutation.yaml allows 0:',
          '  b.dart:3:1 X: `==` → `!=` (its test does not check this)',
        ],
      );
    });

    test('asks to lower the entry of a file that has fewer', () {
      expect(
        check(
          baseline: {'a.dart': 3, 'b.dart': 1},
          survivors: {
            'a.dart': [_survivor(1)],
            'b.dart': [],
          },
        ),
        [
          'a.dart: 1 surviving mutants, fewer than the 3 of '
              'baselines/mutation.yaml: lower its entry to 1',
          'b.dart: 0 surviving mutants, fewer than the 1 of '
              'baselines/mutation.yaml: remove its entry',
        ],
      );
    });

    test('with changed lines, lists the survivors on them only', () {
      expect(
        check(
          baseline: {'a.dart': 5},
          survivors: {
            'a.dart': [
              _survivor(1),
              _survivor(2, lastLine: 4, original: 'x'),
              _survivor(5),
            ],
            'b.dart': [_survivor(1)],
          },
          changed: {
            'a.dart': {3, 5},
          },
        ),
        [
          'a.dart: 2 surviving mutants on the lines this change touches:',
          '  a.dart:2:1 X: `x` → `!=` (its test does not check this)',
          '  a.dart:5:1 X: `==` → `!=` (its test does not check this)',
        ],
      );
    });

    test('with changed lines, does not compare the baseline', () {
      expect(
        check(
          baseline: {'a.dart': 3},
          survivors: {'a.dart': []},
          changed: {
            'a.dart': {1},
          },
        ),
        isEmpty,
      );
    });

    group('edge cases', () {
      test('skips the baseline of files that were not mutated', () {
        expect(
          check(baseline: {'a.dart': 3}, survivors: {'b.dart': []}),
          isEmpty,
        );
      });

      test('prints a survivor on one line, shortened', () {
        final block = '{\n  ${'a(); ' * 20}\n}';
        expect(
          check(
            survivors: {
              'a.dart': [_survivor(1, original: block)],
            },
          )[1],
          '  a.dart:1:1 X: `{ ${'a(); ' * 11}...` → `!=` '
          '(its test does not check this)',
        );
      });

      test('reports baseline entries of files that do not exist', () {
        expect(
          check(baseline: {'a.dart': 3}, survivors: {}, missing: {'a.dart'}),
          ['a.dart: listed by baselines/mutation.yaml, but not found'],
        );
      });
    });
  });
}
