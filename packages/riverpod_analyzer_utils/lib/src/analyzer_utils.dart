import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

@immutable
class _Key {
  const _Key(this.value, this.name);

  final Object value;
  final String name;

  @override
  bool operator ==(Object other) {
    return other is _Key && other.value == value && other.name == name;
  }

  @override
  int get hashCode => Object.hash(value, name);
}

class _Box<T> {
  _Box(this.value);
  final T value;
}

@internal
extension AstUtils on AstNode {
  static final _cache = Expando<_Box<Object?>>();
  R upsert<R>(
    String keyPart,
    R Function() create,
  ) {
    final key = _Key(this, keyPart);
    // Using a record to differentiate "null value" from "no value".
    final existing = _cache[key] as _Box<R>?;
    if (existing != null) return existing.value;

    final created = create();
    _cache[key] = _Box(created);
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
