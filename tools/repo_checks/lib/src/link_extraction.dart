import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:meta/meta.dart';

/// What the target of a [FoundLink] is.
@internal
enum LinkKind {
  /// A URL or a path, as Markdown and HTML link them.
  destination,

  /// The id of a page of the website, optionally followed by `#` and one of
  /// its headings, as `<Link documentID="id" hash="heading" />` links them.
  document,

  /// The label of a reference link, `[text][label]`, that nothing defines.
  undefinedReference,
}

/// A link, where it is in its file, and what it links.
@internal
typedef FoundLink = ({int offset, String target, LinkKind kind});

final _fence = RegExp(r'^[ \t>]*(`{3,}|~{3,})');
// Not across a blank line, where a paragraph, and so its code span, ends.
final _inlineCode = RegExp(
  r'(?<!`)(`+)(?!`)(?:(?!\n[ \t]*\n).)+?(?<!`)\1(?!`)',
  dotAll: true,
);
final _comment = RegExp(r'<!--.*?-->|\{/\*.*?\*/\}', dotAll: true);

// `](destination`, where the destination may be within `<>`, and may have
// one level of parentheses.
final _inlineLink = RegExp(
  r'\]\([ \t]*(?:<([^>\n]*)>|((?:[^\s()\\]|\\.|\([^\s()]*\))*))',
);
// `[label]: destination`, but for footnotes (`[^1]: text`).
final _definition = RegExp(
  r'^ {0,3}\[([^\]^][^\]]*)\]:[ \t]*(?:<([^>\n]*)>|(\S+))',
  multiLine: true,
);
// `[text][label]`. Not `[label][]`, which dartdoc also reads as a reference
// to a declaration.
final _reference = RegExp(r'\[(?:[^\[\]]|\[[^\[\]]*\])+\]\[([^\]]+)\]');
const _attribute =
    r'''[\w:-]+(?:\s*=\s*(?:"[^"]*"|'[^']*'|\{\s*(?:"[^"]*"|'[^']*')\s*\}))?''';
// An HTML or JSX tag with literal attributes: `<Link documentID="id" />`.
final _tag = RegExp('<([A-Za-z][\\w.]*)((?:\\s+$_attribute)+)\\s*/?>');
final _attributeValue = RegExp(
  r'''([\w:-]+)\s*=\s*\{?\s*(?:"([^"]*)"|'([^']*)')''',
);
final _url = RegExp(r'''https?://[^\s<>"'`\[\]{}|\\^]+''');
final _whitespace = RegExp(r'\s+');
final _notLineBreak = RegExp('[^\n]');

/// The links of a Markdown or MDX file:
///
/// - `[text](destination)` and `![image](destination)`;
/// - the destination of `[label]: destination`, and the `[text][label]`
///   whose label nothing defines;
/// - the `href`, `src` and `to` attributes of HTML and JSX tags;
/// - what the components of the website link: the page of
///   `<Link documentID="id" hash="heading" />`, and the gist of
///   `<DartPad id="gist" />`;
/// - URLs in the text.
///
/// Code, whether fenced or in backticks, and comments have no links.
@internal
List<FoundLink> linksInMarkdown(String content) {
  final text = _maskAll(_inlineCode, _maskAll(_comment, _maskFences(content)));
  final links = <FoundLink>[];
  // Where a destination that is already a link starts, so that a URL is not
  // also found as text.
  final found = <int>{};

  void add(int offset, String target, [LinkKind kind = LinkKind.destination]) {
    if (found.add(offset)) {
      links.add((offset: offset, target: target, kind: kind));
    }
  }

  final labels = <String>{};
  for (final match in _definition.allMatches(text)) {
    labels.add(_label(match[1]!));
    final target = match[2] ?? match[3]!;
    add(match.end - target.length - (match[2] == null ? 0 : 1), target);
  }
  for (final match in _reference.allMatches(text)) {
    final label = match[1]!;
    if (!labels.contains(_label(label))) {
      add(match.start, label.trim(), LinkKind.undefinedReference);
    }
  }

  for (final match in _inlineLink.allMatches(text)) {
    final target = match[1] ?? match[2]!;
    add(match.end - target.length - (match[1] == null ? 0 : 1), target);
  }

  for (final tag in _tag.allMatches(text)) {
    final name = tag[1]!;
    final attributesOffset = tag.start + 1 + name.length;
    final attributes = {
      for (final match in _attributeValue.allMatches(tag[2]!))
        match[1]!: (
          offset: attributesOffset + match.end - 1 - _valueOf(match).length,
          value: _valueOf(match),
        ),
    };

    final documentId = attributes['documentID'];
    final gist = attributes['id'];
    if (name == 'Link' && documentId != null) {
      final hash = attributes['hash']?.value;
      add(
        documentId.offset,
        hash == null ? documentId.value : '${documentId.value}#$hash',
        LinkKind.document,
      );
    } else if (name == 'DartPad' && gist != null) {
      add(gist.offset, 'https://gist.github.com/${gist.value}');
    }
    for (final name in const ['href', 'src', 'to']) {
      final attribute = attributes[name];
      if (attribute != null) add(attribute.offset, attribute.value);
    }
  }

  for (final (:offset, :target) in _urlsIn(text)) {
    add(offset, target);
  }

  return links..sort((a, b) => a.offset.compareTo(b.offset));
}

String _valueOf(RegExpMatch attribute) => attribute[2] ?? attribute[3]!;

/// Labels match whatever their case and the whitespace within them.
String _label(String label) =>
    label.trim().toLowerCase().replaceAll(_whitespace, ' ');

/// The URLs in the comments of [unit], but those of their code: Dart files
/// link nothing else, as `[Name]` in a doc comment is a reference to a
/// declaration, which the analyzer checks.
///
/// Comments are read from the tokens, so that a URL in a string is not
/// mistaken for a link.
@internal
List<FoundLink> linksInDart(CompilationUnit unit) {
  final links = <FoundLink>[];
  for (Token? token = unit.beginToken; token != null; token = token.next) {
    // Each line of a `///` comment is its own token. So a fenced code block
    // spans several, up to the end of the comment at the latest.
    var inFence = false;
    for (
      Token? comment = token.precedingComments;
      comment != null;
      comment = comment.next
    ) {
      var text = comment.lexeme;
      if (text.startsWith('///')) {
        final isFence = _fence.hasMatch(text.substring(3));
        if (isFence) inFence = !inFence;
        if (isFence || inFence) continue;
      } else {
        text = _maskFences(text);
      }
      for (final (:offset, :target) in _urlsIn(_maskAll(_inlineCode, text))) {
        links.add((
          offset: comment.offset + offset,
          target: target,
          kind: LinkKind.destination,
        ));
      }
    }
    // The end of file is its own next token.
    if (token.isEof) break;
  }
  return links;
}

/// The URLs of [text], without the punctuation of the sentence around them.
Iterable<({int offset, String target})> _urlsIn(String text) sync* {
  for (final match in _url.allMatches(text)) {
    var url = match[0]!;
    while (true) {
      final last = url[url.length - 1];
      // A `)` that closes a parenthesis of the URL is part of it.
      final isClosing =
          last == ')' &&
          ')'.allMatches(url).length > '('.allMatches(url).length;
      if (!isClosing && !'.,;:!?*_~'.contains(last)) break;
      url = url.substring(0, url.length - 1);
    }
    yield (offset: match.start, target: url);
  }
}

final _heading = RegExp(r'^ {0,3}#{1,6}[ \t]+(.*?)[ \t]*$', multiLine: true);
final _closingHashes = RegExp(r'[ \t]+#+$');
final _explicitId = RegExp(r'[ \t]*\{#([^}\s]+)\}$');
final _htmlId = RegExp(r'''\b(?:id|name)\s*=\s*\{?\s*["']([^"']+)["']''');
final _codeSpan = RegExp(r'(`+)(.+?)\1');
final _linkText = RegExp(
  r'!?\[((?:[^\[\]]|\[[^\[\]]*\])*)\](?:\([^)]*\)|\[[^\]]*\])',
);
final _htmlTag = RegExp('</?[A-Za-z][^>]*>');
// `*` and `~` always mark emphasis; `_` only does around a word, not within.
final _emphasis = RegExp(
  r'[*~]+|(?<![\p{L}\p{N}])_+|_+(?![\p{L}\p{N}])',
  unicode: true,
);
final _escape = RegExp(r'\\([!-/:-@\[-`{-~])');
// What GitHub and Docusaurus (github-slugger) drop from a heading.
final _notInSlug = RegExp(r'[^\p{L}\p{M}\p{N}\p{Pc}\- ]', unicode: true);

/// What a `#fragment` can link in a Markdown or MDX file:
///
/// - its headings, as GitHub and Docusaurus name them: in lowercase, without
///   punctuation and with `-` for spaces, then `-1`, `-2`... for the headings
///   of the same name;
/// - the id of the headings that set it, as in `## Heading {#id}`;
/// - the `id` and `name` attributes of its HTML tags.
@internal
Set<String> anchorsOf(String content) {
  final text = _maskAll(_comment, _maskFences(content));
  final anchors = <String>{};
  final counts = <String, int>{};

  for (final match in _heading.allMatches(text)) {
    var heading = match[1]!.replaceFirst(_closingHashes, '');
    final id = _explicitId.firstMatch(heading);
    if (id != null) {
      anchors.add(id[1]!);
      continue;
    }

    // The text of a heading, without its formatting. The code is kept as is.
    final buffer = StringBuffer();
    var end = 0;
    heading = heading.replaceAllMapped(_linkText, (match) => match[1]!);
    for (final code in _codeSpan.allMatches(heading)) {
      buffer
        ..write(_plain(heading.substring(end, code.start)))
        ..write(code[2]);
      end = code.end;
    }
    buffer.write(_plain(heading.substring(end)));

    final slug = buffer
        .toString()
        .trim()
        .toLowerCase()
        .replaceAll(_notInSlug, '')
        .replaceAll(' ', '-');
    final count = counts.update(slug, (count) => count + 1, ifAbsent: () => 0);
    anchors.add(count == 0 ? slug : '$slug-$count');
  }

  for (final match in _htmlId.allMatches(text)) {
    anchors.add(match[1]!);
  }
  return anchors;
}

String _plain(String text) => text
    .replaceAll(_htmlTag, '')
    .replaceAll(_emphasis, '')
    .replaceAllMapped(_escape, (match) => match[1]!);

/// Replaces the fenced code blocks of [content] with spaces, so that the
/// offsets of the rest are unchanged.
String _maskFences(String content) {
  final lines = content.split('\n');
  String? fence;
  for (var i = 0; i < lines.length; i++) {
    final match = _fence.firstMatch(lines[i]);
    final marker = match?[1];
    final wasInFence = fence != null;
    if (fence == null) {
      fence = marker;
    } else if (marker != null &&
        marker[0] == fence[0] &&
        marker.length >= fence.length &&
        // Unlike an opening fence, a closing one has no info string.
        lines[i].substring(match!.end).trim().isEmpty) {
      fence = null;
    }
    if (wasInFence || fence != null) lines[i] = ' ' * lines[i].length;
  }
  return lines.join('\n');
}

/// Replaces the matches of [pattern] with spaces, but for their line breaks,
/// so that the offsets and the lines of the rest are unchanged.
String _maskAll(RegExp pattern, String content) => content.replaceAllMapped(
  pattern,
  (match) => match[0]!.replaceAll(_notLineBreak, ' '),
);
