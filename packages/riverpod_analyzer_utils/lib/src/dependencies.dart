import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

import '../riverpod_analyzer_utils.dart';

/// A class used to differentiate "no value" from "value but null".
class Optional<T> {
  /// A class used to differentiate "no value" from "value but null".
  const Optional(this.value);

  /// The value
  final T? value;

  @override
  String toString() => 'Optional($value)';
}

/// Metadata about a `dependency` parameter.
@immutable
class ProviderDependency {
  /// Metadata about a `dependency` parameter.
  const ProviderDependency(this.origin, this.node);

  /// The provider that is depended on
  final ProviderExpression origin;

  /// The [AstNode] associated with this dependency
  final AstNode node;
}
