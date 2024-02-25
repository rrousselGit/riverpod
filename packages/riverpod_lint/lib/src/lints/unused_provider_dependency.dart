import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../object_utils.dart';
import '../riverpod_custom_lint.dart';

class _FindNestedDependency extends RecursiveRiverpodAstVisitor {
  _FindNestedDependency(
    this.accumulatedDependencyList, {
    required this.onProvider,
  });

  final AccumulatedDependencyList accumulatedDependencyList;
  final void Function(
    ProviderDeclarationElement provider,
    AccumulatedDependencyList list, {
    required bool checkOverrides,
  }) onProvider;

  _FindNestedDependency copyWith({
    AccumulatedDependencyList? accumulatedDependencyList,
  }) {
    return _FindNestedDependency(
      accumulatedDependencyList ?? this.accumulatedDependencyList,
      onProvider: onProvider,
    );
  }

  @override
  void visitProviderIdentifier(ProviderIdentifier node) {
    super.visitProviderIdentifier(node);

    final enclosingExpression =
        node.node.parent?.thisOrAncestorOfType<Expression>();

    // Overrides don't count as dependencies
    if (enclosingExpression?.providerOverride != null) return;

    onProvider(
      node.providerElement,
      accumulatedDependencyList,
      checkOverrides: false,
    );
  }

  @override
  void visitNode(AstNode node) {
    if (node.accumulatedDependencies case final list?) {
      visitAccumulatedDependencyList(list);
      // Remove recursion to fork the visitor on AccumulatedDependencyList
      return;
    }

    super.visitNode(node);
  }

  @override
  void visitAccumulatedDependencyList(AccumulatedDependencyList node) {
    node.node.visitChildren(
      copyWith(accumulatedDependencyList: node),
    );
  }

  @override
  void visitIdentifierDependencies(IdentifierDependencies node) {
    super.visitIdentifierDependencies(node);

    if (node.dependencies.dependencies case final deps?) {
      for (final dep in deps) {
        onProvider(
          dep,
          accumulatedDependencyList,
          checkOverrides: false,
        );
      }
    }
  }

  @override
  void visitNamedTypeDependencies(NamedTypeDependencies node) {
    super.visitNamedTypeDependencies(node);

    if (node.dependencies.dependencies case final deps?) {
      for (final dep in deps) {
        final type = node.node.type;
        if (type == null) continue;

        onProvider(
          dep,
          accumulatedDependencyList,
          // We check overrides only for Widget instances, as we can't guarantee
          // that non-widget instances use a "ref" that's a child of the overrides.
          checkOverrides: widgetType.isAssignableFromType(type),
        );
      }
    }
  }
}

class UnusedProviderDependency extends RiverpodLintRule {
  const UnusedProviderDependency() : super(code: _code);

  static const _code = LintCode(
    name: 'provider_dependencies',
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
      // Ignore ProviderScopes. We only check annotations
      if (list.overrides != null) return;

      var unusedDependencies =
          list.allDependencies?.map((e) => e.provider).toList();

      final missingDependencies = <GeneratorProviderDeclarationElement>{};

      final visitor = _FindNestedDependency(
        list,
        onProvider: (provider, list, {required checkOverrides}) {
          if (provider is! GeneratorProviderDeclarationElement) return;
          if (!provider.isScoped) return;

          // Check if the provider is overridden. If it is, the provider doesn't
          // count towards the unused/missing dependencies
          if (checkOverrides) {
            for (final override in list.overridesIncludingParents) {
              // If we are overriding only one part of a family,
              // we can't guarantee that later reads will point to the override.
              if (override.familyArguments != null) continue;

              if (override.provider?.providerElement == provider) {
                return;
              }
            }
          }

          unusedDependencies?.remove(provider);

          final dependencies = list.allDependencies ?? const [];
          if (dependencies.any((e) => e.provider == provider)) return;

          missingDependencies.add(provider);
        },
      );

      list.node.accept(visitor);

      final stateAst = list.node
          .safeCast<ClassDeclaration>()
          ?.widget
          .safeCast<StatefulWidgetDeclaration>()
          ?.findStateAst();

      // If targeting a StatefulWidget, we also need to check the state class.
      if (stateAst != null) {
        // "visitChildren" to not context-switch on the AccumulatedDependencyList
        stateAst.node.visitChildren(visitor);
      }

      unusedDependencies ??= const [];
      if (unusedDependencies.isEmpty && missingDependencies.isEmpty) return;

      reporter.reportErrorForNode(
        _code,
        list.riverpod?.annotation.dependencyList?.node ??
            list.riverpod?.annotation.node ??
            list.dependencies?.dependencies.node ??
            list.node,
        [
          'Unused dependencies: ${unusedDependencies.map((e) => e.name).join(', ')} | '
              'Missing dependencies: ${missingDependencies.map((e) => e.name).join(', ')} ',
        ],
      );
    });
  }
}

// class _ProviderDependenciesFix extends RiverpodFix {
//   @override
//   void run(
//     CustomLintResolver resolver,
//     ChangeReporter reporter,
//     CustomLintContext context,
//     AnalysisError analysisError,
//     List<AnalysisError> others,
//   ) {
//     riverpodRegistry(context).addGeneratorProviderDeclaration((declaration) {
//       if (!declaration.node.sourceRange.intersects(analysisError.sourceRange)) {
//         return;
//       }

//       final visitor = _FindNestedIdentifiers();
//       declaration.node.accept(visitor);

//       final scopedDependencies =
//           visitor.identifiers.findScopedDependencies().toList();

//       final dependenciesNode = declaration.annotation.dependencyList?.node;

//       final newDependencies = scopedDependencies.isEmpty
//           ? null
//           : '[${scopedDependencies.map((e) => e.providerElement.name).join(', ')}]';

//       if (newDependencies == null) {
//         // Should never be null, but just in case
//         if (dependenciesNode == null) return;

//         final changeBuilder = reporter.createChangeBuilder(
//           message: 'Remove "dependencies"',
//           priority: _fixDependenciesPriority,
//         );
//         changeBuilder.addDartFileEdit((builder) {
//           if (declaration.annotation.keepAliveNode == null) {
//             // Only "dependencies" is specified in the annotation.
//             // So instead of @Riverpod(dependencies: []) -> @Riverpod(),
//             // we can do @Riverpod(dependencies: []) -> @riverpod
//             builder.addSimpleReplacement(
//               declaration.annotation.node.sourceRange,
//               '@riverpod',
//             );
//           } else {
//             // Some parameters are specified in the annotation, so we remove
//             // only the "dependencies" parameter.

//             final end = min(
//               // End before the closing parenthesis or before the next parameter
//               declaration.annotation.node.arguments!.rightParenthesis.offset,
//               dependenciesNode.endToken.next!.end,
//             );

//             final start = max(
//               // Start after the opening parenthesis or after the next parameter
//               declaration.annotation.node.arguments!.leftParenthesis.end,
//               dependenciesNode.beginToken.previous!.end,
//             );

//             builder.addDeletion(sourceRangeFrom(start: start, end: end));
//           }
//         });

//         return;
//       }

//       if (dependenciesNode == null) {
//         final changeBuilder = reporter.createChangeBuilder(
//           message: 'Specify "dependencies"',
//           priority: _fixDependenciesPriority,
//         );
//         changeBuilder.addDartFileEdit((builder) {
//           final annotationArguments = declaration.annotation.node.arguments;
//           if (annotationArguments == null) {
//             // No argument list found. We are using the @riverpod annotation.
//             builder.addSimpleReplacement(
//               declaration.annotation.node.sourceRange,
//               '@Riverpod(dependencies: $newDependencies)',
//             );
//           } else {
//             // Argument list found, we are using the @Riverpod() annotation

//             // We want to insert the "dependencies" parameter after the last
//             final insertOffset =
//                 annotationArguments.arguments.lastOrNull?.end ??
//                     annotationArguments.leftParenthesis.end;

//             builder.addSimpleInsertion(
//               insertOffset,
//               ', dependencies: $newDependencies',
//             );
//           }
//         });

//         return;
//       }

//       final changeBuilder = reporter.createChangeBuilder(
//         message: 'Update "dependencies"',
//         priority: _fixDependenciesPriority,
//       );
//       changeBuilder.addDartFileEdit((builder) {
//         final dependencies =
//             scopedDependencies.map((e) => e.providerElement.name).join(', ');
//         builder.addSimpleReplacement(
//           dependenciesNode.sourceRange,
//           '[$dependencies]',
//         );
//       });
//     });
//   }
// }
