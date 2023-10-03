import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class IncorrectUsageOfRefMethod extends RiverpodLintRule {
  const IncorrectUsageOfRefMethod() : super(code: _code);

  static const _code = LintCode(
    name: 'incorrect_usage_of_ref_method',
    problemMessage: 'Incorrect usage of {0}.',
    correctionMessage: 'Use {1} instead.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addRefWatchInvocation((invocation) {
      final parent = invocation.parent;
      final methodName = invocation.node
          .thisOrAncestorOfType<MethodDeclaration>()
          ?.name
          .lexeme;

      if (parent is LegacyProviderDeclaration ||
          parent is FunctionalProviderDeclaration ||
          methodName == 'build') return;

      reporter.reportErrorForNode(
        code,
        invocation.node.methodName,
        [
          'ref.watch',
          'ref.read',
        ],
      );
    });

    riverpodRegistry(context).addRefReadInvocation((invocation) {
      final parent = invocation.parent;
      final methodName = invocation.node
          .thisOrAncestorOfType<MethodDeclaration>()
          ?.name
          .lexeme;

      if (!(parent is LegacyProviderDeclaration ||
          parent is FunctionalProviderDeclaration ||
          methodName == 'build')) return;

      reporter.reportErrorForNode(
        code,
        invocation.node.methodName,
        [
          'ref.read',
          'ref.watch',
        ],
      );
    });

    riverpodRegistry(context).addRefListenInvocation((invocation) {
      final parent = invocation.parent;
      final methodName = invocation.node
          .thisOrAncestorOfType<MethodDeclaration>()
          ?.name
          .lexeme;

      if (parent is LegacyProviderDeclaration ||
          parent is FunctionalProviderDeclaration ||
          methodName == 'build') return;

      reporter.reportErrorForNode(
        code,
        invocation.node.methodName,
        [
          'ref.listen',
          'ref.listen in build',
        ],
      );
    });

    riverpodRegistry(context).addWidgetRefWatchInvocation((invocation) {
      final functionExpression =
          invocation.node.thisOrAncestorOfType<FunctionExpression>();
      final methodName = invocation.node
          .thisOrAncestorOfType<MethodDeclaration>()
          ?.name
          .lexeme;

      if (functionExpression == null && methodName == 'build') return;

      reporter.reportErrorForNode(
        code,
        invocation.node.methodName,
        [
          'ref.watch',
          'ref.read',
        ],
      );
    });

    riverpodRegistry(context).addWidgetRefReadInvocation((invocation) {
      final functionExpression =
          invocation.node.thisOrAncestorOfType<FunctionExpression>();
      final methodName = invocation.node
          .thisOrAncestorOfType<MethodDeclaration>()
          ?.name
          .lexeme;

      if (functionExpression != null || methodName != 'build') return;

      reporter.reportErrorForNode(
        code,
        invocation.node.methodName,
        [
          'ref.read',
          'ref.watch',
        ],
      );
    });

    riverpodRegistry(context).addWidgetRefListenInvocation((invocation) {
      final functionExpression =
          invocation.node.thisOrAncestorOfType<FunctionExpression>();
      final methodName = invocation.node
          .thisOrAncestorOfType<MethodDeclaration>()
          ?.name
          .lexeme;

      if (functionExpression == null && methodName == 'build') return;

      reporter.reportErrorForNode(
        code,
        invocation.node.methodName,
        [
          'ref.listen',
          'ref.listenManual',
        ],
      );
    });

    riverpodRegistry(context).addWidgetRefListenManualInvocation((invocation) {
      final functionExpression =
          invocation.node.thisOrAncestorOfType<FunctionExpression>();
      final methodName = invocation.node
          .thisOrAncestorOfType<MethodDeclaration>()
          ?.name
          .lexeme;

      if (functionExpression != null || methodName != 'build') return;

      reporter.reportErrorForNode(
        code,
        invocation.node.methodName,
        [
          'ref.listenManual',
          'ref.listen',
        ],
      );
    });
  }

  @override
  List<Fix> getFixes() => [UseCorrectRefMethod()];
}

class UseCorrectRefMethod extends RiverpodFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    riverpodRegistry(context).addRefWatchInvocation((invocation) {
      if (!invocation.node.methodName.sourceRange
          .intersects(analysisError.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Use ref.read',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          invocation.node.methodName.sourceRange,
          'read',
        );
      });
    });

    riverpodRegistry(context).addRefReadInvocation((invocation) {
      if (!invocation.node.methodName.sourceRange
          .intersects(analysisError.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Use ref.watch',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          invocation.node.methodName.sourceRange,
          'watch',
        );
      });
    });

    riverpodRegistry(context).addWidgetRefWatchInvocation((invocation) {
      if (!invocation.node.methodName.sourceRange
          .intersects(analysisError.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Use ref.read',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          invocation.node.methodName.sourceRange,
          'read',
        );
      });
    });

    riverpodRegistry(context).addWidgetRefReadInvocation((invocation) {
      if (!invocation.node.methodName.sourceRange
          .intersects(analysisError.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Use ref.watch',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          invocation.node.methodName.sourceRange,
          'watch',
        );
      });
    });

    riverpodRegistry(context).addWidgetRefListenInvocation((invocation) {
      if (!invocation.node.methodName.sourceRange
          .intersects(analysisError.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Use ref.listenManual',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          invocation.node.methodName.sourceRange,
          'listenManual',
        );
      });
    });

    riverpodRegistry(context).addWidgetRefListenManualInvocation((invocation) {
      if (!invocation.node.methodName.sourceRange
          .intersects(analysisError.sourceRange)) return;

      final methodName = invocation.node
          .thisOrAncestorOfType<MethodDeclaration>()
          ?.name
          .lexeme;
      if (methodName != 'build') return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Use ref.listen',
        priority: 80,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          invocation.node.methodName.sourceRange,
          'listen',
        );
      });
    });
  }
}
