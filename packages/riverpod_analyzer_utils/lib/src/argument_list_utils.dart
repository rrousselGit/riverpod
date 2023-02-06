import 'package:analyzer/dart/ast/ast.dart';

/// Utilities for [ArgumentList] to help with specific argument retreival.
extension ArgumentListUtils on ArgumentList {
  /// Lists the positional arguments of an argument list.
  Iterable<Expression> positionalArguments() {
    return arguments.where((e) => e is! NamedExpression);
  }

  /// Lists the named arguments of an argument list.
  Iterable<NamedExpression> namedArguments() {
    return arguments.whereType<NamedExpression>();
  }
}
