// ignore: deprecated_member_use
import 'package:analyzer/dart/ast/ast.dart';
import 'package:codemod/codemod.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'package:pub_semver/pub_semver.dart';

enum ClassType { consumer, hook, stateless, stateful, none }

/// Aggregates information needed for the unified syntax change with hooks
///
/// Runs before [RiverpodUnifiedSyntaxChangesMigrationSuggestor]
class RiverpodHooksProviderInfo extends GeneralizingAstVisitor<void>
    with AstVisitingSuggestor {
  RiverpodHooksProviderInfo(this.riverpodVersion);
  final VersionConstraint riverpodVersion;
  static Map<String, bool> isConsumerHookFunction = {};
  static Map<String, Set<String>> hookDependencies = {};
  FunctionDeclaration? currentFunction;
  static bool computedDependencies = false;

  static bool shouldMigrate(String functionName) {
    _propagateDependencies();
    return isConsumerHookFunction[functionName]!;
  }

  static void _propagateDependencies() {
    if (computedDependencies) {
      return;
    }
    var changed = true;
    while (changed) {
      changed = false;
      for (final entry in isConsumerHookFunction.entries) {
        if (entry.value) {
          for (final dependency in hookDependencies.entries) {
            if (dependency.value.contains(entry.key) &&
                !isConsumerHookFunction[dependency.key]!) {
              isConsumerHookFunction[dependency.key] = true;
              changed = true;
            }
          }
        }
      }
    }
    computedDependencies = true;
  }

  @override
  bool shouldResolveAst(FileContext context) => true;

  @override
  bool shouldSkip(FileContext context) {
    return riverpodVersion.allowsAny(
      VersionConstraint.parse('^1.0.0'),
    );
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    currentFunction = node;
    isConsumerHookFunction[currentFunction!.name.name] = false;
    hookDependencies[currentFunction!.name.name] = {};
    super.visitFunctionDeclaration(node);
    currentFunction = null;
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    final functionName = node.function.toSource();
    if (functionName.startsWith('use') && currentFunction != null) {
      hookDependencies[currentFunction!.name.name]!.add(functionName);
      if (functionName == 'useProvider') {
        isConsumerHookFunction[currentFunction!.name.name] = true;
      }
    }
    super.visitFunctionExpressionInvocation(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final functionName = node.methodName.toSource();
    if (currentFunction != null) {
      if (functionName.startsWith('use')) {
        hookDependencies[currentFunction!.name.name]!.add(functionName);
        if (functionName == 'useProvider') {
          hookDependencies[currentFunction!.name.name]!.add(functionName);
          isConsumerHookFunction[currentFunction!.name.name] = true;
        }
      }
    }
    super.visitMethodInvocation(node);
  }
}

/// A suggestor that yields changes to notifier changes
class RiverpodUnifiedSyntaxChangesMigrationSuggestor
    extends GeneralizingAstVisitor<void> with AstVisitingSuggestor {
  RiverpodUnifiedSyntaxChangesMigrationSuggestor(this.riverpodVersion);

  final VersionConstraint riverpodVersion;

  @override
  bool shouldSkip(FileContext context) {
    return riverpodVersion.allowsAny(
      VersionConstraint.parse('^1.0.0'),
    );
  }

  @override
  bool shouldResolveAst(FileContext context) => true;

  ClassType withinClass = ClassType.none;
  ClassDeclaration? classDeclaration;
  FormalParameterList? params;
  FunctionBody? functionBody;
  ConstructorName? hookBuilder;
  bool inConsumerBuilder = false;
  bool inHookBuilder = false;
  bool lookingForParams = false;
  final Map<String, ClassDeclaration> statefulDeclarations = {};
  final Set<String> statefulNeedsMigration = {};

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final name = node.extendsClause?.superclass.name.name;
    classDeclaration = node;
    if (name == 'StatelessWidget') {
      withinClass = ClassType.stateless;
    } else if (name == 'State') {
      withinClass = ClassType.stateful;
    } else if (name == 'ConsumerWidget') {
      withinClass = ClassType.consumer;
    } else if (name == 'HookWidget') {
      withinClass = ClassType.hook;
    } else {
      withinClass = ClassType.none;
      classDeclaration = null;
    }
    if (name == 'StatefulWidget') {
      statefulDeclarations[node.name.name] = node;
      if (statefulNeedsMigration.contains(node.name.name)) {
        migrateStateful(node.name.name);
      }
    }
    super.visitClassDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.name.name == 'build') {
      params = node.parameters;
      functionBody = node.body;
      if (withinClass == ClassType.consumer) {
        // Consumer should be migrated regardless if providers are watched / read or not
        migrateParams();
      }
    }
    super.visitMethodDeclaration(node);
  }

  void migrateParams() {
    final params = this.params;
    if (params != null) {
      if (inConsumerBuilder) {
        assert(
          params.parameters.length == 3,
          'Consumers should have a parameter list of length 3',
        );
        yieldPatch(
          'ref',
          params.parameters[1].offset,
          params.parameters[1].end,
        );
      } else if (inHookBuilder) {
        assert(
          params.parameters.length == 1,
          'HookBuilders should have a parameter list of length 1, $params',
        );
        yieldPatch('HookConsumer', hookBuilder!.offset, hookBuilder!.end);
        yieldPatch(
          ', ref, child',
          params.parameters.first.end,
          params.parameters.first.end,
        );
      } else if (withinClass != ClassType.stateful) {
        // In build method
        if (params.parameters.length == 2) {
          // Consumer
          yieldPatch(
            'WidgetReference ref',
            params.parameters.last.offset,
            params.parameters.last.end,
          );
        }
        if (params.parameters.length == 1) {
          // Stateless, Hook
          yieldPatch(
            ', WidgetReference ref',
            params.parameters.last.end,
            params.parameters.last.end,
          );
        }
      }
      this.params = null;
    }
  }

  void migrateClass() {
    final classDecl = classDeclaration;
    if (classDecl != null && !inHookBuilder && !inConsumerBuilder) {
      if (withinClass == ClassType.hook) {
        yieldPatch(
          'HookConsumerWidget',
          classDecl.extendsClause!.superclass.offset,
          classDecl.extendsClause!.superclass.end,
        );
      } else if (withinClass == ClassType.stateless) {
        yieldPatch(
          'ConsumerWidget',
          classDecl.extendsClause!.superclass.offset,
          classDecl.extendsClause!.superclass.end,
        );
      } else if (withinClass == ClassType.stateful) {
        if (classDecl.withClause == null) {
          yieldPatch(
            ' with ConsumerStateMixin',
            classDecl.extendsClause!.superclass.end,
            classDecl.extendsClause!.superclass.end,
          );
        } else {
          yieldPatch(
            ', ConsumerStateMixin',
            classDecl.withClause!.mixinTypes.last.end,
            classDecl.withClause!.mixinTypes.last.end,
          );
        }
        migrateStateful(classDecl
            .extendsClause!.superclass.typeArguments!.arguments.first.type!
            .getDisplayString(withNullability: false));
      }
      classDeclaration = null;
    }
  }

  void migrateConsumerHookFunctionCall(ArgumentList argumentList) {
    if (argumentList.arguments.isNotEmpty) {
      yieldPatch('ref, ', argumentList.arguments.first.offset,
          argumentList.arguments.first.offset);
    } else {
      yieldPatch('ref', argumentList.leftParenthesis.end,
          argumentList.rightParenthesis.offset);
    }
  }

  void migrateFunctionDeclaration(FunctionDeclaration node) {
    if (node.functionExpression.parameters!.parameters.isNotEmpty) {
      yieldPatch(
          'WidgetReference ref, ',
          node.functionExpression.parameters!.parameters.first.offset,
          node.functionExpression.parameters!.parameters.first.offset);
    } else {
      yieldPatch(
          'WidgetReference ref',
          node.functionExpression.parameters!.leftParenthesis.end,
          node.functionExpression.parameters!.rightParenthesis.offset);
    }
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    if ((inConsumerBuilder || inHookBuilder) && lookingForParams) {
      params = node.parameters;
      lookingForParams = false;
    }
    super.visitFunctionExpression(node);
  }

  void migrateListener(InstanceCreationExpression node) {
    final provider = node.argumentList.arguments.firstWhere((element) =>
            element is NamedExpression && element.name.label.name == 'provider')
        as NamedExpression;
    final onChange = node.argumentList.arguments.firstWhere((element) =>
            element is NamedExpression && element.name.label.name == 'onChange')
        as NamedExpression;
    final fn = functionBody;
    final providerSource = context.sourceText
        .substring(provider.expression.offset, provider.expression.end);
    final onChangeSource = context.sourceText
        .substring(onChange.expression.offset, onChange.expression.end);

    final child = node.argumentList.arguments.firstWhere((element) =>
            element is NamedExpression && element.name.label.name == 'child')
        as NamedExpression;
    final childSource = context.sourceText
        .substring(child.expression.offset, child.expression.end);
    if (fn is BlockFunctionBody) {
      yieldPatch('ref.listen($providerSource, $onChangeSource);',
          fn.block.leftBracket.end, fn.block.leftBracket.end);
    } else if (fn is ExpressionFunctionBody) {
      yieldPatch('{\nref.listen($providerSource, $onChangeSource);return ',
          fn.offset, fn.expression.offset);
      yieldPatch(';}', fn.endToken.offset, fn.endToken.end);
    }

    yieldPatch(childSource, node.offset, node.end);
  }

  @override
  void visitTypeAnnotation(TypeAnnotation node) {
    final type = node.type!.getDisplayString(withNullability: false);
    print(type);
    if (type.contains('ProviderReference')) {
      print('Visiting ProviderReference type');
      yieldPatch('ProviderRefBase', node.offset, node.end);
    }
    super.visitTypeAnnotation(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final type = node.staticType!.getDisplayString(withNullability: false);
    if (type.contains('Consumer')) {
      inConsumerBuilder = true;
      lookingForParams = true;
    }
    if (type.contains('HookBuilder')) {
      inHookBuilder = true;
      lookingForParams = true;
      hookBuilder = node.constructorName;
    }
    if (type.contains('ProviderListener')) {
      migrateListener(node);
      migrateParams();
      migrateClass();
    } else if (!type.contains('Family') && type.contains('Provider')) {
      yieldPatch(type, node.constructorName.offset, node.constructorName.end);
    }
    super.visitInstanceCreationExpression(node);

    inConsumerBuilder = false;
    inHookBuilder = false;
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    final functionName = node.function.toSource();
    if (functionName == 'watch' || functionName == 'useProvider') {
      migrateParams();
      migrateClass();

      // watch(provider) => watch(provider.notifier)
      // useProvider(provider) => useProvider(provider.notifier)
      yieldPatch('ref.watch', node.function.offset, node.function.end);
    } else if (functionName.startsWith('use')) {
      if (RiverpodHooksProviderInfo.shouldMigrate(functionName)) {
        migrateConsumerHookFunctionCall(node.argumentList);
        migrateClass();
      }
    }

    super.visitFunctionExpressionInvocation(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final functionName = node.name.name;
    if (RiverpodHooksProviderInfo.shouldMigrate(functionName)) {
      migrateFunctionDeclaration(node);
    }
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final functionName = node.methodName.toSource();
    // ref.read / ref.watch / context.read / context.watch, useProvider
    if (functionName == 'watch' || functionName == 'useProvider') {
      migrateParams();
      migrateClass();
      yieldPatch('ref.watch', node.offset, node.methodName.end);
    } else if (functionName == 'read') {
      migrateParams();
      migrateClass();
      yieldPatch('ref.read', node.offset, node.methodName.end);
    } else if (functionName == 'refresh') {
      migrateParams();
      migrateClass();
      yieldPatch('ref.refresh', node.offset, node.methodName.end);
      final firstArgStaticType = node.argumentList.arguments.first.staticType!
          .getDisplayString(withNullability: false);
      if (firstArgStaticType.contains('FutureProvider') ||
          firstArgStaticType.contains('StreamProvider')) {
        // StateNotifierProvider
        // watch(provider) => watch(provider.notifier)
        // useProvider(provider) => useProvider(provider.notifier)
        yieldPatch('.future', node.argumentList.arguments.first.end,
            node.argumentList.arguments.first.end);
      } else if (firstArgStaticType.contains('StateNotifier')) {
        yieldPatch('.notifier', node.argumentList.arguments.first.end,
            node.argumentList.arguments.first.end);
      }
    } else if (functionName.startsWith('use')) {
      if (RiverpodHooksProviderInfo.shouldMigrate(functionName)) {
        migrateConsumerHookFunctionCall(node.argumentList);
        migrateClass();
      }
    }
    super.visitMethodInvocation(node);
  }

  void migrateStateful(String statefulName) {
    final statefulDeclaration = statefulDeclarations[statefulName];
    if (statefulDeclaration != null) {
      yieldPatch(
          'ConsumerStatefulWidget',
          statefulDeclaration.extendsClause!.superclass.offset,
          statefulDeclaration.extendsClause!.superclass.end);
    } else {
      statefulNeedsMigration.add(statefulName);
    }
  }
}
