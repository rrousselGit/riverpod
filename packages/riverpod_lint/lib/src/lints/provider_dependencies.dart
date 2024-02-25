import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../object_utils.dart';
import '../riverpod_custom_lint.dart';

const _fixDependenciesPriority = 100;

class _LocatedProvider {
  _LocatedProvider(this.provider, this.node);

  final ProviderDeclarationElement provider;
  final Location node;
}

class _MyDiagnostic implements DiagnosticMessage {
  _MyDiagnostic({
    required this.message,
    required this.filePath,
    required this.length,
    required this.offset,
  });

  @override
  String? get url => null;

  final String message;

  @override
  final String filePath;

  @override
  final int length;

  @override
  final int offset;

  @override
  String messageText({required bool includeUrl}) => message;
}

class _FindNestedDependency extends RecursiveRiverpodAstVisitor {
  _FindNestedDependency(
    this.accumulatedDependencyList, {
    required this.onProvider,
    this.visitStates = false,
  });

  final AccumulatedDependencyList accumulatedDependencyList;
  final bool visitStates;
  final void Function(
    _LocatedProvider provider,
    AccumulatedDependencyList list, {
    required bool checkOverrides,
  }) onProvider;

  _FindNestedDependency copyWith({
    AccumulatedDependencyList? accumulatedDependencyList,
    bool? visitStates,
  }) {
    return _FindNestedDependency(
      accumulatedDependencyList ?? this.accumulatedDependencyList,
      onProvider: onProvider,
      visitStates: visitStates ?? this.visitStates,
    );
  }

  @override
  void visitWidgetDeclaration(WidgetDeclaration node) {
    super.visitWidgetDeclaration(node);

    if (node is! StatefulWidgetDeclaration) return;

    final stateAst = node.findStateAst();

    // If targeting a StatefulWidget, we also need to check the state class.
    if (stateAst != null) {
      stateAst.node.accept(copyWith(visitStates: true));
    }
  }

  @override
  void visitStateDeclaration(StateDeclaration node) {
    if (!visitStates) return;

    super.visitStateDeclaration(node);
  }

  @override
  void visitProviderOverrideExpression(ProviderOverrideExpression node) {
    // Disable the lint for overrides. But only if the override isn't
    // `overrides: [provider]`.
    if (node.node.safeCast<Expression>()?.providerListenable != null) {
      super.visitProviderOverrideExpression(node);
      return;
    }
  }

  @override
  void visitProviderIdentifier(ProviderIdentifier node) {
    super.visitProviderIdentifier(node);

    onProvider(
      _LocatedProvider(node.providerElement, LocationNode(node.node)),
      accumulatedDependencyList,
      checkOverrides: false,
    );
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
          _LocatedProvider(dep, LocationNode(node.node)),
          accumulatedDependencyList,
          checkOverrides: false,
        );
      }
    }
  }

  @override
  void visitNamedTypeDependencies(NamedTypeDependencies node) {
    super.visitNamedTypeDependencies(node);

    final type = node.node.type;
    if (type == null) return;
    late final isWidget = widgetType.isAssignableFromType(type);

    if (node.dependencies.dependencies case final deps?) {
      for (final dep in deps) {
        onProvider(
          _LocatedProvider(dep, LocationNode(node.node)),
          accumulatedDependencyList,
          // We check overrides only for Widget instances, as we can't guarantee
          // that non-widget instances use a "ref" that's a child of the overrides.
          checkOverrides: isWidget,
        );
      }
    }
  }
}

class _Data {
  _Data({
    required this.list,
    required this.usedDependencies,
  });

  final AccumulatedDependencyList list;
  final List<_LocatedProvider> usedDependencies;
}

extension on AccumulatedDependencyList {
  AstNode get target =>
      riverpod?.annotation.dependencyList?.node ??
      riverpod?.annotation.node ??
      dependencies?.dependencies.node ??
      node;
}

class ProviderDependencies extends RiverpodLintRule {
  const ProviderDependencies() : super(code: _code);

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

      // If the State has an associated widget, we don't visit it.
      // The widget will already visit the state.
      if (list.node.safeCast<ClassDeclaration>()?.state?.findWidgetAst() !=
          null) {
        return;
      }

      final usedDependencies = <_LocatedProvider>[];

      final visitor = _FindNestedDependency(
        list,
        onProvider: (locatedProvider, list, {required checkOverrides}) {
          final provider = locatedProvider.provider;
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

          usedDependencies.add(locatedProvider);
        },
      );

      list.node.accept(visitor);

      var unusedDependencies = list.allDependencies
          ?.where(
            (dependency) =>
                !usedDependencies.any((e) => e.provider == dependency.provider),
          )
          .toList();
      final missingDependencies = usedDependencies
          .where(
            (dependency) =>
                list.allDependencies
                    ?.every((e) => e.provider != dependency.provider) ??
                true,
          )
          .toSet();

      unusedDependencies ??= const [];
      if (unusedDependencies.isEmpty && missingDependencies.isEmpty) return;

      final message = StringBuffer();
      if (unusedDependencies.isNotEmpty) {
        message.write('Unused dependencies: ');
        message.writeAll(unusedDependencies.map((e) => e.provider.name), ', ');
      }
      if (missingDependencies.isNotEmpty) {
        if (unusedDependencies.isNotEmpty) {
          message.write(' | ');
        }
        message.write('Missing dependencies: ');
        message.writeAll(missingDependencies.map((e) => e.provider.name), ', ');
      }

      reporter.reportErrorForNode(
        _code,
        list.target,
        [message.toString()],
        [
          for (final dependency in missingDependencies)
            if (dependency.provider.element.source case final source?)
              _MyDiagnostic(
                message: dependency.provider.name,
                filePath: source.fullName,
                offset: switch (dependency.node) {
                  LocationNode(:final node) => node.offset,
                  LocationElement(:final element) => element.nameOffset,
                },
                length: switch (dependency.node) {
                  LocationNode(:final node) => node.length,
                  LocationElement(:final element) => element.nameLength,
                },
              ),
        ],
        _Data(
          usedDependencies: usedDependencies,
          list: list,
        ),
      );
    });
  }

  @override
  List<DartFix> getFixes() => [_ProviderDependenciesFix()];
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
    final data = analysisError.data;
    if (data is! _Data) return;

    final scopedDependencies =
        data.usedDependencies.map((e) => e.provider).toSet();
    final newDependencies = scopedDependencies.isEmpty
        ? null
        : '[${scopedDependencies.map((e) => e.name).join(', ')}]';

    final riverpodAnnotation = data.list.riverpod?.annotation;
    final dependencies = data.list.dependencies;

    if (newDependencies == null) {
      if (riverpodAnnotation == null && dependencies == null) {
        // No annotation found, so we can't fix anything.
        // This shouldn't happen but prevents errors in case of bad states.
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Remove "dependencies"',
        priority: _fixDependenciesPriority,
      );
      changeBuilder.addDartFileEdit((builder) {
        if (riverpodAnnotation case final riverpod?) {
          _riverpodRemoveDependencies(builder, riverpod);
        } else if (dependencies != null) {
          builder.addDeletion(data.list.dependencies!.node.sourceRange);
        }
      });

      return;
    }

    final dependencyList = data.list.riverpod?.annotation.dependencyList ??
        data.list.dependencies?.dependencies;

    if (dependencyList == null) {
      final changeBuilder = reporter.createChangeBuilder(
        message: 'Specify "dependencies"',
        priority: _fixDependenciesPriority,
      );
      changeBuilder.addDartFileEdit((builder) {
        if (riverpodAnnotation case final riverpod?) {
          _riverpodSpecifyDependencies(builder, riverpod, newDependencies);
        } else {
          builder.addSimpleInsertion(
            data.list.node.offset,
            '@Dependencies($newDependencies)\n',
          );
        }
      });

      return;
    }

    if (riverpodAnnotation == null && dependencies == null) {
      // No annotation found, so we can't fix anything.
      // This shouldn't happen but prevents errors in case of bad states.
      return;
    }
    final changeBuilder = reporter.createChangeBuilder(
      message: 'Update "dependencies"',
      priority: _fixDependenciesPriority,
    );
    changeBuilder.addDartFileEdit((builder) {
      if (riverpodAnnotation != null) {
        final dependencies = scopedDependencies.map((e) => e.name).join(', ');
        builder.addSimpleReplacement(
          dependencyList.node!.sourceRange,
          '[$dependencies]',
        );
      } else {
        builder.addSimpleReplacement(
          data.list.dependencies!.node.sourceRange,
          '@Dependencies($newDependencies)',
        );
      }
    });
  }

  void _riverpodRemoveDependencies(
    DartFileEditBuilder builder,
    RiverpodAnnotation riverpod,
  ) {
    if (riverpod.keepAliveNode == null) {
      // Only "dependencies" is specified in the annotation.
      // So instead of @Riverpod(dependencies: []) -> @Riverpod(),
      // we can do @Riverpod(dependencies: []) -> @riverpod
      builder.addSimpleReplacement(
        riverpod.node.sourceRange,
        '@riverpod',
      );
      return;
    }

    // Some parameters are specified in the annotation, so we remove
    // only the "dependencies" parameter.
    final dependenciesNode = riverpod.dependenciesNode!;
    final argumentList = riverpod.node.arguments!;

    builder.addDeletion(
      range.nodeInList(argumentList.arguments, dependenciesNode),
    );
  }

  void _riverpodSpecifyDependencies(
    DartFileEditBuilder builder,
    RiverpodAnnotation riverpod,
    String newDependencies,
  ) {
    final annotationArguments = riverpod.node.arguments;
    if (annotationArguments == null) {
      // No argument list found. We are using the @riverpod annotation.
      builder.addSimpleReplacement(
        riverpod.node.sourceRange,
        '@Riverpod(dependencies: $newDependencies)',
      );
    } else {
      // Argument list found, we are using the @Riverpod() annotation

      // We want to insert the "dependencies" parameter after the last
      final insertOffset = annotationArguments.arguments.lastOrNull?.end ??
          annotationArguments.leftParenthesis.end;

      builder.addSimpleInsertion(
        insertOffset,
        ', dependencies: $newDependencies',
      );
    }
  }
}
