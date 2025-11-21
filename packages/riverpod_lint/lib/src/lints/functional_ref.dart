import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../imports.dart';
import '../riverpod_custom_lint.dart';

class FunctionalRef extends AnalysisRule {
  FunctionalRef() : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'functional_ref',
    'Functional providers must receive a ref matching the provider type as their first argument',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addFunctionDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final declaration = node.provider;
    if (declaration == null) return;

    final parameters = node.functionExpression.parameters;
    if (parameters == null) return;

    final refNode = parameters.parameters.firstOrNull;
    if (refNode == null) {
      // No ref parameter, underlining the function name
      rule.reportAtToken(node.name, arguments: []);
      return;
    }

    if (!refNode.isExplicitlyTyped) {
      // No type specified. Underlining the ref name
      rule.reportAtToken(refNode.name!, arguments: []);
      return;
    }

    if (refNode is! SimpleFormalParameter) {
      // Users likely forgot to specify "ref" and the provider has other parameters
      rule.reportAtToken(refNode.name!, arguments: []);
      return;
    }

    final refNodeType = refNode.type;
    if (refNodeType == null) return;

    final expectedRefName = refNameFor(declaration);
    if (refNodeType.beginToken.lexeme != expectedRefName) {
      rule.reportAtNode(refNodeType, arguments: []);
    }
  }
}

class FunctionalRefFix extends ResolvedCorrectionProducer {
  FunctionalRefFix({required super.context});

  static const fix = FixKind(
    'functional_ref',
    DartFixKindPriority.standard,
    'Fix functional ref parameter',
  );

  @override
  FixKind get fixKind => fix;

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    final declaration =
        node.thisOrAncestorOfType<FunctionDeclaration>()?.provider;
    if (declaration == null) return;

    final refNode =
        declaration.node.functionExpression.parameters?.parameters.firstOrNull;

    if (refNode == null || refNode.isNamed) {
      // No ref parameter, adding one
      await builder.addDartFileEdit(file, (builder) {
        final ref = builder.importRef();
        var toInsert = '$ref ref';
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
    await builder.addDartFileEdit(file, (builder) {
      final ref = builder.importRef();
      if (!refNode.isExplicitlyTyped) {
        builder.addSimpleInsertion(refNode.name!.offset, '$ref ');
        return;
      }

      final type = typeAnnotationFor(refNode);
      builder.addSimpleReplacement(
        range.startEnd(type, refNode.name!),
        '$ref ',
      );
    });
  }
}

extension LibraryForNode on AstNode {
  LibraryElement2 get library => (root as CompilationUnit).library;
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
