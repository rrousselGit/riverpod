import 'package:analyzer/dart/ast/ast.dart';

extension ObjectUtils<ObjT> on ObjT? {
  NewT? safeCast<NewT>() {
    final that = this;
    if (that is NewT) return that;
    return null;
  }

  NewT? let<NewT>(NewT Function(ObjT)? cb) {
    final that = this;
    if (that == null) return null;
    return cb?.call(that);
  }
}

extension AstUtils on AstNode {
  Iterable<AstNode> get ancestors sync* {
    var parent = this.parent;
    while (parent != null) {
      yield parent;
      parent = parent.parent;
    }
  }
}
