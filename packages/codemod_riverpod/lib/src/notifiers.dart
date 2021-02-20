// ignore: deprecated_member_use
import 'package:analyzer/analyzer.dart';
import 'package:codemod/codemod.dart';

/// A suggestor that yields changes to notifier changes
class RiverpodNotifierChangesMigrationSuggestor
    extends GeneralizingAstVisitor<void> with AstVisitingSuggestorMixin {
  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (node.propertyName.name == 'state') {
      if (node.target is MethodInvocation) {
        final target = node.target as MethodInvocation;
        if (target.methodName.name == 'watch') {
          yieldPatch(node.target.end, node.end, '');
        }
      }
    }
    super.visitPropertyAccess(node);
  }
}
