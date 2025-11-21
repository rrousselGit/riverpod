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
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

const _buildMethodName = 'build';

class NotifierBuild extends AnalysisRule {
  NotifierBuild() : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'notifier_build',
    'Notifiers must have a build method.',
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
    final hasRiverpodAnnotation =
        node.metadata.where((element) {
          final annotationElement = element.element2;

          if (annotationElement == null ||
              annotationElement is! ExecutableElement2) {
            return false;
          }

          return riverpodType.isExactlyType(annotationElement.returnType);
        }).isNotEmpty;

    if (!hasRiverpodAnnotation) return;

    final hasBuildMethod =
        node.members
            .where(
              (e) =>
                  e.declaredFragment?.element.displayName == _buildMethodName,
            )
            .isNotEmpty;

    if (hasBuildMethod) return;

    rule.reportAtToken(node.name, arguments: []);
  }
}

class AddBuildMethodFix extends ResolvedCorrectionProducer {
  AddBuildMethodFix({required super.context});

  static const fix = FixKind(
    'notifier_build',
    DartFixKindPriority.standard,
    'Add build method',
  );

  @override
  FixKind get fixKind => fix;

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    final classDeclaration = node.parent;
    if (classDeclaration is! ClassDeclaration) return;

    await builder.addDartFileEdit(file, (builder) {
      final offset = classDeclaration.leftBracket.offset + 1;

      builder.addSimpleInsertion(offset, '''

  @override
  dynamic build() {
    // TODO: implement build
    throw UnimplementedError();
  }
''');
    });
  }
}
