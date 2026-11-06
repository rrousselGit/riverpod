import 'dart:convert';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:repo_checks/src/mutation_check.dart';
import 'package:repo_checks/src/mutation_scope.dart';
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
  String? statusReason,
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
    'statusReason': ?statusReason,
  };
}

ReportedMutant _reported(String key, MutantOutcome outcome, {int line = 1}) {
  return (key: key, outcome: outcome, line: line, column: 1);
}

const _survived = MutantOutcome.survived;
const _killed = MutantOutcome.killed;
const _notRun = MutantOutcome.notRun;

void main() {
  group('parseMutationBaseline', () {
    test('reads the mutants of the files', () {
      expect(
        parseMutationBaseline('''
# A comment
baseline:
  packages/a/lib/a.dart:
    - "f: X: `a` → `b`"
    - "f: X: `a` → `b`"
  packages/a/lib/b.dart:
    - "g: Y: `c` → `d`"
'''),
        {
          'packages/a/lib/a.dart': ['f: X: `a` → `b`', 'f: X: `a` → `b`'],
          'packages/a/lib/b.dart': ['g: Y: `c` → `d`'],
        },
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

      test('rejects entries that are not lists of mutants', () {
        for (final entry in ['2', '[]', '[1]', '{a: b}']) {
          expect(
            () => parseMutationBaseline('baseline:\n  a.dart: $entry'),
            throwsFormatException,
            reason: entry,
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
      final updated = updateMutationBaseline(
        '''
# A comment
#  baseline: in a comment
baseline:
  c.dart:
    - "c"
  a.dart:
    - "a"
  b.dart:
    - "b"
''',
        {
          'a.dart': ['z: `"`', 'y'],
          'b.dart': [],
          'd.dart': ['d', 'd'],
        },
      );

      expect(updated, r'''
# A comment
#  baseline: in a comment
baseline:
  a.dart:
    - "y"
    - "z: `\"`"
  c.dart:
    - "c"
  d.dart:
    - "d"
    - "d"
''');
      expect(parseMutationBaseline(updated)['a.dart'], ['y', 'z: `"`']);
    });

    test('writes an empty map when no entry is left', () {
      expect(
        updateMutationBaseline('# A comment\nbaseline:\n  a.dart:\n    - a\n', {
          'a.dart': [],
        }),
        '# A comment\nbaseline: {}\n',
      );
    });
  });

  group('mutantKey', () {
    test('names the declaration, the mutator and the change, on one line', () {
      expect(
        mutantKey(
          declaration: 'A.b',
          mutator: 'Equality',
          original: 'a ==\n    b',
          replacement: 'a != b',
        ),
        'A.b: Equality: `a == b` → `a != b`',
      );
    });

    test('shortens long code', () {
      expect(
        mutantKey(
          declaration: 'f',
          mutator: 'BlockStatement',
          original: '{ ${'a(); ' * 20}}',
          replacement: '{}',
        ),
        'f: BlockStatement: `{ ${'a(); ' * 11}...` → `{}`',
      );
    });
  });

  group('declarationAt', () {
    const source = '''
var top = 1;
int f() => 1;
class A {
  final int x = 2;
  A() : y = 3;
  A.named();
  int get g => 4;
  set g(int v) {
    void local() {}
  }
}
mixin M { void m() {} }
enum E { a(5); const E(int v); }
extension on int { int get e => 6; }
extension Named on int { void n() {} }
extension type T(int v) { int t() => 7; }
''';
    final unit = parseString(content: source).unit;
    String at(String code) => declarationAt(unit, source.indexOf(code));

    test('names the declarations around the offset, out of bodies', () {
      expect(at('1;'), 'top');
      expect(at('=> 1'), 'f');
      expect(at('2;'), 'A.x');
      expect(at('y = 3'), 'A.new');
      expect(at('named'), 'A.named');
      expect(at('4;'), 'A.g');
      expect(at('local'), 'A.g=');
      expect(at('void m'), 'M.m');
      expect(at('5)'), 'E.a');
      expect(at('6;'), 'extension.e');
      expect(at('void n'), 'Named.n');
      expect(at('7;'), 'T.t');
    });

    test('names the top level out of any declaration', () {
      expect(
        declarationAt(parseString(content: 'library a;').unit, 0),
        '(top level)',
      );
    });
  });

  group('parseMutationReport', () {
    test('keys the mutants, with what the run found of them', () {
      const source = 'bool f() => 1 == 2;\nint g() => 3 +\n  4;\n';
      final report = _report(source, [
        _mutant('Survived', start: (1, 15), end: (1, 17)),
        _mutant('Killed', start: (1, 15), end: (1, 17)),
        _mutant('Timeout', start: (1, 15), end: (1, 17)),
        _mutant('CompileError', start: (1, 15), end: (1, 17)),
        _mutant(
          'CompileError',
          start: (1, 15),
          end: (1, 17),
          statusReason: outOfScopeReason,
        ),
        _mutant('Pending', start: (1, 15), end: (1, 17)),
        _mutant(
          'Survived',
          start: (2, 12),
          end: (3, 4),
          mutatorName: 'Arithmetic',
          replacement: '3 - 4',
        ),
      ]);

      const key = 'f: Equality: `==` → `!=`';
      expect(parseMutationReport(report, package: 'packages/a'), {
        'packages/a/lib/a.dart': [
          (key: key, outcome: _survived, line: 1, column: 15),
          (key: key, outcome: _killed, line: 1, column: 15),
          (key: key, outcome: _killed, line: 1, column: 15),
          (key: key, outcome: _killed, line: 1, column: 15),
          (key: key, outcome: _notRun, line: 1, column: 15),
          (key: key, outcome: _notRun, line: 1, column: 15),
          (
            key: 'g: Arithmetic: `3 + 4` → `3 - 4`',
            outcome: _survived,
            line: 2,
            column: 12,
          ),
        ],
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

      test('rejects a malformed mutant', () {
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

      test('rejects a mutant outside of the source', () {
        expect(
          () => parseMutationReport(
            _report('final a = 1;\n', [
              _mutant('Survived', start: (9, 1), end: (9, 2)),
            ]),
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
      Map<String, List<String>> baseline = const {},
      required Map<String, List<ReportedMutant>> mutants,
      Set<int> neverRun = const {},
      Set<String> missing = const {},
    }) {
      return checkMutations(
        baseline: baseline,
        mutants: mutants,
        neverRun: (_, line) => neverRun.contains(line),
        exists: (path) => !missing.contains(path),
      );
    }

    test('accepts the survivors that the baseline lists', () {
      expect(
        check(
          baseline: {
            'a.dart': ['k', 'k'],
          },
          mutants: {
            'a.dart': [
              _reported('k', _survived),
              _reported('k', _survived),
              _reported('k', _killed),
              _reported('l', _killed),
            ],
            'b.dart': [_reported('k', _killed)],
          },
        ),
        isEmpty,
      );
    });

    test('lists the survivors that it does not, and why', () {
      expect(
        check(
          baseline: {
            'a.dart': ['k'],
          },
          mutants: {
            'a.dart': [
              _reported('k', _survived),
              _reported('k', _survived, line: 2),
              _reported('l', _survived, line: 3),
              _reported('m', _survived, line: 4),
            ],
          },
          neverRun: {3},
        ),
        [
          'a.dart: surviving mutants that baselines/mutation.yaml does not '
              'list:',
          '  a.dart:1:1 k (its test does not check this, 2 such survivors '
              'but 1 listed)',
          '  a.dart:2:1 k (its test does not check this, 2 such survivors '
              'but 1 listed)',
          '  a.dart:3:1 l (its test never runs this line)',
          '  a.dart:4:1 m (its test does not check this)',
        ],
      );
    });

    test('asks to remove the listed mutants that no longer survive', () {
      expect(
        check(
          baseline: {
            'a.dart': ['k', 'k', 'k', 'gone'],
          },
          mutants: {
            'a.dart': [_reported('k', _survived), _reported('k', _killed)],
          },
        ),
        [
          'a.dart: mutants that baselines/mutation.yaml lists, but that no '
              'longer survive: remove them',
          '  2× k',
          '  gone',
        ],
      );
    });

    test('accepts listed mutants that were not run', () {
      expect(
        check(
          baseline: {
            'a.dart': ['k', 'k'],
          },
          mutants: {
            'a.dart': [_reported('k', _survived), _reported('k', _notRun)],
          },
        ),
        isEmpty,
      );
      expect(
        check(
          baseline: {
            'a.dart': ['k', 'k'],
          },
          mutants: {
            'a.dart': [_reported('k', _notRun), _reported('k', _notRun)],
          },
        ),
        isEmpty,
      );
    });

    group('edge cases', () {
      test('skips the baseline of files that were not mutated', () {
        expect(
          check(
            baseline: {
              'a.dart': ['k'],
            },
            mutants: {'b.dart': []},
          ),
          isEmpty,
        );
      });

      test('reports baseline entries of files that do not exist', () {
        expect(
          check(
            baseline: {
              'a.dart': ['k'],
            },
            mutants: {},
            missing: {'a.dart'},
          ),
          ['a.dart: listed by baselines/mutation.yaml, but not found'],
        );
      });
    });
  });

  group('updatedMutationEntries', () {
    test('adds the survivors and keeps what was not run can make up', () {
      final updated = updatedMutationEntries(
        baseline: {
          'a.dart': ['kept', 'kept', 'kept', 'gone', 'k'],
          'b.dart': ['b'],
        },
        mutants: {
          'a.dart': [
            _reported('kept', _notRun),
            _reported('kept', _notRun),
            _reported('kept', _killed),
            _reported('gone', _killed),
            _reported('k', _survived),
            _reported('k', _survived),
            _reported('new', _survived),
          ],
          'c.dart': [_reported('c', _killed)],
        },
      );

      expect(updated, {
        'a.dart': unorderedEquals(['kept', 'kept', 'k', 'k', 'new']),
        'c.dart': isEmpty,
      });
    });
  });
}
