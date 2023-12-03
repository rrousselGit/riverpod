import 'dart:collection';
import 'dart:math';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;
import 'package:meta/meta.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'analyze.dart';

/// Analyzes the given [rootDirectory] and prints the dependency graph.
Future<void> analyze2(
  String rootDirectory, {
  SupportFormat format = SupportFormat.mermaid,
}) async {
  final collection = AnalysisContextCollection(
    includedPaths: [rootDirectory],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
  );

  final logger = Logger.standard();

  final graph = _Graph();

  // Often one context is returned, but depending on the project structure we
  // can see multiple contexts.
  for (final context in collection.contexts) {
    final progress =
        logger.progress('Analyzing ${context.contextRoot.root.path} ...');

    print('');
    print('');
    print('');

    final file = context.contextRoot.root.getChildAssumingFile('pubspec.yaml');
    if (!file.exists) continue;

    final pubspec = Pubspec.parse(file.readAsStringSync());

    final packageNode = _PackageNode(
      pubspec.name,
      context.contextRoot.root.toUri(),
    );
    graph.nodes.add(packageNode);

    try {
      final riverpodAnalysis = await _analyzeContext(context);

      for (final (library, riverpodAnalysis) in riverpodAnalysis) {
        final libraryNode = _LibraryNode(library.element.source.uri);
        packageNode.children.add(libraryNode);

        final providers = const <ProviderDeclaration>[]
            .followedBy(riverpodAnalysis.legacyProviderDeclarations)
            .followedBy(riverpodAnalysis.classBasedProviderDeclarations)
            .followedBy(riverpodAnalysis.functionalProviderDeclarations);
        for (final provider in providers) {
          final providerNode = _ProviderNode(provider);
          libraryNode.addProvider(providerNode);
          if (provider is GeneratorProviderDeclaration) {
            for (final refInvocation in provider.refInvocations) {
              final dependencies = refInvocation.providers
                  .map((e) => e.providerElement)
                  .whereNotNull()
                  .map(
                    (e) => _SymbolKey(uri: e.element.source!.uri, name: e.name),
                  );

              providerNode.edges.addAll(dependencies);
            }
          }
        }

        for (final consumer in riverpodAnalysis.consumerWidgetDeclarations) {
          final consumerNode = _ConsumerNode(consumer);
          libraryNode.addConsumer(consumerNode);

          for (final refInvocation in consumer.widgetRefInvocations) {
            final dependencies = refInvocation.providers
                .map((e) => e.providerElement)
                .whereNotNull()
                .map(
                  (e) => _SymbolKey(uri: e.element.source!.uri, name: e.name),
                );

            consumerNode.edges.addAll(dependencies);
          }
        }
      }
    } finally {
      progress.finish(showTiming: true);
    }
  }

  print(graph.toD2());
}

Future<List<(ResolvedLibraryResult, ResolvedRiverpodLibraryResult)>>
    _analyzeContext(
  AnalysisContext context,
) {
  return Stream.fromFutures(
    context.contextRoot
        .analyzedFiles()
        .where((path) => path.endsWith('.dart'))
        .map(context.currentSession.getResolvedLibrary),
  )
      .where((e) => e is ResolvedLibraryResult)
      .cast<ResolvedLibraryResult>()
      .map(
        (element) => (
          element,
          ResolvedRiverpodLibraryResult.from(
            element.units.map((e) => e.unit).toList(),
          ),
        ),
      )
      .toList();
}

class _Graph {
  final nodes = <_PackageNode>[];

  String toD2() {
    final buffer = StringBuffer();

    // Generate synthetic folders
    var root = _DirectoryNode('');
    for (final node in nodes) {
      root.directories[node.packageName] = node.getDirectoryTree();
    }
    // Collapse redundant folders
    root = root.flatten();

    // Render all nodes
    root.toD2(buffer, 0);

    // Collect paths for nodes
    final nodesPath = <_SymbolKey, List<_DirectoryNode>>{};
    void visit(_DirectoryNode node, List<_DirectoryNode> path) {
      for (final library in node._libraries) {
        for (final node in library.children) {
          nodesPath[node.key] = path;
        }
      }

      for (final directory in node.directories.values) {
        visit(directory, [...path, node]);
      }
    }

    visit(root, []);

    // Draw edges
    String joinPath(List<_DirectoryNode> path, _SymbolKey target) {
      return '${path.map((e) => '"${e.name}"').join('.')}."${target.name}"';
    }

    for (final node in nodes) {
      for (final library in node.children) {
        for (final node in library.children) {
          final nodePath = joinPath(nodesPath[node.key]!, node.key);
          for (final target in node.edges) {
            final targetPath = joinPath(nodesPath[target]!, target);

            buffer.writeln('$targetPath --> $nodePath');
          }
        }
      }
    }

    return buffer.toString();
  }
}

enum _D2Shape {
  none(null),
  package('package'),
  callout('callout'),
  page('page');

  const _D2Shape(this.code);

  final String? code;
}

extension on int {
  String get indent => '  ' * this;
  String get direction => isEven ? 'LR' : 'TD';
}

abstract class _Node {
  bool get isEmpty;
  List<Object> get children;
}

abstract class _DisplayNode extends _Node {
  _SymbolKey get key;
  Set<_SymbolKey> get edges;

  void toD2(StringBuffer buffer, int level);
}

class _PackageNode {
  _PackageNode(this.packageName, this.uri);

  bool get isEmpty => children.every((element) => element.isEmpty);

  final String packageName;
  final Uri uri;

  final List<_LibraryNode> children = <_LibraryNode>[];

  _DirectoryNode getDirectoryTree() {
    final root = _DirectoryNode(
      'package:$packageName',
      shape: _D2Shape.package,
    );

    void insertSegments(List<String> segments, _LibraryNode library) {
      var current = root;

      for (var i = 0; i < segments.length - 1; i++) {
        final segment = segments[i];
        current = current.directories.putIfAbsent(
          segment,
          () => _DirectoryNode(segment),
        );
      }

      current.addLibrary(library);
    }

    for (final library in children) {
      if (library.isEmpty) continue;
      insertSegments(
        path.relative(library.uri.path).split(path.separator),
        library,
      );
    }

    return root;
  }
}

class _DirectoryNode {
  _DirectoryNode(this.name, {this.shape});

  final String name;
  final _D2Shape? shape;
  final directories = <String, _DirectoryNode>{};
  final _libraries = <_LibraryNode>[];

  _DirectoryNode flatten() {
    var name = this.name;
    var directories = this.directories;
    var libraries = _libraries;

    if (directories.length == 1 && _libraries.isEmpty) {
      final child = directories.values.single;

      name = path.join(name, child.name);
      libraries = [
        ..._libraries,
        ...child._libraries,
      ];
      directories = {...child.directories};
    }

    return _DirectoryNode(name)
      .._libraries.addAll(libraries)
      ..directories.addAll(directories);
  }

  void addLibrary(_LibraryNode library) {
    _libraries.add(library);
  }

  void toD2(StringBuffer buffer, int level, [String? parentPath]) {
    if (directories.isEmpty && _libraries.isEmpty) return;
    if (directories.isEmpty && _libraries.length == 1) {
      _libraries.single.toD2(buffer, level, parentPath);
      return;
    }

    final name =
        parentPath == null ? this.name : path.join(parentPath, this.name);

    buffer.writeln('${level.indent}"$name": {');

    for (final child in directories.values) {
      child.toD2(buffer, level + 1);
    }
    for (final library in _libraries) {
      library.toD2(buffer, level + 1);
    }

    buffer.writeln('${level.indent}}');

    if (shape?.code case final String shapeCode) {
      buffer.writeln('${level.indent}"$name".shape: "$shapeCode"');
    }
  }
}

class _LibraryNode extends _Node {
  _LibraryNode(this.uri) : id = uri.toString();

  final String id;
  final Uri uri;

  @override
  bool get isEmpty => children.every((element) => element.isEmpty);

  @override
  List<_DisplayNode> get children => UnmodifiableListView(_children);
  final _children = <_DisplayNode>[];

  void addProvider(_ProviderNode node) {
    _children.add(node);
  }

  void addConsumer(_ConsumerNode node) {
    _children.add(node);
  }

  void toD2(StringBuffer buffer, int level, [String? parentPath]) {
    final fileName = uri.pathSegments.last;

    final nodeName = parentPath == null
        ? fileName
        : path.join(parentPath, uri.pathSegments.last);

    buffer.writeln('${level.indent}"$nodeName": {');
    for (final child in _children) {
      child.toD2(buffer, level + 1);
    }
    buffer.writeln('${level.indent}}');
  }
}

@immutable
class _SymbolKey {
  const _SymbolKey({
    required this.uri,
    required this.name,
  });

  final Uri uri;
  // TODO handle top-level vs Class.provider
  final String name;

  @override
  String toString() => '$uri:$name';

  @override
  bool operator ==(Object other) {
    return other is _SymbolKey && other.uri == uri && other.name == name;
  }

  @override
  int get hashCode => Object.hash(uri, name);
}

extension on ProviderDeclaration {
  _SymbolKey get key {
    return _SymbolKey(
      uri: unit.declaredElement!.source.uri,
      name: name.lexeme,
    );
  }
}

extension on ConsumerDeclaration {
  _SymbolKey get key {
    return _SymbolKey(
      uri: unit.declaredElement!.source.uri,
      name: node.name.lexeme,
    );
  }
}

class _ProviderNode extends _DisplayNode {
  _ProviderNode(this.provider) : key = provider.key;

  @override
  bool get isEmpty => false;

  @override
  List<_Node> get children => const [];

  final ProviderDeclaration provider;
  @override
  final _SymbolKey key;
  @override
  final edges = <_SymbolKey>{};

  @override
  void toD2(StringBuffer buffer, int level) {
    buffer
      ..write(level.indent)
      ..writeln(provider.name);

    buffer.writeln(
      '${level.indent}"${provider.name}".shape: "${_D2Shape.page.code}"',
    );
  }
}

class _ConsumerNode extends _DisplayNode {
  _ConsumerNode(this.consumer) : key = consumer.key;

  // Don't render consumers if they aren't attached to any provider.
  @override
  bool get isEmpty => edges.isEmpty;

  @override
  List<_Node> get children => const [];

  @override
  final _SymbolKey key;
  final ConsumerDeclaration consumer;
  @override
  final edges = <_SymbolKey>{};

  @override
  void toD2(StringBuffer buffer, int level) {
    buffer
      ..write(level.indent)
      ..writeln(consumer.node.name);

    buffer.writeln(
      '${level.indent}"${consumer.node.name}".shape: "${_D2Shape.callout.code}"',
    );
  }
}
