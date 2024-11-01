import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart'
    hide
        // ignore: undefined_hidden_name, necessary to support lower analyzer version
        LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:meta/meta.dart';

import '../riverpod_custom_lint.dart';
import 'notifier_extends.dart';

class FunctionalRef extends RiverpodLintRule {
  const FunctionalRef() : super(code: _code);

  static const _code = LintCode(
    name: 'functional_ref',
    problemMessage:
        'Functional providers must receive a ref matching the provider name as their first positional parameter.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addFunctionalProviderDeclaration((declaration) {
      final parameters = declaration.node.functionExpression.parameters!;

      final refNode = parameters.parameters.firstOrNull;
      if (refNode == null) {
        // No ref parameter, underlining the function name
        reporter.atToken(declaration.name, _code);
        return;
      }

      if (!refNode.isExplicitlyTyped) {
        // No type specified. Underlining the ref name
        reporter.atToken(refNode.name!, _code);
        return;
      }

      if (refNode is! SimpleFormalParameter) {
        // Users likely forgot to specify "ref" and the provider has other parameters
        reporter.atToken(refNode.name!, _code);
        return;
      }

      final refNodeType = refNode.type;
      if (refNodeType == null) return;

      final expectedRefName = refNameFor(declaration);
      if (refNodeType.beginToken.lexeme != expectedRefName) {
        reporter.atNode(refNodeType, _code);
      }

      final expectedTypeArguments =
          declaration.node.functionExpression.typeParameters?.typeParameters ??
              const <TypeParameter>[];

      final currentRefType = refNode.type;
      if (currentRefType is! NamedType) {
        reporter.atNode(refNodeType, _code);
        return;
      }
      final actualTypeArguments =
          currentRefType.typeArguments?.arguments ?? const <TypeAnnotation>[];

      if (!areGenericTypeArgumentsMatching(
        expectedTypeArguments,
        actualTypeArguments,
      )) {
        reporter.atNode(refNodeType, _code);
        return;
      }
    });
  }

  @override
  List<RiverpodFix> getFixes() => [FunctionalRefFix()];
}

class FunctionalRefFix extends RiverpodFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    riverpodRegistry(context).addFunctionalProviderDeclaration((declaration) {
      // This provider is not the one that triggered the error
      if (!analysisError.sourceRange.intersects(declaration.node.sourceRange)) {
        return;
      }

      final refNode = declaration
          .node.functionExpression.parameters!.parameters.firstOrNull;
      if (refNode == null || refNode.isNamed) {
        // No ref parameter, adding one
        final changeBuilder = reporter.createChangeBuilder(
          message: 'Add ref parameter',
          priority: 90,
        );

        changeBuilder.addDartFileEdit((builder) {
          var toInsert = 'Ref ref';
          if (refNode != null) {
            toInsert = '$toInsert, ';
          }

          builder.addSimpleInsertion(
            declaration.node.functionExpression.parameters!.leftParenthesis.end,
            toInsert,
          );
        });
        return;
      }

      if (refNode is! SimpleFormalParameter) return;

      // No type specified, adding it.
      final changeBuilder = reporter.createChangeBuilder(
        message: 'Type as Ref',
        priority: 90,
      );

      changeBuilder.addDartFileEdit((builder) {
        if (!refNode.isExplicitlyTyped) {
          builder.addSimpleInsertion(refNode.name!.offset, 'Ref ');
          return;
        }

        final type = typeAnnotationFor(refNode);
        builder.addSimpleReplacement(
          sourceRangeFrom(
            start: type.offset,
            end: refNode.name!.offset,
          ),
          'Ref ',
        );
      });
    });
  }
}

extension LibraryForNode on AstNode {
  LibraryElement get library => (root as CompilationUnit).library;
}

extension ImportFix on DartFileEditBuilder {
  @useResult
  String importRef() {
    return _importWithPrefix('Ref');
  }

  @useResult
  String _importWithPrefix(String name) {
    final hooksRiverpodUri =
        Uri(scheme: 'package', path: 'hooks_riverpod/hooks_riverpod.dart');
    final flutterRiverpodUri =
        Uri(scheme: 'package', path: 'flutter_riverpod/flutter_riverpod.dart');
    final riverpodUri = Uri(scheme: 'package', path: 'riverpod/riverpod.dart');

    if (importsLibrary(hooksRiverpodUri)) {
      return _buildImport(hooksRiverpodUri, name);
    }

    if (importsLibrary(flutterRiverpodUri)) {
      return _buildImport(flutterRiverpodUri, name);
    }

    return _buildImport(riverpodUri, name);
  }

  String _buildImport(Uri uri, String name) {
    final import = importLibraryElement(uri);

    final prefix = import.prefix;
    if (prefix != null) return '$prefix.$name';

    return name;
  }
}

TypeAnnotation typeAnnotationFor(FormalParameter param) {
  if (param is DefaultFormalParameter) {
    return typeAnnotationFor(param.parameter);
  }
  if (param is SimpleFormalParameter) {
    return param.type!;
  }

  throw UnimplementedError('Unknown parameter type: $param');
}
