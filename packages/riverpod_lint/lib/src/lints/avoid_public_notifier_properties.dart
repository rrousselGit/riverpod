import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/error/error.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

class AvoidPublicNotifierProperties extends AnalysisRule {
  AvoidPublicNotifierProperties()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'avoid_public_notifier_properties',
    'Notifiers should not have public properties/getters. '
    'Instead, all their public API should be exposed through the `state` property.',
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
    final notifierElement = node.declaredFragment?.element;

    if (notifierElement == null ||
        !anyNotifierType.isAssignableFromType(notifierElement.thisType)) {
      return;
    }

    for (final member in node.members) {
      final metadata = switch (member) {
        FieldDeclaration() =>
          member.fields.variables.first.declaredFragment?.element
              as Annotatable?,
        _ => member.declaredFragment?.element as Annotatable?,
      };
      // Skip members if there's an @override annotation
      if (metadata == null || metadata.metadata2.hasOverride) {
        continue;
      }

      bool isVisibleOutsideTheNotifier(Element2? element) {
        final annotatable = element as Annotatable?;
        return element != null &&
            element.isPublic &&
            !annotatable!.metadata2.hasProtected &&
            !annotatable.metadata2.hasVisibleForOverriding &&
            !annotatable.metadata2.hasVisibleForTesting;
      }

      if (member is FieldDeclaration) {
        // We only check class fields, not top-level fields
        if (member.isStatic) continue;

        for (final variable in member.fields.variables) {
          if (variable.isFinal) continue;
          if (!isVisibleOutsideTheNotifier(
            variable.declaredFragment?.element,
          )) {
            continue;
          }

          rule.reportAtNode(member);
        }
      } else if (member is MethodDeclaration) {
        if (!member.isGetter) continue;
        if (member.isStatic) continue;
        if (!isVisibleOutsideTheNotifier(member.declaredFragment!.element)) {
          continue;
        }

        rule.reportAtNode(member);
      }
    }
  }
}
