import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

/// Forbids generators from writing the public API of `riverpod_annotation`
/// in string literals.
///
/// Generators should write those types with `analyzer_buffer`, which handles
/// imports and prefixes.
@internal
class AvoidAnnotationApiInStrings extends AnalysisRule {
  AvoidAnnotationApiInStrings()
    : super(
        name: 'avoid_annotation_api_in_strings',
        description:
            'Generators should write the API of riverpod_annotation using '
            'analyzer_buffer instead of string literals.',
      );

  static const code = LintCode(
    'avoid_annotation_api_in_strings',
    '{0} part of the public API of riverpod_annotation. '
        'Write it using analyzer_buffer instead of a string literal.',
    severity: DiagnosticSeverity.ERROR,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    if (!_isInGeneratorLib(context.definingUnit.file.path)) return;

    final session = context.libraryElement?.session;
    if (session == null) return;

    final names = AnnotationApi.of(session);
    if (names.isEmpty) return;

    final visitor = _Visitor(this, _matcherFor(names));
    registry.addSimpleStringLiteral(this, visitor);
    registry.addStringInterpolation(this, visitor);
  }
}

/// Whether [path] is within the `lib` folder of a `*_generator` package.
bool _isInGeneratorLib(String path) {
  final segments = p.split(path);
  final libIndex = segments.lastIndexOf('lib');
  if (libIndex < 1) return false;

  return segments[libIndex - 1].endsWith('_generator');
}

/// Stands for an interpolated value in the checked strings.
const _interpolation = '\u0000';

/// Matches [names] as whole words. An interpolated value before a name is
/// part of the word (`'${name}Ref'` builds an identifier), but not after it
/// (`'\$Notifier$generics'` still writes `$Notifier`).
RegExp _matcherFor(Set<String> names) {
  final alternatives = names.map(RegExp.escape).join('|');
  return RegExp('(?<![\\w\$$_interpolation])($alternatives)(?![\\w\$])');
}

/// The names exported by the public libraries of `riverpod_annotation`.
@internal
abstract final class AnnotationApi {
  static final _bySession = Expando<Set<String>>();

  static Set<String> of(AnalysisSession session) {
    return _bySession[session] ??= _compute(session);
  }

  static Set<String> _compute(AnalysisSession session) {
    final entrypoint = session.uriConverter.uriToPath(
      Uri.parse('package:riverpod_annotation/riverpod_annotation.dart'),
    );
    if (entrypoint == null) return const {};

    final libFolder = session.resourceProvider.getFile(entrypoint).parent;

    // `riverpod` is also the name of a package, and generators do not emit
    // the `@riverpod` annotation.
    return publicApiOf(session, libFolder.path)..remove('riverpod');
  }

  /// The public names that the libraries of [libPath] declare or export.
  @visibleForTesting
  static Set<String> publicApiOf(AnalysisSession session, String libPath) {
    final names = <String>{};
    final visited = <String>{};
    for (final file in _publicLibraries(libPath, session)) {
      _collectExports(session, file, names, visited);
    }

    return names..removeWhere((name) => name.startsWith('_'));
  }

  /// The Dart files in [libPath], excluding `lib/src`.
  static Iterable<String> _publicLibraries(
    String libPath,
    AnalysisSession session,
  ) sync* {
    final folder = session.resourceProvider.getFolder(libPath);
    for (final child in folder.getChildren()) {
      if (child.shortName == 'src') continue;

      if (child.path.endsWith('.dart')) {
        yield child.path;
      } else if (session.resourceProvider.getFolder(child.path).exists) {
        yield* _publicLibraries(child.path, session);
      }
    }
  }

  static void _collectExports(
    AnalysisSession session,
    String path,
    Set<String> names,
    Set<String> visited,
  ) {
    if (!visited.add(path)) return;

    final library = session.getParsedLibrary(path);
    if (library is! ParsedLibraryResult) return;

    final unit = library.units.first.unit;

    for (final declaration in unit.declarations) {
      switch (declaration) {
        case TopLevelVariableDeclaration(:final variables):
          for (final variable in variables.variables) {
            names.add(variable.name.lexeme);
          }
        case FunctionDeclaration(:final name) || TypeAlias(:final name):
          names.add(name.lexeme);
        case ClassDeclaration(:final namePart) ||
            EnumDeclaration(:final namePart):
          names.add(namePart.typeName.lexeme);
        case MixinDeclaration(:final name):
          names.add(name.lexeme);
        case ExtensionDeclaration(:final name?):
          names.add(name.lexeme);
        case _:
      }
    }

    for (final directive in unit.directives.whereType<ExportDirective>()) {
      final show = directive.combinators.whereType<ShowCombinator>();
      if (show.isNotEmpty) {
        for (final combinator in show) {
          names.addAll(combinator.shownNames.map((e) => e.name));
        }
        continue;
      }

      final uri = directive.uri.stringValue;
      if (uri == null) continue;

      final exportedUri = library.units.first.uri.resolve(uri);
      final exportedPath = session.uriConverter.uriToPath(exportedUri);
      if (exportedPath == null) continue;

      // riverpod_annotation does not use `hide`, so it is not handled.
      _collectExports(session, exportedPath, names, visited);
    }
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.matcher);

  final AvoidAnnotationApiInStrings rule;
  final RegExp matcher;

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    // Import/export URIs and annotation arguments are not generated code.
    if (node.parent is UriBasedDirective) return;
    if (node.thisOrAncestorOfType<Annotation>() != null) return;

    _check(node, node.value);
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    if (node.thisOrAncestorOfType<Annotation>() != null) return;

    // Checked as a whole, so that placeholders with an interpolated value
    // (`'#{{$package|Ref}}'`) are still ignored.
    final value = node.elements
        .map((e) => e is InterpolationString ? e.value : _interpolation)
        .join();
    _check(node, value);
  }

  void _check(AstNode node, String value) {
    final code = value.replaceAll(_ignoredSections, '');
    final matches = {
      for (final match in matcher.allMatches(code)) '`${match.group(1)}`',
    };
    if (matches.isEmpty) return;

    rule.reportAtNode(
      node,
      arguments: [
        if (matches.length == 1)
          '${matches.single} is'
        else
          '${matches.join(', ')} are',
      ],
    );
  }

  /// analyzer_buffer placeholders (`#{{package/library|Name}}`), which are
  /// the expected way to write types, and dartdoc directives such as
  /// `{@macro riverpod.foo}`.
  static final _ignoredSections = RegExp(r'#\{\{.*?\}\}|\{@[^}]*\}');
}
