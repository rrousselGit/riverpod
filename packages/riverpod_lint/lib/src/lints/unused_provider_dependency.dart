import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../object_utils.dart';
import '../riverpod_custom_lint.dart';

class _FindNestedDependency extends RecursiveRiverpodAstVisitor {
  _FindNestedDependency(this.onProvider);

  final void Function(ProviderDeclarationElement provider, AstNode node)
      onProvider;

  @override
  void visitProviderIdentifier(ProviderIdentifier node) {
    super.visitProviderIdentifier(node);
    onProvider(node.providerElement, node.node);
  }

  @override
  void visitIdentifierDependencies(IdentifierDependencies node) {
    super.visitIdentifierDependencies(node);
    node.dependencies.dependencies?.forEach((e) => onProvider(e, node.node));
  }

  @override
  void visitNamedTypeDependencies(NamedTypeDependencies node) {
    super.visitNamedTypeDependencies(node);
    node.dependencies.dependencies?.forEach((e) => onProvider(e, node.node));
  }
}

class UnusedProviderDependency extends RiverpodLintRule {
  const UnusedProviderDependency() : super(code: _code);

  static const _code = LintCode(
    name: 'unused_provider_dependency',
    problemMessage: '{0}',
    // TODO changelog: provider_dependencies is now a WARNING
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addAccumulatedDependencyList((list) {
      // TODO do not consider recursive objects/functions as using their dependencies

      // No need to specify root providers.
      for (final dep
          in list.allDependencies ?? const <AccumulatedDependency>[]) {
        final node = dep.node;
        // We skip "node=null" because that's for inherited @Dependencies
        // (such as a State inheriting @Dependencies from its StatefulWidget)
        if (!dep.provider.isScoped && node != null) {
          reporter.reportErrorForNode(
            _code,
            node,
            [
              'Unnecessary dependency specified. '
                  '`${dep.provider.name}` is not a scoped provider.',
            ],
          );
        }
      }

      final dependenciesToCheck = (list.allDependencies ?? [])
          .map((e) {
            final node = e.node;
            if (node == null || !e.provider.isScoped) return null;
            return (node: node, provider: e.provider);
          })
          .whereNotNull()
          .toSet();

      // Avoid visiting the AST tree if to check for unused dependencies if there are none.
      if (dependenciesToCheck.isEmpty) return;

      final visitor = _FindNestedDependency((provider, node) {
        if (provider is! GeneratorProviderDeclarationElement) return;
        if (!provider.isScoped) return;

        dependenciesToCheck.removeWhere((e) => e.provider == provider);
      });

      list.node.accept(visitor);

      // If targeting a StatefulWidget, we also need to check the state class.
      if (list.node
              .safeCast<ClassDeclaration>()
              ?.widget
              .safeCast<StatefulWidgetDeclaration>()
              ?.findStateAst()
          case final stateAst?) {
        stateAst.node.accept(visitor);
      }

      for (final dep in dependenciesToCheck) {
        reporter.reportErrorForNode(
          _code,
          dep.node,
          ['Unused dependency found.'],
        );
      }
    });
  }

  @override
  List<DartFix> getFixes() => const [];
}
