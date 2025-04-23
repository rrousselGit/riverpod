import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/source.dart';
import 'package:analyzer/source/source_range.dart';
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
    errorSeverity: ErrorSeverity.ERROR,
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

      final meta = _computeExportDiff(export);
      if (meta == null) return;
      final (:missing, :extra, :toExport) = meta;

      if (toExport.isEmpty) {
        reporter.atNode(
          export,
          _code,
          arguments: ['No public API to export. Useless export.'],
        );
        return;
      }

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

extension on Source {
  String? get packageName {
    if (uri.scheme != 'package') return null;

    return uri.pathSegments.elementAtOrNull(0);
  }
}

({
  Iterable<Element> missing,
  Iterable<SimpleIdentifier> extra,
  List<Element> toExport,
})? _computeExportDiff(ExportDirective export) {
  final exportedLibrary = export.element!.exportedLibrary!;
  final exportedPackageName = exportedLibrary.source.packageName;
  if (exportedPackageName == null) {
    return null;
  }

  final exportedIdentifiers = exportedLibrary.exportedElements
      .where((e) {
        var targets = _Public.of(e);
        if (targets.isEmpty && e.hasInternal) return false;

        if (targets.isEmpty) {
          targets = _Public.of(e.library!);
        }

        if (targets.isEmpty) {
          targets = _Public.defaultOf(export, e);
        }
        if (targets.isEmpty) return false;

        final match = targets
            .where((public) => public.hasMatch(export.element!))
            .firstOrNull;

        return match != null;
      })
      .nonNulls
      .toList();

  final show = export.combinators.whereType<ShowCombinator>().firstOrNull;

  final missing = exportedIdentifiers.where(
    (e) => show == null || !show.shownNames.map((e) => e.name).contains(e.name),
  );

  final extra = show?.shownNames.where(
    (e) => !exportedIdentifiers.map((e) => e.name).contains(e.name),
  );

  return (
    missing: missing,
    extra: extra ?? const [],
    toExport: exportedIdentifiers,
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

      final meta = _computeExportDiff(export);
      if (meta == null) return;

      final (:missing, :extra, :toExport) = meta;
      if (toExport.isEmpty) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Update show list',
        priority: 100,
      );

      final show = export.combinators.whereType<ShowCombinator>().firstOrNull;

      changeBuilder.addDartFileEdit((builder) {
        if (show == null) {
          builder.addInsertion(export.semicolon.offset, (builder) {
            builder.write('show ');
            final allExported = toExport.map((e) => e.name).join(', ');
            builder.write(allExported);
          });
          return;
        }

        // Delete extra elements
        range
            .combinatorAll(
              show,
              extra,
              // Only delete "show" if no other elements are added
              canRemoveWholeCombinator: missing.isEmpty,
            )
            .forEach(builder.addDeletion);

        // Insert the missing elements
        if (missing.isNotEmpty) {
          builder.addInsertion(export.semicolon.offset, (builder) {
            builder.write(', ');
            final unexportedElements = missing.map((e) => e.name).join(', ');
            builder.write(unexportedElements);
          });
        }
      });
    });
  }
}

extension on Iterable<int> {
  List<({int startIndex, int endIndex})> foldIndexes() {
    final sorted = toList()..sort();

    return sorted.fold([], (acc, index) {
      final last = acc.lastOrNull;
      if (last == null || last.endIndex != index - 1) {
        acc.add((startIndex: index, endIndex: index));
      } else {
        acc.last = (startIndex: last.startIndex, endIndex: index);
      }

      return acc;
    });
  }
}

extension on RangeFactory {
  Iterable<SourceRange> combinatorAll(
    Combinator combinator,
    Iterable<SimpleIdentifier> nodes, {
    required bool canRemoveWholeCombinator,
  }) {
    final list = switch (combinator) {
      ShowCombinator() => combinator.shownNames,
      HideCombinator() => combinator.hiddenNames,
    };

    final indexes =
        nodes.map(list.indexOf).where((index) => index != -1).toList();

    final grouped = indexes.foldIndexes();

    return [
      for (final group in grouped)
        this.combinator(
          combinator,
          from: group.startIndex,
          to: group.endIndex,
          canRemoveWholeCombinator: canRemoveWholeCombinator,
        ),
    ];
  }

  SourceRange combinator(
    Combinator combinator, {
    required int from,
    required int to,
    required bool canRemoveWholeCombinator,
  }) {
    final list = switch (combinator) {
      ShowCombinator() => combinator.shownNames,
      HideCombinator() => combinator.hiddenNames,
    };
    if (from == to) {
      return nodeInList(list, list[from]);
    } else if (from == 0) {
      if (to == list.length - 1) {
        // All existing elements are removed.
        if (canRemoveWholeCombinator) {
          // Remove combinator entirely
          return node(combinator);
        } else {
          // More show will be added, so we keep the keyword and remove all identifiers
          return startEnd(combinator, list[from]);
        }
      } else {
        // Remove a subset of the list starting with the first argument.
        return startStart(list[from], list[to + 1]);
      }
    } else {
      // Remove a subset of the list starting in the middle of the
      // list.
      return endEnd(list[from - 1], list[to]);
    }
  }
}

class _Public {
  _Public({required this.library, required this.packageName});

  static const type = TypeChecker.fromName('Public', packageName: 'riverpod');
  static const allOf = TypeChecker.fromName('AllOf', packageName: 'riverpod');

  static List<_Public> of(Element element) {
    final annotations = type.annotationsOfExact(
      element,
      throwOnUnresolved: false,
    );

    return [
      for (final annotation in annotations)
        _Public(
          library: annotation.getField('library')!.toStringValue()!,
          packageName: annotation.getField('packageName')?.toStringValue(),
        ),
      for (final allOf in allOf.annotationsOfExact(
        element,
        throwOnUnresolved: false,
      ))
        for (final public in allOf.getField('public')!.toListValue()!)
          _Public(
            library: public.getField('library')!.toStringValue()!,
            packageName: public.getField('packageName')?.toStringValue(),
          ),
    ];
  }

  final String library;
  final String? packageName;

  bool hasMatch(LibraryExportElement e) {
    final uri = e.source.uri;

    if (packageName != null && packageName != e.source.packageName) {
      return false;
    }

    final actualLibrary = uri.pathSegments.skip(1).join('/');
    return library == p.withoutExtension(actualLibrary);
  }

  @override
  String toString() => 'Public(library: $library, packageName: $packageName)';

  static List<_Public> defaultOf(
    ExportDirective export,
    Element element,
  ) {
    final definingPackageName = element.source!.packageName;
    if (definingPackageName == 'riverpod' ||
        definingPackageName == 'flutter_riverpod' ||
        definingPackageName == 'hooks_riverpod') {
      return [
        _Public(library: 'riverpod', packageName: 'riverpod'),
        _Public(library: 'flutter_riverpod', packageName: 'flutter_riverpod'),
        _Public(library: 'hooks_riverpod', packageName: 'hooks_riverpod'),
      ];
    }

    if (definingPackageName == 'state_notifier' &&
        element.name == 'StateNotifier') {
      return [
        _Public(library: 'legacy', packageName: 'riverpod'),
        _Public(library: 'legacy', packageName: 'flutter_riverpod'),
        _Public(library: 'legacy', packageName: 'hooks_riverpod'),
      ];
    }

    final exportedPackageName =
        export.element!.exportedLibrary!.source.packageName;
    return [
      if (exportedPackageName != null)
        _Public(library: exportedPackageName, packageName: exportedPackageName),
    ];
  }
}
