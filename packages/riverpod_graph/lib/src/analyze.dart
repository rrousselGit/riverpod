import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:collection/collection.dart';

/// Analyzes the given [rootDirectory] and prints the dependency graph.
Future<void> analyze(String rootDirectory) async {
  final collection = AnalysisContextCollection(
    includedPaths: [rootDirectory],
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

      // List of all the providers of the current file that are either top level
      // element or static element of classes.
      final providers = unit.element.topLevelElements
          .expand(
            (element) => element is ClassElement
                ? element.fields.where((e) => e.isStatic).toList()
                : [element],
          )
          .whereType<VariableElement>()
          .where(
            (variableElement) =>
                variableElement.type.element?.isFromRiverpod ?? false,
          );

      // List of all the consumer widgets of the current file that are either
      // top level element or static element of classes.
      final consumerWidgets =
          unit.element.topLevelElements.whereType<ClassElement>().where(
                (element) =>
                    const {
                      'ConsumerWidget',
                      'ConsumerStatefulWidget',
                      'HookConsumerWidget',
                    }.contains(element.supertype?.element.name) &&
                    (element.supertype?.element.isFromRiverpod ?? false),
              );

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
    final nodeDefinitionName = displayNameForProvider(node.definition);
    stdout.writeln('  $nodeDefinitionName[[$nodeDefinitionName]];');

    for (final watch in node.watch) {
      stdout.writeln(
        '  ${displayNameForProvider(watch.definition)} ==> $nodeDefinitionName;',
      );
    }
    for (final listen in node.listen) {
      stdout.writeln(
        '  ${displayNameForProvider(listen.definition)} --> $nodeDefinitionName;',
      );
    }
    for (final read in node.read) {
      stdout.writeln(
        '  ${displayNameForProvider(read.definition)} -.-> $nodeDefinitionName;',
      );
    }
  }
}

/// The generated dependency graph.
final graph = ProviderGraph();

/// A dependency graph.
class ProviderGraph {
  final _providerCache = <VariableElement, ProviderNode>{};
  final _consumerWidgetCache = <ClassElement, ConsumerWidgetNode>{};

  /// The different consumer widgets.
  Iterable<ConsumerWidgetNode> get consumerWidgets =>
      _consumerWidgetCache.values;

  /// The different providers
  Iterable<ProviderNode> get providers => _providerCache.values;

  /// Gets the [ProviderNode] for the given [element] and inserts it in the
  /// cache if needed.
  ProviderNode providerNode(VariableElement element) {
    return _providerCache.putIfAbsent(element, () => ProviderNode(element));
  }

  /// Gets the [ConsumerWidgetNode] for the given [element] and inserts it in
  /// the cache if needed.
  ConsumerWidgetNode consumerWidgetNode(ClassElement element) {
    return _consumerWidgetCache.putIfAbsent(
      element,
      () => ConsumerWidgetNode(element),
    );
  }
}

/// Stores the list of providers that the consumer widget depends on.
class ConsumerWidgetNode {
  /// Stores the list of providers that the consumer widget depends on.
  ConsumerWidgetNode(this.definition);

  /// The consumer widget element definition.
  final ClassElement definition;

  /// All the providers the consumer widget is watching.
  final watch = <ProviderNode>[];

  /// All the providers the consumer widget is listening to.
  final listen = <ProviderNode>[];

  /// All the providers the consumer widget is reading.
  final read = <ProviderNode>[];
}

/// A visitor that finds all the providers that are used by the given consumer
/// widget.
class ConsumerWidgetVisitor extends RecursiveAstVisitor<void> {
  /// A visitor that finds all the providers that are used by the given consumer
  /// widget.
  ConsumerWidgetVisitor(this.consumer);

  /// The consumer widget that is being visited.
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

/// Stores the list of providers that the provider depends on.
class ProviderNode {
  /// Stores the list of providers that the provider depends on.
  ProviderNode(this.definition);

  /// The provider element definition.
  final VariableElement definition;

  /// All the providers the provider is watching.
  final watch = <ProviderNode>[];

  /// All the providers the provider is listening to.
  final listen = <ProviderNode>[];

  /// All the providers the provider is reading.
  final read = <ProviderNode>[];
}

/// A visitor that finds all the providers that are used by the given provider.
class ProviderDependencyVisitor extends RecursiveAstVisitor<void> {
  /// A visitor that finds all the providers that are used by the given
  /// provider.
  ProviderDependencyVisitor(this.provider);

  /// The provider that is being visited.
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

/// Returns the name of the provider.
String displayNameForProvider(VariableElement provider) {
  final providerName = provider.name;
  final enclosingElementName = provider.enclosingElement?.displayName;
  if (enclosingElementName != null && enclosingElementName.isNotEmpty) {
    // ClassName.providerName
    return '$enclosingElementName.$providerName';
  }
  // TODO print `futureProvider.future` when possible
  return providerName;
}

/// Returns the variable element of the watched/listened/read `provider` in an expression. For example:
/// - `watch(family(0).modifier)`
/// - `watch(provider.modifier)`
/// - `watch(variable)`
/// - `watch(family(id))`
/// - `watch(variable.select(...))`
/// - `watch(family(id).select(...))`
VariableElement parseProviderFromExpression(Expression providerExpression) {
  if (providerExpression is PropertyAccess) {
    // watch(family(0).modifier)
    final target = providerExpression.target;
    if (target != null) return parseProviderFromExpression(target);
  } else if (providerExpression is PrefixedIdentifier) {
    if (providerExpression.name.isStartedUpperCaseLetter) {
      // watch(SomeClass.provider)
      final Object? staticElement = providerExpression.staticElement;
      if (staticElement is PropertyAccessorElement) {
        return staticElement.declaration.variable;
      }
    }
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
  /// Returns `true` if an element is defined in one of the riverpod packages.
  bool get isFromRiverpod {
    return source?.uri.scheme == 'package' &&
        const {'riverpod', 'flutter_riverpod', 'hooks_riverpod'}
            .contains(source?.uri.pathSegments.firstOrNull);
  }
}

extension on String {
  bool get isStartedUpperCaseLetter =>
      isNotEmpty && _firstLetter == _firstLetter.toUpperCase();

  String get _firstLetter => substring(0, 1);
}
