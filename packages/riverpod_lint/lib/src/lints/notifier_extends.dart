import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

String _generatedClassName(ProviderDeclaration declaration) {
  return '_\$${declaration.name.lexeme.public}';
}

/// Check that a generic type definition matches with a generic type usage.
///
/// This is a strict check based on names, such that `<A extends num, B>` will
/// match with `<A, B>` but not `<B, A>` or `<int, B>` or cases with extra/fewer
/// type arguments.
bool areGenericTypeArgumentsMatching(
  List<TypeParameter> expectedTypeArguments,
  List<TypeAnnotation> actualTypeArguments,
) {
  // Are type arguments specified in the correct order?
  var i = 0;
  for (
    ;
    i < expectedTypeArguments.length && i < actualTypeArguments.length;
    i++
  ) {
    final expectedType = expectedTypeArguments[i].name.lexeme;
    final actualType = actualTypeArguments[i].toSource();

    if (expectedType != actualType) {
      return false;
    }
  }

  // Is a type argument missing?
  if (i != expectedTypeArguments.length || i != actualTypeArguments.length) {
    return false;
  }

  return true;
}

/// Convert a [TypeParameterList] to a string.
String genericsDisplayStringFor(TypeParameterList? typeParameters) {
  if (typeParameters == null) return '';

  return '<${typeParameters.typeParameters.map((e) => e.name).join(', ')}>';
}

class NotifierExtends extends AnalysisRule {
  NotifierExtends() : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'notifier_extends',
    'Notifiers must extend the correct class.',
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
    registry.addClassDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final declaration = node.provider;
    if (declaration == null) return;

    final extendsClause = declaration.node.extendsClause;

    if (extendsClause == null) {
      // No ref parameter, underlining the function name
      rule.reportAtToken(declaration.name, arguments: []);
      return;
    }

    final expectedClassName = _generatedClassName(declaration);
    if (extendsClause.superclass.name2.lexeme != expectedClassName) {
      // No type specified. Underlining the ref name
      rule.reportAtNode(extendsClause.superclass, arguments: []);
      return;
    }

    final expectedTypeArguments =
        declaration.node.typeParameters?.typeParameters ??
        const <TypeParameter>[];
    final actualTypeArguments =
        extendsClause.superclass.typeArguments?.arguments ??
        const <TypeAnnotation>[];
    if (!areGenericTypeArgumentsMatching(
      expectedTypeArguments,
      actualTypeArguments,
    )) {
      // No type specified. Underlining the ref name
      rule.reportAtNode(extendsClause.superclass, arguments: []);
      return;
    }
  }
}

class NotifierExtendsFix extends ResolvedCorrectionProducer {
  NotifierExtendsFix({required super.context});

  static const fix = FixKind(
    'notifier_extends',
    DartFixKindPriority.standard,
    'Extend generated class',
  );

  @override
  FixKind get fixKind => fix;

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    final declaration = node.thisOrAncestorOfType<ClassDeclaration>()?.provider;
    if (declaration == null) return;

    final expectedGenerics = genericsDisplayStringFor(
      declaration.node.typeParameters,
    );
    final expectedClassName = _generatedClassName(declaration);
    final expectedExtends = '$expectedClassName$expectedGenerics';

    final extendsClause = declaration.node.extendsClause;

    await builder.addDartFileEdit(file, (builder) {
      if (extendsClause == null) {
        // No "extends" clause
        builder.addSimpleInsertion(
          declaration.name.end,
          ' extends $expectedExtends',
        );
        return;
      }

      // There is an "extends" clause but the extended type is wrong
      builder.addSimpleReplacement(
        range.node(extendsClause.superclass),
        expectedExtends,
      );
    });
  }
}
