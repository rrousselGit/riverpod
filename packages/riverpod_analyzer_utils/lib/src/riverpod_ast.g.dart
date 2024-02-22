// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riverpod_ast.dart';

// **************************************************************************
// _LintVisitorGenerator
// **************************************************************************

abstract class RiverpodAstVisitor {}

abstract class GeneralizingRiverpodAstVisitor implements RiverpodAstVisitor {
  void visitRiverpodAst(RiverpodAst node) {
    node.visitChildren(this);
  }
}

abstract class RecursiveRiverpodAstVisitor implements RiverpodAstVisitor {}

abstract class SimpleRiverpodAstVisitor implements RiverpodAstVisitor {}

abstract class UnimplementedRiverpodAstVisitor implements RiverpodAstVisitor {}

@internal
class RiverpodAnalysisResult extends GeneralizingRiverpodAstVisitor {}

class _RiverpodAstRegistryVisitor extends GeneralizingRiverpodAstVisitor {
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

  @override
  void visitRiverpodAst(RiverpodAst node) {
    node.visitChildren(this);
  }
}

class RiverpodAstRegistry {
  void run(RiverpodAst node) {
    node.accept(_RiverpodAstRegistryVisitor(this));
  }

  final _onRiverpodAst = <void Function(RiverpodAst)>[];
  void addRiverpodAst(void Function(RiverpodAst node) cb) {
    _onRiverpodAst.add(cb);
  }
}

// ignore_for_file: type=lint
