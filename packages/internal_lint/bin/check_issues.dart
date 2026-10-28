import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:internal_lint/src/ignore_check.dart';
import 'package:internal_lint/src/issue_links.dart';
import 'package:internal_lint/src/todo_check.dart';
import 'package:path/path.dart' as p;

/// Checks that every `// ignore` comment ([ignoreCheck]) and `TODO`
/// ([todoCheck]) links the GitHub issue that requires it (see
/// [checkIssueLinks]), and that those issues are still open.
///
/// The states of the issues are fetched in a single request to the GitHub
/// API, authenticated by `GITHUB_TOKEN`, `GH_TOKEN` or `gh auth token`.
/// Without a token, that part is skipped, except on CI where it fails.
///
/// Usage: `dart run internal_lint:check_issues [root]`, where `root` is the
/// repository root (default: the current directory).
Future<void> main(List<String> args) async {
  const checks = [ignoreCheck, todoCheck];
  final root = p.absolute(args.firstOrNull ?? '.');

  final policyFile = File(p.join(root, issuePolicyPath));
  if (!policyFile.existsSync()) {
    stderr.writeln('$issuePolicyPath is missing.');
    exit(2);
  }
  final IssuePolicy policy;
  try {
    policy = IssuePolicy.parse(policyFile.readAsStringSync(), checks: checks);
  } on FormatException catch (e) {
    stderr.writeln('$issuePolicyPath is malformed: ${e.message}');
    exit(2);
  }

  // Tracked files and untracked ones that are not ignored.
  final git = Process.runSync(
    'git',
    [
      'ls-files',
      '--cached',
      '--others',
      '--exclude-standard',
      // Unquoted paths, separated by NUL.
      '-z',
    ],
    workingDirectory: root,
    stdoutEncoding: utf8,
  );
  if (git.exitCode != 0) {
    stderr.writeln('git ls-files failed:\n${git.stderr}');
    exit(2);
  }
  final files = (git.stdout as String)
      .split('\x00')
      .where((path) => path.isNotEmpty)
      // Deleted files are still listed until the deletion is staged.
      .where((path) => File(p.join(root, path)).existsSync())
      .toList();

  final check = checkIssueLinks(
    policy: policy,
    checks: checks,
    files: files,
    read: (path) => File(p.join(root, path)).readAsStringSync(),
  );
  final problems = [...check.problems];

  if (check.links.isNotEmpty) {
    final token = _token();
    if (token == null) {
      if (Platform.environment['GITHUB_ACTIONS'] != null) {
        stderr.writeln(
          'GITHUB_TOKEN is not set, so the linked issues cannot be checked.',
        );
        exit(2);
      }
      stdout.writeln(
        'Skipped checking that the linked issues are open: set GITHUB_TOKEN, '
        'or sign in with `gh auth login`.',
      );
    } else {
      final response = await _graphql(
        token,
        issueStateQuery(check.links.keys.toList()),
      );
      problems.addAll(closedIssueProblems(check.links, response));
    }
  }

  if (problems.isEmpty) {
    stdout.writeln('Every `// ignore` and TODO links an open GitHub issue.');
    return;
  }

  stderr
    ..writeln(
      'Some `// ignore` and TODO comments do not link an open GitHub issue:',
    )
    ..writeAll(problems.map((problem) => '  $problem\n'))
    ..writeln(
      'Fix the code instead, or link the GitHub issue that requires the '
      'comment in it, such as: '
      '`// ignore: rule, https://github.com/owner/repo/issues/123` or '
      '`// TODO(https://github.com/owner/repo/issues/123): ...`, and '
      '`# TODO(https://github.com/owner/repo/issues/123): ...` in YAML.',
    );
  exit(1);
}

String? _token() {
  for (final name in ['GITHUB_TOKEN', 'GH_TOKEN']) {
    final token = Platform.environment[name];
    if (token != null && token.isNotEmpty) return token;
  }
  try {
    final gh = Process.runSync('gh', ['auth', 'token']);
    final token = (gh.stdout as String).trim();
    if (gh.exitCode == 0 && token.isNotEmpty) return token;
  } on ProcessException {
    // gh is not installed.
  }
  return null;
}

Future<Object?> _graphql(String token, String query) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 30);
  try {
    final request = await client.postUrl(
      Uri.parse('https://api.github.com/graphql'),
    );
    request.headers
      ..set(HttpHeaders.authorizationHeader, 'bearer $token')
      ..set(HttpHeaders.userAgentHeader, 'riverpod-check-issues')
      ..contentType = ContentType.json;
    request.write(jsonEncode({'query': query}));
    final (statusCode, body) = await () async {
      final response = await request.close();
      return (
        response.statusCode,
        await response.transform(utf8.decoder).join(),
      );
    }().timeout(const Duration(minutes: 1));
    Object? json;
    try {
      json = jsonDecode(body);
    } on FormatException {
      // Reported below, along with the body.
    }
    // Without data, every issue would be reported as missing. Missing issues
    // are NOT_FOUND errors; other errors, such as a rate limit, may leave
    // existing issues out of the data.
    final errors = json is Map ? json['errors'] : null;
    if (statusCode != 200 ||
        json is! Map ||
        json['data'] is! Map ||
        (errors is List &&
            errors.any((e) => e is! Map || e['type'] != 'NOT_FOUND'))) {
      stderr.writeln('The GitHub API failed ($statusCode):\n$body');
      exit(2);
    }
    return json;
  } on IOException catch (e) {
    stderr.writeln('Could not reach the GitHub API: $e');
    exit(2);
  } on TimeoutException {
    stderr.writeln('The GitHub API did not answer in time.');
    exit(2);
  } finally {
    client.close();
  }
}
