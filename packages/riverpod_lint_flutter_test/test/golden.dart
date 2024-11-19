import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:custom_lint_core/custom_lint_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:test/test.dart';
import 'package:riverpod_lint/src/riverpod_custom_lint.dart';

final _goldenWrite = bool.parse(Platform.environment[r'goldens'] ?? 'false');

/// Expects that a value matches a golden file.
@visibleForTesting
Matcher matchersGoldenFile<T>(
  File file, {
  required String Function(T value) encode,
  required bool Function(T value) isEmpty,
}) {
  return _MatchesGoldenFile(
    file: file,
    encode: encode,
    isEmpty: isEmpty,
  );
}

class _MatchesGoldenFile<T> extends Matcher {
  _MatchesGoldenFile({
    required this.encode,
    required this.file,
    required this.isEmpty,
  });

  final File file;
  final String Function(T) encode;
  final bool Function(T) isEmpty;

  static final Object _mismatchedValueKey = Object();
  static final Object _expectedKey = Object();

  @override
  bool matches(
    Object? object,
    Map<Object?, Object?> matchState,
  ) {
    if (object is! T) {
      matchState[_mismatchedValueKey] = 'Expected a ${T.toString()}';
      return false;
    }

    late final actual = encode(object);

    if (!_goldenWrite) {
      if (isEmpty(object)) {
        if (file.existsSync()) {
          matchState[_mismatchedValueKey] =
              'Expected to have no file, but found: ${file.path}';
          return false;
        }
        return true;
      }

      if (!file.existsSync()) {
        matchState[_mismatchedValueKey] = 'File not found: ${file.path}';
        return false;
      }

      final expected = file.readAsStringSync();
      if (actual != expected) {
        matchState[_mismatchedValueKey] = actual;
        matchState[_expectedKey] = expected;
        return false;
      }
    } else if (isEmpty(object)) {
      try {
        file.deleteSync(recursive: true);
      } catch (_) {}
    } else {
      file
        ..createSync(recursive: true)
        ..writeAsStringSync(actual);
    }

    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('to match snapshot at ${file.path}');
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<Object?, Object?> matchState,
    bool verbose,
  ) {
    final actualValue = matchState[_mismatchedValueKey] as String?;
    if (actualValue != null) {
      final expected = matchState[_expectedKey] as String?;

      if (expected != null) {
        return mismatchDescription
            .add('Expected to match snapshot at ${file.path}:\n')
            .addDescriptionOf(expected)
            .add('\n\nbut was:\n')
            .addDescriptionOf(actualValue);
      } else {
        return mismatchDescription.add(actualValue);
      }
    }

    return mismatchDescription.add('Unknown mismatch');
  }
}

File writeToTemporaryFile(String content) {
  final tempDir = Directory.systemTemp.createTempSync();
  addTearDown(() => tempDir.deleteSync(recursive: true));

  final file = File(join(tempDir.path, 'file.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync(content);

  return file;
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
      mappedContent = mappedContent.substring(0, offset) +
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

void testGolden(
  String description,
  String fileName,
  Future<Iterable<PrioritizedSourceChange>> Function(
    ResolvedUnitResult unit,
    OffsetHelper offsetHelper,
  ) body, {
  required String sourcePath,
}) {
  test(description, () async {
    final file = File(sourcePath).absolute;

    final result = await resolveFile2(path: file.path);
    result as ResolvedUnitResult;

    final source = file.readAsStringSync();
    final changes = await body(result, OffsetHelper._(source))
        .then((value) => value.toList());

    try {
      expect(
        changes,
        matcherNormalizedPrioritizedSourceChangeSnapshot(
          fileName,
          sources: {'**': source},
          relativePath: Directory.current.path,
        ),
      );
    } on TestFailure {
      if (!_goldenWrite) rethrow;

      final source = File(sourcePath).readAsStringSync();
      final result = encodePrioritizedSourceChanges(
        changes,
        sources: {'**': source},
        relativePath: Directory.current.path,
      );

      final golden = File('test/$fileName');
      golden
        ..createSync(recursive: true)
        ..writeAsStringSync(result);
      return;
    }
  });
}
