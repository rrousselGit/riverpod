import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

@internal
class ShowAll extends DartLintRule {
  const ShowAll() : super(code: _code);

  static const _code = LintCode(
    name: 'show_all_public_api',
    problemMessage: '{0}',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addExportDirective((export) {
      final uri = export.element?.source.uri;
      if (uri == null || uri.scheme != 'package') return;
      if (uri.pathSegments.elementAtOrNull(1) == 'src') return;

      final exportedLibrary = export.element?.exportedLibrary;
      if (exportedLibrary == null) return;

      final show = export.combinators.whereType<ShowCombinator>().firstOrNull;
      if (show == null) {
        reporter.atNode(export, _code, arguments: ['Exports should use show']);
        return;
      }

      final (:extra, :missing) = _computeExportDiff(export);

      if (missing.isNotEmpty) {
        final allMissing = missing.map((e) => e.displayName).join(', ');
        reporter.atNode(
          export,
          _code,
          arguments: ['Missing show: $allMissing'],
        );
      }

      if (extra.isNotEmpty) {
        final allExtra = extra.map((e) => e.name).join(', ');
        reporter.atNode(
          export,
          _code,
          arguments: ['Extra show: $allExtra'],
        );
      }
    });
  }

  @override
  List<Fix> getFixes() => [_ShowAllFix()];
}

extension on LibraryElement {
  Set<Element> get exportedElements {
    return exportNamespace.definedNames.values
        .map((e) => e.nonSynthetic)
        .toSet();
  }
}

({
  Iterable<Element> missing,
  Iterable<SimpleIdentifier> extra,
}) _computeExportDiff(ExportDirective export) {
  final exportedLibrary = export.element!.exportedLibrary!;
  if (exportedLibrary.source.uri.scheme != 'package') {
    return (
      missing: const [],
      extra: const [],
    );
  }

  final exportedIdentifiers = exportedLibrary.exportedElements
      .map((e) {
        final public = _Public.of(e);
        if (e.hasInternal && public.isEmpty) return null;

        return (public, e);
      })
      .nonNulls
      .toList();

  final show = export.combinators.whereType<ShowCombinator>().firstOrNull;

  final missing = exportedIdentifiers
      .where(
    (e) =>
        show == null || !show.shownNames.map((e) => e.name).contains(e.$2.name),
  )
      .where((e) {
    return e.$1.isEmpty || e.$1.any((p) => p.hasMatch(export.element!));
  });

  final extra = show?.shownNames.where(
    (e) => !exportedIdentifiers.map((e) => e.$2.name).contains(e.name),
  );

  return (
    missing: missing.map((e) => e.$2),
    extra: extra ?? const [],
  );
}

class _ShowAllFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addExportDirective((export) {
      if (!export.sourceRange.intersects(analysisError.sourceRange)) return;

      final show = export.combinators.whereType<ShowCombinator>().firstOrNull;
      if (show == null) {
        final changeBuilder = reporter.createChangeBuilder(
          message: 'Convert to show',
          priority: 100,
        );

        changeBuilder.addDartFileEdit((builder) {
          // Delete hide, if any
          final hide =
              export.combinators.whereType<HideCombinator>().firstOrNull;
          if (hide != null) {
            builder.addDeletion(hide.sourceRange);
          }

          final toShow = export.element!.exportedLibrary!.exportedElements
              .where(
                (e) =>
                    hide == null ||
                    !hide.hiddenNames.map((e) => e.name).contains(e.name),
              )
              .toSet();

          builder.addInsertion(export.semicolon.offset, (builder) {
            builder.write(' show ');
            final allShow = toShow.map((e) => e.displayName).join(', ');
            builder.write(allShow);
          });
        });

        return;
      } else {
        final changeBuilder = reporter.createChangeBuilder(
          message: 'Update show list',
          priority: 100,
        );

        changeBuilder.addDartFileEdit((builder) {
          final (:extra, :missing) = _computeExportDiff(export);
          for (final extra in extra) {
            builder.addDeletion(range.deletionRange(extra));
          }

          // Insert the missing elements
          builder.addInsertion(export.semicolon.offset, (builder) {
            builder.write(', ');
            final unexportedElements = missing.map((e) => e.name).join(', ');
            builder.write(unexportedElements);
          });
        });
      }
    });
  }
}

class _Public {
  _Public({required this.library, required this.packageName});

  static const type = TypeChecker.fromName('Public', packageName: 'riverpod');

  static List<_Public> of(Element element) {
    final annotation = type.annotationsOfExact(element);

    return [
      for (final annotation in annotation)
        _Public(
          library: annotation.getField('library')!.toStringValue()!,
          packageName: annotation.getField('packageName')?.toStringValue(),
        ),
    ];
  }

  final String library;
  final String? packageName;

  bool hasMatch(LibraryExportElement e) {
    print('''
Has match
  expected:
    library: $library
    packageName: $packageName
  actual:
    library: ${e.source.uri.pathSegments.skip(1).join('/')}
    packageName: ${e.source.uri.pathSegments[0]}
''');

    final uri = e.source.uri;

    if (packageName != null) {
      if (uri.scheme != 'package') return false;
      if (uri.pathSegments[0] != packageName) return false;
    }

    final actualLibrary = uri.pathSegments.skip(1).join('/');
    return library == p.withoutExtension(actualLibrary);
  }
}
