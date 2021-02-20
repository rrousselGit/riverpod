// ignore: deprecated_member_use
import 'package:analyzer/analyzer.dart';

/// Determines if you are in a build method or not
mixin BuildMethodDetector on GeneralizingAstVisitor {
  /// Whether you are in a Widget build method or not
  bool buildMethod = false;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.name.name == 'build' && node.returnType.toString() == 'Widget') {
      buildMethod = true;
    }

    super.visitMethodDeclaration(node);

    buildMethod = false;
  }
}
