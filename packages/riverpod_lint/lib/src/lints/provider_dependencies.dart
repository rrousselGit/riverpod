import 'dart:math';

import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

const _fixDependenciesPriority = 100;

class _FindNestedIdentifiers extends RecursiveRiverpodAstVisitor {
  final identifiers = <ProviderIdentifier>[];

  @override
  void visitProviderIdentifier(ProviderIdentifier node) {
    super.visitProviderIdentifier(node);
    identifiers.add(node);
  }
}

class _ExtraAndMissingDependencies {
  final List<ProviderDependency> extra = [];
  final List<ProviderIdentifier> missing = [];
}

extension on Iterable<ProviderIdentifier> {
  Iterable<ProviderIdentifier> findScopedDependencies() sync* {
    for (final dependency in this) {
      final dependencyElement = dependency.providerElement;
      if (dependencyElement is! GeneratorProviderDeclarationElement) {
        // If we cannot statically determine the dependencies of the dependency,
        // we cannot check if the provider is missing a dependency.
        continue;
      }

      if (dependencyElement.isScoped) yield dependency;
    }
  }
}

class ProviderDependencies extends RiverpodLintRule {
  const ProviderDependencies() : super(code: _code);

  static const _code = LintCode(
    name: 'provider_dependencies',
    problemMessage:
        'If a provider depends on providers which specify "dependencies", '
        'they should themselves specify "dependencies" and include all the scoped providers. ',
    // TODO changelog: provider_dependencies is now a WARNING
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addGeneratorProviderDeclaration((declaration) {
      final visitor = _FindNestedIdentifiers();
      declaration.node.accept(visitor);

      final extraAndMissing = _findExtraAndMissingDependencies(
        declaration,
        visitor.identifiers,
      );

      for (final extra in extraAndMissing.extra) {
        reporter.reportErrorForNode(_code, extra.node);
      }
      if (extraAndMissing.missing.isNotEmpty) {
        reporter.reportErrorForNode(
          _code,
          declaration.annotation.dependencyList?.node ??
              declaration.annotation.node,
        );
      }
    });
  }

  _ExtraAndMissingDependencies _findExtraAndMissingDependencies(
    GeneratorProviderDeclaration declaration,
    List<ProviderIdentifier> actualDependencies,
  ) {
    final result = _ExtraAndMissingDependencies();
    final dependencies = declaration.annotation.dependencyList?.values;
    final scopedInvocations =
        actualDependencies.findScopedDependencies().toList();

    for (final scopedDependency in scopedInvocations) {
      final dependency = scopedDependency.providerElement;

      if (dependencies == null ||
          !dependencies.any((e) => e.provider == dependency)) {
        result.missing.add(scopedDependency);
      }
    }

    if (dependencies != null) {
      for (final dependency in dependencies) {
        final isDependencyUsed = scopedInvocations.any(
          (e) => e.providerElement == dependency.provider,
        );

        if (!isDependencyUsed) result.extra.add(dependency);
      }
    }

    return result;
  }

  @override
  List<RiverpodFix> getFixes() => [_ProviderDependenciesFix()];
}

class _ProviderDependenciesFix extends RiverpodFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    riverpodRegistry(context).addGeneratorProviderDeclaration((declaration) {
      if (!declaration.node.sourceRange.intersects(analysisError.sourceRange)) {
        return;
      }

      final visitor = _FindNestedIdentifiers();
      declaration.node.accept(visitor);

      final scopedDependencies =
          visitor.identifiers.findScopedDependencies().toList();

      final dependenciesNode = declaration.annotation.dependencyList?.node;

      final newDependencies = scopedDependencies.isEmpty
          ? null
          : '[${scopedDependencies.map((e) => e.providerElement.name).join(', ')}]';

      if (newDependencies == null) {
        // Should never be null, but just in case
        if (dependenciesNode == null) return;

        final changeBuilder = reporter.createChangeBuilder(
          message: 'Remove "dependencies"',
          priority: _fixDependenciesPriority,
        );
        changeBuilder.addDartFileEdit((builder) {
          if (declaration.annotation.keepAliveNode == null) {
            // Only "dependencies" is specified in the annotation.
            // So instead of @Riverpod(dependencies: []) -> @Riverpod(),
            // we can do @Riverpod(dependencies: []) -> @riverpod
            builder.addSimpleReplacement(
              declaration.annotation.node.sourceRange,
              '@riverpod',
            );
          } else {
            // Some parameters are specified in the annotation, so we remove
            // only the "dependencies" parameter.

            final end = min(
              // End before the closing parenthesis or before the next parameter
              declaration.annotation.node.arguments!.rightParenthesis.offset,
              dependenciesNode.endToken.next!.end,
            );

            final start = max(
              // Start after the opening parenthesis or after the next parameter
              declaration.annotation.node.arguments!.leftParenthesis.end,
              dependenciesNode.beginToken.previous!.end,
            );

            builder.addDeletion(sourceRangeFrom(start: start, end: end));
          }
        });

        return;
      }

      if (dependenciesNode == null) {
        final changeBuilder = reporter.createChangeBuilder(
          message: 'Specify "dependencies"',
          priority: _fixDependenciesPriority,
        );
        changeBuilder.addDartFileEdit((builder) {
          final annotationArguments = declaration.annotation.node.arguments;
          if (annotationArguments == null) {
            // No argument list found. We are using the @riverpod annotation.
            builder.addSimpleReplacement(
              declaration.annotation.node.sourceRange,
              '@Riverpod(dependencies: $newDependencies)',
            );
          } else {
            // Argument list found, we are using the @Riverpod() annotation

            // We want to insert the "dependencies" parameter after the last
            final insertOffset =
                annotationArguments.arguments.lastOrNull?.end ??
                    annotationArguments.leftParenthesis.end;

            builder.addSimpleInsertion(
              insertOffset,
              ', dependencies: $newDependencies',
            );
          }
        });

        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Update "dependencies"',
        priority: _fixDependenciesPriority,
      );
      changeBuilder.addDartFileEdit((builder) {
        final dependencies =
            scopedDependencies.map((e) => e.providerElement.name).join(', ');
        builder.addSimpleReplacement(
          dependenciesNode.sourceRange,
          '[$dependencies]',
        );
      });
    });
  }
}
