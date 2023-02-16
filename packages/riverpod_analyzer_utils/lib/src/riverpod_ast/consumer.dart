part of '../riverpod_ast.dart';

abstract class ConsumerDeclaration extends RiverpodAst {}

class ConsumerWidgetDeclaration extends RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerWidgetDeclaration(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

class StatefulConsumerWidgetDeclaration extends RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitStatefulConsumerWidgetDeclaration(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}

class ConsumerStateDeclaration extends RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerStateDeclaration(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {}
}
