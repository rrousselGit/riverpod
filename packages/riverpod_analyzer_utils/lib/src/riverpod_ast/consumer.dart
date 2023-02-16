part of '../riverpod_ast.dart';

abstract class ConsumerDeclaration extends RiverpodAst {}

class ConsumerWidgetDeclaration extends RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerWidgetDeclaration(this);
  }
}

class StatefulConsumerWidgetDeclaration extends RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitStatefulConsumerWidgetDeclaration(this);
  }
}

class ConsumerStateDeclaration extends RiverpodAst {
  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitConsumerStateDeclaration(this);
  }
}
