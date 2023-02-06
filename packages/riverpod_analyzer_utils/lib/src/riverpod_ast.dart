import 'dart:convert';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:meta/meta.dart';

import 'argument_list_utils.dart';
import 'riverpod_element.dart';
import 'riverpod_types.dart';
import 'riverpod_visitor.dart';

const _providerForAnnotationChecker = TypeChecker.fromName(
  'ProviderFor',
  packageName: 'riverpod_annotation',
);

@internal
class RefInvocationVisitor {
  final onRefInvocation = <void Function(RefInvocation)>[];
  final onRefWatchInvocation = <void Function(RefWatchInvocation)>[];
  final onRefListenInvocation = <void Function(RefListenInvocation)>[];
  final onRefReadInvocation = <void Function(RefReadInvocation)>[];
}

class RefInvocation {
  RefInvocation._({
    required this.node,
    required this.function,
  });

  static void parse(
    MethodInvocation node,
    RefInvocationVisitor visitor,
  ) {
    final targetType = node.target?.staticType;
    if (targetType == null) return;

    // Since Ref is sealed, checking that the function is from the package:riverpod
    // before checking its type skips iterating over the superclasses of an element
    // if it's not from Riverpod.
    if (!isFromRiverpod.isExactlyType(targetType) |
        !refType.isAssignableFromType(targetType)) {
      return;
    }
    final function = node.function;
    if (function is! SimpleIdentifier) return;
    final functionOwner = function.staticElement
        .cast<MethodElement>()
        ?.declaration
        .enclosingElement;

    if (functionOwner == null ||
        // Since Ref is sealed, checking that the function is from the package:riverpod
        // before checking its type skips iterating over the superclasses of an element
        // if it's not from Riverpod.
        !isFromRiverpod.isExactly(functionOwner) ||
        !refType.isAssignableFrom(functionOwner)) {
      return;
    }

    RefInvocation? invocation;
    switch (function.name) {
      case 'watch':
        final watchInvocation =
            invocation = RefWatchInvocation._parse(node, function);
        if (watchInvocation == null) break;

        runSubscription(watchInvocation, visitor.onRefWatchInvocation);
        break;
      case 'read':
        final readInvocation =
            invocation = RefReadInvocation._parse(node, function);
        if (readInvocation == null) break;

        runSubscription(readInvocation, visitor.onRefReadInvocation);
        break;
      case 'listen':
        final listenInvocation =
            invocation = RefListenInvocation._parse(node, function);
        if (listenInvocation == null) break;

        runSubscription(listenInvocation, visitor.onRefListenInvocation);
        break;
    }

    if (invocation == null) return;
    runSubscription(invocation, visitor.onRefInvocation);
  }

  final MethodInvocation node;
  final SimpleIdentifier function;
}

class RefWatchInvocation extends RefInvocation {
  RefWatchInvocation._({
    required super.node,
    required super.function,
    required this.provider,
  }) : super._();

  static RefWatchInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function,
  ) {
    assert(
      function.name == 'watch',
      'Argument error, function is not a ref.watch function',
    );

    final providerListenableExpression = ProviderListenableExpression.parse(
      node.argumentList.positionalArguments().singleOrNull,
    );
    if (providerListenableExpression == null) return null;

    return RefWatchInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
    );
  }

  final ProviderListenableExpression provider;
}

class RefReadInvocation extends RefInvocation {
  RefReadInvocation._({
    required super.node,
    required super.function,
    required this.provider,
  }) : super._();

  static RefReadInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function,
  ) {
    assert(
      function.name == 'read',
      'Argument error, function is not a ref.read function',
    );

    final providerListenableExpression = ProviderListenableExpression.parse(
      node.argumentList.positionalArguments().singleOrNull,
    );
    if (providerListenableExpression == null) return null;

    return RefReadInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
    );
  }

  final ProviderListenableExpression provider;
}

class RefListenInvocation extends RefInvocation {
  RefListenInvocation._({
    required super.node,
    required super.function,
    required this.provider,
    required this.listener,
  }) : super._();

  static RefListenInvocation? _parse(
    MethodInvocation node,
    SimpleIdentifier function,
  ) {
    assert(
      function.name == 'listen',
      'Argument error, function is not a ref.listen function',
    );

    final positionalArgs = node.argumentList.positionalArguments().toList();

    final providerListenableExpression = ProviderListenableExpression.parse(
      positionalArgs.firstOrNull,
    );
    if (providerListenableExpression == null) return null;

    final listener = positionalArgs.elementAtOrNull(1);
    if (listener == null) return null;

    return RefListenInvocation._(
      node: node,
      function: function,
      provider: providerListenableExpression,
      listener: listener,
    );
  }

  final ProviderListenableExpression provider;
  final Expression listener;
}

class ProviderListenableExpression {
  ProviderListenableExpression._({
    required this.node,
    required this.provider,
    required this.providerElement,
    required this.familyArguments,
  });

  static ProviderListenableExpression? parse(Expression? expression) {
    if (expression == null) return null;

    // print('oy $expression // ${expression.runtimeType}');
    SimpleIdentifier? provider;
    ProviderDeclarationElement? providerElement;
    ArgumentList? familyArguments;

    void parseExpression(Expression? expression) {
      if (expression is SimpleIdentifier) {
        // watch(expression)
        provider = expression;
        final element = expression.staticElement;
        if (element is PropertyAccessorElement) {
          final annotation = _providerForAnnotationChecker
              .firstAnnotationOfExact(element.variable);

          if (annotation == null) {
            providerElement =
                LegacyProviderDeclarationElement.parse(element.variable);
          } else {
            providerElement = _parseGeneratedProviderFromAnnotation(annotation);
          }
        }
      } else if (expression is FunctionExpressionInvocation) {
        // watch(expression())
        familyArguments = expression.argumentList;
        parseExpression(expression.function);
      } else if (expression is MethodInvocation) {
        // watch(expression.method())
        parseExpression(expression.target);
      } else if (expression is PrefixedIdentifier) {
        // watch(expression.modifier)
        parseExpression(expression.prefix);
      } else if (expression is IndexExpression) {
        // watch(expression[])
        parseExpression(expression.target);
      } else if (expression is PropertyAccess) {
        // watch(expression.property)
        parseExpression(expression.target);
      } else {
        throw UnsupportedError(
          'Unknown expression $expression (${expression.runtimeType})',
        );
      }
    }

    parseExpression(expression);

    return ProviderListenableExpression._(
      node: expression,
      provider: provider,
      providerElement: providerElement,
      familyArguments: familyArguments,
    );
  }

  static GeneratorProviderDeclarationElement?
      _parseGeneratedProviderFromAnnotation(
    DartObject annotation,
  ) {
    final generatedProviderDefinition = annotation.getField('value')!;

    final function = generatedProviderDefinition.toFunctionValue();
    if (function != null) {
      return StatelessProviderDeclarationElement.parse(
        function,
        annotation: null,
      );
    }
    late final type = generatedProviderDefinition.toTypeValue()?.element;
    if (type != null && type is ClassElement) {
      return StatefulProviderDeclarationElement.parse(
        type,
        annotation: null,
      );
    } else {
      throw StateError('Unknown value $generatedProviderDefinition');
    }
  }

  final Expression node;
  final SimpleIdentifier? provider;
  final ProviderDeclarationElement? providerElement;

  /// If [provider] is a provider with arguments (family), represents the arguments
  /// passed to the provider.
  final ArgumentList? familyArguments;
}

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
  LegacyProviderDependencies._({
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

    return LegacyProviderDependencies._(
      dependenciesNode: dependenciesNode,
      dependencies: dependencies,
    );
  }

  final List<LegacyProviderDependency>? dependencies;
  final NamedExpression dependenciesNode;
}

@internal
extension ObjectUtils<T> on T? {
  R? cast<R>() {
    final that = this;
    if (that is R) return that;
    return null;
  }

  R? let<R>(R? Function(T value)? cb) {
    if (cb == null) return null;
    final that = this;
    if (that != null) return cb(that);
    return null;
  }
}

class LegacyProviderDependency {
  LegacyProviderDependency._({
    required this.node,
    required this.provider,
  });

  static LegacyProviderDependency parse(CollectionElement node) {
    return LegacyProviderDependency._(
      node: node,
      provider: node
          .cast<Expression>()
          .let(ProviderListenableExpression.parse)
          ?.providerElement,
    );
  }

  final CollectionElement node;
  final ProviderDeclarationElement? provider;
}

class LegacyProviderDeclaration implements ProviderDeclaration {
  LegacyProviderDeclaration._({
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

    final dependenciesElement = arguments
        .namedArguments()
        .firstWhereOrNull((e) => e.name.label.name == 'dependencies');

    final build = arguments.positionalArguments().firstOrNull;
    if (build is! FunctionExpression) return null;

    return LegacyProviderDeclaration._(
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
  DartType get valueType;
  DartType get exposedType;
  DartType get createdType;

  String computeProviderHash() {
    // TODO improve hash function to inspect the body of the create fn
    // such that the hash changes if one of the element defined outside of the
    // fn changes.
    final bytes = utf8.encode(node.toSource());
    final digest = sha1.convert(bytes);
    return digest.toString();
  }
}

DartType _computeExposedType(
  DartType createdType,
  LibraryElement library,
) {
  if (createdType.isDartAsyncFuture || createdType.isDartAsyncFutureOr) {
    createdType as InterfaceType;
    return library.createdTypeToValueType(createdType.typeArguments.first);
  }

  return createdType;
}

DartType _getValueType(DartType createdType) {
  if (createdType.isDartAsyncFuture || createdType.isDartAsyncFutureOr) {
    createdType as InterfaceType;
    return createdType.typeArguments.first;
  }

  return createdType;
}

class StatefulProviderDeclaration extends GeneratorProviderDeclaration {
  StatefulProviderDeclaration._({
    required this.name,
    required this.node,
    required this.buildMethod,
    required this.providerElement,
    required this.annotation,
    required this.createdType,
    required this.exposedType,
    required this.valueType,
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

    final createdType = buildMethod.returnType?.type ??
        element.library.typeProvider.dynamicType;

    return StatefulProviderDeclaration._(
      name: node.name,
      node: node,
      buildMethod: buildMethod,
      providerElement: providerElement,
      annotation: riverpodAnnotation,
      createdType: createdType,
      exposedType: _computeExposedType(createdType, element.library),
      valueType: _getValueType(createdType),
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
  @override
  final DartType createdType;
  @override
  final DartType exposedType;
  @override
  final DartType valueType;
}

class StatelessProviderDeclaration extends GeneratorProviderDeclaration {
  StatelessProviderDeclaration._({
    required this.name,
    required this.node,
    required this.providerElement,
    required this.annotation,
    required this.createdType,
    required this.exposedType,
    required this.valueType,
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

    final createdType = element.returnType;
    return StatelessProviderDeclaration._(
      name: node.name,
      node: node,
      providerElement: providerElement,
      annotation: riverpodAnnotation,
      createdType: createdType,
      exposedType: _computeExposedType(createdType, element.library),
      valueType: _getValueType(createdType),
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
  @override
  final DartType createdType;
  @override
  final DartType exposedType;
  @override
  final DartType valueType;
}
