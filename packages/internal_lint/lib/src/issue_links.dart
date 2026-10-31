import 'dart:convert';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:glob/glob.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// The path of the policy file, relative to the repository root.
@internal
const issuePolicyPath = 'baselines/issues.yaml';

final _issueLink = RegExp(
  r'https://github\.com/([\w.-]+)/([\w.-]+)/issues/([1-9]\d{0,9})\b',
);

// GraphQL's `Int` has 32 bits. Larger numbers are not issues, so their
// comment counts as unlinked.
const _maxIssueNumber = 2147483647;

/// A kind of comment that must link the GitHub issue that requires it, such
/// as `// ignore` comments.
@internal
final class LinkedCommentCheck {
  const LinkedCommentCheck({
    required this.name,
    required this.label,
    required this.whenClosed,
    required this.keyword,
    required this.find,
    this.findInYaml,
  });

  /// The key of this check in the `baseline` of [issuePolicyPath].
  final String name;

  /// How problems name these comments, such as "`// ignore`".
  final String label;

  /// What to do once the linked issue is closed, such as "Remove the ignore".
  final String whenClosed;

  /// A text without which a file has none of these comments, so that it need
  /// not be parsed.
  final String keyword;

  /// The comments of a parsed file that this check applies to, with their
  /// offset in the file. Their text is where the issue link must be.
  final Iterable<({int offset, String text})> Function(CompilationUnit unit)
  find;

  /// Like [find], for the content of a YAML file, or null if YAML files have
  /// none of these comments.
  final Iterable<({int offset, String text})> Function(String content)?
  findInYaml;
}

/// Which files [LinkedCommentCheck]s skip, or allow comments without a link
/// in.
///
/// Read from [issuePolicyPath], and enforced by `bin/check_issues.dart`.
@internal
final class IssuePolicy {
  IssuePolicy({required this.ignored, required this.baseline});

  /// Parses the content of [issuePolicyPath], whose baseline may only list
  /// the [LinkedCommentCheck.name] of [checks].
  ///
  /// Throws a [FormatException] if it is malformed.
  factory IssuePolicy.parse(
    String content, {
    required List<LinkedCommentCheck> checks,
  }) {
    final yaml = loadYaml(content, sourceUrl: Uri.parse(issuePolicyPath));
    if (yaml is! YamlMap) {
      throw const FormatException('$issuePolicyPath must be a map');
    }

    final unknownKeys = yaml.keys.toSet().difference({'ignored', 'baseline'});
    if (unknownKeys.isNotEmpty) {
      throw FormatException('Unknown keys: ${unknownKeys.join(', ')}');
    }

    final ignored = yaml['ignored'] ?? YamlList();
    if (ignored is! YamlList || ignored.any((e) => e is! String)) {
      throw const FormatException('`ignored` must be a list of strings');
    }

    final baseline = yaml['baseline'] ?? YamlMap();
    if (baseline is! YamlMap) {
      throw const FormatException('`baseline` must be a map');
    }
    final names = {for (final check in checks) check.name};
    final unknownChecks = baseline.keys.toSet().difference(names);
    if (unknownChecks.isNotEmpty) {
      throw FormatException(
        'Unknown checks in `baseline`: ${unknownChecks.join(', ')}',
      );
    }
    for (final MapEntry(key: name, value: counts) in baseline.entries) {
      if (counts is! YamlMap ||
          counts.entries.any(
            (e) => e.key is! String || e.value is! int || (e.value as int) < 1,
          )) {
        throw FormatException(
          '`baseline.$name` must map paths to positive numbers',
        );
      }
    }

    return IssuePolicy(
      ignored: [
        for (final pattern in ignored.cast<String>())
          Glob(pattern, context: p.posix),
      ],
      baseline: {
        for (final MapEntry(:key, :value) in baseline.entries)
          key as String: (value as YamlMap).cast<String, int>(),
      },
    );
  }

  /// The files that are not checked at all, such as the fixtures of lint
  /// tests.
  final List<Glob> ignored;

  /// For each [LinkedCommentCheck.name], how many comments without an issue
  /// link each file had when the check was added.
  ///
  /// This may only shrink: a file with fewer such comments than listed is
  /// reported, so that its entry gets lowered.
  final Map<String, Map<String, int>> baseline;

  /// Whether [path], relative to the repository root, is in [ignored].
  bool isIgnored(String path) => ignored.any((glob) => glob.matches(path));
}

/// A link to a GitHub issue, `https://github.com/owner/repo/issues/number`.
@internal
@immutable
final class IssueLink {
  const IssueLink(this.owner, this.repo, this.number);

  final String owner;
  final String repo;
  final int number;

  @override
  bool operator ==(Object other) =>
      other is IssueLink &&
      other.owner == owner &&
      other.repo == repo &&
      other.number == number;

  @override
  int get hashCode => Object.hash(owner, repo, number);

  @override
  String toString() => 'https://github.com/$owner/$repo/issues/$number';
}

/// Where a comment links an issue: `path:line`, and the check of the comment.
@internal
typedef LinkLocation = ({String location, LinkedCommentCheck check});

/// What [checkIssueLinks] found.
@internal
final class IssueCheck {
  IssueCheck(this.problems, this.links);

  /// The problems found, one per line.
  final List<String> problems;

  /// The issues linked by the comments, and where.
  final Map<IssueLink, List<LinkLocation>> links;
}

/// Checks that every comment that one of [checks] applies to, in the Dart
/// and YAML files, links the GitHub issue that requires it, in its text. A link
/// elsewhere may be about something else, such as the bug a test covers.
///
/// Generated files and the [IssuePolicy.ignored] ones are skipped. The files
/// of [IssuePolicy.baseline] may have exactly as many comments without a link
/// as it lists for each check.
///
/// Whether the linked issues are still open is checked separately, from
/// [IssueCheck.links] (see [issueStateQuery]).
///
/// [files] are the paths of the repository's files, relative to its root, and
/// [read] reads one of them.
@internal
IssueCheck checkIssueLinks({
  required IssuePolicy policy,
  required List<LinkedCommentCheck> checks,
  required List<String> files,
  required String Function(String path) read,
}) {
  final problems = <String>[];
  final links = <IssueLink, List<LinkLocation>>{};
  final fileSet = files.toSet();

  for (final MapEntry(key: name, value: counts) in policy.baseline.entries) {
    for (final entry in counts.keys) {
      if (!fileSet.contains(entry)) {
        problems.add('$entry: in the `$name` baseline, but no longer exists.');
      } else if (policy.isIgnored(entry)) {
        problems.add('$entry: in the `$name` baseline, but ignored.');
      }
    }
  }

  for (final path in files) {
    final extension = p.posix.extension(path);
    final isDart = extension == '.dart';
    if (!(isDart || extension == '.yaml' || extension == '.yml') ||
        policy.isIgnored(path)) {
      continue;
    }
    final content = read(path);
    if (_isGenerated(path, content)) continue;

    CompilationUnit? unit;
    LineInfo? lineInfo;
    for (final check in checks) {
      // The lines of the comments that link no issue.
      final unlinked = <int>[];
      // Most files have none of these comments, and need not be parsed.
      if (content.contains(check.keyword)) {
        final Iterable<({int offset, String text})> comments;
        if (isDart) {
          unit ??= parseString(
            content: content,
            throwIfDiagnostics: false,
          ).unit;
          lineInfo = unit.lineInfo;
          comments = check.find(unit);
        } else {
          lineInfo ??= LineInfo.fromContent(content);
          comments = check.findInYaml?.call(content) ?? const [];
        }
        for (final (:offset, :text) in comments) {
          final line = lineInfo.getLocation(offset).lineNumber;
          final found = _linksIn(text);
          if (found.isEmpty) unlinked.add(line);
          for (final link in found) {
            (links[link] ??= []).add((location: '$path:$line', check: check));
          }
        }
      }
      problems.addAll(_baselineProblems(policy, check, path, unlinked..sort()));
    }
  }

  return IssueCheck(problems, links);
}

/// Compares the [unlinked] comments of [path] for [check] to its baseline.
Iterable<String> _baselineProblems(
  IssuePolicy policy,
  LinkedCommentCheck check,
  String path,
  List<int> unlinked,
) sync* {
  final label = check.label;
  final baseline = '`${check.name}` baseline of $issuePolicyPath';
  final allowed = policy.baseline[check.name]?[path] ?? 0;
  if (allowed == 0) {
    for (final line in unlinked) {
      yield '$path:$line: $label without a GitHub issue link.';
    }
  } else if (unlinked.length > allowed) {
    yield '$path: ${unlinked.length} $label without a GitHub issue link '
        '(lines ${unlinked.join(', ')}), but the $baseline allows $allowed. '
        'Link an issue in the new ones.';
  } else if (unlinked.length < allowed) {
    yield unlinked.isEmpty
        ? '$path: every $label links an issue. '
              'Remove it from the $baseline.'
        : '$path: ${unlinked.length} $label without a GitHub issue link. '
              'Lower its count in the $baseline to ${unlinked.length}.';
  }
}

List<IssueLink> _linksIn(String text) => [
  for (final match in _issueLink.allMatches(text))
    if (int.parse(match[3]!) case final number when number <= _maxIssueNumber)
      IssueLink(match[1]!, match[2]!, number),
];

/// Generated files: `*.g.dart`, `*.freezed.dart`, or a "GENERATED" header. Matches `is_generated` of scripts/lib/common.sh.
bool _isGenerated(String path, String content) {
  if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) return true;
  return content.split('\n').take(5).any((line) => line.contains('GENERATED'));
}

/// The comments of [unit], read from its tokens so that the same text in a
/// string is not mistaken for one.
@internal
Iterable<Token> commentsOf(CompilationUnit unit) sync* {
  for (Token? token = unit.beginToken; token != null; token = token.next) {
    for (
      Token? comment = token.precedingComments;
      comment != null;
      comment = comment.next
    ) {
      yield comment;
    }
    // The end of file is its own next token.
    if (token.isEof) break;
  }
}

/// A GraphQL query of the GitHub API that fetches the state of every issue
/// of [links], in a single request. Read the response with
/// [closedIssueProblems].
@internal
String issueStateQuery(List<IssueLink> links) {
  final buffer = StringBuffer('query {');
  var r = 0;
  for (final MapEntry(key: (owner, repo), value: numbers) in _byRepo(
    links,
  ).entries) {
    buffer.write(
      ' r$r: repository(owner: ${jsonEncode(owner)}, '
      'name: ${jsonEncode(repo)}) {',
    );
    for (final number in numbers) {
      buffer.write(' i$number: issue(number: $number) { state }');
    }
    buffer.write(' }');
    r++;
  }
  buffer.write(' }');
  return buffer.toString();
}

Map<(String, String), Set<int>> _byRepo(List<IssueLink> links) {
  final byRepo = <(String, String), Set<int>>{};
  for (final link in links) {
    (byRepo[(link.owner, link.repo)] ??= {}).add(link.number);
  }
  return byRepo;
}

/// Reads the response to [issueStateQuery], and reports the issues of [links]
/// that are closed or do not exist, at each comment that links them.
@internal
List<String> closedIssueProblems(
  Map<IssueLink, List<LinkLocation>> links,
  Object? response,
) {
  final data = response is Map ? response['data'] : null;
  final problems = <String>[];
  var r = 0;
  for (final MapEntry(key: (owner, repo), value: numbers) in _byRepo(
    links.keys.toList(),
  ).entries) {
    final repository = data is Map ? data['r$r'] : null;
    for (final number in numbers) {
      final link = IssueLink(owner, repo, number);
      final issue = repository is Map ? repository['i$number'] : null;
      final state = issue is Map ? issue['state'] : null;
      if (state == 'OPEN') continue;
      for (final (:location, :check) in links[link]!) {
        problems.add(
          state == 'CLOSED'
              ? '$location: ${check.label} links $link, which is closed. '
                    '${check.whenClosed}, or link the issue that still '
                    'requires it.'
              : '$location: ${check.label} links $link, which does not '
                    'exist. If the issue was moved, link its new URL.',
        );
      }
    }
    r++;
  }
  return problems;
}
