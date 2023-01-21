import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

import 'analyzer_utils.dart';
import 'dependencies.dart';

/// The representation of a provider definition
@immutable
@sealed
class ProviderExpression {
  /// The representation of a provider definition
  ProviderExpression._(this.node, this.element);

  /// The [AstNode] for the provider definition.
  final VariableDeclaration node;

  /// The [Element] that defines the provieer
  final VariableElement element;

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
  static FutureOr<ProviderExpression?> tryParse(AstNode providerExpression) {
    if (providerExpression is PropertyAccess) {
      // watch(family(0).modifier)
      final target = providerExpression.target;
      if (target != null) return ProviderExpression.tryParse(target);
    } else if (providerExpression is PrefixedIdentifier) {
      // watch(provider.modifier)
      return ProviderExpression.tryParse(providerExpression.prefix);
    } else if (providerExpression is Identifier) {
      // watch(variable)
      final Object? staticElement = providerExpression.staticElement;
      if (staticElement is PropertyAccessorElement) {
        // TODO can this be removed?
        return findAstNodeForElement(staticElement.declaration.variable)
            .then((ast) {
          if (ast is VariableDeclaration) {
            return ProviderExpression._(
              ast,
              staticElement.declaration.variable,
            );
          }
          return null;
        });
      }
    } else if (providerExpression is FunctionExpressionInvocation) {
      // watch(family(id))
      return ProviderExpression.tryParse(providerExpression.function);
    } else if (providerExpression is MethodInvocation) {
      // watch(variable.select(...)) or watch(family(id).select(...))
      final target = providerExpression.target;
      if (target != null) return ProviderExpression.tryParse(target);
    }

    return null;
  }

  /// Finds the "dependencies:" expression in a provider creation
  ///
  /// Returns null if failed to parse.
  /// Returns Result(null) if successfully passed but no dependencies was specified
  static Optional<NamedExpression>? _findDependenciesExpression(
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

    return Optional(
      argumentList.arguments
          .whereType<NamedExpression>()
          .firstWhereOrNull((e) => e.name.label.name == 'dependencies'),
    );
  }

  /// Decode the parameter "dependencies" from a provider
  ///
  /// Returns null if failed to decode.
  /// Returns a [Optional] with `value` as null if the parameter "dependencies" was
  /// not specified.
  static Future<Optional<List<ProviderDependency>>?> _findDependencies(
    Optional<NamedExpression>? dependenciesExpressionResult,
  ) async {
    if (dependenciesExpressionResult == null) return null;
    final namedExpression = dependenciesExpressionResult.value;
    if (namedExpression == null) return const Optional(null);
    final value = namedExpression.expression;
    if (value is! ListLiteral) return null;

    return Optional(
      await Stream.fromIterable(value.elements)
          .asyncMap((node) async {
            final origin = await ProviderExpression.tryParse(node);
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

  /// The statically analyzed `dependencies` parameter a provider receives.
  late final dependencies = _findDependencies(dependenciesExpression);

  /// Is the provider possibly non-root (such as if it defines a `dependencies`).
  late final Future<bool> isScoped = dependencies.then((e) => e?.value != null);

  /// The provider name.
  ///
  /// This is not equivalent to `ProviderBase.name` but instead the static
  /// name.
  String get name => node.name2.lexeme;

  @override
  String toString() => node.toString();

  @override
  bool operator ==(Object other) {
    return other is ProviderExpression && element == other.element;
  }

  @override
  int get hashCode => element.hashCode;
}
