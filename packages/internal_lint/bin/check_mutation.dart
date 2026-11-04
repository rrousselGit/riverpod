import 'dart:io';

import 'package:internal_lint/src/mutation_check.dart';
import 'package:path/path.dart' as p;

/// Checks a dart_mutant report: each mutated file must have as many
/// surviving mutants as [mutationBaselinePath] lists for it (see
/// [checkMutations]).
///
/// Usage:
///
/// ```sh
/// dart run internal_lint:check_mutation \
///   root package report coverage [--update-baseline] file...
/// ```
///
/// where `root` is the repository root, `package` the path of the mutated
/// package relative to it, `report` the dart_mutant report, `coverage` the
/// folder holding, for each file, the lcov report of its test alone at
/// `coverage/file.info`, and `file` the mutated files, relative to
/// `package`.
///
/// With `--update-baseline`, the entries of the files are set to their number
/// of survivors instead.
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
  final survivors = parse(
    reportPath,
    () => parseMutationReport(reportFile.readAsStringSync(), package: package),
  );

  final missing = [
    for (final file in files)
      if (!survivors.containsKey(p.posix.join(package, file))) file,
  ];
  if (missing.isNotEmpty) {
    stderr
      ..writeln('dart_mutant did not report on these files of $package:')
      ..writeAll(missing.map((file) => '  $file\n'));
    exit(1);
  }

  if (update) {
    baselineFile.writeAsStringSync(
      updateMutationBaseline(baselineFile.readAsStringSync(), {
        for (final MapEntry(:key, :value) in survivors.entries)
          key: value.length,
      }),
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
    survivors: survivors,
    neverRun: neverRun,
    exists: (path) => File(p.join(root, path)).existsSync(),
  );
  if (problems.isEmpty) {
    stdout.writeln(
      'Every mutated file has the surviving mutants that '
      '$mutationBaselinePath lists for it.',
    );
    return;
  }

  stderr
    ..writeln('Mutation testing found problems:')
    ..writeAll(problems.map((problem) => '  $problem\n'))
    ..writeln(
      'Each lib/ file must be checked by its own test: make it kill these '
      'mutants, in test/src. For a mutant that no test can tell apart from '
      'the code, rewrite the code instead.',
    );
  exit(1);
}
