import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

class ScopedProvidersShouldSpecifyDependencies extends RiverpodLintRule {
  const ScopedProvidersShouldSpecifyDependencies() : super(code: _code);

  static const _code = LintCode(
    name: 'scoped_providers_should_specify_dependencies',
    problemMessage:
        'Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    void checkScopedOverrideList(
      ProviderOverrideList? overrideList,
    ) {
      final overrides = overrideList?.overrides;
      if (overrides == null) return;

      for (final override in overrides) {
        final provider = override.providerElement;
        // We can only know statically if a provider is scoped on generator providers
        if (provider is! GeneratorProviderDeclarationElement) continue;

        final isRoot = provider.annotation.dependencies == null;
        if (isRoot) {
          reporter.reportErrorForNode(code, override.expression);
        }
      }
    }

    riverpodRegistry(context)
      ..addProviderScopeInstanceCreationExpression((expression) {
        final isScoped = isProviderScopeScoped(expression);
        if (!isScoped) return;

        checkScopedOverrideList(expression.overrides);
      })
      ..addProviderContainerInstanceCreationExpression((expression) {
        final hasParent = expression.node.argumentList.arguments
            .whereType<NamedExpression>()
            // TODO handle parent:null.
            // This might be doable by checking that the expression's
            // static type is non-nullable
            .any((e) => e.name.label.name == 'parent');

        // No parent: parameter found, therefore ProviderContainer is never scoped
        if (!hasParent) return;

        checkScopedOverrideList(expression.overrides);
      });
  }

  bool isProviderScopeScoped(
    ProviderScopeInstanceCreationExpression expression,
  ) {
    final hasParent = expression.node.argumentList.arguments
        .whereType<NamedExpression>()
        // TODO handle parent:null.
        // This might be doable by checking that the expression's
        // static type is non-nullable
        .any((e) => e.name.label.name == 'parent');
    if (hasParent) return true;

    final enclosingFunction =
        expression.node.thisOrAncestorOfType<FunctionDeclaration>();

    // Any ProviderScope without parent outside of the main are considered "scoped".
    return enclosingFunction == null || enclosingFunction.name.lexeme != 'main';
  }
}
