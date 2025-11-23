import 'dart:io';
import 'dart:math';

import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart'
    show SourceFileEdit;
import 'package:path/path.dart' as p;

String _encodeAnalysisErrors(
  Iterable<AnalysisError> errors, {
  required String relativePath,
}) {
  final buffer = StringBuffer();

  for (final (index, error) in errors.indexed) {
    if (index != 0) buffer.writeln('\n=======\n');

    _writeAnalysisError(
      buffer,
      error,
      relativePath: relativePath,
    );
  }

  return buffer.toString();
}

void _writeAnalysisError(
  StringBuffer buffer,
  AnalysisError error, {
  String indent = '',
  required String relativePath,
}) {
  buffer.writeln('${indent}code: ${error.errorCode.name}');
  _writeDiagnostic(
    buffer,
    error,
    indent: indent,
    relativePath: Directory.current.path,
  );
}

void _writeDiagnostic(
  StringBuffer buffer,
  Diagnostic diagnostic, {
  String indent = '',
  required String relativePath,
}) {
  buffer.writeln('${indent}severity: ${diagnostic.severity}');
  if (diagnostic.correctionMessage case final correctionMessage?) {
    buffer.writeln('${indent}correctionMessage: $correctionMessage');
  }
  if (diagnostic.contextMessages.isNotEmpty) {
    buffer.writeln('${indent}contextMessages:');
    for (final (index, message) in diagnostic.contextMessages.indexed) {
      if (index != 0) buffer.writeln();

      _writeDiagnosticMessage(
        buffer,
        message,
        indent: indent + '  ',
        relativePath: relativePath,
      );
    }
  }

  _writeDiagnosticMessage(
    buffer,
    diagnostic.problemMessage,
    indent: indent,
    relativePath: relativePath,
  );
}

void _writeDiagnosticMessage(
  StringBuffer buffer,
  DiagnosticMessage error, {
  String indent = '',
  required String relativePath,
}) {
  buffer.writeln(
    '${indent}message: ${error.messageText(includeUrl: false)}',
  );

  if (error.url case final url?) {
    buffer.writeln('${indent}url: $url');
  }

  _highlight(
    buffer,
    File(error.filePath),
    offset: error.offset,
    length: error.length,
    indent: indent,
  );
}

void _highlight(
  StringBuffer buffer,
  File file, {
  required int offset,
  required int length,
  String indent = '',
}) {
  const leadingCount = 2;
  const trailingCount = 2;

  final source = file.readAsStringSync();
  final lineInfo = LineInfo.fromContent(source);

  final start = lineInfo.getLocation(offset);
  final end = lineInfo.getLocation(offset + length);

  buffer.writeln(
    '$indent${p.normalize(p.relative(file.path))}:${start.lineNumber}:${start.columnNumber}',
  );
  buffer.writeln();

  buffer.writeln('$indent```${p.extension(file.path).substring(1)}');
  final firstChangedLine = start.lineNumber - 1;
  final lastChangedLine = end.lineNumber - 1;

  final endLine = min(lastChangedLine + trailingCount, lineInfo.lineCount - 1);

  for (
    var line = max(0, firstChangedLine - leadingCount);
    line <= endLine;
    line++
  ) {
    final endOfSource = !(line + 1 < lineInfo.lineCount);

    final lineContent = source.substring(
      lineInfo.getOffsetOfLine(line),
      endOfSource ? null : lineInfo.getOffsetOfLine(line + 1) - 1,
    );
    buffer.write(indent);

    var startCol = 0;
    if (line == firstChangedLine) {
      startCol = max(0, start.columnNumber - 1);
    }

    buffer.write(lineContent.substring(0, startCol));
    if (line == firstChangedLine) buffer.write('>>>');

    var endCol = max(lineContent.length, 0);
    if (line == lastChangedLine) {
      endCol = max(
        min(end.columnNumber - 1, lineContent.length),
        startCol,
      );
    }

    buffer.write(lineContent.substring(startCol, endCol));
    if (line == lastChangedLine) buffer.write('<<<');

    if (endCol < lineContent.length) {
      buffer.write(lineContent.substring(endCol));
    }

    if (!endOfSource) buffer.writeln();
  }
  buffer.writeln('$indent```');
}

String encodePrioritizedSourceChanges({
  required String unmodifiedSource,
  required LineInfo unmodifiedLineInfo,
  required String editedSource,
  required LineInfo editedLineInfo,
}) {
  final buffer = StringBuffer();

  // Get the offset of the first changed character between modifiedSource and source.
  var firstDiffOffset = 0;
  for (; firstDiffOffset < unmodifiedSource.length; firstDiffOffset++) {
    if (unmodifiedSource[firstDiffOffset] != editedSource[firstDiffOffset]) {
      break;
    }
  }

  // Get the last changed character offset between modifiedSource and source.
  var endSourceOffset = unmodifiedSource.length - 1;
  var endOutputOffset = editedSource.length - 1;
  for (
    ;
    endOutputOffset > firstDiffOffset && endSourceOffset > firstDiffOffset;
    endOutputOffset--, endSourceOffset--
  ) {
    if (unmodifiedSource[endSourceOffset] != editedSource[endOutputOffset]) {
      break;
    }
  }

  final firstChangedLine = unmodifiedLineInfo.getLocation(firstDiffOffset).lineNumber - 1;

  void writeDiff({
    required String source,
    required LineInfo lineInfo,
    required int endOffset,
    required String token,
    required int leadingCount,
    required int trailingCount,
  }) {
    final lastChangedLine = lineInfo.getLocation(endOffset).lineNumber - 1;
    final endLine = min(
      lastChangedLine + trailingCount,
      lineInfo.lineCount - 1,
    );
    for (
      var line = max(0, firstChangedLine - leadingCount);
      line <= endLine;
      line++
    ) {
      final changed = line >= firstChangedLine && line <= lastChangedLine;
      if (changed) buffer.write(token);

      final endOfSource = !(line + 1 < lineInfo.lineCount);

      buffer.write(
        source.substring(
          lineInfo.getOffsetOfLine(line),
          endOfSource ? null : lineInfo.getOffsetOfLine(line + 1) - 1,
        ),
      );
      if (!endOfSource) buffer.writeln();
    }
  }

  buffer.writeln('```');
  writeDiff(
    source: unmodifiedSource,
    lineInfo: unmodifiedLineInfo,
    endOffset: endSourceOffset,
    leadingCount: 2,
    trailingCount: 0,
    token: '- ',
  );

  writeDiff(
    source: editedSource,
    endOffset: endOutputOffset,
    lineInfo: editedLineInfo,
    leadingCount: 0,
    trailingCount: 2,
    token: '+ ',
  );
  buffer.writeln('```');

  return buffer.toString();
}
