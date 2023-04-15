import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

typedef ErrorReporter = void Function(RiverpodAnalysisError);

ErrorReporter? errorReporter;

class RiverpodAnalysisError {
  RiverpodAnalysisError(
    this.message, {
    this.targetNode,
    this.targetElement,
  });

  final String message;
  final AstNode? targetNode;
  final Element? targetElement;

  @override
  String toString() {
    var trailing = '';
    if (targetElement != null) {
      trailing += '\nelement: $targetElement (${targetElement.runtimeType})';
    }
    if (targetNode != null) {
      trailing += '\nelement: $targetNode (${targetNode.runtimeType})';
    }

    return 'RiverpodAnalysisError: $message$trailing';
  }
}
