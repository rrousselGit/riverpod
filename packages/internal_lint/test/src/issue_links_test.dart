import 'package:analyzer/dart/ast/ast.dart';
import 'package:internal_lint/src/issue_links.dart';
import 'package:test/test.dart';

const _open = 'https://github.com/owner/repo/issues/1';
const _closed = 'https://github.com/owner/repo/issues/2';
const _other = 'https://github.com/owner/other/issues/1';

/// Applies to the comments that contain "FLAG".
const _check = LinkedCommentCheck(
  name: 'flags',
  label: 'FLAG',
  whenClosed: 'Remove the flag',
  keyword: 'FLAG',
  find: _flags,
);

Iterable<({int offset, String text})> _flags(CompilationUnit unit) sync* {
  for (final comment in commentsOf(unit)) {
    if (comment.lexeme.contains('FLAG')) {
      yield (offset: comment.offset, text: comment.lexeme);
    }
  }
}

void main() {
  final policy = IssuePolicy.parse(
    '''
ignored:
  - ignored/**
baseline:
  flags:
    lib/baseline.dart: 2
''',
    checks: [_check],
  );

  IssueCheck check(Map<String, String> files, {IssuePolicy? policy_}) {
    return checkIssueLinks(
      policy: policy_ ?? policy,
      checks: [_check],
      files: files.keys.toList(),
      read: (path) => files[path]!,
    );
  }

  const baseline = {'lib/baseline.dart': '// FLAG\n// FLAG\n'};

  group('IssuePolicy.parse', () {
    test('defaults to nothing ignored or baselined', () {
      final policy = IssuePolicy.parse('{}', checks: [_check]);
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
        'baseline: {unknown: {}}',
        'baseline: {flags: [a]}',
        'baseline: {flags: {a: b}}',
        'baseline: {flags: {a: 0}}',
      ]) {
        expect(
          () => IssuePolicy.parse(content, checks: [_check]),
          throwsFormatException,
          reason: content,
        );
      }
    });
  });

  group('checkIssueLinks', () {
    test('passes when every comment links an issue in its text', () {
      final result = check({
        ...baseline,
        'lib/a.dart': 'a; // FLAG, $_open\n/* FLAG\n $_other */',
        'lib/b.dart': 'no flags',
      });
      expect(result.problems, isEmpty);
      expect(
        result.links.map(
          (link, locations) => MapEntry(link, [
            for (final (:location, :check) in locations)
              '$location ${check.name}',
          ]),
        ),
        {
          const IssueLink('owner', 'repo', 1): ['lib/a.dart:1 flags'],
          const IssueLink('owner', 'other', 1): ['lib/a.dart:2 flags'],
        },
      );
    });

    test('reports comments without a link in their text', () {
      expect(
        check({
          ...baseline,
          // A link in another comment is about something else.
          'lib/a.dart': '// See $_open\n// FLAG\nfinal a = "FLAG";',
        }).problems,
        ['lib/a.dart:2: FLAG without a GitHub issue link.'],
      );
    });

    test('only accepts issue numbers that GraphQL can query', () {
      const max = 'https://github.com/owner/repo/issues/2147483647';
      const tooLarge = 'https://github.com/owner/repo/issues/2147483648';
      const tooLong = 'https://github.com/owner/repo/issues/12345678901';
      final result = check({
        ...baseline,
        'lib/a.dart': '// FLAG $max\n// FLAG $tooLarge\n// FLAG $tooLong',
      });
      expect(result.problems, [
        'lib/a.dart:2: FLAG without a GitHub issue link.',
        'lib/a.dart:3: FLAG without a GitHub issue link.',
      ]);
      expect(result.links.keys, [const IssueLink('owner', 'repo', 2147483647)]);
    });

    test('skips ignored, generated and non-Dart files', () {
      expect(
        check({
          ...baseline,
          'ignored/a.dart': '// FLAG',
          'lib/a.g.dart': '// FLAG',
          'lib/a.freezed.dart': '// FLAG',
          'lib/b.dart': '// GENERATED CODE\n// FLAG',
          'a.md': '// FLAG',
        }).problems,
        isEmpty,
      );
    });

    test('reports baselined files with more unlinked comments', () {
      expect(
        check({'lib/baseline.dart': '// FLAG\n// FLAG\n// FLAG'}).problems,
        [
          'lib/baseline.dart: 3 FLAG without a GitHub issue link '
              '(lines 1, 2, 3), but the `flags` baseline of '
              'baselines/issues.yaml allows 2. Link an issue in the new ones.',
        ],
      );
    });

    test('reports baselined files with fewer unlinked comments', () {
      expect(check({'lib/baseline.dart': '// FLAG'}).problems, [
        'lib/baseline.dart: 1 FLAG without a GitHub issue link. '
            'Lower its count in the `flags` baseline of baselines/issues.yaml '
            'to 1.',
      ]);
      expect(check({'lib/baseline.dart': ''}).problems, [
        'lib/baseline.dart: every FLAG links an issue. '
            'Remove it from the `flags` baseline of baselines/issues.yaml.',
      ]);
    });

    test('reports stale baseline entries', () {
      expect(check({}).problems, [
        'lib/baseline.dart: in the `flags` baseline, but no longer exists.',
      ]);
      expect(
        check(
          {'ignored/a.dart': '// FLAG'},
          policy_: IssuePolicy.parse(
            '''
ignored: [ignored/**]
baseline: {flags: {ignored/a.dart: 1}}
''',
            checks: [_check],
          ),
        ).problems,
        ['ignored/a.dart: in the `flags` baseline, but ignored.'],
      );
    });
  });

  group('issue states', () {
    final links = <IssueLink, List<LinkLocation>>{
      const IssueLink('owner', 'repo', 1): [
        (location: 'a.dart:1', check: _check),
      ],
      const IssueLink('owner', 'repo', 2): [
        (location: 'a.dart:2', check: _check),
        (location: 'b.dart:3', check: _check),
      ],
      const IssueLink('owner', 'other', 1): [
        (location: 'c.dart:4', check: _check),
      ],
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
          'a.dart:2: FLAG links $_closed, which is closed. Remove the flag, '
              'or link the issue that still requires it.',
          'b.dart:3: FLAG links $_closed, which is closed. Remove the flag, '
              'or link the issue that still requires it.',
          'c.dart:4: FLAG links $_other, which does not exist. If the issue '
              'was moved, link its new URL.',
        ],
      );
    });

    test('report every issue when the response has no data', () {
      expect(closedIssueProblems(links, null), hasLength(4));
    });
  });
}
