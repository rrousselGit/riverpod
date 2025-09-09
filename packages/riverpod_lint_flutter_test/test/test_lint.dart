import 'dart:convert';
import 'dart:io';

import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:test/test.dart';
import 'package:path/path.dart';
import 'package:riverpod_lint/src/riverpod_custom_lint.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:collection/collection.dart';

import 'encoders.dart';

@isTest
void testLint(
  String description,
  String file,
  RiverpodLintRule lint, {
  required String goldensDirectory,
}) {
  assert(file.endsWith('.dart'));
  final fixesGoldenPath = join(
    goldensDirectory,
    '${basenameWithoutExtension(file)}_fix.diff',
  );
  final lintGoldenPath = join(
    goldensDirectory,
    '${basenameWithoutExtension(file)}_lint.md',
  );

  test(description, () async {
    final sourcePath = File(normalize(file)).absolute;
    final result = await resolveFile(path: sourcePath.path);
    result as ResolvedUnitResult;

    final errors = await lint.testRun(result);
    expect(
      errors,
      matchesAnalysisErrorGoldens(lintGoldenPath),
    );

    final fixes = await lint.getFixes();
    final changes = await Future.wait([
      for (final fix in fixes)
        for (final error in errors) fix.testRun(result, error, errors),
    ]);

    expect(
      changes.flattened,
      matchesPrioritizedSourceChangesGolden(
        File(fixesGoldenPath),
        source: result.content,
        sourcePath: sourcePath.path,
      ),
    );
  });
}

@isTest
void testGolden(
  String description,
  String goldensFile,
  Future<Iterable<PrioritizedSourceChange>> Function(
    ResolvedUnitResult,
    OffsetHelper helper,
  )
  body, {
  required String sourcePath,
}) {
  assert(sourcePath.endsWith('.dart'));
  test(description, () async {
    final absoluteSource = File(normalize(sourcePath)).absolute;

    final sourceFile = File(sourcePath).absolute;

    final result = await resolveFile(path: absoluteSource.path);
    result as ResolvedUnitResult;

    final source = sourceFile.readAsStringSync();
    final changes = await body(result, OffsetHelper._(source)).then(
      (value) => value.toList(),
    );

    expect(
      await changes,
      matchesPrioritizedSourceChangesGolden(
        File(goldensFile),
        source: result.content,
        sourcePath: sourcePath,
      ),
    );
  });
}

const _cursor = '<>';

class OffsetHelper {
  OffsetHelper._(this._content);

  final String _content;

  /// Strings must be code of the format:
  ///
  /// ``dart
  /// Some<>Code
  /// ```
  ///
  /// where `<>` is the location of the cursor.
  ///
  /// At least one `<>` must be present, or the function will throw.
  Iterable<SourceRange> rangesForString(String string) sync* {
    final cursors = '<>'.allMatches(string).toList();
    if (cursors.isEmpty) {
      throw ArgumentError('String does not contain any cursors: $string');
    }

    final stringWithoutCursors = string.replaceAll(_cursor, '');

    final start = _content.indexOf(stringWithoutCursors);
    if (start == -1) {
      throw ArgumentError('String not found in content: $stringWithoutCursors');
    }

    if (_content.indexOf(stringWithoutCursors, start + 1) != -1) {
      throw ArgumentError(
        'Found the string twice in the content: $stringWithoutCursors',
      );
    }

    for (final (index, cursor) in cursors.indexed) {
      // In the case of multiple cursors, we need to adjust the offset
      // to account for the previous cursors.
      final actualCursorStart = cursor.start - 2 * index;
      yield SourceRange(start + actualCursorStart, 0);
    }
  }

  Future<Iterable<PrioritizedSourceChange>> runAssist(
    RiverpodAssist assist,
    ResolvedUnitResult result,
    Iterable<SourceRange> cursorRanges, {
    Pubspec? pubspec,
  }) async {
    return Future.wait(
      cursorRanges.map(
        (range) => assist.testRun(result, range, pubspec: pubspec),
      ),
    ).then((value) => value.expand((e) => e));
  }

  void debugOffset(List<int> offsets) {
    offsets.sort();

    var mappedContent = _content;
    for (final offset in offsets.reversed) {
      mappedContent =
          mappedContent.substring(0, offset) +
          '<>' +
          mappedContent.substring(offset);
    }

    final lines = LineSplitter.split(mappedContent).toList();

    final codes = [];

    StringBuffer? buffer;

    void openBuffer() {
      buffer ??= StringBuffer("helper.rangesForString('''\n");
    }

    void closeBuffer() {
      if (buffer == null) return;

      buffer!.write("''')");
      codes.add(buffer.toString());
      buffer = null;
    }

    // Print all lines with <> in them and one line before and after.
    for (final (index, line) in lines.indexed) {
      if (buffer == null && line.trim().isEmpty) continue;

      final hasCursor = line.contains(_cursor);
      late final hadCursor = index >= 1 && lines[index - 1].contains(_cursor);
      late final willHaveCursor =
          index + 1 < lines.length && lines[index + 1].contains(_cursor);

      if (hasCursor || hadCursor || willHaveCursor) {
        openBuffer();
        buffer!.writeln(line);
      } else {
        closeBuffer();
      }
    }

    if (buffer != null) closeBuffer();

    if (codes.length == 1) {
      print('  final cursors = ${codes.single};');
    } else {
      print('  final cursors = [');
      for (final code in codes) {
        print('    ...$code,');
      }
      print('  ];');
    }
  }
}
