import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/listener.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:riverpod_lint/src/lints/prefer_keep_alive_annotation.dart';
import 'package:test/test.dart';

import 'context.dart';
import 'registry.dart';

/// The declarations of [_fixturePath] which are expected to be reported.
const _expectedReports = ['first', 'FirstClass'];

/// The declarations of [_fixturePath] which use `ref.keepAlive()` in a way
/// that `@Riverpod(keepAlive: true)` cannot express.
const _expectedNoReports = [
  'alreadyAnnotated',
  'conditional',
  'afterAwait',
  'linkKept',
  'notFirst',
  'insideClosure',
  'NotBuild',
  'notAProvider',
];

final _fixturePath = p.normalize(
  p.absolute('test', 'lints', 'prefer_keep_alive_annotation.dart'),
);

Future<void> main() async {
  late final CompilationUnit unit;
  late final List<Diagnostic> diagnostics;

  setUpAll(() async {
    final collection = AnalysisContextCollection(includedPaths: [_fixturePath]);
    final session = collection.contextFor(_fixturePath).currentSession;

    final unitResult =
        await session.getResolvedUnit(_fixturePath) as ResolvedUnitResult;
    final libraryResult =
        await session.getResolvedLibrary(_fixturePath) as ResolvedLibraryResult;

    unit = unitResult.unit;
    diagnostics = _run(
      PreferKeepAliveAnnotation(),
      unit: unitResult,
      library: libraryResult,
    );
  });

  test('reports providers which start with ref.keepAlive()', () {
    expect(
      diagnostics.map((e) => _declarationAt(unit, e.offset)),
      _expectedReports,
    );
  });

  test('does not report a keepAlive which the annotation cannot replace', () {
    final reported = diagnostics
        .map((e) => _declarationAt(unit, e.offset))
        .toSet();

    for (final declaration in _expectedNoReports) {
      expect(reported, isNot(contains(declaration)));
    }
  });
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

/// The name of the top-level declaration of [unit] containing [offset].
String _declarationAt(CompilationUnit unit, int offset) {
  for (final declaration in unit.declarations) {
    if (offset < declaration.offset || offset > declaration.end) continue;

    return switch (declaration) {
      FunctionDeclaration() => declaration.name.lexeme,
      ClassDeclaration() => declaration.namePart.typeName.lexeme,
      _ => declaration.toSource(),
    };
  }

  return 'unknown declaration at $offset';
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
