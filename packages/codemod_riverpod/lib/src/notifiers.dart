// ignore: deprecated_member_use
import 'package:analyzer/analyzer.dart';
import 'package:codemod/codemod.dart';

/// A suggestor that yields changes to notifier changes
class RiverpodNotifierChangesMigrationSuggestor
    extends GeneralizingAstVisitor<void> with AstVisitingSuggestor {
  @override
  bool shouldResolveAst(FileContext context) => true;
  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    // StateNotifierProvider
    // watch(provider.state) => watch(provider)
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
  void visitPropertyAccess(PropertyAccess node) {
    // StateProvider
    // watch(provider).state => watch(provider)
    if (node.propertyName.name == 'state') {
      if (node.target is FunctionExpressionInvocation) {
        final target = node.target as FunctionExpressionInvocation;
        if (target.function.toSource() == 'watch') {
          if (target.argumentList.arguments.first.staticType
              .getDisplayString()
              .contains('StateProvider')) {
            yieldPatch('', node.target.end, node.end);
          }
        }
      }
    }
    super.visitPropertyAccess(node);
  }
}
