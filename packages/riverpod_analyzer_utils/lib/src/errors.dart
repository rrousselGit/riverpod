import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:meta/meta.dart';

@internal
typedef ErrorReporter = void Function(RiverpodAnalysisError);

@internal
ErrorReporter? errorReporter;

enum RiverpodAnalysisErrorCode {
  missingNotifierBuild,
  abstractNotifier,
  missingNotifierDefaultConstructor,
  notifierDefaultConstructorHasRequiredParameters,
  riverpodDependencyParseError,
}

class RiverpodAnalysisError {
  RiverpodAnalysisError(
    this.message, {
    this.targetNode,
    this.targetElement,
    required this.code,
  });

  final String message;
  final AstNode? targetNode;
  final Element? targetElement;
  final RiverpodAnalysisErrorCode? code;

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
