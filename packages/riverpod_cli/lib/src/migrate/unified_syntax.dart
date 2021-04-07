// ignore: deprecated_member_use
import 'package:analyzer/analyzer.dart';
import 'package:codemod/codemod.dart';
import 'package:pub_semver/pub_semver.dart';

enum ClassType { consumer, hook, stateless, none }

/// A suggestor that yields changes to notifier changes
class RiverpodUnifiedSyntaxChangesMigrationSuggestor
    extends GeneralizingAstVisitor<void> with AstVisitingSuggestor {
  RiverpodUnifiedSyntaxChangesMigrationSuggestor(this.riverpodVersion);

  final VersionConstraint riverpodVersion;

  @override
  bool shouldSkip(FileContext context) {
    return riverpodVersion.allowsAny(
      VersionConstraint.parse('^0.15.0'),
    );
  }

  @override
  bool shouldResolveAst(FileContext context) => true;

  ClassType withinClass = ClassType.none;
  ClassDeclaration classDeclaration;
  FormalParameterList params;
  bool inConsumerBuilder = false;
  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final name = node.extendsClause.superclass.name.name;
    classDeclaration = node;
    if (name == 'StatelessWidget') {
      withinClass = ClassType.stateless;
    } else if (name == 'ConsumerWidget') {
      withinClass = ClassType.consumer;
    } else if (name == 'HookWidget') {
      withinClass = ClassType.hook;
    } else {
      withinClass = ClassType.none;
      classDeclaration = null;
    }
    super.visitClassDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.name.name == 'build') {
      params = node.parameters;
      if (withinClass == ClassType.consumer) {
        // Consumer should be migrated regardless if providers are watched / read or not
        migrateParams();
      }
    }
    super.visitMethodDeclaration(node);
  }

  void migrateParams() {
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
      } else {
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
      params = null;
    }
  }

  void migrateClass() {
    if (classDeclaration != null) {
      if (withinClass == ClassType.hook) {
        yieldPatch(
          'ConsumerHookWidget',
          classDeclaration.extendsClause.superclass.offset,
          classDeclaration.extendsClause.superclass.end,
        );
      } else if (withinClass == ClassType.stateless) {
        yieldPatch(
          'ConsumerWidget',
          classDeclaration.extendsClause.superclass.offset,
          classDeclaration.extendsClause.superclass.end,
        );
      }
      classDeclaration = null;
    }
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    if (inConsumerBuilder) {
      params = node.parameters;
    }
    super.visitFunctionExpression(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (node.staticType.getDisplayString().contains('Consumer')) {
      inConsumerBuilder = true;
    }

    super.visitInstanceCreationExpression(node);
    inConsumerBuilder = false;
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    if (node.function.toSource() == 'watch' ||
        node.function.toSource() == 'useProvider') {
      migrateParams();
      migrateClass();
      // watch(provider) => watch(provider.notifier)
      // useProvider(provider) => useProvider(provider.notifier)
      yieldPatch('ref.watch', node.function.offset, node.function.end);
    }
    super.visitFunctionExpressionInvocation(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // ref.read / ref.watch / context.read / context.watch, useProvider
    if (node.methodName.toSource() == 'watch' ||
        node.methodName.toSource() == 'useProvider') {
      migrateParams();
      migrateClass();
      yieldPatch('ref.watch', node.offset, node.methodName.end);
    } else if (node.methodName.toSource() == 'read') {
      migrateParams();
      migrateClass();
      yieldPatch('ref.read', node.offset, node.methodName.end);
    } else if (node.methodName.toSource() == 'refresh') {
      migrateParams();
      migrateClass();
      yieldPatch('ref.refresh', node.offset, node.methodName.end);
    }
    super.visitMethodInvocation(node);
  }
}
