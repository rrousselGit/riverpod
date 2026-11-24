import 'dart:convert';

import 'package:meta/meta.dart';

/// For each file of a `git diff -U0` [diff], by its path after `b/`, the
/// lines of its new version that the diff adds or changes, without the
/// blank lines and the `//` comment lines: no mutant is made of those.
///
/// Files the diff deletes, or of which it only removes lines, are not
/// included.
@internal
Map<String, Set<int>> parseChangedLines(String diff) {
  final result = <String, Set<int>>{};
  Set<int>? lines;
  var next = 0;
  final hunk = RegExp(r'^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@');
  for (final line in const LineSplitter().convert(diff)) {
    if (line.startsWith('+++ ')) {
      final path = line.substring(4);
      lines = path.startsWith('b/') ? <int>{} : null;
      if (lines != null) result[path.substring(2)] = lines;
    } else if (hunk.firstMatch(line) case final match?) {
      next = int.parse(match[1]!);
    } else if (line.startsWith('+') && lines != null) {
      final code = line.substring(1).trim();
      if (code.isNotEmpty && !code.startsWith('//')) lines.add(next);
      next++;
    }
  }
  return result..removeWhere((_, lines) => lines.isEmpty);
}

/// The lines, counted from 1, that the text from [offset] to [end] (not
/// included) of [source] spans.
@internal
({int first, int last}) linesOf(String source, int offset, int end) {
  int lineAt(int offset) =>
      '\n'.allMatches(source.substring(0, offset)).length + 1;
  return (first: lineAt(offset), last: lineAt(end > offset ? end - 1 : offset));
}

/// Whether [lines], from `first` to `last`, include one of [changed].
@internal
bool touches(({int first, int last}) lines, Set<int> changed) {
  for (var line = lines.first; line <= lines.last; line++) {
    if (changed.contains(line)) return true;
  }
  return false;
}

/// Why a mutant that [scopeMutants] leaves out was not run.
@internal
const outOfScopeReason = 'not run: on no line that this change touches';

/// Returns the [incremental] state of dart_mutant 0.2.1
/// (`.dart_tool/dart_mutant/incremental.json`), with every mutant that has no
/// result yet (`Pending`) and touches none of the [changed] lines of its file
/// given one, so that the next run without `--force` only runs the others.
///
/// dart_mutant has no status for a mutant that is left out, and the only
/// ones it reuses and that `merge` accepts are those it finds itself, so it
/// is a `CompileError`, with [outOfScopeReason] as its reason.
///
/// Also returns, for each file of [changed], how many of its mutants are
/// left to run, and how many it has. Files that [incremental] does not have
/// are not included.
///
/// Throws a [FormatException] if [incremental] is not such a state.
@internal
({String incremental, Map<String, ({int left, int all})> counts}) scopeMutants(
  String incremental,
  Map<String, Set<int>> changed,
) {
  final json = jsonDecode(incremental);
  final files = json is Map ? json['files'] : null;
  if (files is! Map) {
    throw const FormatException('The state has no `files`');
  }

  final counts = <String, ({int left, int all})>{};
  for (final MapEntry(key: path, value: lines) in changed.entries) {
    final file = files[path];
    if (file == null) continue;
    final source = file is Map ? file['input'] : null;
    final mutants = file is Map ? file['mutants'] : null;
    if (source is! Map || source['source'] is! String || mutants is! List) {
      throw FormatException('`$path` has no source or mutants');
    }
    var left = 0;
    for (final mutant in mutants) {
      if (mutant case {
        'status': final String status,
        'offset': final int offset,
        'end': final int end,
      }) {
        if (status != 'Pending') continue;
        if (touches(linesOf(source['source'] as String, offset, end), lines)) {
          left++;
        } else {
          mutant['status'] = 'CompileError';
          mutant['reason'] = outOfScopeReason;
        }
      } else {
        throw FormatException('`$path` has a malformed mutant');
      }
    }
    counts[path] = (left: left, all: mutants.length);
  }
  return (incremental: jsonEncode(json), counts: counts);
}
