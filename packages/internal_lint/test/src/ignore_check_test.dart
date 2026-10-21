import 'package:internal_lint/src/ignore_check.dart';
import 'package:test/test.dart';

// Split, so that this file does not trip the check it tests.
const _ignore =
    '//'
    ' ignore: rule';
const _ignoreForFile =
    '//'
    ' ignore_for_file: rule';
const _open = 'https://github.com/owner/repo/issues/1';
const _closed = 'https://github.com/owner/repo/issues/2';
const _other = 'https://github.com/owner/other/issues/1';

void main() {
  final policy = IgnorePolicy.parse('''
ignored:
  - ignored/**
baseline:
  lib/baseline.dart: 2
''');

  IgnoreCheck check(Map<String, String> files) {
    return checkIgnores(
      policy: policy,
      files: files.keys.toList(),
      read: (path) => files[path]!,
    );
  }

  const baseline = {'lib/baseline.dart': '$_ignore\n$_ignore\n'};

  group('IgnorePolicy.parse', () {
    test('defaults to nothing ignored or baselined', () {
      final policy = IgnorePolicy.parse('{}');
      expect(policy.ignored, isEmpty);
      expect(policy.baseline, isEmpty);
    });

    test('rejects malformed policies', () {
      for (final content in [
        '[]',
        'unknown: 1',
        'ignored: a',
        'ignored: [1]',
        'baseline: [a]',
        'baseline: {a: b}',
        'baseline: {a: 0}',
      ]) {
        expect(
          () => IgnorePolicy.parse(content),
          throwsFormatException,
          reason: content,
        );
      }
    });
  });

  group('checkIgnores', () {
    test('passes when every ignore links an issue', () {
      final result = check({
        ...baseline,
        'lib/a.dart': 'a; $_ignore, $_open\n$_ignoreForFile $_other',
        'lib/b.dart': 'no ignores',
      });
      expect(result.problems, isEmpty);
      expect(result.links, {
        const IssueLink('owner', 'repo', 1): ['lib/a.dart:1'],
        const IssueLink('owner', 'other', 1): ['lib/a.dart:2'],
      });
    });

    test('reports ignores without a link on their line', () {
      expect(
        check({
          ...baseline,
          // A link above is about something else.
          'lib/a.dart': '// See $_open\n$_ignore\n$_ignoreForFile\n',
        }).problems,
        [
          'lib/a.dart:2: `// ignore` without a GitHub issue link.',
          'lib/a.dart:3: `// ignore` without a GitHub issue link.',
        ],
      );
    });

    test('skips ignored, generated and non-Dart files', () {
      expect(
        check({
          ...baseline,
          'ignored/a.dart': _ignore,
          'lib/a.g.dart': _ignore,
          'lib/a.freezed.dart': _ignore,
          'lib/b.dart': '// GENERATED CODE\n$_ignore',
          'a.md': _ignore,
        }).problems,
        isEmpty,
      );
    });

    test('reports baselined files with more unlinked ignores', () {
      expect(
        check({'lib/baseline.dart': '$_ignore\n$_ignore\n$_ignore'}).problems,
        [
          'lib/baseline.dart: 3 `// ignore` without a GitHub issue link '
              '(lines 1, 2, 3), but the baseline of scripts/ignores.yaml '
              'allows 2. Link an issue in the new ones.',
        ],
      );
    });

    test('reports baselined files with fewer unlinked ignores', () {
      expect(check({'lib/baseline.dart': _ignore}).problems, [
        'lib/baseline.dart: 1 `// ignore` without a GitHub issue link. '
            'Lower its baseline in scripts/ignores.yaml to 1.',
      ]);
      expect(check({'lib/baseline.dart': ''}).problems, [
        'lib/baseline.dart: every `// ignore` links an issue. '
            'Remove it from the baseline of scripts/ignores.yaml.',
      ]);
    });

    test('reports stale baseline entries', () {
      expect(check({}).problems, [
        'lib/baseline.dart: in the baseline, but no longer exists.',
      ]);
      expect(
        checkIgnores(
          policy: IgnorePolicy.parse('''
ignored: [ignored/**]
baseline: {ignored/a.dart: 1}
'''),
          files: ['ignored/a.dart'],
          read: (_) => _ignore,
        ).problems,
        ['ignored/a.dart: in the baseline, but ignored.'],
      );
    });
  });

  group('issue states', () {
    final links = {
      const IssueLink('owner', 'repo', 1): ['a.dart:1'],
      const IssueLink('owner', 'repo', 2): ['a.dart:2', 'b.dart:3'],
      const IssueLink('owner', 'other', 1): ['c.dart:4'],
    };

    test('are fetched in one query, grouped by repository', () {
      expect(
        issueStateQuery(links.keys.toList()),
        'query {'
        ' r0: repository(owner: "owner", name: "repo") {'
        ' i1: issue(number: 1) { state }'
        ' i2: issue(number: 2) { state } }'
        ' r1: repository(owner: "owner", name: "other") {'
        ' i1: issue(number: 1) { state } } }',
      );
    });

    test('report closed and missing issues', () {
      expect(
        closedIssueProblems(links, {
          'data': {
            'r0': {
              'i1': {'state': 'OPEN'},
              'i2': {'state': 'CLOSED'},
            },
            'r1': null,
          },
        }),
        [
          'a.dart:2: links $_closed, which is closed. Remove the '
              '`// ignore`, or link the issue that still requires it.',
          'b.dart:3: links $_closed, which is closed. Remove the '
              '`// ignore`, or link the issue that still requires it.',
          'c.dart:4: links $_other, which does not exist. If the issue was '
              'moved, link its new URL.',
        ],
      );
    });

    test('report every issue when the response has no data', () {
      expect(closedIssueProblems(links, null), hasLength(4));
    });
  });
}
