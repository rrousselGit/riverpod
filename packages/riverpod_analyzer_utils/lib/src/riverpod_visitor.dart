import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
// ignore: implementation_imports, I made it
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

  final widgetRefInvocations = <WidgetRefInvocation>[];
  final widgetRefWatchInvocations = <WidgetRefWatchInvocation>[];
  final widgetRefReadInvocations = <WidgetRefReadInvocation>[];
  final widgetRefListenInvocations = <WidgetRefListenInvocation>[];
  final widgetRefListenManualInvocations = <WidgetRefListenManualInvocation>[];
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
  bool? parseWidgetRefInvocation,
  bool? parseWidgetRefWatchInvocation,
  bool? parseWidgetRefListenInvocation,
  bool? parseWidgetRefListenManualInvocation,
  bool? parseWidgetRefReadInvocation,
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
  parseWidgetRefInvocation ??= defaultFlagValue;
  parseWidgetRefWatchInvocation ??= defaultFlagValue;
  parseWidgetRefReadInvocation ??= defaultFlagValue;
  parseWidgetRefListenInvocation ??= defaultFlagValue;
  parseWidgetRefListenManualInvocation ??= defaultFlagValue;

  // ignore: invalid_use_of_internal_member
  final nodeLintRegistry = NodeLintRegistry(
    LintRegistry(),
    enableTiming: false,
  );
  final lintRuleNodeRegistry = LintRuleNodeRegistry(
    nodeLintRegistry,
    '',
  );
  final visitor = RiverpodRegistry(lintRuleNodeRegistry);

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
  if (parseWidgetRefInvocation) {
    visitor.addWidgetRefInvocation(result.widgetRefInvocations.add);
  }
  if (parseWidgetRefWatchInvocation) {
    visitor.addWidgetRefWatchInvocation(result.widgetRefWatchInvocations.add);
  }
  if (parseWidgetRefReadInvocation) {
    visitor.addWidgetRefReadInvocation(result.widgetRefReadInvocations.add);
  }
  if (parseWidgetRefListenInvocation) {
    visitor.addWidgetRefListenInvocation(result.widgetRefListenInvocations.add);
  }
  if (parseWidgetRefListenManualInvocation) {
    visitor.addWidgetRefListenManualInvocation(
      result.widgetRefListenManualInvocations.add,
    );
  }

  // ignore: invalid_use_of_internal_member
  node.accept(LinterVisitor(nodeLintRegistry));

  return result;
}

class RiverpodRegistry {
  RiverpodRegistry(this._registry);

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

  RefInvocationVisitor? _refVisitor;
  RefInvocationVisitor _addRefVisitor() {
    final hadVisitor = _refVisitor != null;
    final visitor = _refVisitor ??= RefInvocationVisitor();
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

  WidgetRefInvocationVisitor? _widgetRefVisitor;
  WidgetRefInvocationVisitor _addWidgetRefVisitor() {
    final hadVisitor = _widgetRefVisitor != null;
    final visitor = _widgetRefVisitor ??= WidgetRefInvocationVisitor();
    if (hadVisitor) return visitor;

    _registry.addMethodInvocation(
      (node) => WidgetRefInvocation.parse(node, visitor),
    );

    return visitor;
  }

  void addWidgetRefInvocation(
    void Function(WidgetRefInvocation) cb,
  ) {
    _addWidgetRefVisitor().onWidgetRefInvocation.add(cb);
  }

  void addWidgetRefWatchInvocation(
    void Function(WidgetRefWatchInvocation) cb,
  ) {
    _addWidgetRefVisitor().onWidgetRefWatchInvocation.add(cb);
  }

  void addWidgetRefListenInvocation(
    void Function(WidgetRefListenInvocation) cb,
  ) {
    _addWidgetRefVisitor().onWidgetRefListenInvocation.add(cb);
  }

  void addWidgetRefListenManualInvocation(
    void Function(WidgetRefListenManualInvocation) cb,
  ) {
    _addWidgetRefVisitor().onWidgetRefListenManualInvocation.add(cb);
  }

  void addWidgetRefReadInvocation(
    void Function(WidgetRefReadInvocation) cb,
  ) {
    _addWidgetRefVisitor().onWidgetRefReadInvocation.add(cb);
  }

  // Ref life-cycle visitors

  void addProviderListenableExpression(
    void Function(ProviderListenableExpression node) cb,
  ) {
    _addRefVisitor()
      ..onRefReadInvocation.add((e) => cb(e.provider))
      ..onRefWatchInvocation.add((e) => cb(e.provider))
      ..onRefListenInvocation.add((e) => cb(e.provider));
    _addWidgetRefVisitor()
      ..onWidgetRefReadInvocation.add((e) => cb(e.provider))
      ..onWidgetRefWatchInvocation.add((e) => cb(e.provider))
      ..onWidgetRefListenInvocation.add((e) => cb(e.provider))
      ..onWidgetRefListenManualInvocation.add((e) => cb(e.provider));
  }
}
