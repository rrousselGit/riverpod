import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../object_utils.dart';
import '../riverpod_custom_lint.dart';

class UnknownScopedUsage extends RiverpodLintRule {
  const UnknownScopedUsage() : super(code: _code);

  static const _code = LintCode(
    name: 'unknown_scoped_usage',
    problemMessage:
        'A provider was used, but could not find the associated `ref`.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addProviderIdentifier((identifier) {
      // Ignore [provider] identifiers in comments.
      if (identifier.node.parent is CommentReference) return;

      final providerElement = identifier.providerElement;
      if (providerElement is! GeneratorProviderDeclarationElement) return;
      if (!providerElement.isScoped) return;

      final enclosingMethodInvocation =
          identifier.node.thisOrAncestorOfType<MethodInvocation>();
      final refInvocation = enclosingMethodInvocation?.refInvocation
          .safeCast<RefDependencyInvocation>();
      final widgetRefInvocation = enclosingMethodInvocation?.widgetRefInvocation
          .safeCast<WidgetRefDependencyInvocation>();

      // If in a ref expression, and the associated ref is the checked provider,
      // then it's fine.
      // This is to reject cases like `ref.watch(something(provider))`.
      if (refInvocation?.listenable.provider == identifier ||
          widgetRefInvocation?.listenable.provider == identifier) {
        return;
      }

      // .parent is used because providers count as overrides.
      // We don't want to count "provider" as an override, and want to focus
      // on "provider.overrideX".
      final override = identifier.node.parent
          ?.thisOrAncestorOfType<Expression>()
          ?.providerOverride;
      // The identifier is in override, so it's fine.
      if (override?.provider == identifier) return;

      final enclosingConstructorType = identifier
          .node.staticParameterElement?.enclosingElement3
          .safeCast<ConstructorElement>()
          ?.returnType;
      // Silence the warning if passed to a widget constructor.
      if (enclosingConstructorType != null &&
          widgetType.isAssignableFromType(enclosingConstructorType)) {
        return;
      }

      reporter.atNode(
        identifier.node,
        code,
      );
    });
  }
}
