import 'package:analyzer/dart/ast/ast.dart';

typedef RiverpodErrorReporter = void Function(RiverpodAnalysisError);

RiverpodErrorReporter errorReporter = (error) {
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
  invalidProviderNameStripPattern,
}

class RiverpodAnalysisError {
  RiverpodAnalysisError.ast(
    this.message, {
    required this.targetNode,
    required this.code,
  });

  final String message;
  final AstNode targetNode;
  final RiverpodAnalysisErrorCode? code;

  @override
  String toString() {
    var trailing = '';
    trailing += ' ; node: $targetNode (${targetNode.runtimeType})';

    return 'RiverpodAnalysisError: $message$trailing';
  }
}
