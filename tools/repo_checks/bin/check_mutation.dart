import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:repo_checks/src/mutation_check.dart';

/// Checks a dart_mutant report, which may be of only some mutants of each
/// file: each mutant that survived must be listed by [mutationBaselinePath],
/// and each one it lists must still survive (see [checkMutations]).
///
/// Usage:
///
/// ```sh
/// dart run repo_checks:check_mutation \
///   root package report coverage [--update-baseline] file...
/// ```
///
/// where `root` is the repository root, `package` the path of the mutated
/// package relative to it, `report` the dart_mutant report, `coverage` the
/// folder holding, for each file, the lcov report of its test alone at
/// `coverage/file.info`, and `file` the mutated files, relative to
/// `package`.
///
/// With `--update-baseline`, the entries of the files are set to what the
/// report found instead (see [updatedMutationEntries]).
Future<void> main(List<String> args) async {
  final arguments = [...args];
  final update = arguments.remove('--update-baseline');
  if (arguments.length < 5) {
    stderr.writeln(
      'Usage: check_mutation <root> <package> <report> <coverage> '
      '[--update-baseline] <file>...',
    );
    exit(2);
  }
  final [root, package, reportPath, coverage, ...files] = arguments;
  final packageRoot = p.join(root, package);

  final baselineFile = File(p.join(root, mutationBaselinePath));
  final reportFile = File(reportPath);
  if (!reportFile.existsSync()) {
    stderr.writeln('dart_mutant wrote no report at $reportPath.');
    exit(1);
  }
  ResultT parse<ResultT>(String path, ResultT Function() parse) {
    try {
      return parse();
    } on FormatException catch (e) {
      stderr.writeln('$path is malformed: ${e.message}');
      exit(2);
    }
  }

  final baseline = parse(
    mutationBaselinePath,
    () => parseMutationBaseline(baselineFile.readAsStringSync()),
  );
  final mutants = parse(
    reportPath,
    () => parseMutationReport(reportFile.readAsStringSync(), package: package),
  );

  final missing = [
    for (final file in files)
      if (!mutants.containsKey(p.posix.join(package, file))) file,
  ];
  if (missing.isNotEmpty) {
    stderr
      ..writeln('dart_mutant did not report on these files of $package:')
      ..writeAll(missing.map((file) => '  $file\n'));
    exit(1);
  }

  if (update) {
    baselineFile.writeAsStringSync(
      updateMutationBaseline(
        baselineFile.readAsStringSync(),
        updatedMutationEntries(baseline: baseline, mutants: mutants),
      ),
    );
    stdout.writeln('Updated $mutationBaselinePath.');
    return;
  }

  final lines = <String, Map<int, bool>?>{};
  bool neverRun(String path, int line) {
    final file = p.posix.relative(path, from: package);
    final listed = lines.putIfAbsent(file, () {
      final lcov = File(p.join(coverage, '$file.info'));
      if (!lcov.existsSync()) return null;
      return parseLcovLines(
        lcov.readAsStringSync(),
        packageRoot: packageRoot,
      )[file];
    });
    // Without coverage of the file, its test does not load it.
    if (listed == null) return true;
    return listed[line] == false;
  }

  final problems = checkMutations(
    baseline: baseline,
    mutants: mutants,
    neverRun: neverRun,
    exists: (path) => File(p.join(root, path)).existsSync(),
  );
  if (problems.isEmpty) {
    stdout.writeln(
      'The mutants that survived are those that $mutationBaselinePath lists.',
    );
    return;
  }

  stderr
    ..writeln('Mutation testing found problems:')
    ..writeAll(problems.map((problem) => '  $problem\n'))
    ..writeln(
      'Each lib/ file must be checked by its own test: make it kill the '
      'mutants it does not list, in test/src. For a mutant that no test can '
      'tell apart from the code, rewrite the code instead. '
      'scripts/mutation.sh --update-baseline removes what no longer '
      'survives.',
    );
  exit(1);
}
