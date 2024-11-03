import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:collection/collection.dart';

/// Analyzes the given [rootDirectory] and prints the dependency graph.
Future<void> analyze(
  String rootDirectory, {
  SupportFormat format = SupportFormat.mermaid,
}) async {
  final collection = AnalysisContextCollection(
    includedPaths: [rootDirectory],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
  );

  verifyRootDirectoryExists(rootDirectory);

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
        (variableElement) {
          if (variableElement.type.element?.isFromRiverpod ?? false) {
            return true;
          }
          return variableElement.type.extendsFromRiverpod;
        },
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

      for (final provider in providers.toList()) {
        final ast = unit.getElementDeclaration(provider)?.node;
        ast?.visitChildren(
          ProviderDependencyVisitor(
            provider: provider,
            unit: unit,
          ),
        );
      }
    }
  }

  switch (format) {
    case SupportFormat.d2:
      return stdout.write(_buildD2(graph));
    case SupportFormat.mermaid:
      return stdout.write(_buildMermaid(graph));
  }
}

///
///Throws an exception if the directory doesn't exist
///
bool verifyRootDirectoryExists(String rootDirectory) {
  if (!Directory(rootDirectory).existsSync()) {
    throw FileSystemException(
      'Requested scanning target directory does not exist $rootDirectory',
    );
  }
  return true;
}

/// Output formats supported by riverpod_graph
enum SupportFormat {
  /// Mermaid.js format
  mermaid,

  /// D2 format
  d2,
}

/// used to wrap names in d2 diagram boxes
const rawNewline = r'\n';

String _buildD2(ProviderGraph providerGraph) {
  const _watchLineStyle = '{style.stroke-width: 4}';
  const _readLineStyle = '{style.stroke-dash: 4}';

  final buffer = StringBuffer('''
Legend: {
  Type: {
    Widget.shape: circle
    Provider: rectangle
  }
  Arrows: {
    "." -> "..": read: {style.stroke-dash: 4}
    "." -> "..": listen
    "." -> "..": watch: {style.stroke-width: 4}
  }
}

''');

  // declare all the provider nodes before doing any connections
  // this lets us do all node config in one place before they are used
  for (final node in providerGraph.providers) {
    final providerName = _displayNameForProvider(node.definition).name;
    buffer.writeln('$providerName: "$providerName"');
    buffer.writeln('$providerName.shape: rectangle');

    // d2 supports tooltips.  mermaid does not
    // add the first line of any documentation comment as a tooltip
    final docComment = _displayDocCommentForProvider(node.definition);
    if (docComment != null) {
      buffer.writeln('$providerName.tooltip: "$docComment"');
    }
  }

  // declare all the widget nodes before doing any connections
  // this lets us do all node config in one place before they are used
  for (final node in providerGraph.consumerWidgets) {
    final widgetName = node.definition.name;
    buffer.writeln('$widgetName.shape: circle');

    // d2 supports tooltips.  mermaid does not
    // add the first line of any documentation comment as a tooltip
    final docComment = _displayDocCommentForWidget(node.definition);
    if (docComment != null) {
      buffer.writeln('$widgetName.tooltip: "$docComment"');
    }
  }
  buffer.writeln();

  for (final node in providerGraph.consumerWidgets) {
    for (final watch in node.watch) {
      buffer.writeln(
        '${_displayNameForProvider(watch.definition).name} -> ${node.definition.name}: $_watchLineStyle',
      );
    }
    for (final listen in node.listen) {
      buffer.writeln(
        '${_displayNameForProvider(listen.definition).name} -> ${node.definition.name}',
      );
    }
    for (final read in node.read) {
      buffer.writeln(
        '${_displayNameForProvider(read.definition).name} -> ${node.definition.name}: $_readLineStyle',
      );
    }
  }

  for (final node in providerGraph.providers) {
    final providerName = _displayNameForProvider(node.definition).name;

    for (final watch in node.watch) {
      buffer.writeln(
        '${_displayNameForProvider(watch.definition).name} -> $providerName: $_watchLineStyle',
      );
    }
    for (final listen in node.listen) {
      buffer.writeln(
        '${_displayNameForProvider(listen.definition).name} -> $providerName:',
      );
    }
    for (final read in node.read) {
      buffer.writeln(
        '${_displayNameForProvider(read.definition).name} -> $providerName: $_readLineStyle',
      );
    }
  }

  return buffer.toString();
}

String _buildMermaid(ProviderGraph providerGraph) {
  final buffer = StringBuffer('''
flowchart TB
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

  // declare all the provider nodes before doing any connections
  // this lets us do all node config in one place before they are used
  for (final node in providerGraph.providers) {
    final nodeGlobalName = _displayNameForProvider(node.definition);
    final isContainedInClass = nodeGlobalName.enclosingElementName.isNotEmpty;

    if (isContainedInClass) {
      buffer.writeln('  subgraph ${nodeGlobalName.enclosingElementName}');
      buffer.writeln(
        '    ${nodeGlobalName.name}[["${nodeGlobalName.providerName}"]];',
      );
      buffer.writeln('  end');
    } else {
      buffer.writeln(
        '  ${nodeGlobalName.name}[["${nodeGlobalName.providerName}"]];',
      );
    }
  }

  // declare all the widget nodes before doing any connections
  // this lets us do all node config in one place before they are used
  for (final node in providerGraph.consumerWidgets) {
    buffer.writeln('  ${node.definition.name}((${node.definition.name}));');
  }
  buffer.writeln();

  for (final node in providerGraph.consumerWidgets) {
    for (final watch in node.watch) {
      buffer.writeln(
        '  ${_displayNameForProvider(watch.definition).name} ==> ${node.definition.name};',
      );
    }
    for (final listen in node.listen) {
      buffer.writeln(
        '  ${_displayNameForProvider(listen.definition).name} --> ${node.definition.name};',
      );
    }
    for (final read in node.read) {
      buffer.writeln(
        '  ${_displayNameForProvider(read.definition).name} -.-> ${node.definition.name};',
      );
    }
  }

  for (final node in providerGraph.providers) {
    final nodeGlobalName = _displayNameForProvider(node.definition);

    final providerName = nodeGlobalName.providerName;
    for (final watch in node.watch) {
      buffer.writeln(
        '  ${_displayNameForProvider(watch.definition).name} ==> $providerName;',
      );
    }
    for (final listen in node.listen) {
      buffer.writeln(
        '  ${_displayNameForProvider(listen.definition).name} --> $providerName;',
      );
    }
    for (final read in node.read) {
      buffer.writeln(
        '  ${_displayNameForProvider(read.definition).name} -.-> $providerName;',
      );
    }
  }

  return buffer.toString();
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

    final targetTypeElement = node.realTarget?.staticType?.element;

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
          throw UnsupportedError('Unknown ref method ${node.methodName.name}');
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
  ProviderDependencyVisitor({
    required this.unit,
    required this.provider,
  });

  /// The provider that is being visited.
  final VariableElement provider;

  /// The current unit.
  final ResolvedLibraryResult unit;

  @override
  void visitArgumentList(ArgumentList node) {
    final parent = node.parent;
    if (parent is InstanceCreationExpression) {
      if (parent.staticType?.element?.isFromRiverpod ?? false) {
        // A provider is being created, if the first positional parameter is not
        // a function expression declaration (normal use of provider), but a
        // simple identifier or a constructor reference (usually the case with
        // riverpod_generator), we need to go the declaration of the method or
        // the class.
        // ```dart
        // final provider = Provider((ref) => 0);  // Expression declaration.
        // final providerSimpleIdentifier = Provider(myMethod); // Simple identifier.
        // final providerConstructorReference= Provider(MyClass.new); // Constructor reference.
        // ```
        final firstArgument = node.arguments.firstWhere(
          (argument) => argument is! NamedExpression,
        );
        if (firstArgument is SimpleIdentifier) {
          // The created provider is referencing a method defined somewhere else:
          // ```dart
          // final providerSimpleIdentifier = Provider(myMethod);
          // ```
          if (firstArgument.staticElement != null) {
            final functionDeclaration = unit
                .getElementDeclaration(
                  firstArgument.staticElement!,
                )
                ?.node;
            if (functionDeclaration is FunctionDeclaration) {
              // Instead of continuing with the current node, we visit the one of
              // the referenced method.
              return functionDeclaration.visitChildren(this);
            }
          }
        } else if (firstArgument is ConstructorReference) {
          // The created provider is referencing a constructor defined somewhere
          // else:
          // ```dart
          // final providerConstructorReference = Provider(MyClass.new);
          // ```
          if (firstArgument.constructorName.staticElement != null) {
            final classDeclaration = unit
                .getElementDeclaration(
                  firstArgument
                      .constructorName.staticElement!.returnType.element,
                )
                ?.node;
            if (classDeclaration is ClassDeclaration) {
              // firstWhereOrNull required if a class was created with .new
              final buildMethod = classDeclaration.members
                  .whereType<MethodDeclaration>()
                  .firstWhereOrNull(
                    (method) => method.name.lexeme == 'build',
                  );
              // Instead of continuing with the current node, we visit the one of
              // the referenced constructor.
              if (buildMethod != null) {
                return buildMethod.visitChildren(this);
              }
            }
          }
        }
      }
    } else if (node.parent is SuperConstructorInvocation) {
      // We might be visiting a family provider.
      // super(
      //   (ref) => family(ref, i),
      // );
      if ((node.parent! as SuperConstructorInvocation)
              .staticElement
              ?.isFromRiverpod ??
          false) {
        final firstArgument = node.arguments.firstWhere(
          (argument) => argument is! NamedExpression,
        );
        if (firstArgument is FunctionExpression &&
            firstArgument.body is ExpressionFunctionBody) {
          final bodyExpression =
              (firstArgument.body as ExpressionFunctionBody).expression;
          if (bodyExpression is MethodInvocation) {
            // We are visiting the invocation of `family(ref, i)`. This is
            // generated from a family method.
            // ```dart
            // @riverpod
            // String family(ref, int i) => 'Hello World';
            // ```
            // We now want to visit its declaration.
            final methodDeclaration = unit
                .getElementDeclaration(
                  bodyExpression.methodName.staticElement!,
                )
                ?.node;
            return methodDeclaration?.visitChildren(this);
          } else {
            // We need to check whether we are visiting a family provider
            // generated from a class.
            // ```dart
            // class FamilyClass extends _$FamilyClass {
            //   @override
            //   String build(i) => 'Hello World';
            // }
            // ```
            if (bodyExpression is CascadeExpression) {
              // The generated code contains a cascade expression :
              // ```dart
              // super(
              //   () => FamilyClass()..i = i,
              // );
              // ```
              if (bodyExpression.target.staticType is InterfaceType) {
                final classType =
                    bodyExpression.target.staticType! as InterfaceType;
                if (classType.methods.any(
                  (method) => method.name == 'build' && method.hasOverride,
                )) {
                  // The logic is implemented in an overridden `build` method.
                  // ```dart
                  // @override
                  // String build(i) => 'Hello World';
                  // ```
                  // We visit the declaration of this method.
                  final buildMethod = classType.methods.firstWhere(
                    (method) => method.name == 'build',
                  );
                  final methodDeclaration = unit
                      .getElementDeclaration(
                        buildMethod,
                      )
                      ?.node;
                  if (methodDeclaration != null) {
                    return methodDeclaration.visitChildren(this);
                  }
                }
              }
            }
          }
        }
      }
    }
    super.visitArgumentList(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (node.constructorName.type.type?.element?.isFromRiverpod ?? false) {
      // An "normal" provider is being created.
      // ```dart
      // final provider = Provider((ref) => 0);
      // ```
      // This case is handled by the `visitArgumentList` method.
      return super.visitInstanceCreationExpression(node);
    } else if (node.constructorName.type.type?.extendsFromRiverpod ?? false) {
      // A generated family provider is being created.
      final methods = (node.staticType as InterfaceType?)?.methods ?? const [];
      if (methods.any((method) => method.name == 'call')) {
        // The provider is generated family provider.
        // ```dart
        // @riverpod
        // String family(ref, int i) => 'Hello World';
        // ```
        // This case is handled by the `visitArgumentList` method.
        final callMethod =
            methods.firstWhere((method) => method.name == 'call');
        if (callMethod.returnType is InterfaceType &&
            (callMethod.returnType as InterfaceType).constructors.any(
                  (constructor) => constructor.name == '',
                )) {
          // The `call` method's returned type is generated provider class.
          //
          // The unnamed constructor calls the super constructor, with
          // ```dart
          // super(
          //   (ref) => family(ref, i),
          // );
          // ```
          final unnamedConstructorElement =
              (callMethod.returnType as InterfaceType).constructors.firstWhere(
                    (constructor) => constructor.name == '',
                  );
          final newNode =
              unit.getElementDeclaration(unnamedConstructorElement)?.node;
          // We visit the node of the unnamed constructor and continue in
          // `visitArgumentList`.
          return newNode?.visitChildren(this);
        }
      }
    }
    return super.visitInstanceCreationExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final targetTypeElement = node.realTarget?.staticType?.element;

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
          throw UnsupportedError('Unknown ref method ${node.methodName.name}');
      }
    }
  }
}

/// Stores the name of the provider and the name of the enclosing element if
/// any.
/// ```dart
/// class MyClass {
///   static final myProvider = Provider((ref) => 0);
/// }
/// ```
/// In the case of the above example [providerName] will be `'myProvider'` and
/// [enclosingElementName] will be `'MyClass'`.
class _ProviderName {
  const _ProviderName({
    required this.providerName,
    this.enclosingElementName = '',
  });

  final String providerName;
  final String enclosingElementName;

  /// The name displayed in the graph: `'MyClass.myProvider'`.
  String get name => enclosingElementName.isNotEmpty
      ? '$enclosingElementName.$providerName'
      : providerName;
}

/// Returns the name of the provider.
_ProviderName _displayNameForProvider(VariableElement provider) {
  final providerName = provider.name;
  final enclosingElementName = provider
      // ignore: deprecated_member_use, necessary to support older versions of analyzer
      .enclosingElement
      ?.displayName;
  return _ProviderName(
    providerName: providerName,
    enclosingElementName: enclosingElementName ?? '',
  );
}

String? _displayDocCommentForProvider(VariableElement definition) {
  return definition.documentationComment
      // this will show no text if the first doc comment line is blank :-(
      // tooltips should be short
      ?.split('\n')[0]
      .replaceAll('/// ', '');
}

String? _displayDocCommentForWidget(ClassElement definition) {
  return definition.documentationComment
      // this will show no text if the first doc comment line is blank :-(
      // tooltips should be short
      ?.split('\n')[0]
      .replaceAll('/// ', '');
}

/// Returns the variable element of the watched/listened/read `provider` in an expression. For example:
/// - `watch(family(0).modifier)`
/// - `watch(provider.modifier)`
/// - `watch(variable)`
/// - `watch(family(id))`
/// - `watch(variable.select(...))`
/// - `watch(family(id).select(...))`
VariableElement parseProviderFromExpression(
  Expression providerExpression,
) {
  if (providerExpression is PropertyAccess) {
    final staticElement = providerExpression.propertyName.staticElement;
    if (staticElement is PropertyAccessorElement &&
        !staticElement.library.isFromRiverpod) {
      // watch(SampleClass.familyProviders(id))
      return staticElement.declaration.variable2!;
    }
    final target = providerExpression.realTarget;
    return parseProviderFromExpression(target);
  } else if (providerExpression is PrefixedIdentifier) {
    if (providerExpression.name.isStartedUpperCaseLetter) {
      // watch(SomeClass.provider)
      final Object? staticElement = providerExpression.staticElement;
      if (staticElement is PropertyAccessorElement) {
        return staticElement.declaration.variable2!;
      }
    }
    // watch(provider.modifier)
    return parseProviderFromExpression(providerExpression.prefix);
  } else if (providerExpression is Identifier) {
    // watch(variable)
    final Object? staticElement = providerExpression.staticElement;
    if (staticElement is PropertyAccessorElement) {
      return staticElement.declaration.variable2!;
    }
  } else if (providerExpression is FunctionExpressionInvocation) {
    // watch(family(id))
    return parseProviderFromExpression(providerExpression.function);
  } else if (providerExpression is MethodInvocation) {
    // watch(variable.select(...)) or watch(family(id).select(...))
    final target = providerExpression.realTarget;
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
        const {
          'riverpod',
          'flutter_riverpod',
          'hooks_riverpod',
        }.contains(source?.uri.pathSegments.firstOrNull);
  }
}

extension on String {
  bool get isStartedUpperCaseLetter =>
      isNotEmpty && _firstLetter == _firstLetter.toUpperCase();

  String get _firstLetter => substring(0, 1);
}

extension on DartType {
  /// Returns `true` if the type is extending a type from riverpod.
  bool get extendsFromRiverpod {
    return this is InterfaceType &&
        (this as InterfaceType)
            .allSupertypes
            .any((type) => type.element.isFromRiverpod);
  }
}
