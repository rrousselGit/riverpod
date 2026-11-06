import 'dart:convert';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'mutation_scope.dart';

/// The path of the baseline file, relative to the repository root.
@internal
const mutationBaselinePath = 'baselines/mutation.yaml';

/// Parses the content of [mutationBaselinePath]: for each file, relative to
/// the repository root, the keys (see [mutantKey]) of the mutants of it that
/// its own test lets survive. A key is listed once per such mutant.
///
/// Throws a [FormatException] if it is malformed.
@internal
Map<String, List<String>> parseMutationBaseline(String content) {
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
        (e) =>
            e.key is! String ||
            e.value is! YamlList ||
            (e.value as YamlList).isEmpty ||
            (e.value as YamlList).any((key) => key is! String),
      )) {
    throw const FormatException(
      '`baseline` must map paths to non-empty lists of mutants',
    );
  }
  return {
    for (final MapEntry(:key, :value) in baseline.entries)
      key as String: (value as YamlList).cast<String>().toList(),
  };
}

/// Returns [content], the content of [mutationBaselinePath], with the
/// entries of the files of [entries] replaced, or removed when empty. The
/// comments above `baseline:` are kept.
@internal
String updateMutationBaseline(
  String content,
  Map<String, List<String>> entries,
) {
  final all = {...parseMutationBaseline(content), ...entries}
    ..removeWhere((_, keys) => keys.isEmpty);
  final lines = const LineSplitter().convert(content);
  final header = lines.takeWhile((line) => !line.startsWith('baseline:'));

  final buffer = StringBuffer()..writeAll(header.map((line) => '$line\n'));
  if (all.isEmpty) return (buffer..writeln('baseline: {}')).toString();
  buffer.writeln('baseline:');
  for (final path in all.keys.toList()..sort()) {
    buffer.writeln('  $path:');
    for (final key in all[path]!.toList()..sort()) {
      // A JSON string is a double-quoted YAML scalar.
      buffer.writeln('    - ${jsonEncode(key)}');
    }
  }
  return buffer.toString();
}

/// What a run found of a mutant.
@internal
enum MutantOutcome {
  /// Its test still passed.
  survived,

  /// Its test failed, or it could not be run (it does not compile, or did
  /// not end), so it cannot survive.
  killed,

  /// It was left to another run: another part (`Pending`), or out of the
  /// lines a change touches ([outOfScopeReason]).
  notRun,
}

/// A mutant of a report.
@internal
typedef ReportedMutant = ({
  String key,
  MutantOutcome outcome,
  int line,
  int column,
});

/// What names a mutant in [mutationBaselinePath], so that it is the same
/// while the code around it moves: the declaration it is in (see
/// [declarationAt]), its mutator, and the code it replaces and its
/// replacement, on one line and shortened. Mutants with the same key are
/// told apart by their number only.
@internal
String mutantKey({
  required String declaration,
  required String mutator,
  required String original,
  required String replacement,
}) {
  return '$declaration: $mutator: `${_snippet(original)}` → '
      '`${_snippet(replacement)}`';
}

/// The declaration of [unit] that [offset] is in, as the names of the
/// declarations around it outside of function bodies, joined by dots, such
/// as `MyClass.method` or `topLevelFunction`. Setters end with `=`, unnamed
/// constructors are `new`, unnamed extensions `extension`. `(top level)`
/// when it is in none.
@internal
String declarationAt(CompilationUnit unit, int offset) {
  final names = <String>[];
  unit.accept(_DeclarationFinder(offset, names));
  return names.isEmpty ? '(top level)' : names.join('.');
}

final class _DeclarationFinder extends GeneralizingAstVisitor<void> {
  _DeclarationFinder(this.offset, this.names);

  final int offset;
  final List<String> names;

  @override
  void visitNode(AstNode node) {
    if (offset < node.offset || offset >= node.end) return;
    if (node is FunctionBody) return;
    final name = switch (node) {
      ClassDeclaration(:final namePart) => namePart.typeName.lexeme,
      EnumDeclaration(:final namePart) => namePart.typeName.lexeme,
      ExtensionTypeDeclaration(:final namePart) => namePart.typeName.lexeme,
      MixinDeclaration(:final name) => name.lexeme,
      ExtensionDeclaration(:final name) => name?.lexeme ?? 'extension',
      FunctionDeclaration(:final name, :final isSetter) ||
      MethodDeclaration(
        :final name,
        :final isSetter,
      ) => '${name.lexeme}${isSetter ? '=' : ''}',
      ConstructorDeclaration(:final name) => name?.lexeme ?? 'new',
      VariableDeclaration(:final name) => name.lexeme,
      EnumConstantDeclaration(:final name) => name.lexeme,
      _ => null,
    };
    if (name != null) names.add(name);
    node.visitChildren(this);
  }
}

/// The mutants of each file of a dart_mutant [report], in the
/// mutation-testing-elements JSON schema, by path relative to the repository
/// root. [package] is the path of the mutated package, relative to the
/// repository root, which the paths of the report are relative to.
///
/// Throws a [FormatException] if [report] does not follow the schema.
@internal
Map<String, List<ReportedMutant>> parseMutationReport(
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
      p.posix.join(package, key as String): _mutants(key, value),
  };
}

List<ReportedMutant> _mutants(String path, Object? file) {
  if (file is! Map || file['source'] is! String || file['mutants'] is! List) {
    throw FormatException('`$path` has no `source` or `mutants`');
  }
  final source = file['source'] as String;
  final unit = parseString(content: source, throwIfDiagnostics: false).unit;
  final lineStarts = [0, for (final m in '\n'.allMatches(source)) m.end];
  int offset(int line, int column) {
    if (line < 1 || line > lineStarts.length) {
      throw FormatException('`$path` has a mutant outside of its source');
    }
    return lineStarts[line - 1] + column - 1;
  }

  return [
    for (final mutant in file['mutants'] as List)
      if (mutant case {
        'status': final String status,
        'mutatorName': final String mutator,
        'replacement': final String replacement,
        'location': {
          'start': {'line': final int line, 'column': final int column},
          'end': {'line': final int endLine, 'column': final int endColumn},
        },
      })
        (
          key: mutantKey(
            declaration: declarationAt(unit, offset(line, column)),
            mutator: mutator,
            original: source.substring(
              offset(line, column),
              offset(endLine, endColumn),
            ),
            replacement: replacement,
          ),
          outcome: switch (status) {
            'Survived' || 'NoCoverage' => MutantOutcome.survived,
            'Pending' || 'Ignored' => MutantOutcome.notRun,
            'CompileError' when mutant['statusReason'] == outOfScopeReason =>
              MutantOutcome.notRun,
            _ => MutantOutcome.killed,
          },
          line: line,
          column: column,
        )
      else
        throw FormatException('`$path` has a malformed mutant'),
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

/// For each key of the mutants of a file and of its [listed] keys: how many
/// times it is listed, and how many of its mutants survived, or were not
/// run.
Map<String, ({int listed, int survived, int notRun})> _tally(
  List<String> listed,
  List<ReportedMutant> mutants,
) {
  final tally = <String, ({int listed, int survived, int notRun})>{};
  void add(String key, {int listed = 0, int survived = 0, int notRun = 0}) {
    final old = tally[key] ?? (listed: 0, survived: 0, notRun: 0);
    tally[key] = (
      listed: old.listed + listed,
      survived: old.survived + survived,
      notRun: old.notRun + notRun,
    );
  }

  for (final key in listed) {
    add(key, listed: 1);
  }
  for (final mutant in mutants) {
    switch (mutant.outcome) {
      case MutantOutcome.survived:
        add(mutant.key, survived: 1);
      case MutantOutcome.notRun:
        add(mutant.key, notRun: 1);
      case MutantOutcome.killed:
        add(mutant.key);
    }
  }
  return tally;
}

/// Checks the [mutants] of each file against the keys [baseline] lists for
/// it, which may come from a run of only some of them: a key may not have
/// more survivors than it is listed, nor be listed more often than its
/// survivors and the mutants with that key that were not run could make up.
/// Also checks that every file of [baseline] exists.
///
/// [neverRun] tells whether the test of a file never runs a line of it,
/// which explains why a mutant there survived.
///
/// Returns the problems found, one per line.
@internal
List<String> checkMutations({
  required Map<String, List<String>> baseline,
  required Map<String, List<ReportedMutant>> mutants,
  required bool Function(String path, int line) neverRun,
  required bool Function(String path) exists,
}) {
  final problems = <String>[];
  for (final path in mutants.keys.toList()..sort()) {
    final tally = _tally(baseline[path] ?? const [], mutants[path]!);
    final added = [
      for (final MapEntry(:key, :value) in tally.entries)
        if (value.survived > value.listed) key,
    ];
    final stale = [
      for (final MapEntry(:key, :value) in tally.entries)
        if (value.listed > value.survived + value.notRun)
          (key, value.listed - value.survived - value.notRun),
    ];
    if (added.isNotEmpty) {
      problems.add(
        '$path: surviving mutants that $mutationBaselinePath does not list:',
      );
      for (final m in mutants[path]!) {
        if (m.outcome != MutantOutcome.survived || !added.contains(m.key)) {
          continue;
        }
        final value = tally[m.key]!;
        final why = neverRun(path, m.line)
            ? 'its test never runs this line'
            : 'its test does not check this';
        final listed = value.listed == 0
            ? ''
            : ', ${value.survived} such survivors but ${value.listed} listed';
        problems.add('  $path:${m.line}:${m.column} ${m.key} ($why$listed)');
      }
    }
    if (stale.isNotEmpty) {
      problems.add(
        '$path: mutants that $mutationBaselinePath lists, but that no longer '
        'survive: remove them',
      );
      for (final (key, count) in stale) {
        problems.add('  ${count == 1 ? '' : '$count× '}$key');
      }
    }
  }
  for (final path in baseline.keys.toList()..sort()) {
    if (!exists(path)) {
      problems.add('$path: listed by $mutationBaselinePath, but not found');
    }
  }
  return problems;
}

/// The keys that [baseline] should list for each file of [mutants] to pass
/// [checkMutations]: the survivors of each key, and as many of its other
/// entries as the mutants that were not run could make up.
@internal
Map<String, List<String>> updatedMutationEntries({
  required Map<String, List<String>> baseline,
  required Map<String, List<ReportedMutant>> mutants,
}) {
  return {
    for (final MapEntry(key: path, value: found) in mutants.entries)
      path: [
        for (final MapEntry(:key, :value) in _tally(
          baseline[path] ?? const [],
          found,
        ).entries)
          for (
            var i = 0;
            i <
                value.listed.clamp(
                  value.survived,
                  value.survived + value.notRun,
                );
            i++
          )
            key,
      ],
  };
}

/// [code] on one line, shortened, as a mutant may span a whole block.
String _snippet(String code) {
  final line = code.replaceAll(RegExp(r'\s+'), ' ').trim();
  return line.length <= 60 ? line : '${line.substring(0, 57)}...';
}
