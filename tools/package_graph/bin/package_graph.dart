// Generates /package_graph.yaml: how the packages of this pub workspace depend
// on each other, read from their pubspec.yaml files.
//
// Run from the repository root:
//   dart run tools/package_graph/bin/package_graph.dart [--output <file> | -]
//
// Prefer `scripts/check.sh graph --fix`, which runs this. `scripts/check.sh`
// (and therefore CI) fails while the committed file is out of date.

import 'dart:io';

import 'package:yaml/yaml.dart';

const _defaultOutput = 'package_graph.yaml';

const _header = '''
# GENERATED FILE - DO NOT MODIFY BY HAND.
#
# How the packages of this workspace depend on each other, sourced from the
# pubspec.yaml of every package listed under `workspace:` in /pubspec.yaml.
# Regenerate with: scripts/check.sh graph --fix
# (scripts/check.sh fails while this file is out of date.)
#
# Only packages of this workspace appear. `dependencies`, `dev_dependencies`
# and `dependency_overrides` all count as edges: a package's dev dependencies
# (code generators, test utilities...) must be ready before the package is.
''';

class _Package {
  _Package({
    required this.name,
    required this.path,
    required this.codegen,
    required this.dependencies,
    required this.devDependencies,
    required this.dependencyOverrides,
  });

  final String name;
  final String path;

  /// Whether the package runs build_runner.
  final bool codegen;

  final List<String> dependencies;
  final List<String> devDependencies;
  final List<String> dependencyOverrides;

  /// Workspace packages that depend on this one, in any way.
  final Set<String> dependents = {};

  /// Every workspace package this one depends on, in any way, sorted.
  List<String> get edges => {
        ...dependencies,
        ...devDependencies,
        ...dependencyOverrides,
      }.toList()
        ..sort();

  /// Direct children in the tree: (name, isDevOnly), sorted by name.
  List<(String, bool)> get children {
    final regular = {...dependencies, ...dependencyOverrides};
    return [
      for (final name in edges) (name, !regular.contains(name)),
    ];
  }
}

Never _fail(String message) {
  stderr.writeln('package_graph: $message');
  exit(1);
}

void main(List<String> args) {
  var output = _defaultOutput;
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--output' || '-o' when i + 1 < args.length:
        output = args[++i];
      case '--help' || '-h':
        stdout.writeln(
          'Usage: dart run tools/package_graph/bin/package_graph.dart '
          '[--output <file> | -]',
        );
        return;
      default:
        _fail('Unknown argument: ${args[i]}');
    }
  }

  final content = render(readWorkspace(Directory.current));
  if (output == '-') {
    stdout.write(content);
  } else {
    File(output).writeAsStringSync(content);
  }
}

YamlMap _loadPubspec(String path) {
  final file = File(path);
  if (!file.existsSync()) _fail('$path does not exist.');
  final content = loadYaml(file.readAsStringSync(), sourceUrl: file.uri);
  if (content is! YamlMap) _fail('$path is not a YAML map.');
  return content;
}

String _normalize(String path) {
  var result = path;
  if (result.startsWith('./')) result = result.substring(2);
  while (result.endsWith('/')) {
    result = result.substring(0, result.length - 1);
  }
  return result;
}

/// The keys of a pubspec section such as `dependencies`.
List<String> _keys(YamlMap pubspec, String section) {
  final value = pubspec[section];
  if (value is! YamlMap) return const [];
  return [for (final key in value.keys) key as String];
}

Map<String, _Package> readWorkspace(Directory root) {
  final rootPubspec = _loadPubspec('${root.path}/pubspec.yaml');
  final workspace = rootPubspec['workspace'];
  if (workspace is! YamlList) {
    _fail('pubspec.yaml has no `workspace:` list. '
        'Run this from the repository root.');
  }

  final pubspecs = <String, YamlMap>{};
  final paths = <String, String>{};
  for (final entry in workspace) {
    final path = _normalize(entry as String);
    final pubspec = _loadPubspec('${root.path}/$path/pubspec.yaml');
    final name = pubspec['name'];
    if (name is! String) _fail('$path/pubspec.yaml has no `name`.');
    final existing = paths[name];
    if (existing != null) {
      _fail('Two workspace packages are named "$name": $existing and $path.');
    }
    pubspecs[name] = pubspec;
    paths[name] = path;
  }

  List<String> workspaceKeys(YamlMap pubspec, String section) =>
      _keys(pubspec, section).where(paths.containsKey).toList()..sort();

  final packages = <String, _Package>{
    for (final MapEntry(key: name, value: pubspec) in pubspecs.entries)
      name: _Package(
        name: name,
        path: paths[name]!,
        codegen: [
          ..._keys(pubspec, 'dependencies'),
          ..._keys(pubspec, 'dev_dependencies'),
        ].contains('build_runner'),
        dependencies: workspaceKeys(pubspec, 'dependencies'),
        devDependencies: workspaceKeys(pubspec, 'dev_dependencies'),
        dependencyOverrides: workspaceKeys(pubspec, 'dependency_overrides'),
      ),
  };
  for (final package in packages.values) {
    for (final dependency in package.edges) {
      packages[dependency]!.dependents.add(package.name);
    }
  }
  return packages;
}

/// Groups packages so that each group only depends on earlier groups.
///
/// A package's group is the length of its longest dependency chain.
List<List<String>> layersOf(Map<String, _Package> packages) {
  final depth = <String, int>{};
  final visiting = <String>[];

  int visit(String name) {
    final known = depth[name];
    if (known != null) return known;
    if (visiting.contains(name)) {
      final cycle = [...visiting.sublist(visiting.indexOf(name)), name];
      _fail('Dependency cycle: ${cycle.join(' -> ')}');
    }
    visiting.add(name);
    var result = 0;
    for (final dependency in packages[name]!.edges) {
      final candidate = visit(dependency) + 1;
      if (candidate > result) result = candidate;
    }
    visiting.removeLast();
    return depth[name] = result;
  }

  final names = packages.keys.toList()..sort();
  for (final name in names) {
    visit(name);
  }

  final layers = <List<String>>[];
  for (final name in names) {
    final layer = depth[name]!;
    while (layers.length <= layer) {
      layers.add([]);
    }
    layers[layer].add(name);
  }
  return layers;
}

String _list(Iterable<String> items) => '[${items.join(', ')}]';

String render(Map<String, _Package> packages) {
  final names = packages.keys.toList()..sort();
  final buffer = StringBuffer(_header)
    ..writeln()
    ..writeln('# Every workspace package, with its direct relationships.')
    ..writeln('packages:');
  for (final name in names) {
    final package = packages[name]!;
    buffer
      ..writeln('  $name:')
      ..writeln('    path: ${package.path}')
      ..writeln('    codegen: ${package.codegen}')
      ..writeln('    dependencies: ${_list(package.dependencies)}')
      ..writeln('    dev_dependencies: ${_list(package.devDependencies)}')
      ..writeln(
        '    dependency_overrides: ${_list(package.dependencyOverrides)}',
      )
      ..writeln(
        '    dependents: ${_list(package.dependents.toList()..sort())}',
      );
  }

  buffer
    ..writeln()
    ..writeln('# Every relationship as a tree, starting from the packages that')
    ..writeln('# nothing depends on. Dev-only dependencies are marked "(dev)".')
    ..writeln('# Shared subtrees are repeated in full.')
    ..writeln('tree:');
  void writeNode(String name, String label, int indent) {
    final children = packages[name]!.children;
    final prefix = '  ' * indent;
    if (children.isEmpty) {
      buffer.writeln('$prefix$label: {}');
      return;
    }
    buffer.writeln('$prefix$label:');
    for (final (child, isDev) in children) {
      writeNode(child, isDev ? '$child (dev)' : child, indent + 1);
    }
  }

  for (final name in names) {
    if (packages[name]!.dependents.isEmpty) writeNode(name, name, 1);
  }

  buffer
    ..writeln()
    ..writeln('# The same graph flattened for parallel work: each group only')
    ..writeln('# depends on earlier groups. Run the groups in order; everything')
    ..writeln('# within a group can run at the same time.')
    ..writeln('layers:');
  for (final layer in layersOf(packages)) {
    buffer.writeln('  - ${_list(layer)}');
  }
  return buffer.toString();
}
