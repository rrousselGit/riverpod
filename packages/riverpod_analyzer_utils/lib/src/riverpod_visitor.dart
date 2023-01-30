import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:custom_lint_builder/src/node_lint_visitor.dart';
import 'package:meta/meta.dart';

import 'riverpod_ast.dart';

@internal
extension RiverpodLibraryExtension on LibraryElement {
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

  ClassElement? findAsyncValue() {
    return findElementWithNameFromPackage(
      'AsyncValue',
      packageName: 'riverpod',
    ) as ClassElement?;
  }

  DartType createdTypeToValueType(DartType? typeArg) {
    final asyncValue = findAsyncValue();
    if (asyncValue == null) {
      throw RiverpodAnalysisException(
        'No AsyncValue accessible in the library. Did you forget to import Riverpod?',
      );
    }

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

class RiverpodVisitor<T> {
  RiverpodVisitor(this._registry);

  final LintRuleNodeRegistry _registry;

  void _runSubscription<R>(
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

      _runSubscription(declaration, _onStatefulProviderDeclaration);
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

      _runSubscription(declaration, _onStatelessProviderDeclaration);
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

        _runSubscription(declaration, _onLegacyProviderDeclaration);
      }
    });

    _registry.addFieldDeclaration((node) {
      if (!node.isStatic) return;

      for (final variable in node.fields.variables) {
        final declaration = LegacyProviderDeclaration.parse(variable);
        if (declaration == null) continue;

        _runSubscription(declaration, _onLegacyProviderDeclaration);
      }
    });
  }

  // void addLegacyProviderDeclaration();

  // // Ref life-cycle visitors
  // void addRefWatchInvocation();
  // void addRefListenInvocation();
  // void addRefReadInvocation();

  // // Cusumer visitors
  // void addConsumerWidgetDeclaration();

  // // Ref life-cycle visitors
  // void addWidgetRefWatchInvocation();
  // void addWidgetRefListenInvocation();
  // void addWidgetRefListenManualInvocation();
  // void addWidgetRefReadInvocation();
}
