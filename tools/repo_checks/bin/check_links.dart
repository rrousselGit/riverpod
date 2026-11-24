import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:repo_checks/src/link_check.dart';

/// The Docusaurus website of the repository.
const _website = (root: 'website', host: 'riverpod.dev');

/// Where the repository is pushed.
const _repository = (slug: 'rrousselGit/riverpod', branch: 'master');

const _concurrency = 8;
const _timeout = Duration(seconds: 20);

/// The error code of a lookup that found no host of that name
/// (`EAI_NONAME`), unlike those that could not tell.
final _unknownHostCode = Platform.isWindows
    ? 11001
    : Platform.isMacOS
    ? 8
    : -2;

/// Checks that the links of the Markdown and MDX files, and of the comments
/// of the Dart files, are valid (see [checkLinks]), then that the links to
/// other websites exist, by requesting them (see [checkExternalLinks]).
///
/// Usage: `dart run repo_checks:check_links [--offline] [root]`, where `root`
/// is the repository root (default: the current directory), and `--offline`
/// skips the links to other websites.
Future<void> main(List<String> args) async {
  final offline = args.contains('--offline');
  final root = p.absolute(
    args.where((arg) => arg != '--offline').firstOrNull ?? '.',
  );

  final policyFile = File(p.join(root, linkPolicyPath));
  if (!policyFile.existsSync()) {
    stderr.writeln('$linkPolicyPath is missing.');
    exit(2);
  }
  final LinkPolicy policy;
  try {
    policy = LinkPolicy.parse(policyFile.readAsStringSync());
  } on FormatException catch (e) {
    stderr.writeln('$linkPolicyPath is malformed: ${e.message}');
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

  final check = checkLinks(
    policy: policy,
    website: _website,
    repository: _repository,
    files: files,
    read: (path) => File(p.join(root, path)).readAsStringSync(),
  );
  final problems = [...check.problems];

  if (offline) {
    stdout.writeln(
      'Skipped the ${check.external.length} links to other websites '
      '(--offline).',
    );
  } else {
    final external = checkExternalLinks(
      check.external,
      await _request(check.external.keys.toList()),
    );
    if (external.isOffline) {
      if (Platform.environment['GITHUB_ACTIONS'] != null) {
        stderr.writeln('No website could be reached.');
        exit(2);
      }
      stdout.writeln(
        'Skipped the links to other websites: none could be reached.',
      );
    }
    if (external.unverified.isNotEmpty) {
      stdout
        ..writeln(
          'Could not tell whether these links exist, so they are not '
          'reported as broken:',
        )
        ..writeAll(external.unverified.map((link) => '  $link\n'));
    }
    problems.addAll(external.problems);
  }

  if (problems.isEmpty) {
    stdout.writeln('Every link is valid.');
    return;
  }

  stderr
    ..writeln('Some links are broken:')
    ..writeAll((problems..sort()).map((problem) => '  $problem\n'))
    ..writeln(
      'Fix them. If a URL is only an example, write it as code (in '
      'backticks), or add what it starts with to `ignored_links` in '
      '$linkPolicyPath.',
    );
  exit(1);
}

/// Requests every one of [urls], a few at a time.
Future<Map<Uri, ({LinkState state, String detail})>> _request(
  List<Uri> urls,
) async {
  final client = HttpClient()
    ..connectionTimeout = _timeout
    // Some websites refuse the default one.
    ..userAgent = 'Mozilla/5.0 (compatible; link-checker)';
  final results = <Uri, ({LinkState state, String detail})>{};
  final queue = [...urls];
  try {
    await Future.wait([
      for (var i = 0; i < _concurrency; i++)
        () async {
          while (queue.isNotEmpty) {
            final url = queue.removeLast();
            var result = await _state(client, url);
            // Once more, in case the failure was temporary.
            if (result.state != LinkState.found &&
                result.state != LinkState.missing) {
              result = await _state(client, url);
            }
            results[url] = result;
          }
        }(),
    ]);
  } finally {
    client.close(force: true);
  }
  return results;
}

Future<({LinkState state, String detail})> _state(
  HttpClient client,
  Uri url,
) async {
  try {
    // Some servers do not support HEAD, or answer it differently.
    var statusCode = await _statusCode(client, 'HEAD', url);
    if (linkStateOf(statusCode) != LinkState.found) {
      statusCode = await _statusCode(client, 'GET', url);
    }
    return (
      state: linkStateOf(statusCode),
      detail: 'the server answered $statusCode',
    );
  } on SocketException catch (e) {
    if (e.osError?.errorCode == _unknownHostCode) {
      return (state: LinkState.unknownHost, detail: 'no such host');
    }
    // Among which the lookups that failed for another reason, such as a
    // resolver that did not answer.
    return (state: LinkState.unreachable, detail: 'could not connect');
  } on TimeoutException {
    return (state: LinkState.unreachable, detail: 'no answer in time');
  } on RedirectException {
    // Too many redirections, or a loop: often a login page.
    return (state: LinkState.unverified, detail: 'too many redirections');
  } on IOException catch (e) {
    return (state: LinkState.unreachable, detail: 'could not connect ($e)');
  }
}

Future<int> _statusCode(HttpClient client, String method, Uri url) async {
  // Connecting has its own timeout.
  final request = await client.openUrl(method, url);
  request.headers.set(HttpHeaders.acceptHeader, '*/*');
  final HttpClientResponse response;
  try {
    response = await request.close().timeout(_timeout);
  } on TimeoutException {
    // Otherwise, the request goes on, and holds its connection.
    request.abort();
    rethrow;
  }
  // The body is not needed.
  await response.listen((_) {}).cancel();
  return response.statusCode;
}
