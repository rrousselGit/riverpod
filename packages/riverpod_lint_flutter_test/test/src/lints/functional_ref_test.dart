import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/listener.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:riverpod_lint/src/lints/functional_ref.dart';
import 'package:test/test.dart';

import '../../context.dart';
import '../../io_utils.dart';
import '../../registry.dart';

Future<void> main() async {
  group('with riverpod_annotation imported with a prefix', () {
    late final CompilationUnit unit;
    late final List<Diagnostic> diagnostics;

    setUpAll(() async {
      (:unit, :diagnostics) = await _analyze(
        p.join(
          'test',
          'lints',
          'functional_ref',
          'prefixed_functional_ref.dart',
        ),
      );
    });

    test('accepts a prefixed Ref', () {
      expect(
        _reportedDeclarations(unit, diagnostics),
        isNot(contains('prefixedRef')),
      );
    });

    test('reports a prefixed type which is not Ref', () {
      expect(_reportedDeclarations(unit, diagnostics), ['prefixedWrongType']);
      expect(
        diagnostics.single.offset,
        _firstParameterType(unit, 'prefixedWrongType').offset,
      );
    });
  });

  test('without a prefix, reports the same declarations as before', () async {
    final (:unit, :diagnostics) = await _analyze(
      p.join('test', 'lints', 'functional_ref', 'failing_functional_ref.dart'),
    );

    expect(_reportedDeclarations(unit, diagnostics), [
      'refless',
      'incorrectlyTyped',
      'noRefButArgs',
    ]);
  });
}

Future<({CompilationUnit unit, List<Diagnostic> diagnostics})> _analyze(
  String relativePath,
) async {
  final path = p.normalize(p.absolute(relativePath));
  final collection = AnalysisContextCollection(
    includedPaths: [path],
    sdkPath: dartSdkPath,
  );
  final session = collection.contextFor(path).currentSession;

  final unit = await session.getResolvedUnit(path) as ResolvedUnitResult;
  final library =
      await session.getResolvedLibrary(path) as ResolvedLibraryResult;

  return (
    unit: unit.unit,
    diagnostics: _run(FunctionalRef(), unit: unit, library: library),
  );
}

/// Runs [rule] against [unit] and returns the diagnostics it emitted.
List<Diagnostic> _run(
  AbstractAnalysisRule rule, {
  required ResolvedUnitResult unit,
  required ResolvedLibraryResult library,
}) {
  final previousErrorReporter = errorReporter;
  errorReporter = (_) {};

  try {
    final diagnosticsListener = RecordingDiagnosticListener();
    final registry = Registry();

    rule.reporter = DiagnosticReporter(
      diagnosticsListener,
      unit.libraryFragment.source,
    );
    rule.registerNodeProcessors(
      registry,
      Context.fromResolvedUnitResult(unit, library, diagnosticsListener),
    );

    unit.unit.accept(_InvokeVisitor(registry));

    return diagnosticsListener.diagnostics;
  } finally {
    errorReporter = previousErrorReporter;
  }
}

/// The names of the functions of [unit] that [diagnostics] point into.
List<String> _reportedDeclarations(
  CompilationUnit unit,
  List<Diagnostic> diagnostics,
) {
  return [
    for (final diagnostic in diagnostics)
      unit.declarations
          .whereType<FunctionDeclaration>()
          .firstWhere(
            (e) => diagnostic.offset >= e.offset && diagnostic.offset <= e.end,
          )
          .name
          .lexeme,
  ];
}

TypeAnnotation _firstParameterType(CompilationUnit unit, String name) {
  final function = unit.declarations
      .whereType<FunctionDeclaration>()
      .firstWhere((e) => e.name.lexeme == name);
  final parameter =
      function.functionExpression.parameters!.parameters.first
          as RegularFormalParameter;

  return parameter.type!;
}

class _InvokeVisitor extends GeneralizingAstVisitor<void> {
  _InvokeVisitor(this.registry);

  final Registry registry;

  @override
  void visitNode(AstNode node) {
    super.visitNode(node);

    for (final (_, visitor) in registry.visitors) {
      node.accept(visitor);
    }
  }
}
