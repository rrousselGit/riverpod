// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:collection/collection.dart';

void main(List<String> args) async {
  final collection = AnalysisContextCollection(
    includedPaths: [Directory.current.absolute.path],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
  );

  // Often one context is returned, but depending on the project structure we
  // can see multiple contexts.
  for (final context in collection.contexts) {
    stdout.writeln('Analyzing ${context.contextRoot.root.path} ...');

    for (final filePath in context.contextRoot.analyzedFiles()) {
      if (!filePath.endsWith('.dart')) {
        continue;
      }

      final unit = await context.currentSession.getResolvedLibrary(filePath);
      if (unit is! ResolvedLibraryResult) continue;

      final providers = unit.element.topLevelElements
          .expand(
            (element) => element is ClassElement
                ? element.fields.where((e) => e.isStatic).toList()
                : [element],
          )
          .whereType<VariableElement>()
          .where((e) => e.type.element?.isFromRiverpod ?? false)
          .toList();

      final consumerWidgets = unit.element.topLevelElements
          .whereType<ClassElement>()
          .where(
            (element) =>
                const {
                  'ConsumerWidget',
                  'ConsumerStatefulWidget',
                  'HookConsumerWidget',
                }.contains(element.supertype?.element.name) &&
                (element.supertype?.element.isFromRiverpod ?? false),
          )
          .toList();

      for (final consumer in consumerWidgets) {
        final ast = unit.getElementDeclaration(consumer)?.node;
        ast?.visitChildren(ConsumerWidgetVisitor(consumer));
      }

      for (final provider in providers) {
        final ast = unit.getElementDeclaration(provider)?.node;

        ast?.visitChildren(ProviderDependencyVisitor(provider));
      }
    }
  }

  stdout.writeln('flowchart TB');
  stdout.write('''
  subgraph Arrows
    direction LR
    start1[ ] -..->|read| stop1[ ]
    style start1 height:0px;
    style stop1 height:0px;
    start2[ ] --->|listen| stop2[ ]
    style start2 height:0px;
    style stop2 height:0px; 
    start3[ ] ===>|watch| stop3[ ]
    style start3 height:0px;
    style stop3 height:0px; 
  end

  subgraph Type
    direction TB
    ConsumerWidget((widget));
    Provider[[provider]];
  end
''');

  for (final node in graph.consumerWidgets) {
    stdout.writeln('  ${node.definition.name}((${node.definition.name}));');

    for (final watch in node.watch) {
      stdout.writeln(
        '  ${displayNameForProvider(watch.definition)} ==> ${node.definition.name};',
      );
    }
    for (final listen in node.listen) {
      stdout.writeln(
        '  ${displayNameForProvider(listen.definition)} --> ${node.definition.name};',
      );
    }
    for (final read in node.read) {
      stdout.writeln(
        '  ${displayNameForProvider(read.definition)} -.-> ${node.definition.name};',
      );
    }
  }

  for (final node in graph.providers) {
    stdout.writeln('  ${node.definition.name}[[${node.definition.name}]];');

    for (final watch in node.watch) {
      stdout.writeln(
        '  ${displayNameForProvider(watch.definition)} ==> ${node.definition.name};',
      );
    }
    for (final listen in node.listen) {
      stdout.writeln(
        '  ${displayNameForProvider(listen.definition)} --> ${node.definition.name};',
      );
    }
    for (final read in node.read) {
      stdout.writeln(
        '  ${displayNameForProvider(read.definition)} -.-> ${node.definition.name};',
      );
    }
  }
}

final graph = ProviderGraph();

class ProviderGraph {
  final _providerCache = <VariableElement, ProviderNode>{};
  final _consumerWidgetCache = <ClassElement, ConsumerWidgetNode>{};

  Iterable<ConsumerWidgetNode> get consumerWidgets =>
      _consumerWidgetCache.values;

  Iterable<ProviderNode> get providers => _providerCache.values;

  ProviderNode providerNode(VariableElement element) {
    return _providerCache.putIfAbsent(element, () => ProviderNode(element));
  }

  ConsumerWidgetNode consumerWidgetNode(ClassElement element) {
    return _consumerWidgetCache.putIfAbsent(
      element,
      () => ConsumerWidgetNode(element),
    );
  }
}

class ConsumerWidgetNode {
  ConsumerWidgetNode(this.definition);

  final ClassElement definition;
  final watch = <ProviderNode>[];
  final listen = <ProviderNode>[];
  final read = <ProviderNode>[];
}

class ConsumerWidgetVisitor extends RecursiveAstVisitor<void> {
  ConsumerWidgetVisitor(this.consumer);

  final ClassElement consumer;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final targetTypeElement = node.target?.staticType?.element;

    if (const {'watch', 'listen', 'read'}.contains(node.methodName.name) &&
        targetTypeElement != null &&
        targetTypeElement.isFromRiverpod) {
      final providerExpression = node.argumentList.arguments.firstOrNull;
      if (providerExpression == null) return;

      final consumedProvider = parseProviderFromExpression(providerExpression);
      switch (node.methodName.name) {
        case 'watch':
          graph
              .consumerWidgetNode(consumer)
              .watch
              .add(graph.providerNode(consumedProvider));
          return;
        case 'listen':
          graph
              .consumerWidgetNode(consumer)
              .listen
              .add(graph.providerNode(consumedProvider));
          return;
        case 'read':
          graph
              .consumerWidgetNode(consumer)
              .read
              .add(graph.providerNode(consumedProvider));
          return;
        default:
          throw FallThroughError();
      }
    }
  }
}

class ProviderNode {
  ProviderNode(this.definition);

  final VariableElement definition;
  final watch = <ProviderNode>[];
  final listen = <ProviderNode>[];
  final read = <ProviderNode>[];
}

class ProviderDependencyVisitor extends RecursiveAstVisitor<void> {
  ProviderDependencyVisitor(this.provider);

  final VariableElement provider;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final targetTypeElement = node.target?.staticType?.element;

    if (const {'watch', 'listen', 'read'}.contains(node.methodName.name) &&
        targetTypeElement != null &&
        targetTypeElement.isFromRiverpod) {
      final providerExpression = node.argumentList.arguments.firstOrNull;
      if (providerExpression == null) return;

      final consumedProvider = parseProviderFromExpression(providerExpression);
      switch (node.methodName.name) {
        case 'watch':
          graph
              .providerNode(provider)
              .watch
              .add(graph.providerNode(consumedProvider));
          return;
        case 'listen':
          graph
              .providerNode(provider)
              .listen
              .add(graph.providerNode(consumedProvider));
          return;
        case 'read':
          graph
              .providerNode(provider)
              .read
              .add(graph.providerNode(consumedProvider));
          return;
        default:
          throw FallThroughError();
      }
    }
  }
}

String displayNameForProvider(VariableElement provider) {
  // TODO print `futureProvider.future` when possible
  return provider.name;
}

VariableElement parseProviderFromExpression(Expression providerExpression) {
  if (providerExpression is PropertyAccess) {
    // watch(family(0).modifier)
    final target = providerExpression.target;
    if (target != null) return parseProviderFromExpression(target);
  } else if (providerExpression is PrefixedIdentifier) {
    // watch(provider.modifier)
    return parseProviderFromExpression(providerExpression.prefix);
  } else if (providerExpression is Identifier) {
    // watch(variable)
    final Object? staticElement = providerExpression.staticElement;
    if (staticElement is PropertyAccessorElement) {
      return staticElement.declaration.variable;
    }
  } else if (providerExpression is FunctionExpressionInvocation) {
    // watch(family(id))
    return parseProviderFromExpression(providerExpression.function);
  } else if (providerExpression is MethodInvocation) {
    // watch(variable.select(...)) or watch(family(id).select(...))
    final target = providerExpression.target;
    if (target != null) return parseProviderFromExpression(target);
  }

  throw UnsupportedError(
    'unknown expression $providerExpression ${providerExpression.runtimeType}',
  );
}

extension on Element {
  bool get isFromRiverpod {
    return source?.uri.scheme == 'package' &&
        const {'riverpod', 'flutter_riverpod', 'hooks_riverpod'}
            .contains(source?.uri.pathSegments.firstOrNull);
  }
}
