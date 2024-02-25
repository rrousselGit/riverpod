import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../object_utils.dart';
import '../riverpod_custom_lint.dart';

class MissingProviderDependency extends RiverpodLintRule {
  const MissingProviderDependency() : super(code: _code);

  static const _code = LintCode(
    name: 'missing_provider_dependency',
    problemMessage: 'Missing scoped provider dependencies found: {0}',
    // TODO changelog: provider_dependencies is now a WARNING
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context)
      ..addProviderIdentifier((node) {
        final enclosingExpression =
            node.node.parent?.thisOrAncestorOfType<Expression>();

        // Overrides don't count as dependencies
        if (enclosingExpression?.providerOverride != null) return;

        _findMissingDependency(
          node.node,
          [node.providerElement],
          reporter,
        );
      })
      ..addAccumulatedDependencyList((node) {
        final dependencies = node.allDependencies;
        if (dependencies == null) return;

        _findMissingDependency(
          node.node,
          dependencies.map((e) => e.provider).toList(),
          reporter,
        );
      })
      ..addIdentifierDependencies((node) {
        final dependencies = node.dependencies.dependencies;
        if (dependencies == null) return;

        _findMissingDependency(node.node, dependencies, reporter);
      })
      ..addNamedTypeDependencies((node) {
        final dependencies = node.dependencies.dependencies;
        if (dependencies == null) return;

        final type = node.node.type;
        if (type == null) return;

        _findMissingDependency(
          node.node,
          dependencies,
          reporter,
          // We check overrides only for Widget instances, as we can't guarantee
          // that non-widget instances use a "ref" that's a child of the overrides.
          checkOverrides: widgetType.isAssignableFromType(type),
        );
      });
  }

  void _findMissingDependency(
    AstNode node,
    List<ProviderDeclarationElement> list,
    ErrorReporter reporter, {
    bool checkOverrides = false,
  }) {
    final scopedProviders = list
        .whereType<GeneratorProviderDeclarationElement>()
        .where((e) => e.isScoped)
        .toSet();
    if (scopedProviders.isEmpty) return;

    final enclosingAccumulatedDependencies = node.ancestors
        .map((e) => e.accumulatedDependencies)
        .whereNotNull()
        .firstOrNull;

    // We are likely on a class declaration. There's no possible enclosing annotated element.
    if (enclosingAccumulatedDependencies == null) return;

    final missingDependencies = scopedProviders.where(
      (scopedProvider) {
        // Check if the provider is overridden
        if (checkOverrides) {
          for (final override
              in enclosingAccumulatedDependencies.overridesIncludingParents) {
            // If we are overriding only one part of a family,
            // we can't guarantee that later reads will point to the override.
            if (override.familyArguments != null) continue;

            if (override.provider?.providerElement == scopedProvider) {
              return false;
            }
          }
        }

        final deps = enclosingAccumulatedDependencies.allDependencies;
        if (deps == null) return true;

        return deps.every(
          (dependency) => dependency.provider != scopedProvider,
        );
      },
    ).toList();

    if (missingDependencies.isNotEmpty) {
      reporter.reportErrorForNode(
        _code,
        node,
        [missingDependencies.map((e) => e.name).join(', ')],
      );
    }
  }

  @override
  List<DartFix> getFixes() => const [];
}
