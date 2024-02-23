// ignore_for_file: require_trailing_commas

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart' hide TypeChecker;

/// Builds generators for `build_runner` to run
Builder lintVisitorGenerator(BuilderOptions options) {
  return SharedPartBuilder(
    [_LintVisitorGenerator()],
    'lint_visitor_generator',
  );
}

extension on String {
  String get plural {
    if (endsWith('y')) return '${substring(0, length - 1)}ies';
    if (endsWith('s')) return '${this}List';
    return '${this}s';
  }
}

class _LintVisitorGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final buffer = StringBuffer();
    if (library.element.name == 'nodes') {
      _writeRiverpodAstVisitor(library, buffer);
    }

    if (buffer.isNotEmpty) {
      buffer.writeln('// ignore_for_file: type=lint');
    }

    return buffer.toString();
  }

  void _writeRiverpodAstVisitor(LibraryReader library, StringBuffer buffer) {
    final allAst = library.element.topLevelElements
        .whereType<ExtensionElement>()
        .where((e) => e.metadata.firstOrNull?.toSource() == '@_ast')
        .expand((extension) {
      final constraint = extension.extendedType;

      return extension.accessors.map(
        (e) => (
          constraint: constraint.element!.name!,
          type: e.returnType.element!.name!,
          name: e.name,
        ),
      );
    }).toList();

    final byConstraint = <String, List<({String type, String name})>>{};
    for (final ast in allAst) {
      byConstraint
          .putIfAbsent(ast.constraint, () => [])
          .add((type: ast.type, name: ast.name));
    }

    buffer.writeln('''
mixin RiverpodAstVisitor {
  ${allAst.map((e) => 'void visit${e.type}(${e.type} node) {}').join('\n')}
}

abstract class RecursiveRiverpodAstVisitor
    extends GeneralizingAstVisitor<void>
    with RiverpodAstVisitor {
  ${byConstraint.entries.map((e) => '''
void visit${e.key}(${e.key} node) {
  super.visit${e.key}(node);
  ${e.value.map((e) => 'node.${e.name}.let(visit${e.type});').join('\n')}
}''').join('\n')}
}

abstract class SimpleRiverpodAstVisitor
    extends RecursiveRiverpodAstVisitor {
  @override
  void visitNode(AstNode node) {}
}

abstract class UnimplementedRiverpodAstVisitor
    extends SimpleRiverpodAstVisitor {
  ${allAst.map((e) => 'void visit${e.type}(${e.type} node) => throw UnimplementedError();').join('\n')}
}

@internal
class RiverpodAnalysisResult extends RecursiveRiverpodAstVisitor {
  final List<RiverpodAnalysisError> errors = [];

    ${allAst.map((e) => '''
  final ${e.type.lowerFirst.plural} = <${e.type}>[];
  @override
  void visit${e.type}(
    ${e.type} node,
  ) {
    super.visit${e.type}(node);
    ${e.type.lowerFirst.plural}.add(node);
  }
''').join('\n')}
}

class RiverpodAstRegistry {
  void run(AstNode node) {
    final previousErrorReporter = errorReporter;
    try {
      final visitor = _RiverpodAstRegistryVisitor(this);
      errorReporter = (error) => visitor._runSubscriptions(error, _onRiverpodAnalysisError);
      node.accept(visitor);
    } finally {
      errorReporter = previousErrorReporter;
    }
  }

  final _onRiverpodAnalysisError = <void Function(RiverpodAnalysisError)>[];
  void addRiverpodAnalysisError(
    void Function(RiverpodAnalysisError node) cb,
  ) {
    _onRiverpodAnalysisError.add(cb);
  }

  ${allAst.map((e) => '''
  final _on${e.type} = <void Function(${e.type})>[];
  void add${e.type}(void Function(${e.type} node) cb) {
    _on${e.type}.add(cb);
  }
''').join('\n')}
}

class _RiverpodAstRegistryVisitor extends RecursiveRiverpodAstVisitor {
  _RiverpodAstRegistryVisitor(this._registry);

  final RiverpodAstRegistry _registry;

  void _runSubscriptions<R>(
    R value,
    List<void Function(R)> subscriptions,
  ) {
    for (final sub in subscriptions) {
      try {
        sub(value);
      } catch (e, stack) {
        Zone.current.handleUncaughtError(e, stack);
      }
    }
  }

  ${allAst.map((e) => '''
  @override
  void visit${e.type}(${e.type} node) {
    super.visit${e.type}(node);
    _runSubscriptions(
      node,
      _registry._on${e.type},
    );
  }

''').join('\n')}
}
''');
  }
}

extension on String {
  String get lowerFirst => substring(0, 1).toLowerCase() + substring(1);
}
