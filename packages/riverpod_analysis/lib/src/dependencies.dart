import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'analyzer_utils.dart';

class Result<T> {
  const Result(this.value);
  final T value;

  @override
  String toString() => 'Result($value)';
}

abstract class GeneralProviderDeclaration {
  String get name;

  /// Decode a provider expression to extract the provider listened.
  ///
  /// For example, for:
  ///
  /// ```dart
  /// family(42).select(...)
  /// ```
  ///
  /// this will return the variable definition of `family`.
  ///
  /// Returns `null` if failed to decode the expression.
  // TODO fuse with riverpod_graph
  static FutureOr<ProviderDeclaration?> tryParse(AstNode providerExpression) {
    if (providerExpression is PropertyAccess) {
      // watch(family(0).modifier)
      final target = providerExpression.target;
      if (target != null) return GeneralProviderDeclaration.tryParse(target);
    } else if (providerExpression is PrefixedIdentifier) {
      // watch(provider.modifier)
      return GeneralProviderDeclaration.tryParse(providerExpression.prefix);
    } else if (providerExpression is Identifier) {
      // watch(variable)
      final Object? staticElement = providerExpression.staticElement;
      if (staticElement is PropertyAccessorElement) {
        // TODO can this be removed?
        return findAstNodeForElement(staticElement.declaration.variable)
            .then((ast) {
          if (ast is VariableDeclaration) {
            return ProviderDeclaration(
              ast,
              staticElement.declaration.variable,
            );
          }
          return null;
        });
      }
    } else if (providerExpression is FunctionExpressionInvocation) {
      // watch(family(id))
      return GeneralProviderDeclaration.tryParse(providerExpression.function);
    } else if (providerExpression is MethodInvocation) {
      // watch(variable.select(...)) or watch(family(id).select(...))
      final target = providerExpression.target;
      if (target != null) return GeneralProviderDeclaration.tryParse(target);
    }

    return null;
  }

  /// Decode a provider expression to extract the provider listened.
  ///
  /// For example, for:
  ///
  /// ```dart
  /// family(42).select(...)
  /// ```
  ///
  /// this will return the variable definition of `family`.
  ///
  /// Returns `null` if failed to decode the expression.
  // TODO fuse with riverpod_graph
  static FutureOr<GeneralProviderDeclaration?> tryParseGenerated(
    AstNode providerExpression,
  ) {
    if (providerExpression is PropertyAccess) {
      // watch(family(0).modifier)
      final target = providerExpression.target;
      if (target != null) {
        return GeneralProviderDeclaration.tryParseGenerated(target);
      }
    } else if (providerExpression is PrefixedIdentifier) {
      // watch(provider.modifier)
      return GeneralProviderDeclaration.tryParseGenerated(
        providerExpression.prefix,
      );
    } else if (providerExpression is Identifier) {
      // watch(variable)
      return ProviderDeclarationGenerated(providerExpression.toSource());
    } else if (providerExpression is FunctionExpressionInvocation) {
      // watch(family(id))
      return GeneralProviderDeclaration.tryParseGenerated(
        providerExpression.function,
      );
    } else if (providerExpression is MethodInvocation) {
      // watch(variable.select(...)) or watch(family(id).select(...))
      final target = providerExpression.target;
      if (target != null) {
        return GeneralProviderDeclaration.tryParseGenerated(target);
      }
      return ProviderDeclarationGenerated(providerExpression.methodName.name);
    }
    return null;
  }
}

@immutable
class ProviderDeclarationGenerated extends GeneralProviderDeclaration {
  ProviderDeclarationGenerated(this.name);

  @override
  final String name;

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) {
    return other is ProviderDeclarationGenerated && name == other.name;
  }

  @override
  int get hashCode => name.hashCode;
}

@immutable
class ProviderDeclaration extends GeneralProviderDeclaration {
  ProviderDeclaration(this.node, this.element);

  final VariableDeclaration node;
  final VariableElement element;

  /// Finds the "dependencies:" expression in a provider creation
  ///
  /// Returns null if failed to parse.
  /// Returns Result(null) if successfully passed but no dependencies was specified
  static Result<NamedExpression?>? _findDependenciesExpression(
    VariableDeclaration node,
  ) {
    final initializer = node.initializer;
    ArgumentList argumentList;

    if (initializer is InstanceCreationExpression) {
      argumentList = initializer.argumentList;
    } else if (initializer is FunctionExpressionInvocation) {
      argumentList = initializer.argumentList;
    } else {
      return null;
    }

    return Result(
      argumentList.arguments
          .whereType<NamedExpression>()
          .firstWhereOrNull((e) => e.name.label.name == 'dependencies'),
    );
  }

  /// Decode the parameter "dependencies" from a provider
  ///
  /// Returns null if failed to decode.
  /// Returns a [Result] with `value` as null if the parameter "dependencies" was
  /// not specified.
  static Future<Result<List<ProviderDependency>?>?> _findDependencies(
    Result<NamedExpression?>? dependenciesExpressionResult,
  ) async {
    if (dependenciesExpressionResult == null) return null;
    final namedExpression = dependenciesExpressionResult.value;
    if (namedExpression == null) return const Result(null);
    final value = namedExpression.expression;
    if (value is! ListLiteral) return null;

    return Result(
      await Stream.fromIterable(value.elements)
          .asyncMap((node) async {
            final origin = await GeneralProviderDeclaration.tryParse(node);
            if (origin == null) return null;
            return ProviderDependency(origin, node);
          })
          .where((e) => e != null)
          .cast<ProviderDependency>()
          .toList(),
    );
  }

  /// The [AstNode] that points to the `dependencies` parameter of a provider
  late final dependenciesExpression = _findDependenciesExpression(node);

  /// The decoded `dependencies` of a provider
  late final dependencies = _findDependencies(dependenciesExpression);

  late final Future<bool> isScoped = dependencies.then((e) => e?.value != null);

  @override
  String get name => node.name2.lexeme;

  @override
  String toString() => node.toString();

  @override
  bool operator ==(Object other) {
    return other is ProviderDeclaration && element == other.element;
  }

  @override
  int get hashCode => element.hashCode;
}

@immutable
class ProviderDependency {
  const ProviderDependency(this.origin, this.node);

  /// The provider that is depended on
  final ProviderDeclaration origin;

  /// The [AstNode] associated with this dependency
  final AstNode node;
}
