import 'package:glob/glob.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'extract.dart';
import 'render.dart';

/// The path of the policy file, relative to the repository root.
@internal
const snippetPolicyPath = 'baselines/snippets.yaml';

/// Which files have their snippets extracted.
///
/// Read from [snippetPolicyPath].
@internal
final class SnippetPolicy {
  SnippetPolicy({required this.ignored, required this.unchecked});

  /// Parses the content of [snippetPolicyPath].
  ///
  /// Throws a [FormatException] if it is malformed.
  factory SnippetPolicy.parse(String content) {
    final yaml = loadYaml(content, sourceUrl: Uri.parse(snippetPolicyPath));
    if (yaml is! YamlMap) {
      throw const FormatException('$snippetPolicyPath must be a map');
    }

    final unknownKeys = yaml.keys.toSet().difference({'ignored', 'unchecked'});
    if (unknownKeys.isNotEmpty) {
      throw FormatException('Unknown keys: ${unknownKeys.join(', ')}');
    }

    List<String> strings(String key) {
      final value = yaml[key] ?? YamlList();
      if (value is! YamlList || value.any((e) => e is! String)) {
        throw FormatException('`$key` must be a list of strings');
      }
      return value.cast<String>();
    }

    return SnippetPolicy(
      ignored: [
        for (final pattern in strings('ignored'))
          Glob(pattern, context: p.posix),
      ],
      unchecked: strings('unchecked').toSet(),
    );
  }

  /// The files whose snippets are never extracted, such as changelogs.
  final List<Glob> ignored;

  /// The files whose snippets were invalid when the extraction was added,
  /// and are not extracted until they are fixed.
  final Set<String> unchecked;

  /// Whether [path], relative to the repository root, is in [ignored].
  bool isIgnored(String path) => ignored.any((glob) => glob.matches(path));
}

/// What [generateSnippets] made.
@internal
final class SnippetGeneration {
  SnippetGeneration(this.files, this.problems);

  /// The content of each Dart file to write, by its path relative to the
  /// folder of the snippets.
  final Map<String, String> files;

  /// The problems found, one per line.
  final List<String> problems;
}

final _name = RegExp(r'^[a-z][a-z0-9_]*$');

/// Renders every `dart` snippet of the doc comments of the Dart files, and
/// of the Markdown and MDX files, as a Dart file of its own (see
/// [renderSnippet]).
///
/// The n-th snippet of `folder/file.md` becomes `folder/file_md/snippet_n.dart`,
/// or `folder/file_md/name.dart` if its fence is `dart name=name`, so that
/// tests can import it by a path that stays the same when the file changes.
/// A `dart continued` fence follows the code of the extracted snippet before
/// it, which it can then refer to. The fences with `dart no-analyze` are skipped, as
/// are generated files and the files that [policy] ignores or leaves
/// unchecked.
///
/// A snippet imports the main library of its package, if it has one.
///
/// [files] are the paths of the repository's files, relative to its root, and
/// [read] reads one of them.
@internal
SnippetGeneration generateSnippets({
  required SnippetPolicy policy,
  required List<String> files,
  required String Function(String path) read,
}) {
  final outputs = <String, String>{};
  final problems = <String>[];
  final fileSet = files.toSet();

  // The folder of each package with a main library, and that library.
  final mainLibraries = <String, String>{};
  for (final path in files) {
    if (p.posix.basename(path) != 'pubspec.yaml') continue;
    final pubspec = loadYaml(read(path));
    final name = pubspec is YamlMap ? pubspec['name'] : null;
    final folder = p.posix.dirname(path);
    if (name is String &&
        fileSet.contains(p.posix.join(folder, 'lib', '$name.dart'))) {
      mainLibraries[folder] = 'package:$name/$name.dart';
    }
  }
  String? mainLibraryOf(String path) {
    var folder = p.posix.dirname(path);
    while (!mainLibraries.containsKey(folder) && folder != '.') {
      folder = p.posix.dirname(folder);
    }
    return mainLibraries[folder];
  }

  for (final path in policy.unchecked) {
    if (!fileSet.contains(path)) {
      problems.add('$path: in `unchecked`, but no longer exists.');
    } else if (policy.isIgnored(path)) {
      problems.add('$path: in `unchecked`, but ignored.');
    }
  }

  for (final path in files) {
    final extension = p.posix.extension(path);
    final isDart = extension == '.dart';
    if (!(isDart || extension == '.md' || extension == '.mdx') ||
        policy.isIgnored(path)) {
      continue;
    }
    final content = read(path);
    if (isDart && _isGenerated(path, content)) continue;

    final source = isDart
        ? extractDartSnippets(content)
        : extractMarkdownSnippets(content);
    if (policy.unchecked.contains(path)) {
      if (source.snippets.every((snippet) => snippet.isSkipped)) {
        problems.add(
          '$path: in `unchecked`, but has no snippet to extract. '
          'Remove it from $snippetPolicyPath.',
        );
      }
      continue;
    }

    final folder = p.posix.join(
      p.posix.dirname(path),
      '${p.posix.basenameWithoutExtension(path)}_${extension.substring(1)}',
    );
    final mainLibrary = mainLibraryOf(path);
    // The code of the previous extracted snippet, which a `continued` one
    // follows.
    String? previous;
    for (final (index, snippet) in source.snippets.indexed) {
      final location = '$path:${snippet.line}';
      var code = snippet.code;
      if (snippet.isContinued) {
        if (previous == null) {
          problems.add(
            '$location: `continued`, but the first snippet of its file.',
          );
        } else {
          code = '$previous\n\n$code';
        }
      }
      if (snippet.isSkipped) continue;
      previous = code;

      final name = snippet.name;
      if (name != null && !_name.hasMatch(name)) {
        problems.add(
          '$location: the name of a snippet must be in snake_case, '
          'but is "$name".',
        );
        continue;
      }
      final output = p.posix.normalize(
        p.posix.join(folder, '${name ?? 'snippet_${index + 1}'}.dart'),
      );
      if (outputs.containsKey(output)) {
        problems.add(
          '$location: another snippet of this file is extracted to $output. '
          'Rename one of them.',
        );
        continue;
      }

      outputs[output] = renderSnippet(
        source: path,
        code: code,
        assumptions: source.assumptions,
        imports: [?mainLibrary],
      );
    }
  }

  return SnippetGeneration(outputs, problems);
}

/// Generated files: `*.g.dart`, `*.freezed.dart`, or a "GENERATED" header.
/// Matches `is_generated` of scripts/lib/common.sh.
bool _isGenerated(String path, String content) {
  if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) return true;
  return content.split('\n').take(5).any((line) => line.contains('GENERATED'));
}
