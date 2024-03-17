import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

@internal
extension AstUtils on AstNode {
  R upsert<R>(
    String keyPart,
    R Function() create,
  ) {
    final key = 'riverpod.$keyPart';
    // Using a record to differentiate "null value" from "no value".
    final existing = getProperty<(R value,)>(key);
    if (existing != null) return existing.$1;

    final created = create();
    setProperty(key, (created,));
    return created;
  }

  Iterable<AstNode> get ancestors sync* {
    var parent = this.parent;
    while (parent != null) {
      yield parent;
      parent = parent.parent;
    }
  }
}
