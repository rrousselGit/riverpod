import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/src/node_lint_visitor.dart';
import 'package:meta/meta.dart';

import 'riverpod_ast.dart';

@internal
extension RiverpodLibraryExtension on LibraryElement {
  static final _asyncValueCache = Expando<ClassElement>();

  bool isFromPackage(String packageName) {
    return librarySource.fullName.startsWith('/$packageName/');
  }

  Element? findElementWithNameFromPackage(
    String name, {
    required String packageName,
  }) {
    return library.importedLibraries
        .map((e) => e.exportNamespace.get(name))
        .firstWhereOrNull(
          (element) =>
              element != null &&
              (element.library?.isFromPackage(packageName) ?? false),
        );
  }

  ClassElement findAsyncValue() {
    final cache = _asyncValueCache[this];
    if (cache != null) return cache;

    final result = findElementWithNameFromPackage(
      'AsyncValue',
      packageName: 'riverpod',
    );
    if (result == null) {
      throw RiverpodAnalysisException(
        'No AsyncValue accessible in the library. Did you forget to import Riverpod?',
      );
    }

    return _asyncValueCache[this] = result as ClassElement;
  }

  DartType createdTypeToValueType(DartType? typeArg) {
    final asyncValue = findAsyncValue();

    return asyncValue.instantiate(
      typeArguments: [if (typeArg != null) typeArg],
      nullabilitySuffix: NullabilitySuffix.none,
    );
  }
}

class RiverpodAnalysisException implements Exception {
  RiverpodAnalysisException(
    this.message, {
    this.targetNode,
    this.targetElement,
  });

  final String message;
  final AstNode? targetNode;
  final Element? targetElement;

  @override
  String toString() {
    var trailing = '';
    if (targetElement != null) {
      trailing += '\nelement: $targetElement (${targetElement.runtimeType})';
    }
    if (targetNode != null) {
      trailing += '\nelement: $targetNode (${targetNode.runtimeType})';
    }

    return 'RiverpodAnalysisException: $message$trailing';
  }
}

@internal
void runSubscription<R>(
  R value,
  List<void Function(R)> subscriptions,
) {
  for (final sub in subscriptions) {
    try {
      sub(value);
    } catch (e, stack) {
      Zone.current.handleUncaughtError(e, stack);
    }
  }
}

class RiverpodAnalysisResult {
  final providerDeclarations = <String, ProviderDeclaration>{};
  final generatorProviderDeclarations =
      <String, GeneratorProviderDeclaration>{};
  final statelessProviderDeclarations =
      <String, StatelessProviderDeclaration>{};
  final statefulProviderDeclarations = <String, StatefulProviderDeclaration>{};
  final legacyProviderDeclarations = <String, LegacyProviderDeclaration>{};

  final refInvocations = <RefInvocation>[];
  final refWatchInvocations = <RefWatchInvocation>[];
  final refReadInvocations = <RefReadInvocation>[];
  final refListenInvocations = <RefListenInvocation>[];
}

/// All flags are enabled by default.
///
/// Alls "parseSomething" flags default to [defaultFlagValue].
RiverpodAnalysisResult parseRiverpod(
  CompilationUnit node, {
  bool defaultFlagValue = true,
  bool? parseProviderDeclaration,
  bool? parseGeneratorProviderDeclaration,
  bool? parseStatelessProviderDeclaration,
  bool? parseStatefulProviderDeclaration,
  bool? parseLegacyProviderDeclaration,
  bool? parseRefInvocation,
  bool? parseRefWatchInvocation,
  bool? parseRefListenInvocation,
  bool? parseRefReadInvocation,
}) {
  parseProviderDeclaration ??= defaultFlagValue;
  parseGeneratorProviderDeclaration ??= defaultFlagValue;
  parseStatelessProviderDeclaration ??= defaultFlagValue;
  parseStatefulProviderDeclaration ??= defaultFlagValue;
  parseLegacyProviderDeclaration ??= defaultFlagValue;
  parseRefInvocation ??= defaultFlagValue;
  parseRefWatchInvocation ??= defaultFlagValue;
  parseRefReadInvocation ??= defaultFlagValue;
  parseRefListenInvocation ??= defaultFlagValue;

  final nodeLintRegistry = NodeLintRegistry(
    LintRegistry(),
    enableTiming: false,
  );
  final lintRuleNodeRegistry = LintRuleNodeRegistry(
    nodeLintRegistry,
    '',
  );
  final visitor = RiverpodVisitor(lintRuleNodeRegistry);

  final result = RiverpodAnalysisResult();

  if (parseProviderDeclaration) {
    visitor.addProviderDeclaration(
      (p0) => result.providerDeclarations[p0.name.lexeme] = p0,
    );
  }
  if (parseGeneratorProviderDeclaration) {
    visitor.addGeneratorProviderDeclaration(
      (p0) => result.generatorProviderDeclarations[p0.name.lexeme] = p0,
    );
  }
  if (parseStatelessProviderDeclaration) {
    visitor.addStatelessProviderDeclaration(
      (p0) => result.statelessProviderDeclarations[p0.name.lexeme] = p0,
    );
  }
  if (parseStatefulProviderDeclaration) {
    visitor.addStatefulProviderDeclaration(
      (p0) => result.statefulProviderDeclarations[p0.name.lexeme] = p0,
    );
  }
  if (parseLegacyProviderDeclaration) {
    visitor.addLegacyProviderDeclaration(
      (p0) => result.legacyProviderDeclarations[p0.name.lexeme] = p0,
    );
  }
  if (parseRefInvocation) {
    visitor.addRefInvocation(result.refInvocations.add);
  }
  if (parseRefWatchInvocation) {
    visitor.addRefWatchInvocation(result.refWatchInvocations.add);
  }
  if (parseRefReadInvocation) {
    visitor.addRefReadInvocation(result.refReadInvocations.add);
  }
  if (parseRefListenInvocation) {
    visitor.addRefListenInvocation(result.refListenInvocations.add);
  }

  node.accept(LinterVisitor(nodeLintRegistry));

  return result;
}

class RiverpodVisitor {
  RiverpodVisitor(this._registry);

  final LintRuleNodeRegistry _registry;

  // Provider visitors
  void addProviderDeclaration(void Function(ProviderDeclaration) cb) {
    addGeneratorProviderDeclaration(cb);
    addLegacyProviderDeclaration(cb);
  }

  void addGeneratorProviderDeclaration(
    void Function(GeneratorProviderDeclaration) cb,
  ) {
    addStatefulProviderDeclaration(cb);
    addStatelessProviderDeclaration(cb);
  }

  final _onStatefulProviderDeclaration =
      <void Function(StatefulProviderDeclaration)>[];
  void addStatefulProviderDeclaration(
    void Function(StatefulProviderDeclaration) cb,
  ) {
    _onStatefulProviderDeclaration.add(cb);
    if (_onStatefulProviderDeclaration.length != 1) return;

    _registry.addClassDeclaration((node) {
      final declaration = StatefulProviderDeclaration.parse(node);
      if (declaration == null) return;

      runSubscription(declaration, _onStatefulProviderDeclaration);
    });
  }

  final _onStatelessProviderDeclaration =
      <void Function(StatelessProviderDeclaration)>[];
  void addStatelessProviderDeclaration(
    void Function(StatelessProviderDeclaration) cb,
  ) {
    _onStatelessProviderDeclaration.add(cb);
    if (_onStatelessProviderDeclaration.length != 1) return;

    _registry.addFunctionDeclaration((node) {
      final declaration = StatelessProviderDeclaration.parse(node);
      if (declaration == null) return;

      runSubscription(declaration, _onStatelessProviderDeclaration);
    });
  }

  final _onLegacyProviderDeclaration =
      <void Function(LegacyProviderDeclaration)>[];
  void addLegacyProviderDeclaration(
    void Function(LegacyProviderDeclaration) cb,
  ) {
    _onLegacyProviderDeclaration.add(cb);
    if (_onLegacyProviderDeclaration.length != 1) return;

    // Visit only top level variables and static variables, as anything else
    // is not a legal usage of providers.
    // This saves significant computing power, as it won't try to analyze
    // local function variables & class properties.
    _registry.addTopLevelVariableDeclaration((node) {
      for (final variable in node.variables.variables) {
        final declaration = LegacyProviderDeclaration.parse(variable);
        if (declaration == null) continue;

        runSubscription(declaration, _onLegacyProviderDeclaration);
      }
    });

    _registry.addFieldDeclaration((node) {
      if (!node.isStatic) return;

      for (final variable in node.fields.variables) {
        final declaration = LegacyProviderDeclaration.parse(variable);
        if (declaration == null) continue;

        runSubscription(declaration, _onLegacyProviderDeclaration);
      }
    });
  }

  // // Ref life-cycle visitors
  RefInvocationVisitor? _visitor;

  RefInvocationVisitor _addRefVisitor() {
    final hadVisitor = _visitor != null;
    final visitor = _visitor ??= RefInvocationVisitor();
    if (hadVisitor) return visitor;

    _registry.addMethodInvocation((node) => RefInvocation.parse(node, visitor));

    return visitor;
  }

  void addRefInvocation(
    void Function(RefInvocation) cb,
  ) {
    _addRefVisitor().onRefInvocation.add(cb);
  }

  void addRefWatchInvocation(
    void Function(RefWatchInvocation) cb,
  ) {
    _addRefVisitor().onRefWatchInvocation.add(cb);
  }

  void addRefListenInvocation(
    void Function(RefListenInvocation) cb,
  ) {
    _addRefVisitor().onRefListenInvocation.add(cb);
  }

  void addRefReadInvocation(
    void Function(RefReadInvocation) cb,
  ) {
    _addRefVisitor().onRefReadInvocation.add(cb);
  }

  // // Cusumer visitors
  // void addConsumerWidgetDeclaration();

  // // Ref life-cycle visitors
  // void addWidgetRefWatchInvocation();
  // void addWidgetRefListenInvocation();
  // void addWidgetRefListenManualInvocation();
  // void addWidgetRefReadInvocation();
}
