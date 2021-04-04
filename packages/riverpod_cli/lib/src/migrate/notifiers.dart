// ignore: deprecated_member_use
import 'package:analyzer/analyzer.dart';
import 'package:codemod/codemod.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:pub_semver/pub_semver.dart';

/// A suggestor that yields changes to notifier changes
class RiverpodNotifierChangesMigrationSuggestor
    extends GeneralizingAstVisitor<void> with AstVisitingSuggestor {
  RiverpodNotifierChangesMigrationSuggestor(this.riverpodVersion);

  final VersionConstraint riverpodVersion;

  @override
  bool shouldSkip(FileContext context) {
    return riverpodVersion.allowsAny(
      VersionConstraint.parse('^0.14.0'),
    );
  }

  @override
  bool shouldResolveAst(FileContext context) => true;

  @override
  void visitInvocationExpression(InvocationExpression node) {
    final nodeType = node.staticType.getDisplayString();
    if (nodeType.contains('StateNotifierProvider')) {
      final providerType = node.staticType as InterfaceType;
      final notifierType = providerType.typeArguments.first as InterfaceType;
      final stateType = notifierType.superclass.typeArguments.first;

      if (nodeType.contains('Family')) {
        yieldPatch(
            '<${notifierType.getDisplayString()}, ${stateType.getDisplayString()}, ${providerType.typeArguments.last.getDisplayString()}>',
            node.typeArguments.offset,
            node.argumentList.offset);
      } else {
        yieldPatch(
            '<${notifierType.getDisplayString()}, ${stateType.getDisplayString()}>',
            node.function.end,
            node.argumentList.offset);
      }
    }

    super.visitInvocationExpression(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (node.staticType.getDisplayString().contains('StateNotifierProvider')) {
      final providerType = node.staticType as InterfaceType;
      final notifierType = providerType.typeArguments.first as InterfaceType;
      final stateType = notifierType.superclass.typeArguments.first;
      final constructorTypeArguments = node.constructorName.type.typeArguments;
      yieldPatch(
          '<${notifierType.getDisplayString()}, ${stateType.getDisplayString()}>',
          constructorTypeArguments != null
              ? constructorTypeArguments.offset
              : node.constructorName.end,
          node.argumentList.offset);
    }

    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    // StateNotifierProvider
    // watch(provider.state) => watch(provider)
    // ref.watch(provider.state) => ref.watch(provider)
    // ref.read(provider.state) => ref.read(provider)
    // context.read(provider.state) => context.read(provider)
    // useProvider(provider.state) => useProvider(provider)
    if (node.identifier.name == 'state') {
      if (node.prefix.staticType
          .getDisplayString()
          .contains('StateNotifierProvider')) {
        yieldPatch('', node.prefix.end, node.end);
      }
    }
    super.visitPrefixedIdentifier(node);
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    if (node.function.toSource() == 'watch' ||
        node.function.toSource() == 'useProvider') {
      final firstArgStaticType =
          node.argumentList.arguments.first.staticType.getDisplayString();
      if (firstArgStaticType.contains('StateNotifierProvider')) {
        // StateNotifierProvider
        // watch(provider) => watch(provider.notifier)
        // useProvider(provider) => useProvider(provider.notifier)
        yieldPatch('.notifier', node.argumentList.arguments.first.end,
            node.argumentList.arguments.first.end);
      }
    }
    super.visitFunctionExpressionInvocation(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // ref.read / ref.watch / context.read / context.watch, useProvider
    if (node.methodName.toSource() == 'read' ||
        node.methodName.toSource() == 'watch' ||
        node.methodName.toSource() == 'useProvider') {
      final firstArgStaticType =
          node.argumentList.arguments.first.staticType.getDisplayString();
      // StateNotifierProvider
      if (firstArgStaticType.contains('StateNotifierProvider')) {
        // ref.watch(provider) => ref.watch(provider.notifier)
        yieldPatch('.notifier', node.argumentList.arguments.first.end,
            node.argumentList.arguments.first.end);
      }
    }
    super.visitMethodInvocation(node);
  }
}
