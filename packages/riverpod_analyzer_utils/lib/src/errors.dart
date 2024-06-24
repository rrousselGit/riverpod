import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:meta/meta.dart';

@internal
typedef ErrorReporter = void Function(RiverpodAnalysisError);

ErrorReporter errorReporter = (error) {
  throw UnsupportedError(
    'RiverpodAnalysisError found but no errorReporter specified: $error',
  );
};

enum RiverpodAnalysisErrorCode {
  missingNotifierBuild,
  abstractNotifier,
  missingNotifierDefaultConstructor,
  notifierDefaultConstructorHasRequiredParameters,
  providerDependencyListParseError,
  providerOrFamilyExpressionParseError,
  invalidRetryArgument,
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
      trailing += ' ; element: $targetElement (${targetElement.runtimeType})';
    }
    if (targetNode != null) {
      trailing += ' ; node: $targetNode (${targetNode.runtimeType})';
    }

    return 'RiverpodAnalysisError: $message$trailing';
  }
}
