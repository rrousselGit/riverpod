import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type_provider.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/workspace/workspace.dart';
import 'package:path/path.dart' as p;

class Context extends RuleContext {
  Context({
    required this.allUnits,
    required this.definingUnit,
    required this.typeProvider,
    required this.typeSystem,
    this.currentUnit,
    this.package,
    this.libraryElement,
  });

  @override
  final List<RuleContextUnit> allUnits;

  @override
  final RuleContextUnit? currentUnit;

  @override
  final RuleContextUnit definingUnit;

  @override
  final TypeProvider typeProvider;

  @override
  final TypeSystem typeSystem;

  @override
  final WorkspacePackage? package;

  @override
  final LibraryElement? libraryElement;

  @override
  bool get isInLibDir {
    final path = definingUnit.file.path;
    final segments = p.split(path);
    final libIndex = segments.indexOf('lib');
    return libIndex != -1;
  }

  @override
  bool get isInTestDirectory {
    final path = definingUnit.file.path;
    final segments = p.split(path);
    return segments.contains('test');
  }

  @override
  bool isFeatureEnabled(Feature feature) {
    // For testing purposes, assume all features are enabled
    // This can be customized based on the actual analysis session if needed
    return true;
  }

  /// Creates a [Context] from a [ResolvedUnitResult].
  ///
  /// This factory method extracts all necessary information from the resolved
  /// unit result, including the library result, and creates a fully configured
  /// context for use in analysis rules.
  static Context fromResolvedUnitResult(
    ResolvedUnitResult result,
    ResolvedLibraryResult libraryResult,
    DiagnosticListener diagnosticsListener,
  ) {
    // Create RuleContextUnit for each unit in the library
    final resourceProvider = result.session.resourceProvider;
    final allUnits =
        libraryResult.units.map((unit) {
          final reporter = DiagnosticReporter(
            diagnosticsListener,
            unit.libraryFragment.source,
          );

          return RuleContextUnit(
            file: resourceProvider.getFile(unit.path),
            content: unit.content,
            diagnosticReporter: reporter,
            unit: unit.unit,
          );
        }).toList();

    final definingUnit = allUnits.firstWhere(
      (u) => u.file.path == result.path,
    );

    return Context(
      allUnits: allUnits,
      definingUnit: definingUnit,
      typeProvider: result.typeProvider,
      typeSystem: result.typeSystem,
      package: null, // package - can be null for testing
      libraryElement: libraryResult.element,
    );
  }
}
