// ignore: deprecated_member_use
import 'package:analyzer/analyzer.dart';
import 'package:codemod/codemod.dart';

/// A suggestor that yields changes to notifier changes
class RiverpodNotifierChangesMigrationSuggestor
    extends GeneralizingAstVisitor<void> with AstVisitingSuggestor {
  bool _stateProviderAccessedState = false;
  @override
  bool shouldResolveAst(FileContext context) => true;
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
      } else if (firstArgStaticType.contains('StateProvider') &&
          !firstArgStaticType.contains('StateNotifierStateProvider')) {
        if (_stateProviderAccessedState) {
          // watch(provider).state => watch(provider)
          _stateProviderAccessedState = false;
          yieldPatch('', node.end, node.end + '.state'.length);
        } else {
          // watch(provider) => watch(provider.notifier)
          yieldPatch('.notifier', node.argumentList.arguments.first.end,
              node.argumentList.arguments.first.end);
        }
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
      // StateProvider
      if (firstArgStaticType.contains('StateProvider') &&
          !firstArgStaticType.contains('StateNotifierStateProvider')) {
        if (_stateProviderAccessedState) {
          // ref.watch(provider).state => ref.watch(provider)
          _stateProviderAccessedState = false;
          yieldPatch('', node.end, node.end + '.state'.length);
        } else {
          // ref.watch(provider) => ref.watch(provider.notifier)
          yieldPatch('.notifier', node.argumentList.arguments.first.end,
              node.argumentList.arguments.first.end);
        }
      }
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    // StateProvider
    // watch(provider).state => watch(provider)
    // ref.watch(provider).state => ref.watch(provider)
    // ref.watch(provider).state => ref.read(provider)
    // context.read(provider).state => context.read(provider)
    // useProvider(provider).state => useProvider(provider)
    if (node.propertyName.name == 'state') {
      _stateProviderAccessedState = true;
    }
    super.visitPropertyAccess(node);
  }
}
