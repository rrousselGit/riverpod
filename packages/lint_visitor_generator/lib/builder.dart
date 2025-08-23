import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart' hide TypeChecker;

/// Builds generators for `build_runner` to run
Builder lintVisitorGenerator(BuilderOptions options) {
  return SharedPartBuilder([_LintVisitorGenerator()], 'lint_visitor_generator');
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
    if (library.element.name3 == 'nodes') {
      _writeRiverpodAstVisitor(library, buffer);
    }

    if (buffer.isNotEmpty) {
      buffer.writeln('// ignore_for_file: type=lint');
    }

    return buffer.toString();
  }

  void _writeRiverpodAstVisitor(LibraryReader library, StringBuffer buffer) {
    final allAst = library.element.extensions
        .where(
      (e) => e.metadata2.annotations.firstOrNull?.toSource() == '@_ast',
    )
        .expand((extension) {
      final constraint = extension.extendedType;

      return extension.getters2
          .map(
            (e) => (
              constraint: constraint.element3!.name3!,
              type: e.returnType.element3!.name3!,
              name: e.name3!,
            ),
          )
          .where((e) => !e.name.startsWith('_cache'));
    }).toList();

    final byConstraint =
        <({String type, String name}), List<({String type, String name})>>{};
    for (final ast in allAst) {
      byConstraint.putIfAbsent(
        (
          type: ast.constraint,
          name: ast.constraint == 'AstNode' ? 'Node' : ast.constraint,
        ),
        () => [],
      ).add((type: ast.type, name: ast.name));
    }

    buffer.writeln('''
mixin RiverpodAstVisitor {
  ${allAst.map((e) => 'void visit${e.type}(${e.type} node) {}').join('\n')}
}

abstract class RecursiveRiverpodAstVisitor
    extends GeneralizingAstVisitor<void>
    with RiverpodAstVisitor {
  ${byConstraint.entries.map(
              (e) => '''
@override
void visit${e.key.name}(${e.key.type} node) {
  ${e.value.map(
                        (e) => '''
  if (node.${e.name} case final value?) {
    visit${e.type}(value);
    return;
  }
  ''',
                      ).join('\n')}

  super.visit${e.key.name}(node);
}''',
            ).join('\n')}

  ${allAst.map(
              (e) => '''
  void visit${e.type}(${e.type} node) {
    super.visit${e.constraint == 'AstNode' ? 'Node' : e.constraint}(node.node);
  }
  ''',
            ).join('\n')}

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
class CollectionRiverpodAst extends SimpleRiverpodAstVisitor {
  final Map<String, List<Object>> riverpodAst = {};
  List<Object?>? _pendingList;

${byConstraint.keys.map(
              (e) => '''
  @override
  void visit${e.name}(
    ${e.type} node,
  ) {
    final list = riverpodAst.putIfAbsent('${e.type}', () => []);
    final previousList = list;
    _pendingList = list;
    super.visit${e.name}(node);
    _pendingList = previousList;
  }
''',
            ).join('\n')}

${allAst.map(
              (e) => '''
  void visit${e.type}(${e.type} node) {
    _pendingList!.add(node);
  }
''',
            ).join('\n')}
}

@internal
class RiverpodAnalysisResult extends RecursiveRiverpodAstVisitor {
  final List<RiverpodAnalysisError> errors = [];

    ${allAst.map(
              (e) => '''
  final ${e.type.lowerFirst.plural} = <${e.type}>[];
  @override
  void visit${e.type}(
    ${e.type} node,
  ) {
    super.visit${e.type}(node);
    ${e.type.lowerFirst.plural}.add(node);
  }
''',
            ).join('\n')}
}

class RiverpodAstRegistry {
  static final _cache = Expando<Box<List<RiverpodAnalysisError>>>();

  void run(AstNode node) {
    final previousErrorReporter = errorReporter;
    try {
      final errors = _cache.upsert(
        node,
        () => <RiverpodAnalysisError>[],
      );

      final visitor = _RiverpodAstRegistryVisitor(this);
      errorReporter = errors.add;

      node.accept(visitor);
      for (final error in errors) {
        visitor._runSubscriptions(error, _onRiverpodAnalysisError);
      }
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

  ${allAst.map(
              (e) => '''
  final _on${e.type} = <void Function(${e.type})>[];
  void add${e.type}(void Function(${e.type} node) cb) {
    _on${e.type}.add(cb);
  }
''',
            ).join('\n')}
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

  ${allAst.map(
              (e) => '''
  @override
  void visit${e.type}(${e.type} node) {
    super.visit${e.type}(node);
    _runSubscriptions(
      node,
      _registry._on${e.type},
    );
  }

''',
            ).join('\n')}
}
''');
  }
}

extension on String {
  String get lowerFirst => substring(0, 1).toLowerCase() + substring(1);
}
