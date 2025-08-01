import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart'
    hide
        // ignore: undefined_hidden_name, necessary to support broad analyzer versions
        LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

extension SimpleIdentifierX on SimpleIdentifier {
  bool get isFlutterRunApp {
    if (name != 'runApp') return false;

    final library = element?.library2;
    if (library == null) return false;

    return library.uri.scheme == 'package' &&
        library.uri.pathSegments.first == 'flutter';
  }

  bool get isPumpWidget {
    if (name != 'pumpWidget') return false;

    final library = element?.library2;
    if (library == null) return false;

    return library.uri.scheme == 'package' &&
        library.uri.pathSegments.first == 'flutter_test';
  }
}

class ScopedProvidersShouldSpecifyDependencies extends RiverpodLintRule {
  const ScopedProvidersShouldSpecifyDependencies() : super(code: _code);

  static const _code = LintCode(
    name: 'scoped_providers_should_specify_dependencies',
    problemMessage:
        'Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context)
      ..addProviderContainerInstanceCreationExpression((node) {
        handleProviderContainerInstanceCreation(node, reporter);
      })
      ..addProviderScopeInstanceCreationExpression((node) {
        handleProviderScopeInstanceCreation(node, reporter);
      });
  }

  void checkScopedOverrideList(
    ProviderOverrideList? overrideList,
    ErrorReporter reporter,
  ) {
    final overrides = overrideList?.overrides;
    if (overrides == null) return;

    for (final override in overrides) {
      final provider = override.provider?.providerElement;

      // We can only know statically if a provider is scoped on generator providers
      if (provider is! GeneratorProviderDeclarationElement) continue;
      if (!provider.isScoped) {
        reporter.atNode(override.node, code);
      }
    }
  }

  void handleProviderScopeInstanceCreation(
    ProviderScopeInstanceCreationExpression expression,
    ErrorReporter reporter,
  ) {
    final isScoped = isProviderScopeScoped(expression);
    if (!isScoped) return;

    checkScopedOverrideList(expression.overrides, reporter);
  }

  void handleProviderContainerInstanceCreation(
    ProviderContainerInstanceCreationExpression expression,
    ErrorReporter reporter,
  ) {
    // This might be doable by checking that the expression's
    // static type is non-nullable
    final hasParent = expression.parent != null;

    // No parent: parameter found, therefore ProviderContainer is never scoped
    if (!hasParent) return;

    checkScopedOverrideList(expression.overrides, reporter);
  }

  bool isProviderScopeScoped(
    ProviderScopeInstanceCreationExpression expression,
  ) {
    // in runApp(ProviderScope(..)) the direct parent of the ProviderScope
    // is an ArgumentList.
    final enclosingExpression = expression.node.parent?.parent;

    // If the ProviderScope isn't directly as a child of runApp, it is scoped
    return enclosingExpression is! MethodInvocation ||
        (!enclosingExpression.methodName.isFlutterRunApp &&
            !enclosingExpression.methodName.isPumpWidget);
  }
}
