import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:internal_lint/src/ignore_check.dart';
import 'package:path/path.dart' as p;

/// Checks that every `// ignore` comment links the GitHub issue that justifies
/// it (see [checkIgnores]), and that those issues are still open.
///
/// The states of the issues are fetched in a single request to the GitHub
/// API, authenticated by `GITHUB_TOKEN`, `GH_TOKEN` or `gh auth token`.
/// Without a token, that part is skipped, except on CI where it fails.
///
/// Usage: `dart run internal_lint:check_ignores [root]`, where `root` is the
/// repository root (default: the current directory).
Future<void> main(List<String> args) async {
  final root = p.absolute(args.firstOrNull ?? '.');

  final policyFile = File(p.join(root, ignorePolicyPath));
  if (!policyFile.existsSync()) {
    stderr.writeln('$ignorePolicyPath is missing.');
    exit(2);
  }
  final IgnorePolicy policy;
  try {
    policy = IgnorePolicy.parse(policyFile.readAsStringSync());
  } on FormatException catch (e) {
    stderr.writeln('$ignorePolicyPath is malformed: ${e.message}');
    exit(2);
  }

  // Tracked files and untracked ones that are not ignored.
  final git = Process.runSync('git', [
    'ls-files',
    '--cached',
    '--others',
    '--exclude-standard',
  ], workingDirectory: root);
  if (git.exitCode != 0) {
    stderr.writeln('git ls-files failed:\n${git.stderr}');
    exit(2);
  }
  final files = (git.stdout as String)
      .split('\n')
      .where((path) => path.isNotEmpty)
      // Deleted files are still listed until the deletion is staged.
      .where((path) => File(p.join(root, path)).existsSync())
      .toList();

  final check = checkIgnores(
    policy: policy,
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
    stdout.writeln('Every `// ignore` links an open GitHub issue.');
    return;
  }

  stderr
    ..writeln('Some `// ignore` comments are not justified by an open issue:')
    ..writeAll(problems.map((problem) => '  $problem\n'))
    ..writeln(
      'Fix the code instead, or link the GitHub issue that requires the '
      'ignore on its line, such as: '
      // Split, so that this file does not trip the check it runs.
      '`//'
      ' ignore: rule, https://github.com/owner/repo/issues/123`.',
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
      ..set(HttpHeaders.userAgentHeader, 'riverpod-check-ignores')
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
    // Without data, every issue would be reported as missing.
    if (statusCode != 200 || json is! Map || json['data'] is! Map) {
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
