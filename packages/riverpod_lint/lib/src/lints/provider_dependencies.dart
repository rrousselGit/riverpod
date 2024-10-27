import 'dart:math';

import 'package:analyzer/error/error.dart'
    hide
        // ignore: undefined_hidden_name, necessary to support lower analyzer version
        LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../riverpod_custom_lint.dart';

const _fixDependenciesPriority = 100;

class _ExtraAndMissingDependencies {
  final List<RiverpodAnnotationDependency> extra = [];
  final List<RefDependencyInvocation> missing = [];
}

extension on GeneratorProviderDeclaration {
  Iterable<RefDependencyInvocation> findScopedDependencies() sync* {
    for (final dependency
        in refInvocations.whereType<RefDependencyInvocation>()) {
      final dependencyElement = dependency.provider.providerElement;
      if (dependencyElement is! GeneratorProviderDeclarationElement) {
        // If we cannot statically determine the dependencies of the dependency,
        // we cannot check if the provider is missing a dependency.
        return;
      }
      if (dependencyElement.isScoped) {
        yield dependency;
      }
    }
  }

  _ExtraAndMissingDependencies findExtraAndMissingDependencies() {
    final result = _ExtraAndMissingDependencies();

    final dependencies = annotation.dependencies?.dependencies;
    final scopedInvocations = findScopedDependencies().toList();

    for (final scopedDependency in scopedInvocations) {
      final dependencyName = scopedDependency.provider.providerElement?.name;

      if (dependencies == null ||
          !dependencies.any((e) => e.provider.name == dependencyName)) {
        result.missing.add(scopedDependency);
      }
    }

    if (dependencies != null) {
      for (final dependency in dependencies) {
        final isDependencyUsed = scopedInvocations.any(
          (e) => e.provider.providerElement?.name == dependency.provider.name,
        );
        if (!isDependencyUsed) {
          result.extra.add(dependency);
        }
      }
    }

    return result;
  }
}

class ProviderDependencies extends RiverpodLintRule {
  const ProviderDependencies() : super(code: _code);

  static const _code = LintCode(
    name: 'provider_dependencies',
    problemMessage:
        'If a provider depends on providers which specify "dependencies", '
        'they should themselves specify "dependencies" and include all the scoped providers. ',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    riverpodRegistry(context).addGeneratorProviderDeclaration((declaration) {
      final extraAndMissing = declaration.findExtraAndMissingDependencies();

      for (final extra in extraAndMissing.extra) {
        reporter.atNode(extra.node, _code);
      }
      if (extraAndMissing.missing.isNotEmpty) {
        reporter.atNode(
          declaration.annotation.dependencies?.node ??
              declaration.annotation.annotation,
          _code,
        );
      }
    });
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

      final scopedDependencies = declaration.findScopedDependencies().toList();
      final dependenciesNode = declaration.annotation.dependencies?.node;

      final newDependencies = scopedDependencies.isEmpty
          ? null
          : '[${scopedDependencies.map((e) => e.provider.providerElement?.name).join(', ')}]';

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
              declaration.annotation.annotation.sourceRange,
              '@riverpod',
            );
          } else {
            // Some parameters are specified in the annotation, so we remove
            // only the "dependencies" parameter.

            final end = min(
              // End before the closing parenthesis or before the next parameter
              declaration
                  .annotation.annotation.arguments!.rightParenthesis.offset,
              dependenciesNode.endToken.next!.end,
            );

            final start = max(
              // Start after the opening parenthesis or after the next parameter
              declaration.annotation.annotation.arguments!.leftParenthesis.end,
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
          final annotationArguments =
              declaration.annotation.annotation.arguments;
          if (annotationArguments == null) {
            // No argument list found. We are using the @riverpod annotation.
            builder.addSimpleReplacement(
              declaration.annotation.annotation.sourceRange,
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
        final dependencies = scopedDependencies
            .map((e) => e.provider.providerElement?.name)
            .join(', ');
        builder.addSimpleReplacement(
          dependenciesNode.expression.sourceRange,
          '[$dependencies]',
        );
      });
    });
  }
}
