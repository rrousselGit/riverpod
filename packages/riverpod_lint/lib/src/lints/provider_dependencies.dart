import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

import '../imports.dart';
import '../object_utils.dart';

const _fixDependenciesPriority = 100;

class _LocatedProvider {
  _LocatedProvider(this.provider, this.node);

  final ProviderDeclarationElement provider;
  final AstNode node;
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
  })
  onProvider;

  _FindNestedDependency copyWith({
    AccumulatedDependencyList? accumulatedDependencyList,
    bool? visitStates,
    void Function(AccumulatedDependencyList child)? parentAddChild,
  }) {
    return _FindNestedDependency(
      accumulatedDependencyList ?? this.accumulatedDependencyList,
      onProvider: onProvider,
      visitStates: visitStates ?? this.visitStates,
    );
  }

  @override
  void visitComment(Comment node) {
    // Identifiers in comments shouldn't count.
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
      _LocatedProvider(node.providerElement, node.node),
      accumulatedDependencyList,
      checkOverrides: false,
    );
  }

  @override
  void visitAccumulatedDependencyList(AccumulatedDependencyList node) {
    node.node.visitChildren(copyWith(accumulatedDependencyList: node));
  }

  @override
  void visitIdentifierDependencies(IdentifierDependencies node) {
    super.visitIdentifierDependencies(node);

    if (_isSelfReference(node.dependencies)) return;

    if (node.dependencies.dependencies case final deps?) {
      for (final dep in deps) {
        onProvider(
          _LocatedProvider(dep, node.node),
          accumulatedDependencyList,
          checkOverrides: false,
        );
      }
    }
  }

  /// If an object references itself, so we don't count those dependencies
  /// as "used".
  bool _isSelfReference(DependenciesAnnotationElement node) {
    return node == accumulatedDependencyList.dependencies?.element;
  }

  @override
  void visitNamedTypeDependencies(NamedTypeDependencies node) {
    super.visitNamedTypeDependencies(node);

    if (_isSelfReference(node.dependencies)) return;

    final type = node.node.type;
    if (type == null) return;
    late final isWidget = widgetType.isAssignableFromType(type);

    if (node.dependencies.dependencies case final deps?) {
      for (final dep in deps) {
        onProvider(
          _LocatedProvider(dep, node.node),
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
  _Data({required this.list, required this.usedDependencies});

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

class ProviderDependencies extends AnalysisRule {
  ProviderDependencies()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'provider_dependencies',
    '{0}',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addCompilationUnit(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitCompilationUnit(CompilationUnit node) {
    final registry = RiverpodAstRegistry();

    registry.addAccumulatedDependencyList((list) {
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
          if (checkOverrides &&
              list.isSafelyAccessibleAfterOverrides(provider)) {
            return;
          }

          usedDependencies.add(locatedProvider);
        },
      );

      list.node.accept(visitor);

      var unusedDependencies =
          list.allDependencies
              ?.where(
                (dependency) =>
                    !usedDependencies.any(
                      (e) => e.provider == dependency.provider,
                    ),
              )
              .toList();
      final missingDependencies =
          usedDependencies
              .where(
                (dependency) =>
                    list.allDependencies?.every(
                      (e) => e.provider != dependency.provider,
                    ) ??
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

      late final unit = list.node.thisOrAncestorOfType<CompilationUnit>();
      late final source = unit?.declaredFragment?.source;

      rule.reportAtNode(
        list.target,
        arguments: [message.toString()],
        contextMessages: [
          for (final dependency in missingDependencies)
            if (source != null)
              _MyDiagnostic(
                message: dependency.provider.name,
                filePath: source.fullName,
                offset: dependency.node.offset,
                length: dependency.node.length,
              ),
        ],
      );
    });

    registry.run(node);
  }
}

class ProviderDependenciesFix extends ResolvedCorrectionProducer {
  ProviderDependenciesFix({required super.context});

  static const fix = FixKind(
    'riverpod.provider_dependencies',
    DartFixKindPriority.standard,
    'Fix dependencies',
  );

  @override
  FixKind get fixKind => fix;

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    final accumulatedDependencyList = node.accumulatedDependencies;

    if (accumulatedDependencyList == null) return;

    final list = accumulatedDependencyList;

    // Recompute used dependencies
    final usedDependencies = <_LocatedProvider>[];

    final visitor = _FindNestedDependency(
      list,
      onProvider: (locatedProvider, list, {required checkOverrides}) {
        final provider = locatedProvider.provider;
        if (provider is! GeneratorProviderDeclarationElement) return;
        if (!provider.isScoped) return;

        if (checkOverrides && list.isSafelyAccessibleAfterOverrides(provider)) {
          return;
        }

        usedDependencies.add(locatedProvider);
      },
    );

    list.node.accept(visitor);

    final data = _Data(list: list, usedDependencies: usedDependencies);

    final scopedDependencies =
        data.usedDependencies.map((e) => e.provider).toSet();
    final newDependencies =
        scopedDependencies.isEmpty
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

      await builder.addDartFileEdit(file, (builder) {
        if (riverpodAnnotation case final riverpod?) {
          _riverpodRemoveDependencies(builder, riverpod);
        } else if (dependencies != null) {
          builder.addDeletion(range.node(data.list.dependencies!.node));
        }
      });

      return;
    }

    final dependencyList =
        data.list.riverpod?.annotation.dependencyList ??
        data.list.dependencies?.dependencies;

    if (dependencyList == null) {
      await builder.addDartFileEdit(file, (builder) {
        if (riverpodAnnotation case final riverpod?) {
          _riverpodSpecifyDependencies(builder, riverpod, newDependencies);
        } else {
          final dep = builder.importDependenciesClass();
          builder.addSimpleInsertion(
            data.list.node.offset,
            '@$dep($newDependencies)\n',
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

    await builder.addDartFileEdit(file, (builder) {
      if (riverpodAnnotation != null) {
        final dependencies = scopedDependencies.map((e) => e.name).join(', ');
        builder.addSimpleReplacement(
          range.node(dependencyList.node!),
          '[$dependencies]',
        );
      } else {
        final dep = builder.importDependenciesClass();
        builder.addSimpleReplacement(
          range.node(data.list.dependencies!.node),
          '@$dep($newDependencies)',
        );
      }
    });
  }

  void _riverpodRemoveDependencies(
    DartFileEditBuilder builder,
    RiverpodAnnotation riverpod,
  ) {
    if (riverpod.keepAliveNode == null) {
      final _riverpod = builder.importRiverpod();
      // Only "dependencies" is specified in the annotation.
      // So instead of @Riverpod(dependencies: []) -> @Riverpod(),
      // we can do @Riverpod(dependencies: []) -> @riverpod
      builder.addSimpleReplacement(range.node(riverpod.node), '@$_riverpod');
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
      final _riverpod = builder.importRiverpodClass();
      // No argument list found. We are using the @riverpod annotation.
      builder.addSimpleReplacement(
        range.node(riverpod.node),
        '@$_riverpod(dependencies: $newDependencies)',
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
  }
}
