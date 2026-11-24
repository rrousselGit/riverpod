import 'package:analyzer/dart/element/element.dart';
import 'package:glob/glob.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// The path of the policy file, relative to the repository root.
@internal
const legacyApiPolicyPath = 'baselines/legacy_api.yaml';

/// Which files of the repository may use the legacy APIs (`StateProvider`,
/// `StateNotifierProvider`, `ChangeNotifierProvider`, `package:state_notifier`
/// and the `legacy.dart` libraries that export them).
///
/// Read from [legacyApiPolicyPath]. Enforced on the Dart files that the
/// `avoid_legacy_api` lint analyzes by the lint, and on every other file by
/// `bin/check_legacy_api.dart`.
@internal
final class LegacyApiPolicy {
  LegacyApiPolicy({
    required this.ignored,
    required this.allowed,
    required this.baseline,
  });

  /// Parses the content of [legacyApiPolicyPath].
  ///
  /// Throws a [FormatException] if it is malformed.
  factory LegacyApiPolicy.parse(String content) {
    final yaml = loadYaml(content, sourceUrl: Uri.parse(legacyApiPolicyPath));
    if (yaml is! YamlMap) {
      throw const FormatException('$legacyApiPolicyPath must be a map');
    }

    List<String> list(String key) {
      final value = yaml[key];
      if (value == null) return const [];
      if (value is! YamlList || value.any((e) => e is! String)) {
        throw FormatException('`$key` must be a list of strings');
      }
      return value.cast<String>();
    }

    final unknownKeys = yaml.keys.toSet().difference({
      'ignored',
      'allowed',
      'baseline',
    });
    if (unknownKeys.isNotEmpty) {
      throw FormatException('Unknown keys: ${unknownKeys.join(', ')}');
    }

    List<Glob> globs(String key) => [
      for (final pattern in list(key)) Glob(pattern, context: p.posix),
    ];

    return LegacyApiPolicy(
      ignored: globs('ignored'),
      allowed: globs('allowed'),
      baseline: list('baseline'),
    );
  }

  /// The files that are not checked at all, such as translations of the docs.
  final List<Glob> ignored;

  /// The files that may always use legacy APIs: their implementation, their
  /// tests and the migration guides.
  final List<Glob> allowed;

  /// The files that used legacy APIs when this policy was added.
  ///
  /// This list may only shrink: an entry that no longer uses legacy APIs is
  /// reported, so that it gets removed.
  final List<String> baseline;

  /// Whether [path], relative to the repository root, is in [ignored].
  bool isIgnored(String path) => ignored.any((glob) => glob.matches(path));

  /// Whether [path], relative to the repository root, is in [allowed].
  bool isAllowed(String path) => allowed.any((glob) => glob.matches(path));

  /// Whether [path], relative to the repository root, is in [baseline].
  bool isBaseline(String path) => baseline.contains(path);
}

/// Converts [path] into a path relative to [root], with `/` separators,
/// as used by [LegacyApiPolicy].
@internal
String relativePolicyPath(String path, {required String root}) {
  return p.split(p.relative(path, from: root)).join('/');
}

/// The libraries that are the legacy APIs, or that only exist to export them.
@internal
bool isLegacyLibrary(Uri uri) {
  if (uri.scheme != 'package') return false;

  final segments = uri.pathSegments;
  if (segments.isEmpty) return false;

  switch (segments) {
    case ['state_notifier', ...]:
    case ['riverpod' || 'flutter_riverpod', 'src', 'providers', 'legacy', ...]:
    case ['riverpod' || 'flutter_riverpod' || 'hooks_riverpod', 'legacy.dart']:
      return true;
  }

  return false;
}

/// Whether [element] is declared by a legacy library (see [isLegacyLibrary]).
@internal
bool isLegacyElement(Element element) {
  final uri = element.library?.uri;
  return uri != null && isLegacyLibrary(uri);
}

final _legacyImport = RegExp(
  r'''['"]package:((riverpod|flutter_riverpod|hooks_riverpod)/legacy\.dart|state_notifier/)''',
);
final _legacyIdentifier = RegExp(
  r'\b(StateNotifier|StateNotifierProvider|StateNotifierProviderFamily|'
  'StateProvider|StateProviderFamily|StateController|'
  r'ChangeNotifierProvider|ChangeNotifierProviderFamily)\b',
);
final _stateNotifierDependency = RegExp(r'^\s+state_notifier\s*:');
final _dartFence = RegExp(r'^\s*```dart\b');
final _fenceEnd = RegExp(r'^\s*```\s*$');

/// A use of a legacy API found by [findLegacyTextUses].
@internal
typedef LegacyTextUse = ({int line, String text});

/// Finds the uses of legacy APIs in a file that the analyzer does not check,
/// by reading it as text.
///
/// - `pubspec.yaml`: a dependency on `state_notifier`.
/// - `.md` and `.mdx`: legacy imports or identifiers within ```` ```dart ````
///   code blocks.
/// - `.dart`: legacy imports or identifiers anywhere.
///
/// Other files have no uses.
@internal
List<LegacyTextUse> findLegacyTextUses(String path, String content) {
  final lines = content.split('\n');
  final uses = <LegacyTextUse>[];

  bool isLegacyCode(String line) =>
      _legacyImport.hasMatch(line) || _legacyIdentifier.hasMatch(line);

  void add(int index) => uses.add((line: index + 1, text: lines[index].trim()));

  switch (p.posix.extension(path)) {
    case _ when p.posix.basename(path) == 'pubspec.yaml':
      for (var i = 0; i < lines.length; i++) {
        if (_stateNotifierDependency.hasMatch(lines[i])) add(i);
      }
    case '.md' || '.mdx':
      var inDart = false;
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (!inDart) {
          inDart = _dartFence.hasMatch(line);
        } else if (_fenceEnd.hasMatch(line)) {
          inDart = false;
        } else if (isLegacyCode(line)) {
          add(i);
        }
      }
    case '.dart':
      for (var i = 0; i < lines.length; i++) {
        if (isLegacyCode(lines[i])) add(i);
      }
  }

  return uses;
}
