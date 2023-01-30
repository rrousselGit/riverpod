import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'riverpod_element.dart';
import 'riverpod_types.dart';
import 'riverpod_visitor.dart';

class RiverpodAnnotationDependency {
  RiverpodAnnotationDependency._({
    required this.node,
    required this.provider,
  });

  final Expression node;
  final RiverpodAnnotationDependencyElement provider;
}

class RiverpodAnnotation {
  RiverpodAnnotation._({
    required this.annotation,
    required this.element,
    required this.keepAliveNode,
    required this.dependencies,
    required this.dependenciesNode,
  });

  static RiverpodAnnotation? parse(AnnotatedNode node) {
    for (final annotation in node.metadata) {
      final elementAnnotation = annotation.elementAnnotation;
      final element = annotation.element;
      if (elementAnnotation == null || element == null) continue;
      if (element is! ExecutableElement ||
          !riverpodType.isExactlyType(element.returnType)) {
        // The annotation is not an @Riverpod
        continue;
      }

      final dartObject = elementAnnotation.computeConstantValue();
      if (dartObject == null) return null;

      NamedExpression? keepAliveNode;
      NamedExpression? dependenciesNode;
      final argumentList = annotation.arguments;
      if (argumentList != null) {
        for (final argument
            in argumentList.arguments.whereType<NamedExpression>()) {
          switch (argument.name.label.name) {
            case 'keepAlive':
              keepAliveNode = argument;
              break;
            case 'dependencies':
              dependenciesNode = argument;
              break;
          }
        }
      }

      final dependenciesNodeValue = dependenciesNode?.expression;

      if (dependenciesNodeValue != null &&
          dependenciesNodeValue is! ListLiteral) {
        throw RiverpodAnalysisException(
          '@Riverpod(dependencies: <...>) only support list literals (using []).',
          targetNode: dependenciesNodeValue,
        );
      }

      final dependencies = dependenciesNodeValue == null
          ? null
          : _parseDependencies(dependenciesNodeValue as ListLiteral).toList();

      return RiverpodAnnotation._(
        annotation: annotation,
        element: RiverpodAnnotationElement(
          keepAlive: RiverpodAnnotationElement.readKeepAlive(dartObject),
          dependencies: dependencies?.map((e) => e.provider).toList(),
        ),
        keepAliveNode: keepAliveNode,
        dependenciesNode: dependenciesNode,
        dependencies: dependencies,
      );
    }

    return null;
  }

  static Iterable<RiverpodAnnotationDependency> _parseDependencies(
    ListLiteral dependenciesNodeValue,
  ) sync* {
    for (final dependency in dependenciesNodeValue.elements) {
      if (dependency is! Expression) {
        throw RiverpodAnalysisException(
          '@Riverpod(dependencies: [...]) does not support if/for/spread operators.',
          targetNode: dependency,
        );
      } else if (dependency is SimpleIdentifier) {
        final dependencyElement = dependency.staticElement;
        if (dependencyElement is FunctionElement) {
          final dependencyProvider = StatelessProviderDeclarationElement.parse(
            dependencyElement,
            annotation: null,
          );
          if (dependencyProvider == null) {
            throw RiverpodAnalysisException(
              'The dependency $dependency is not a class annotated with @riverpod',
              targetNode: dependency,
            );
          }

          yield RiverpodAnnotationDependency._(
            node: dependency,
            provider: RiverpodAnnotationDependencyElement(dependencyProvider),
          );
        } else if (dependencyElement is ClassElement) {
          final dependencyProvider = StatefulProviderDeclarationElement.parse(
            dependencyElement,
            annotation: null,
          );
          if (dependencyProvider == null) {
            throw RiverpodAnalysisException(
              'The dependency $dependency is not a class annotated with @riverpod',
              targetNode: dependency,
            );
          }

          yield RiverpodAnnotationDependency._(
            node: dependency,
            provider: RiverpodAnnotationDependencyElement(dependencyProvider),
          );
        } else {
          throw RiverpodAnalysisException(
            '@Riverpod(dependencies: [...]) only supports elements annotated with @riverpod as values.',
            targetNode: dependency,
          );
        }
      } else {
        throw RiverpodAnalysisException(
          'Only elements annotated with @riverpod are supported as "dependencies".',
          targetNode: dependency,
        );
      }
    }
  }

  final Annotation annotation;
  final RiverpodAnnotationElement element;
  final NamedExpression? keepAliveNode;
  final List<RiverpodAnnotationDependency>? dependencies;
  final NamedExpression? dependenciesNode;
}

abstract class ProviderDeclaration {
  Token get name;
  AstNode get node;
  ProviderDeclarationElement get providerElement;
}

class LegacyProviderDependencies {
  LegacyProviderDependencies({
    required this.dependencies,
    required this.dependenciesNode,
  });

  static LegacyProviderDependencies? parse(NamedExpression? dependenciesNode) {
    if (dependenciesNode == null) return null;

    final value = dependenciesNode.expression;

    List<LegacyProviderDependency>? dependencies;
    if (value is ListLiteral) {
      dependencies =
          value.elements.map(LegacyProviderDependency.parse).toList();
    }

    return LegacyProviderDependencies(
      dependenciesNode: dependenciesNode,
      dependencies: dependencies,
    );
  }

  final List<LegacyProviderDependency>? dependencies;
  final NamedExpression dependenciesNode;
}

extension<T> on T? {
  R? cast<R>() {
    final that = this;
    if (that is R) return that;
    return null;
  }

  R? let<R>(R? Function(T value) cb) {
    final that = this;
    if (that != null) return cb(that);
    return null;
  }
}

class LegacyProviderDependency {
  LegacyProviderDependency({
    required this.node,
    required this.provider,
  });

  static LegacyProviderDependency parse(CollectionElement node) {
    final variableElement = node
        .cast<SimpleIdentifier>()
        ?.staticElement
        .cast<PropertyAccessorElement>()
        ?.variable;

    final providerElement =
        variableElement.let(LegacyProviderDeclarationElement.parse);

    return LegacyProviderDependency(
      node: node,
      provider: providerElement,
    );
  }

  final CollectionElement node;
  final LegacyProviderDeclarationElement? provider;
}

class LegacyProviderDeclaration implements ProviderDeclaration {
  LegacyProviderDeclaration({
    required this.name,
    required this.node,
    required this.build,
    required this.typeArguments,
    required this.providerElement,
    required this.dependencies,
    required this.argumentList,
    required this.provider,
    required this.autoDisposeModifier,
    required this.familyModifier,
  });

  static LegacyProviderDeclaration? parse(
    VariableDeclaration node,
  ) {
    final element = node.declaredElement;
    if (element == null) return null;

    final providerElement = LegacyProviderDeclarationElement.parse(element);
    if (providerElement == null) return null;

    final initializer = node.initializer;
    ArgumentList? arguments;
    late Identifier provider;
    SimpleIdentifier? autoDisposeModifier;
    SimpleIdentifier? familyModifier;
    TypeArgumentList? typeArguments;
    if (initializer is InstanceCreationExpression) {
      // Provider((ref) => ...)

      arguments = initializer.argumentList;
      provider = initializer.constructorName.type.name;
      typeArguments = initializer.constructorName.type.typeArguments;
    } else if (initializer is FunctionExpressionInvocation) {
      // Provider.modifier()

      void decodeIdentifier(SimpleIdentifier identifier) {
        switch (identifier.name) {
          case 'autoDispose':
            autoDisposeModifier = identifier;
            break;
          case 'family':
            familyModifier = identifier;
            break;
          default:
            provider = identifier;
        }
      }

      void decodeTarget(Expression? expression) {
        if (expression is SimpleIdentifier) {
          decodeIdentifier(expression);
        } else if (expression is PrefixedIdentifier) {
          decodeIdentifier(expression.identifier);
          decodeIdentifier(expression.prefix);
        } else {
          throw UnsupportedError(
            'unknown expression "$expression" (${expression.runtimeType})',
          );
        }
      }

      final modifier = initializer.function as PropertyAccess;

      decodeIdentifier(modifier.propertyName);
      decodeTarget(modifier.target);
      arguments = initializer.argumentList;
      typeArguments = initializer.typeArguments;
    } else {
      throw UnsupportedError('Unknown type ${initializer.runtimeType}');
    }

    final dependenciesElement = arguments.arguments
        .whereType<NamedExpression>()
        .firstWhereOrNull((e) => e.name.label.name == 'dependencies');

    final build = arguments.arguments.firstOrNull;
    if (build is! FunctionExpression) return null;

    return LegacyProviderDeclaration(
      name: node.name,
      node: node,
      build: build,
      providerElement: providerElement,
      argumentList: arguments,
      typeArguments: typeArguments,
      provider: provider,
      autoDisposeModifier: autoDisposeModifier,
      familyModifier: familyModifier,
      dependencies: LegacyProviderDependencies.parse(dependenciesElement),
    );
  }

  final LegacyProviderDependencies? dependencies;

  final FunctionExpression build;
  final ArgumentList argumentList;
  final Identifier provider;
  final SimpleIdentifier? autoDisposeModifier;
  final SimpleIdentifier? familyModifier;
  final TypeArgumentList? typeArguments;

  @override
  final LegacyProviderDeclarationElement providerElement;

  @override
  final Token name;

  @override
  final VariableDeclaration node;
}

abstract class GeneratorProviderDeclaration implements ProviderDeclaration {
  @override
  GeneratorProviderDeclarationElement get providerElement;

  RiverpodAnnotation get annotation;
}

class StatefulProviderDeclaration implements GeneratorProviderDeclaration {
  StatefulProviderDeclaration._({
    required this.name,
    required this.node,
    required this.buildMethod,
    required this.providerElement,
    required this.annotation,
  });

  @internal
  static StatefulProviderDeclaration? parse(
    ClassDeclaration node,
  ) {
    final element = node.declaredElement;
    if (element == null) return null;
    final riverpodAnnotation = RiverpodAnnotation.parse(node);
    if (riverpodAnnotation == null) return null;

    final buildMethod = node.members.whereType<MethodDeclaration>().firstWhere(
          (method) => method.name.lexeme == 'build',
          orElse: () => throw RiverpodAnalysisException(
            'No "build" method found. '
            'Classes annotated with @riverpod must define a method named "build".',
          ),
        );

    final providerElement = StatefulProviderDeclarationElement.parse(
      element,
      annotation: riverpodAnnotation.element,
    );
    if (providerElement == null) return null;

    return StatefulProviderDeclaration._(
      name: node.name,
      node: node,
      buildMethod: buildMethod,
      providerElement: providerElement,
      annotation: riverpodAnnotation,
    );
  }

  @override
  final Token name;

  @override
  final ClassDeclaration node;
  @override
  final GeneratorProviderDeclarationElement providerElement;

  @override
  final RiverpodAnnotation annotation;

  final MethodDeclaration buildMethod;
}

class StatelessProviderDeclaration implements GeneratorProviderDeclaration {
  StatelessProviderDeclaration._({
    required this.name,
    required this.node,
    required this.providerElement,
    required this.annotation,
  });

  @internal
  static StatelessProviderDeclaration? parse(
    FunctionDeclaration node,
  ) {
    final element = node.declaredElement;
    if (element == null) return null;
    final riverpodAnnotation = RiverpodAnnotation.parse(node);
    if (riverpodAnnotation == null) return null;

    final providerElement = StatelessProviderDeclarationElement.parse(
      element,
      annotation: riverpodAnnotation.element,
    );
    if (providerElement == null) return null;

    return StatelessProviderDeclaration._(
      name: node.name,
      node: node,
      providerElement: providerElement,
      annotation: riverpodAnnotation,
    );
  }

  @override
  final Token name;

  @override
  final FunctionDeclaration node;
  @override
  final GeneratorProviderDeclarationElement providerElement;
  @override
  final RiverpodAnnotation annotation;
}
