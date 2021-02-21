import 'dart:io';
// ignore: deprecated_member_use
import 'package:analyzer/analyzer.dart';
import 'package:codemod/codemod.dart';

/// A suggestor that yields changes to notifier changes
class RiverpodNotifierChangesMigrationSuggestor
    extends GeneralizingAstVisitor<void>
    with ResolvedAstVisitingSuggestorMixin {
  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (node.identifier.name == 'state') {
      if (node.prefix.staticType
          .getDisplayString()
          .contains('StateNotifierProvider')) {
        // StateNotifierProvider
        // watch(provider.state) => watch(provider)
        yieldPatch(node.prefix.end, node.end, '');
      }
    }
    super.visitPrefixedIdentifier(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (node.propertyName.name == 'state') {
      if (node.target is FunctionExpressionInvocation) {
        // StateProvider
        // watch(provider).state => watch(provider)
        final target = node.target as FunctionExpressionInvocation;
        if (target.function.toSource() == 'watch') {
          if (target.argumentList.arguments.first.staticType
              .getDisplayString()
              .contains('StateProvider')) {
            yieldPatch(node.target.end, node.end, '');
          }
        }
      }
    }
    super.visitPropertyAccess(node);
  }
}
