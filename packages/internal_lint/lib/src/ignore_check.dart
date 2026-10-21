import 'dart:convert';

import 'package:glob/glob.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// The path of the policy file, relative to the repository root.
@internal
const ignorePolicyPath = 'scripts/ignores.yaml';

final _ignoreComment = RegExp(r'//\s*ignore(_for_file)?\s*:');
// At most 9 digits, as GraphQL's `Int` has 32 bits. Longer numbers are not
// issues, so the comment counts as unlinked.
final _issueLink = RegExp(
  r'https://github\.com/([\w.-]+)/([\w.-]+)/issues/([1-9]\d{0,8})\b',
);

/// Which `// ignore` comments of the repository may lack a link to the GitHub
/// issue that justifies them.
///
/// Read from [ignorePolicyPath], and enforced by `bin/check_ignores.dart`.
@internal
final class IgnorePolicy {
  IgnorePolicy({required this.ignored, required this.baseline});

  /// Parses the content of [ignorePolicyPath].
  ///
  /// Throws a [FormatException] if it is malformed.
  factory IgnorePolicy.parse(String content) {
    final yaml = loadYaml(content, sourceUrl: Uri.parse(ignorePolicyPath));
    if (yaml is! YamlMap) {
      throw const FormatException('$ignorePolicyPath must be a map');
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
    if (baseline is! YamlMap ||
        baseline.entries.any(
          (e) => e.key is! String || e.value is! int || (e.value as int) < 1,
        )) {
      throw const FormatException(
        '`baseline` must map paths to positive numbers',
      );
    }

    return IgnorePolicy(
      ignored: [
        for (final pattern in ignored.cast<String>())
          Glob(pattern, context: p.posix),
      ],
      baseline: baseline.cast<String, int>(),
    );
  }

  /// The files that are not checked at all, such as the fixtures of lint
  /// tests.
  final List<Glob> ignored;

  /// How many `// ignore` comments without an issue link each file had when
  /// this policy was added.
  ///
  /// This may only shrink: a file with fewer such comments than listed is
  /// reported, so that its entry gets lowered.
  final Map<String, int> baseline;

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

/// What [checkIgnores] found.
@internal
final class IgnoreCheck {
  IgnoreCheck(this.problems, this.links);

  /// The problems found, one per line.
  final List<String> problems;

  /// The issues linked by `// ignore` comments, and where: `path:line`.
  final Map<IssueLink, List<String>> links;
}

/// Checks that every `// ignore` and `// ignore_for_file` comment of the Dart
/// files links the GitHub issue that justifies it, on the same line. A link
/// elsewhere may be about something else, such as the bug a test covers.
///
/// Generated files and the [IgnorePolicy.ignored] ones are skipped. The files
/// of [IgnorePolicy.baseline] may have exactly as many comments without a
/// link as it lists.
///
/// Whether the linked issues are still open is checked separately, from
/// [IgnoreCheck.links] (see [issueStateQuery]).
///
/// [files] are the paths of the repository's files, relative to its root, and
/// [read] reads one of them.
@internal
IgnoreCheck checkIgnores({
  required IgnorePolicy policy,
  required List<String> files,
  required String Function(String path) read,
}) {
  final problems = <String>[];
  final links = <IssueLink, List<String>>{};
  final fileSet = files.toSet();

  for (final entry in policy.baseline.keys) {
    if (!fileSet.contains(entry)) {
      problems.add('$entry: in the baseline, but no longer exists.');
    } else if (policy.isIgnored(entry)) {
      problems.add('$entry: in the baseline, but ignored.');
    }
  }

  for (final path in files) {
    if (p.posix.extension(path) != '.dart' || policy.isIgnored(path)) {
      continue;
    }
    final lines = read(path).split('\n');
    if (_isGenerated(path, lines)) continue;

    // The lines of the comments that link no issue.
    final unlinked = <int>[];
    for (var i = 0; i < lines.length; i++) {
      if (!_ignoreComment.hasMatch(lines[i])) continue;

      final found = [
        for (final match in _issueLink.allMatches(lines[i]))
          IssueLink(match[1]!, match[2]!, int.parse(match[3]!)),
      ];
      if (found.isEmpty) unlinked.add(i + 1);
      for (final link in found) {
        (links[link] ??= []).add('$path:${i + 1}');
      }
    }

    final allowed = policy.baseline[path] ?? 0;
    if (allowed == 0) {
      for (final line in unlinked) {
        problems.add('$path:$line: `// ignore` without a GitHub issue link.');
      }
    } else if (unlinked.length > allowed) {
      problems.add(
        '$path: ${unlinked.length} `// ignore` without a GitHub issue link '
        '(lines ${unlinked.join(', ')}), but the baseline of '
        '$ignorePolicyPath allows $allowed. Link an issue in the new ones.',
      );
    } else if (unlinked.length < allowed) {
      problems.add(
        unlinked.isEmpty
            ? '$path: every `// ignore` links an issue. '
                  'Remove it from the baseline of $ignorePolicyPath.'
            : '$path: ${unlinked.length} `// ignore` without a GitHub issue '
                  'link. Lower its baseline in $ignorePolicyPath to '
                  '${unlinked.length}.',
      );
    }
  }

  return IgnoreCheck(problems, links);
}

/// Generated Dart files: `*.g.dart`, `*.freezed.dart`, or a "GENERATED"
/// header. Matches `is_generated` of scripts/lib/common.sh.
bool _isGenerated(String path, List<String> lines) {
  if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) return true;
  return lines.take(5).any((line) => line.contains('GENERATED'));
}

/// A GraphQL query of the GitHub API that fetches the state of every issue
/// of [links], in a single request. Read the response with
/// [closedIssueProblems].
@internal
String issueStateQuery(List<IssueLink> links) {
  final buffer = StringBuffer('query {');
  final byRepo = _byRepo(links);
  var r = 0;
  for (final MapEntry(key: (owner, repo), value: numbers) in byRepo.entries) {
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
/// that are closed or do not exist, at each `path:line` that links them.
@internal
List<String> closedIssueProblems(
  Map<IssueLink, List<String>> links,
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
      final String? message;
      if (state == 'OPEN') {
        message = null;
      } else if (state == 'CLOSED') {
        message =
            'links $link, which is closed. Remove the `// ignore`, or '
            'link the issue that still requires it.';
      } else {
        message =
            'links $link, which does not exist. If the issue was '
            'moved, link its new URL.';
      }
      if (message == null) continue;
      for (final location in links[link]!) {
        problems.add('$location: $message');
      }
    }
    r++;
  }
  return problems;
}
