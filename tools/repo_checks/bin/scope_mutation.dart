import 'dart:io';

import 'package:repo_checks/src/mutation_scope.dart';

/// Limits a dart_mutant run to the mutants on the lines a change touches,
/// for scripts/mutation.sh.
///
/// Usage:
///
/// ```sh
/// dart run repo_checks:scope_mutation files <diff>
/// dart run repo_checks:scope_mutation mark <diff> <incremental>
/// ```
///
/// where `diff` is the output of `git diff -U0` in the mutated package.
///
/// `files` prints the files that the diff adds or changes lines of (see
/// [parseChangedLines]), one per line.
///
/// `mark` rewrites `incremental`, the state that a run of dart_mutant with
/// `--force` left in `.dart_tool/dart_mutant/incremental.json`, so that the
/// next run only runs the mutants on those lines (see [scopeMutants]), and
/// prints how many mutants of each file that is.
void main(List<String> args) {
  switch (args) {
    case ['files', final diff]:
      final changed = parseChangedLines(File(diff).readAsStringSync());
      stdout.writeAll(changed.keys.map((path) => '$path\n'));
    case ['mark', final diff, final state]:
      final changed = parseChangedLines(File(diff).readAsStringSync());
      final file = File(state);
      final (:incremental, :counts) = scopeMutants(
        file.readAsStringSync(),
        changed,
      );
      file.writeAsStringSync(incremental);
      for (final MapEntry(key: path, value: (:left, :all)) in counts.entries) {
        stdout.writeln(
          '  $path: $left of $all mutant(s) on the lines this change touches',
        );
      }
    default:
      stderr.writeln(
        'Usage: scope_mutation files <diff>\n'
        '       scope_mutation mark <diff> <incremental>',
      );
      exit(2);
  }
}
