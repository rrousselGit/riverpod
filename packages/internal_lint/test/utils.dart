import 'dart:io';

import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/listener.dart';
// The analyzer has no public way to run rules.
import 'package:analyzer/src/lint/linter_visitor.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Creates a folder with [files] (path relative to the folder -> content),
/// deleted after the test.
///
/// It is within this package, so that its Dart files can import the packages
/// of the workspace.
Directory createFixture(Map<String, String> files) {
  final parent = Directory(p.join('.dart_tool', 'internal_lint_test'))
    ..createSync(recursive: true);
  final root = parent.createTempSync().absolute;
  addTearDown(() => root.deleteSync(recursive: true));

  for (final MapEntry(:key, :value) in files.entries) {
    File(p.join(root.path, key))
      ..createSync(recursive: true)
      ..writeAsStringSync(value);
  }
  return root;
}

/// Resolves the library at [filePath] and runs [rule] on it, the way the analysis
/// server does. Exceptions of the rule are rethrown.
Future<List<Diagnostic>> runRule(AnalysisRule rule, String filePath) async {
  final path = p.normalize(p.absolute(filePath));
  final collection = AnalysisContextCollection(includedPaths: [path]);
  final session = collection.contextFor(path).currentSession;
  final library = await session.getResolvedLibrary(path);
  if (library is! ResolvedLibraryResult) {
    throw StateError('Could not resolve $path: $library');
  }

  final listener = RecordingDiagnosticListener();
  final units = [
    for (final unit in library.units)
      (
        unit: unit,
        context: RuleContextUnit(
          file: session.resourceProvider.getFile(unit.path),
          content: unit.content,
          diagnosticReporter: DiagnosticReporter(
            listener,
            unit.libraryFragment.source,
          ),
          unit: unit.unit,
        ),
      ),
  ];

  final registry = RuleVisitorRegistryImpl(enableTiming: false);
  rule.registerNodeProcessors(
    registry,
    _RuleContext(
      allUnits: [for (final unit in units) unit.context],
      definingUnit: units.first.context,
      libraryElement: library.element,
    ),
  );

  final visitor = AnalysisRuleVisitor(
    registry,
    shouldPropagateExceptions: true,
  );
  for (final unit in units) {
    rule.reporter = unit.context.diagnosticReporter;
    unit.unit.unit.accept(visitor);
  }
  visitor.afterLibrary();

  return listener.diagnostics.toList()
    ..sort((a, b) => a.offset.compareTo(b.offset));
}

class _RuleContext implements RuleContext {
  _RuleContext({
    required this.allUnits,
    required this.definingUnit,
    required this.libraryElement,
  });

  @override
  final List<RuleContextUnit> allUnits;

  @override
  final RuleContextUnit definingUnit;

  @override
  final LibraryElement libraryElement;

  // Like the analysis server, while processors are being registered.
  @override
  RuleContextUnit? get currentUnit => null;

  @override
  Object? noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
