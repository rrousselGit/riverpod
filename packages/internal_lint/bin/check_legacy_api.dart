import 'dart:io';

import 'package:internal_lint/src/legacy_api.dart';
import 'package:internal_lint/src/legacy_api_check.dart';
import 'package:path/path.dart' as p;

/// Checks the uses of legacy APIs that the `avoid_legacy_api` lint cannot see.
/// See [checkLegacyApi].
///
/// Usage: `dart run internal_lint:check_legacy_api [root]`, where `root` is
/// the repository root (default: the current directory).
void main(List<String> args) {
  final root = p.absolute(args.firstOrNull ?? '.');

  final policyFile = File(p.join(root, legacyApiPolicyPath));
  if (!policyFile.existsSync()) {
    stderr.writeln('$legacyApiPolicyPath is missing.');
    exit(2);
  }
  final LegacyApiPolicy policy;
  try {
    policy = LegacyApiPolicy.parse(policyFile.readAsStringSync());
  } on FormatException catch (e) {
    stderr.writeln('$legacyApiPolicyPath is malformed: ${e.message}');
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

  final problems = checkLegacyApi(
    policy: policy,
    files: files,
    read: (path) => File(p.join(root, path)).readAsStringSync(),
  );

  if (problems.isEmpty) {
    stdout.writeln(
      'Legacy APIs are only used where $legacyApiPolicyPath allows it.',
    );
    return;
  }

  stderr
    ..writeln('Legacy APIs are used where $legacyApiPolicyPath forbids it:')
    ..writeAll(problems.map((problem) => '  $problem\n'))
    ..writeln(
      'Use Notifier/NotifierProvider instead. Dart files the analyzer checks '
      'are reported by the avoid_legacy_api lint (scripts/analyze.sh).',
    );
  exit(1);
}
