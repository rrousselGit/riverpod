import 'package:glob/glob.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'legacy_api.dart';

final _ignoreComment = RegExp(r'ignore(_for_file)?:.*\bavoid_legacy_api\b');
final _disabledInOptions = RegExp(r'\bavoid_legacy_api\b');
final _analysisOptions = RegExp(r'^analysis_options.*\.yaml$');

/// Checks what the `avoid_legacy_api` lint cannot see, in every file but the
/// [LegacyApiPolicy.ignored] ones:
///
/// - The files the lint does not analyze: pubspec.yaml, Markdown, and the Dart
///   files whose analysis_options.yaml do not enable `internal_lint` or
///   exclude them (see [findLegacyTextUses]).
/// - That nothing silences the lint, with an `ignore` comment or in an
///   analysis_options.yaml.
/// - That every entry of [LegacyApiPolicy.baseline] exists, and is still
///   needed for the files checked as text. Analyzed files are reported by the
///   lint instead.
///
/// [files] are the paths of the repository's files, relative to its root, and
/// [read] reads one of them. Returns the problems found, one per line.
@internal
List<String> checkLegacyApi({
  required LegacyApiPolicy policy,
  required List<String> files,
  required String Function(String path) read,
}) {
  final problems = <String>[];
  final fileSet = files.toSet();
  final options = _AnalysisOptions(fileSet, read);

  final seen = <String>{};
  for (final entry in policy.baseline) {
    if (!seen.add(entry)) {
      problems.add('$entry: listed twice in the baseline.');
    } else if (!fileSet.contains(entry)) {
      problems.add('$entry: in the baseline, but no longer exists.');
    } else if (policy.isIgnored(entry)) {
      problems.add('$entry: in the baseline, but ignored.');
    } else if (policy.isAllowed(entry)) {
      problems.add('$entry: in the baseline, but already allowed.');
    }
  }

  for (final path in files) {
    if (policy.isIgnored(path)) continue;

    final basename = p.posix.basename(path);
    final isDart = p.posix.extension(path) == '.dart';
    final isOptions = _analysisOptions.hasMatch(basename);
    // Whether the uses of legacy APIs are found by reading the file as text,
    // rather than by the lint.
    final isText = isDart
        ? !options.isLinted(path)
        : basename == 'pubspec.yaml' ||
              const {'.md', '.mdx'}.contains(p.posix.extension(path));

    if (!isDart && !isOptions && !isText) continue;

    final String content;
    try {
      content = read(path);
    } on Object {
      // Binary or unreadable files cannot use legacy APIs.
      continue;
    }

    if (isDart) {
      final lines = content.split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (_ignoreComment.hasMatch(lines[i])) {
          problems.add(
            '$path:${i + 1}: avoid_legacy_api must not be ignored. '
            'Add the file to the baseline of $legacyApiPolicyPath instead.',
          );
        }
      }
    }
    if (isOptions && _disabledInOptions.hasMatch(content)) {
      problems.add('$path: avoid_legacy_api must not be configured.');
    }

    if (!isText || policy.isAllowed(path)) continue;

    final uses = findLegacyTextUses(path, content);
    if (policy.isBaseline(path)) {
      if (uses.isEmpty) {
        problems.add(
          '$path: no longer uses legacy APIs. '
          'Remove it from the baseline of $legacyApiPolicyPath.',
        );
      }
      continue;
    }

    for (final use in uses) {
      problems.add('$path:${use.line}: uses a legacy API: ${use.text}');
    }
  }

  return problems;
}

/// The analysis_options.yaml files of a repository, which tell which Dart
/// files the `avoid_legacy_api` lint analyzes.
///
/// This follows the analyzer: a Dart file uses the closest
/// analysis_options.yaml among its folders, along with the files it
/// `include`s.
final class _AnalysisOptions {
  _AnalysisOptions(this._files, this._read);

  final Set<String> _files;
  final String Function(String path) _read;
  final _parsed = <String, _OptionsFile>{};

  /// Whether the lint analyzes the Dart file at [path]: its options enable
  /// `internal_lint`, and do not exclude it.
  bool isLinted(String path) {
    final closest = _closest(path);
    if (closest == null) return false;

    final chain = _chain(closest);
    return chain.any((options) => options.plugins.contains('internal_lint')) &&
        !chain.any((options) => options.excludes(path));
  }

  String? _closest(String path) {
    for (var dir = p.posix.dirname(path); ; dir = p.posix.dirname(dir)) {
      final options = p.posix.normalize(
        p.posix.join(dir, 'analysis_options.yaml'),
      );
      if (_files.contains(options)) return options;
      if (dir == '.' || dir == '/') return null;
    }
  }

  /// [path] and the options files it includes, directly or not.
  List<_OptionsFile> _chain(String path) {
    final chain = <_OptionsFile>[];
    final pending = [path];
    final seen = <String>{};
    while (pending.isNotEmpty) {
      final next = pending.removeLast();
      if (!seen.add(next) || !_files.contains(next)) continue;

      final options = _parsed[next] ??= _OptionsFile.parse(next, _read(next));
      chain.add(options);
      pending.addAll(options.includes);
    }
    return chain;
  }
}

final class _OptionsFile {
  _OptionsFile({
    required this.path,
    required this.includes,
    required this.plugins,
    required this.exclude,
  });

  /// Parses the analysis_options.yaml at [path]. Unexpected content is
  /// ignored: the analyzer reports it.
  factory _OptionsFile.parse(String path, String content) {
    final dir = p.posix.dirname(path);
    Object? yaml;
    try {
      yaml = loadYaml(content);
    } on YamlException {
      yaml = null;
    }
    final map = yaml is YamlMap ? yaml : YamlMap();

    final include = map['include'];
    final analyzer = map['analyzer'];
    final exclude = analyzer is YamlMap ? analyzer['exclude'] : null;
    final plugins = map['plugins'];

    return _OptionsFile(
      path: path,
      includes: [
        for (final included in [
          if (include is String) include,
          if (include is YamlList) ...include.whereType<String>(),
        ])
          // `package:` includes cannot enable the repository's plugins.
          if (!included.startsWith('package:'))
            p.posix.normalize(p.posix.join(dir, included)),
      ],
      plugins: {if (plugins is YamlMap) ...plugins.keys.whereType<String>()},
      exclude: [
        if (exclude is YamlList)
          for (final pattern in exclude.whereType<String>())
            Glob(pattern, context: p.posix),
      ],
    );
  }

  final String path;
  final List<String> includes;
  final Set<String> plugins;

  /// Relative to the folder of [path].
  final List<Glob> exclude;

  bool excludes(String file) {
    final relative = p.posix.relative(file, from: p.posix.dirname(path));
    return exclude.any((glob) => glob.matches(relative));
  }
}
