import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

@internal
class ShowAll extends AnalysisRule {
  ShowAll()
    : super(name: 'show_all_public_api', description: 'Show all public API');

  static const code = LintCode(
    'show_all_public_api',
    '{0}',
    severity: DiagnosticSeverity.ERROR,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    if (!context.isInLibDir) return;
    if (context.isInSrc) return;

    final visitor = _Visitor(this, context);
    registry.addExportDirective(this, visitor);
  }
}

extension IsInSrc on RuleContext {
  bool get isInSrc => p.split(definingUnit.file.path).contains('src');
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final ShowAll rule;
  final RuleContext context;

  @override
  void visitExportDirective(ExportDirective export) {
    if (export.libraryExport?.metadata.hasDeprecated ?? true) return;

    final exportedLibrary = export.libraryExport?.exportedLibrary2;
    if (exportedLibrary == null) return;

    final meta = _computeExportDiff(export);
    if (meta == null) return;
    final (:missing, :extra, :toExport) = meta;

    if (toExport.isEmpty) {
      rule.reportAtToken(
        export.exportKeyword,
        arguments: ['No public API to export. Useless export.'],
      );
      return;
    }

    if (missing.isNotEmpty) {
      final allMissing = missing.map((e) => e.displayName).join(', ');
      rule.reportAtToken(
        export.exportKeyword,
        arguments: ['Missing show: $allMissing'],
      );
    }

    if (extra.isNotEmpty) {
      final allExtra = extra.map((e) => e.name).join(', ');
      rule.reportAtToken(
        export.exportKeyword,
        arguments: ['Extra show: $allExtra'],
      );
    }
  }
}

extension on LibraryElement2 {
  Set<Element2> get exportedElements {
    return exportNamespace.definedNames2.values
        .map((e) => e.nonSynthetic2)
        .toSet();
  }
}

({
  Iterable<Element2> missing,
  Iterable<SimpleIdentifier> extra,
  List<Element2> toExport,
})?
_computeExportDiff(ExportDirective export) {
  final exportedLibrary = export.libraryExport!.exportedLibrary2;
  final exportedPackageName = exportedLibrary?.packageName;
  if (exportedPackageName == null) {
    return null;
  }

  final exportedIdentifiers = exportedLibrary!.exportedElements
      .where((e) {
        final annotatable = e as Annotatable;

        var targets = _Public.of(annotatable);
        if (targets.isEmpty && annotatable.metadata2.hasInternal) return false;

        if (targets.isEmpty) targets = _Public.of(e.library2!);
        if (targets.isEmpty) targets = _Public.defaultOf(export, e);
        if (targets.isEmpty) return false;

        final match = targets
            .where((public) => public.hasMatch(export.libraryExport!))
            .firstOrNull;

        return match != null;
      })
      .nonNulls
      .toList();

  final show = export.combinators.whereType<ShowCombinator>().firstOrNull;

  final missing = exportedIdentifiers.where(
    (e) =>
        show == null || !show.shownNames.map((e) => e.name).contains(e.name3),
  );

  final extra = show?.shownNames.where(
    (e) => !exportedIdentifiers.map((e) => e.name3).contains(e.name),
  );

  return (
    missing: missing,
    extra: extra ?? const [],
    toExport: exportedIdentifiers,
  );
}

@internal
class ShowAllFix extends ResolvedCorrectionProducer {
  ShowAllFix({required super.context});

  static const _removeAwaitKind = FixKind(
    'dart.fix.updateExportShow',
    DartFixKindPriority.standard,
    'Add missing and remove `show` elements',
  );

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _removeAwaitKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final export = node;
    if (export is! ExportDirective) return;

    final meta = _computeExportDiff(export);
    if (meta == null) return;

    final (:missing, :extra, :toExport) = meta;
    if (toExport.isEmpty) return;

    final show = export.combinators.whereType<ShowCombinator>().firstOrNull;

    await builder.addDartFileEdit(file, (builder) {
      if (show == null) {
        builder.addInsertion(export.semicolon.offset, (builder) {
          builder.write('show ');
          final allExported = toExport.map((e) => e.name3).join(', ');
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
          final unexportedElements = missing.map((e) => e.name3).join(', ');
          builder.write(unexportedElements);
        });
      }
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

    final indexes = nodes
        .map(list.indexOf)
        .where((index) => index != -1)
        .toList();

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

  static List<_Public> of(Annotatable element) {
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

  bool hasMatch(LibraryExport e) {
    final uri = e.libraryFragment.source.uri;

    if (packageName != null && packageName != e.exportedLibrary2!.packageName) {
      return false;
    }

    final actualLibrary = uri.pathSegments.skip(1).join('/');
    return library == p.withoutExtension(actualLibrary);
  }

  @override
  String toString() => 'Public(library: $library, packageName: $packageName)';

  static List<_Public> defaultOf(ExportDirective export, Element2 element) {
    final definingPackageName = element.library2!.packageName;
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
        element.name3 == 'StateNotifier') {
      return [
        _Public(library: 'legacy', packageName: 'riverpod'),
        _Public(library: 'legacy', packageName: 'flutter_riverpod'),
        _Public(library: 'legacy', packageName: 'hooks_riverpod'),
      ];
    }

    final exportedPackageName =
        export.libraryExport!.exportedLibrary2!.packageName;
    return [
      if (exportedPackageName != null)
        _Public(library: exportedPackageName, packageName: exportedPackageName),
    ];
  }
}

extension on LibraryElement2 {
  String? get packageName {
    if (uri.scheme != 'package') return null;

    return uri.pathSegments.first;
  }
}
