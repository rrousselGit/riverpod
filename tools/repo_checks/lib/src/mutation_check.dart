import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'mutation_scope.dart';

/// The path of the baseline file, relative to the repository root.
@internal
const mutationBaselinePath = 'baselines/mutation.yaml';

/// Parses the content of [mutationBaselinePath]: for each file, relative to
/// the repository root, how many mutants of it its own test let survive when
/// the file was added to the baseline.
///
/// Throws a [FormatException] if it is malformed.
@internal
Map<String, int> parseMutationBaseline(String content) {
  final yaml = loadYaml(content, sourceUrl: Uri.parse(mutationBaselinePath));
  if (yaml is! YamlMap) {
    throw const FormatException('$mutationBaselinePath must be a map');
  }

  final unknownKeys = yaml.keys.toSet().difference({'baseline'});
  if (unknownKeys.isNotEmpty) {
    throw FormatException('Unknown keys: ${unknownKeys.join(', ')}');
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
  return baseline.cast<String, int>();
}

/// Returns [content], the content of [mutationBaselinePath], with the
/// entries of the files of [counts] set to their count, or removed for a
/// count of 0. The comments above `baseline:` are kept.
@internal
String updateMutationBaseline(String content, Map<String, int> counts) {
  final entries = {...parseMutationBaseline(content), ...counts}
    ..removeWhere((_, count) => count == 0);
  final lines = const LineSplitter().convert(content);
  final header = lines.takeWhile((line) => !line.startsWith('baseline:'));

  final buffer = StringBuffer()..writeAll(header.map((line) => '$line\n'));
  if (entries.isEmpty) return (buffer..writeln('baseline: {}')).toString();
  buffer.writeln('baseline:');
  for (final path in entries.keys.toList()..sort()) {
    buffer.writeln('  $path: ${entries[path]}');
  }
  return buffer.toString();
}

/// A mutant that no test of its file killed, from `line` and `column` to
/// `lastLine`.
@internal
typedef Survivor = ({
  int line,
  int column,
  int lastLine,
  String mutator,
  String original,
  String replacement,
});

/// The surviving mutants of each file of a dart_mutant [report], in the
/// mutation-testing-elements JSON schema, by path relative to the repository
/// root. [package] is the path of the mutated package, relative to the
/// repository root, which the paths of the report are relative to.
///
/// Files without survivors are included, with an empty list.
///
/// Throws a [FormatException] if [report] does not follow the schema.
@internal
Map<String, List<Survivor>> parseMutationReport(
  String report, {
  required String package,
}) {
  final json = jsonDecode(report);
  final files = json is Map ? json['files'] : null;
  if (files is! Map) {
    throw const FormatException('The report has no `files`');
  }

  return {
    for (final MapEntry(:key, :value) in files.entries)
      p.posix.join(package, key as String): _survivors(key, value),
  };
}

List<Survivor> _survivors(String path, Object? file) {
  if (file is! Map || file['source'] is! String || file['mutants'] is! List) {
    throw FormatException('`$path` has no `source` or `mutants`');
  }
  final source = file['source'] as String;
  final lineStarts = [0, for (final m in '\n'.allMatches(source)) m.end];
  int offset(Object? position) {
    if (position case {'line': final int line, 'column': final int column}) {
      return lineStarts[line - 1] + column - 1;
    }
    throw FormatException('`$path` has a mutant with a malformed location');
  }

  return [
    for (final mutant in file['mutants'] as List)
      if (mutant case {
        'status': 'Survived',
        'mutatorName': final String mutator,
        'replacement': final String replacement,
        'location': {
          'start':
              {'line': final int line, 'column': final int column} &&
              final start,
          'end': final end,
        },
      })
        (
          line: line,
          column: column,
          lastLine: linesOf(source, offset(start), offset(end)).last,
          mutator: mutator,
          original: source.substring(offset(start), offset(end)),
          replacement: replacement,
        ),
  ];
}

/// For each file of an [lcov] report, by path relative to the package at
/// [packageRoot], the lines it lists, and whether one of its runs hit them.
///
/// The paths of the report are either relative to the package or absolute.
@internal
Map<String, Map<int, bool>> parseLcovLines(
  String lcov, {
  required String packageRoot,
}) {
  final result = <String, Map<int, bool>>{};
  Map<int, bool>? lines;
  for (final line in const LineSplitter().convert(lcov)) {
    if (line.startsWith('SF:')) {
      var path = line.substring(3);
      if (p.isAbsolute(path)) path = p.relative(path, from: packageRoot);
      lines = result.putIfAbsent(p.split(path).join('/'), () => {});
    } else if (line.startsWith('DA:') && lines != null) {
      final [number, hits, ...] = line.substring(3).split(',');
      final n = int.parse(number);
      // A file may be listed once per isolate.
      lines[n] = (lines[n] ?? false) || int.parse(hits) > 0;
    }
  }
  return result;
}

/// Checks that each file of [survivors] has as many surviving mutants as
/// [baseline] lists for it (none if unlisted), and that every file of
/// [baseline] exists.
///
/// [neverRun] tells whether the test of a file never runs a line of it,
/// which explains why a mutant there survived.
///
/// With [changed], the lines a change touches of each file, by path relative
/// to the repository root, only the mutants on those lines were run: then
/// none of them may survive, and [baseline] is not compared, as it counts
/// the survivors of whole files.
///
/// Returns the problems found, one per line.
@internal
List<String> checkMutations({
  required Map<String, int> baseline,
  required Map<String, List<Survivor>> survivors,
  required bool Function(String path, int line) neverRun,
  required bool Function(String path) exists,
  Map<String, Set<int>>? changed,
}) {
  final problems = <String>[];
  void list(String path, List<Survivor> found) {
    for (final s in found) {
      final why = neverRun(path, s.line)
          ? 'its test never runs this line'
          : 'its test does not check this';
      problems.add(
        '  $path:${s.line}:${s.column} ${s.mutator}: '
        '`${_snippet(s.original)}` → `${_snippet(s.replacement)}` ($why)',
      );
    }
  }

  for (final path in survivors.keys.toList()..sort()) {
    if (changed != null) {
      final lines = changed[path] ?? const {};
      final found = [
        for (final s in survivors[path]!)
          if (touches((first: s.line, last: s.lastLine), lines)) s,
      ];
      if (found.isNotEmpty) {
        problems.add(
          '$path: ${found.length} surviving mutants on the lines this change '
          'touches:',
        );
        list(path, found);
      }
      continue;
    }
    final found = survivors[path]!;
    final allowed = baseline[path] ?? 0;
    if (found.length > allowed) {
      problems.add(
        '$path: ${found.length} surviving mutants, but $mutationBaselinePath '
        'allows $allowed:',
      );
      list(path, found);
    } else if (found.length < allowed) {
      problems.add(
        '$path: ${found.length} surviving mutants, fewer than the $allowed of '
        '$mutationBaselinePath: '
        '${found.isEmpty ? 'remove its entry' : 'lower its entry to ${found.length}'}',
      );
    }
  }
  for (final path in baseline.keys.toList()..sort()) {
    if (!exists(path)) {
      problems.add('$path: listed by $mutationBaselinePath, but not found');
    }
  }
  return problems;
}

/// [code] on one line, shortened, as a mutant may span a whole block.
String _snippet(String code) {
  final line = code.replaceAll(RegExp(r'\s+'), ' ');
  return line.length <= 60 ? line : '${line.substring(0, 57)}...';
}
