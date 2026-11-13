import 'package:meta/meta.dart';

/// A fenced code block tagged `dart`, in a doc comment or a Markdown file.
@internal
@immutable
final class Snippet {
  const Snippet({
    required this.line,
    required this.code,
    this.name,
    this.isSkipped = false,
    this.isContinued = false,
  });

  /// The 1-based line of the opening fence, in the file.
  final int line;

  /// The code between the fences, without the indentation of the fence nor
  /// the `///` of doc comments.
  final String code;

  /// The `name=` of the fence, if any.
  final String? name;

  /// Whether the fence opts out of the extraction, with `no-analyze`.
  final bool isSkipped;

  /// Whether the fence builds on the snippet before it, with `continued`.
  final bool isContinued;
}

/// The snippets of a file, and what they can assume.
@internal
final class SnippetSource {
  SnippetSource({required this.assumptions, required this.snippets});

  /// The code of the `Examples can assume:` comments of the file. It is
  /// prepended to each of the [snippets], to declare what they leave out.
  final String assumptions;

  /// Every `dart` snippet, in the order of the file.
  final List<Snippet> snippets;
}

final _docLine = RegExp(r'^\s*/// ?(.*)$');
final _commentLine = RegExp(r'^\s*// ?(.*)$');
final _dartAssumptions = RegExp(r'^\s*// Examples can assume:\s*$');
final _markdownAssumptions = RegExp(r'^\s*<!--\s*Examples can assume:\s*$');
final _markdownAssumptionsEnd = RegExp(r'^\s*-->\s*$');
// Backtick fences cannot have backticks in their info string.
final _fence = RegExp(r'^( *)(`{3,}|~{3,})[ \t]*([^\s`]*)[ \t]*([^`]*)$');

/// Finds the `dart` snippets of the `///` comments of a Dart file.
///
/// What they can assume is in the `//` comments that start with the line
/// `// Examples can assume:`, as in the Flutter SDK:
///
/// ```dart no-analyze
/// // Examples can assume:
/// // import 'dart:async';
/// // late Ref ref;
/// ```
@internal
SnippetSource extractDartSnippets(String content) {
  final lines = content.split('\n');
  final assumptions = <String>[];
  final snippets = <Snippet>[];

  // A doc comment is the Markdown of consecutive `///` lines.
  var comment = <(int, String)>[];
  void endComment() {
    snippets.addAll(_snippetsOf(comment));
    comment = [];
  }

  var inAssumptions = false;
  for (final (index, raw) in lines.indexed) {
    final line = _withoutCarriageReturn(raw);
    if (_docLine.firstMatch(line) case final doc?) {
      inAssumptions = false;
      comment.add((index + 1, doc[1]!));
      continue;
    }
    endComment();

    if (_dartAssumptions.hasMatch(line)) {
      inAssumptions = true;
    } else if (inAssumptions) {
      if (_commentLine.firstMatch(line) case final code?) {
        assumptions.add(code[1]!);
      } else {
        inAssumptions = false;
      }
    }
  }
  endComment();

  return SnippetSource(assumptions: assumptions.join('\n'), snippets: snippets);
}

/// Finds the `dart` snippets of a Markdown or MDX file.
///
/// What they can assume is in the HTML comments that start with the line
/// `<!-- Examples can assume:` and end with the line `-->`:
///
/// ```md
/// <!-- Examples can assume:
/// import 'dart:async';
/// late Ref ref;
/// -->
/// ```
@internal
SnippetSource extractMarkdownSnippets(String content) {
  final assumptions = <String>[];
  final snippets = _snippetsOf([
    for (final (index, line) in content.split('\n').indexed)
      (index + 1, _withoutCarriageReturn(line)),
  ], assumptions: assumptions).toList();

  return SnippetSource(assumptions: assumptions.join('\n'), snippets: snippets);
}

String _withoutCarriageReturn(String line) =>
    line.endsWith('\r') ? line.substring(0, line.length - 1) : line;

/// The `dart` fenced code blocks of [lines] of Markdown, which come with
/// their 1-based number in the file.
///
/// The code of the `Examples can assume:` HTML comments that are not in a
/// code block is added to [assumptions], if any.
Iterable<Snippet> _snippetsOf(
  List<(int, String)> lines, {
  List<String>? assumptions,
}) sync* {
  var inAssumptions = false;
  // The opening fence of the current block, and the code read so far.
  RegExpMatch? open;
  var openLine = 0;
  var code = <String>[];

  Snippet? close() {
    final info = open![4]!.trim().split(RegExp(r'\s+'));
    final isDart = open![3]!.toLowerCase() == 'dart';
    open = null;
    if (!isDart) return null;

    String? name;
    for (final word in info) {
      if (word.startsWith('name=')) name = word.substring('name='.length);
    }
    return Snippet(
      line: openLine,
      code: code.join('\n'),
      name: name,
      isSkipped: info.contains('no-analyze'),
      isContinued: info.contains('continued'),
    );
  }

  for (final (number, line) in lines) {
    if (inAssumptions) {
      if (_markdownAssumptionsEnd.hasMatch(line)) {
        inAssumptions = false;
      } else {
        assumptions!.add(line);
      }
      continue;
    }

    final fence = _fence.firstMatch(line);
    final opening = open;
    if (opening == null) {
      if (assumptions != null && _markdownAssumptions.hasMatch(line)) {
        inAssumptions = true;
      } else if (fence != null) {
        open = fence;
        openLine = number;
        code = [];
      }
      continue;
    }

    // Closed by a fence of the same character, at least as long, and without
    // info string.
    final isClosing =
        fence != null &&
        fence[2]![0] == opening[2]![0] &&
        fence[2]!.length >= opening[2]!.length &&
        fence[3]!.isEmpty &&
        fence[4]!.trim().isEmpty;
    if (isClosing) {
      if (close() case final snippet?) yield snippet;
      continue;
    }

    // The indentation of the opening fence is not part of the code.
    var indentation = 0;
    while (indentation < opening[1]!.length &&
        indentation < line.length &&
        line[indentation] == ' ') {
      indentation++;
    }
    code.add(line.substring(indentation));
  }

  // An unclosed block runs to the end of the Markdown.
  if (open != null) {
    if (close() case final snippet?) yield snippet;
  }
}
