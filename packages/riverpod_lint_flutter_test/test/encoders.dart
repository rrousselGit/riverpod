import 'dart:math';

import 'package:analyzer/source/line_info.dart';

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

  final firstChangedLine =
      unmodifiedLineInfo.getLocation(firstDiffOffset).lineNumber - 1;

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
