part of '../riverpod_ast.dart';

class LegacyProviderDependencies extends RiverpodAst {
  LegacyProviderDependencies._({
    required this.dependencies,
    required this.dependenciesNode,
    required this.unit,
  });

  static LegacyProviderDependencies? _parse(
    NamedExpression? dependenciesNode, {
    required CompilationUnit unit,
  }) {
    if (dependenciesNode == null) return null;

    final value = dependenciesNode.expression;

    List<LegacyProviderDependency>? dependencies;
    if (value is ListLiteral) {
      dependencies = value.elements
          .map((e) => LegacyProviderDependency._parse(e, unit: unit))
          .toList();
    }

    final legacyProviderDependencies = LegacyProviderDependencies._(
      dependenciesNode: dependenciesNode,
      dependencies: dependencies,
      unit: unit,
    );
    legacyProviderDependencies.dependencies?.forEach((element) {
      element._parent = legacyProviderDependencies;
    });

    return legacyProviderDependencies;
  }

  @override
  final CompilationUnit unit;
  final List<LegacyProviderDependency>? dependencies;
  final NamedExpression dependenciesNode;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitLegacyProviderDependencies(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    final dependencies = this.dependencies;
    if (dependencies != null) {
      for (final dependency in dependencies) {
        dependency.accept(visitor);
      }
    }
  }
}

class LegacyProviderDependency extends RiverpodAst
    implements ProviderListenableExpressionParent {
  LegacyProviderDependency._({
    required this.node,
    required this.provider,
    required this.unit,
  });

  factory LegacyProviderDependency._parse(
    CollectionElement node, {
    required CompilationUnit unit,
  }) {
    final provider = node
        .cast<Expression>()
        .let((e) => ProviderListenableExpression._parse(e, unit: unit));

    final legacyProviderDependency = LegacyProviderDependency._(
      node: node,
      provider: provider,
      unit: unit,
    );
    provider?._parent = legacyProviderDependency;
    return legacyProviderDependency;
  }

  @override
  final CompilationUnit unit;
  final CollectionElement node;
  final ProviderListenableExpression? provider;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitLegacyProviderDependency(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    provider?.accept(visitor);
  }
}

class LegacyProviderDeclaration extends RiverpodAst
    implements ProviderDeclaration {
  LegacyProviderDeclaration._({
    required this.name,
    required this.node,
    required this.build,
    required this.typeArguments,
    required this.providerElement,
    required this.argumentList,
    required this.provider,
    required this.autoDisposeModifier,
    required this.familyModifier,
    required this.dependencies,
    required this.unit,
  });

  static LegacyProviderDeclaration? _parse(
    VariableDeclaration node,
    _ParseRefInvocationMixin parent, {
    required CompilationUnit unit,
  }) {
    final element = node.declaredElement;
    if (element == null) return null;

    final providerElement = LegacyProviderDeclarationElement.parse(element);
    if (providerElement == null) return null;

    final initializer = node.initializer;
    ArgumentList? arguments;
    late SyntacticEntity provider;
    SimpleIdentifier? autoDisposeModifier;
    SimpleIdentifier? familyModifier;
    TypeArgumentList? typeArguments;
    if (initializer is InstanceCreationExpression) {
      // Provider((ref) => ...)

      arguments = initializer.argumentList;
      provider = initializer.constructorName.type.name2;
      typeArguments = initializer.constructorName.type.typeArguments;
    } else if (initializer is FunctionExpressionInvocation) {
      // Provider.modifier()

      void decodeIdentifier(SimpleIdentifier identifier) {
        switch (identifier.name) {
          case 'autoDispose':
            autoDisposeModifier = identifier;
          case 'family':
            familyModifier = identifier;
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

      final modifier = initializer.function;
      if (modifier is! PropertyAccess) return null;

      decodeIdentifier(modifier.propertyName);
      decodeTarget(modifier.target);
      arguments = initializer.argumentList;
      typeArguments = initializer.typeArguments;
    } else {
      // Invalid provider expression.
      // Such as "final provider = variable;"
      return null;
    }

    final build = arguments.positionalArguments().firstOrNull;
    if (build is! FunctionExpression) return null;

    final dependenciesElement = arguments
        .namedArguments()
        .firstWhereOrNull((e) => e.name.label.name == 'dependencies');
    final dependencies = LegacyProviderDependencies._parse(
      dependenciesElement,
      unit: unit,
    );

    final legacyProviderDeclaration = LegacyProviderDeclaration._(
      name: node.name,
      node: node,
      build: build,
      providerElement: providerElement,
      argumentList: arguments,
      typeArguments: typeArguments,
      provider: provider,
      autoDisposeModifier: autoDisposeModifier,
      familyModifier: familyModifier,
      dependencies: dependencies,
      unit: unit,
    );

    dependencies?._parent = legacyProviderDeclaration;
    build.accept(
      _LegacyRefInvocationVisitor(
        legacyProviderDeclaration,
        parent,
        unit: unit,
      ),
    );

    return legacyProviderDeclaration;
  }

  @override
  final CompilationUnit unit;

  final LegacyProviderDependencies? dependencies;

  final FunctionExpression build;
  final ArgumentList argumentList;
  final SyntacticEntity provider;
  final SimpleIdentifier? autoDisposeModifier;
  final SimpleIdentifier? familyModifier;
  final TypeArgumentList? typeArguments;

  @override
  final LegacyProviderDeclarationElement providerElement;

  final List<RefInvocation> refInvocations = [];

  @override
  final Token name;

  @override
  final VariableDeclaration node;

  @override
  void accept(RiverpodAstVisitor visitor) {
    visitor.visitLegacyProviderDeclaration(this);
  }

  @override
  void visitChildren(RiverpodAstVisitor visitor) {
    dependencies?.accept(visitor);
    for (final refInvocation in refInvocations) {
      refInvocation.accept(visitor);
    }
  }
}

class _LegacyRefInvocationVisitor extends RecursiveAstVisitor<void>
    with _ParseRefInvocationMixin {
  _LegacyRefInvocationVisitor(
    this.declaration,
    this.parent, {
    required this.unit,
  });

  @override
  final CompilationUnit unit;

  final LegacyProviderDeclaration declaration;
  final _ParseRefInvocationMixin parent;

  @override
  void visitRefInvocation(RefInvocation invocation) {
    declaration.refInvocations.add(invocation);
    invocation._parent = declaration;
  }

  @override
  void visitWidgetRefInvocation(WidgetRefInvocation invocation) {
    parent.visitWidgetRefInvocation(invocation);
  }

  @override
  void visitProviderContainerInstanceCreationExpression(
    ProviderContainerInstanceCreationExpression expression,
  ) {
    parent.visitProviderContainerInstanceCreationExpression(expression);
  }

  @override
  void visitProviderScopeInstanceCreationExpression(
    ProviderScopeInstanceCreationExpression expression,
  ) {
    parent.visitProviderScopeInstanceCreationExpression(expression);
  }
}
