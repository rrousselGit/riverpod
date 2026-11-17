import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:glob/glob.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'link_extraction.dart';

/// The path of the policy file, relative to the repository root.
@internal
const linkPolicyPath = 'baselines/links.yaml';

/// Which files and links [checkLinks] skips.
///
/// Read from [linkPolicyPath], and enforced by `bin/check_links.dart`.
@internal
final class LinkPolicy {
  LinkPolicy({required this.ignored, required this.ignoredLinks});

  /// Parses the content of [linkPolicyPath].
  ///
  /// Throws a [FormatException] if it is malformed.
  factory LinkPolicy.parse(String content) {
    final yaml = loadYaml(content, sourceUrl: Uri.parse(linkPolicyPath));
    if (yaml is! YamlMap) {
      throw const FormatException('$linkPolicyPath must be a map');
    }
    const keys = {'ignored', 'ignored_links'};
    final unknownKeys = yaml.keys.toSet().difference(keys);
    if (unknownKeys.isNotEmpty) {
      throw FormatException('Unknown keys: ${unknownKeys.join(', ')}');
    }
    List<String> strings(String key) {
      final list = yaml[key] ?? YamlList();
      if (list is! YamlList || list.any((e) => e is! String)) {
        throw FormatException('`$key` must be a list of strings');
      }
      return list.cast<String>();
    }

    return LinkPolicy(
      ignored: [
        for (final pattern in strings('ignored'))
          Glob(pattern, context: p.posix),
      ],
      ignoredLinks: strings('ignored_links'),
    );
  }

  /// The files whose links are not checked.
  final List<Glob> ignored;

  /// What the links that are not checked start with, such as the URLs that
  /// the examples make up.
  final List<String> ignoredLinks;

  /// Whether [path], relative to the repository root, is in [ignored].
  bool isIgnored(String path) => ignored.any((glob) => glob.matches(path));

  /// Whether [target] starts with one of [ignoredLinks].
  bool ignoresLink(String target) => ignoredLinks.any(target.startsWith);
}

/// The Docusaurus website of the repository: `root` is its folder, relative
/// to the repository root, and `host` where it is published, such as
/// `riverpod.dev`.
@internal
typedef Website = ({String root, String host});

/// The GitHub repository that the files are pushed to: `slug` is its
/// `owner/name`, and `branch` the branch that the links to its files name.
@internal
typedef Repository = ({String slug, String branch});

/// What [checkLinks] found.
@internal
final class LinkCheck {
  LinkCheck(this.problems, this.external);

  /// The broken links, one per line.
  final List<String> problems;

  /// The links to other websites, without their fragment, and where they
  /// are (`path:line`). Whether those exist is checked separately (see
  /// [checkExternalLinks]).
  final Map<Uri, List<String>> external;
}

/// Checks the links of the Markdown and MDX files (see [linksInMarkdown])
/// and of the comments of the Dart files (see [linksInDart]):
///
/// - A path must be one of [files], or a folder of them. In a page of the
///   `website`, it may also be the path of a page or of a static file, as
///   Docusaurus resolves them.
/// - `<Link documentID="id" />` must name a page of the website, in the
///   language of its file or in English.
/// - A URL of the website, or of a file of the `repository` on its branch,
///   is checked like a path, as what it links is among [files]. So it is
///   valid as soon as the change that adds its target is.
/// - A `#fragment` must be among the [anchorsOf] the Markdown file it links.
/// - A reference link must be defined.
///
/// Other URLs are returned as [LinkCheck.external].
///
/// Generated files, the [LinkPolicy.ignored] files and the
/// [LinkPolicy.ignoredLinks] are skipped.
///
/// [files] are the paths of the repository's files, relative to its root, and
/// [read] reads one of them.
@internal
LinkCheck checkLinks({
  required LinkPolicy policy,
  required Website website,
  required Repository repository,
  required List<String> files,
  required String Function(String path) read,
}) {
  final checker = _Checker(website, repository, files, read);
  final problems = <String>[];

  for (final path in files) {
    final isDart = p.posix.extension(path) == '.dart';
    if (!(isDart || _isMarkdown(path)) || policy.isIgnored(path)) continue;
    final content = read(path);
    final List<FoundLink> links;
    final LineInfo lineInfo;
    if (isDart) {
      // Most files link nothing, and need not be parsed.
      if (!content.contains('://') || _isGenerated(path, content)) continue;
      final unit = parseString(
        content: content,
        throwIfDiagnostics: false,
      ).unit;
      links = linksInDart(unit);
      lineInfo = unit.lineInfo;
    } else {
      links = linksInMarkdown(content);
      lineInfo = LineInfo.fromContent(content);
    }

    for (final link in links) {
      if (policy.ignoresLink(link.target)) continue;
      final location = '$path:${lineInfo.getLocation(link.offset).lineNumber}';
      final problem = checker.check(path, location, link);
      if (problem != null) {
        problems.add('$location: `${link.target}`: $problem.');
      }
    }
  }

  return LinkCheck(problems, checker.external);
}

/// Generated files: `*.g.dart`, `*.freezed.dart`, or a "GENERATED" header.
/// Matches `is_generated` of scripts/lib/common.sh.
bool _isGenerated(String path, String content) {
  if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) return true;
  return content.split('\n').take(5).any((line) => line.contains('GENERATED'));
}

bool _isMarkdown(String path) =>
    const {'.md', '.mdx'}.contains(p.posix.extension(path));

final _lines = RegExp(r'^L\d+(-L\d+)?$');
final _badEscape = RegExp('%(?![0-9A-Fa-f]{2})');

class _Checker {
  _Checker(this.website, this.repository, List<String> files, this.read)
    : files = files.toSet(),
      site = _Site(website.root, files) {
    for (final file in files) {
      for (
        var folder = p.posix.dirname(file);
        folders.add(folder);
        folder = p.posix.dirname(folder)
      ) {}
    }
  }

  final Website website;
  final Repository repository;
  final String Function(String path) read;
  final Set<String> files;
  final _Site site;

  /// The folders of [files]. The repository root is `.`.
  final folders = <String>{};
  final external = <Uri, List<String>>{};
  final _anchors = <String, Set<String>>{};

  /// Why the [link] of the file at [path] is broken, if it is.
  String? check(String path, String location, FoundLink link) {
    final page = site.pageOf(path);
    switch (link.kind) {
      case LinkKind.undefinedReference:
        return 'no `[${link.target}]: ...` defines this reference';
      case LinkKind.document:
        final [id, ...fragment] = link.target.split('#');
        final file = site.document(id, page?.locale);
        if (file == null) return 'the website has no page with this id';
        // The component links `/docs/id`.
        if (site.route('/docs/$id', page?.locale) == null) {
          return 'the id of this page is not its path on the website, which '
              '`<Link>` requires';
        }
        return _anchor(file, fragment.firstOrNull);
      case LinkKind.destination:
    }

    final target = link.target;
    if (target.isEmpty) return 'the link is empty';
    final Uri uri;
    final String path_;
    final String? fragment;
    // Decoding throws an Error, rather than an Exception, on those.
    if (_badEscape.hasMatch(target)) return 'not a valid URL';
    try {
      // `//host/path` is a URL of the same scheme as the page.
      uri = Uri.parse(target.startsWith('//') ? 'https:$target' : target);
      path_ = Uri.decodeComponent(uri.path);
      fragment = uri.hasFragment ? Uri.decodeComponent(uri.fragment) : null;
    } on FormatException {
      return 'not a valid URL';
    }

    if (uri.hasScheme) {
      // Such as `mailto:`.
      if (!const {'http', 'https'}.contains(uri.scheme)) return null;
      if (uri.host.isEmpty) return 'not a valid URL';
      return _url(uri, path_, fragment, location);
    }

    if (path_.isEmpty) return _anchor(path, fragment);
    if (path_.startsWith('/')) {
      // On the website, the path of a page. On GitHub, of a file.
      return page != null
          ? _route(path_, page.locale, fragment)
          : _file(path_.substring(1), fragment);
    }

    final file = p.posix.normalize(p.posix.join(p.posix.dirname(path), path_));
    if (file.startsWith('..')) return 'it links outside of the repository';
    if (page != null && !_exists(file)) {
      // Docusaurus also resolves the path of a file from the same folder of
      // the English docs, and a path without extension as the URL of a page.
      final id = p.posix.normalize(
        p.posix.join(p.posix.dirname(page.id), path_),
      );
      final document = site.document(
        _isMarkdown(id) ? p.posix.withoutExtension(id) : id,
        page.locale,
      );
      if (document != null) return _anchor(document, fragment);
    }
    return _file(file, fragment);
  }

  bool _exists(String path) => files.contains(path) || folders.contains(path);

  /// Checks a URL: locally if it is one of the website or of a file of the
  /// repository, and later otherwise.
  String? _url(Uri uri, String path, String? fragment, String location) {
    final host = uri.host.toLowerCase();
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    final slug = segments.take(2).join('/').toLowerCase();
    final isRepository = slug == repository.slug.toLowerCase();

    if (host == website.host || host == 'www.${website.host}') {
      return _route(path, null, fragment);
    }
    if (host == 'github.com' && isRepository) {
      if (segments.length == 2) return _file('', fragment);
      if (const {'blob', 'tree'}.contains(segments[2]) &&
          segments.elementAtOrNull(3) == repository.branch) {
        return _file(
          segments.skip(4).join('/'),
          // `#L10` links a line of the file.
          fragment != null && _lines.hasMatch(fragment) ? null : fragment,
        );
      }
    }
    if (host == 'raw.githubusercontent.com' &&
        isRepository &&
        segments.elementAtOrNull(2) == repository.branch) {
      return _file(segments.skip(3).join('/'), null);
    }

    (external[uri.removeFragment()] ??= []).add(location);
    return null;
  }

  /// Checks a link to the file or the folder at [path], relative to the
  /// repository root.
  String? _file(String path, String? fragment) {
    final normalized = p.posix.normalize(path);
    if (files.contains(normalized)) return _anchor(normalized, fragment);
    if (!folders.contains(normalized)) return 'no such file';
    // GitHub shows the README of a folder under its files.
    final readme = p.posix.normalize(p.posix.join(normalized, 'README.md'));
    return files.contains(readme) ? _anchor(readme, fragment) : null;
  }

  /// Checks a link to the page of the website at [path], from a page in
  /// [locale].
  String? _route(String path, String? locale, String? fragment) {
    final route = site.route(path, locale);
    if (route == null) return 'the website has no such page';
    return route.file == null ? null : _anchor(route.file!, fragment);
  }

  /// Checks that the Markdown file at [path] has the anchor [fragment].
  String? _anchor(String path, String? fragment) {
    if (fragment == null || fragment.isEmpty || !_isMarkdown(path)) return null;
    final anchors = _anchors[path] ??= anchorsOf(read(path));
    if (anchors.contains(fragment)) return null;
    return '$path has no heading or id `#$fragment`';
  }
}

/// The pages and the static files of a Docusaurus website, in the folder
/// [root].
class _Site {
  _Site(this.root, List<String> files) {
    for (final file in files) {
      if (!p.posix.isWithin(root, file)) continue;
      final relative = p.posix.relative(file, from: root);
      final page = pageOf(file);
      if (page != null) {
        (_documents[page.locale] ??= {})[page.id] = file;
        (_pages[page.locale] ??= {})[_routeOf(page.id)] = file;
        if (page.locale != null) _locales.add(page.locale!);
      } else if (p.posix.isWithin('static', relative)) {
        _routes.add(p.posix.relative(relative, from: 'static'));
      } else if (p.posix.isWithin('src/pages', relative)) {
        final route = p.posix.withoutExtension(
          p.posix.relative(relative, from: 'src/pages'),
        );
        _routes.add(
          p.posix.basename(route) == 'index' ? p.posix.dirname(route) : route,
        );
      }
    }
  }

  final String root;
  // By locale, where null is English, then by id.
  final _documents = <String?, Map<String, String>>{};
  // By locale, then by path under `/docs`.
  final _pages = <String?, Map<String, String>>{};
  final _locales = <String>{};
  // The paths of the static files and of the pages other than the docs.
  // The home page is `.`.
  final _routes = <String>{};

  /// The locale (null for English) and the id of the page of the docs that
  /// the file at [path] is, if it is one.
  ({String? locale, String id})? pageOf(String path) {
    if (!_isMarkdown(path) || !p.posix.isWithin(root, path)) return null;
    final parts = p.posix.split(p.posix.relative(path, from: root));
    final String? locale;
    final List<String> id;
    switch (parts) {
      case ['docs', ...final rest]:
        locale = null;
        id = rest;
      case [
        'i18n',
        final language,
        'docusaurus-plugin-content-docs',
        'current',
        ...final rest,
      ]:
        locale = language;
        id = rest;
      default:
        return null;
    }
    return (locale: locale, id: p.posix.withoutExtension(id.join('/')));
  }

  /// The path under `/docs` of the page with this [id]: the id, but for the
  /// page that is named `index`, `README` or like its folder, which is at
  /// the path of its folder.
  static String _routeOf(String id) {
    final folder = p.posix.dirname(id);
    final name = p.posix.basename(id).toLowerCase();
    final isIndex =
        const {'index', 'readme'}.contains(name) ||
        name == p.posix.basename(folder).toLowerCase();
    return isIndex && folder != '.' ? folder : id;
  }

  /// The file of the page of the docs with this [id]: its translation in
  /// [locale] if there is one, and the English page otherwise.
  String? document(String id, String? locale) =>
      _documents[locale]?[id] ?? _documents[null]?[id];

  /// What is at the [path] of the website, such as `/fr/docs/id`, for a
  /// link in a page in [locale]. Null if nothing is, and a null file for
  /// what is not a page of the docs.
  ({String? file})? route(String path, String? locale) {
    var segments = path.split('/').where((s) => s.isNotEmpty).toList();
    var language = locale;
    if (segments.isNotEmpty && _locales.contains(segments.first)) {
      language = segments.first;
      segments = segments.sublist(1);
    }
    if (segments.firstOrNull == 'docs') {
      final page = segments.skip(1).join('/');
      final file = _pages[language]?[page] ?? _pages[null]?[page];
      return file == null ? null : (file: file);
    }
    final route = segments.isEmpty ? '.' : segments.join('/');
    return _routes.contains(route) ? (file: null) : null;
  }
}

/// What requesting an external link told.
@internal
enum LinkState {
  /// The server answered that the link exists.
  found,

  /// The server answered that the link does not exist.
  missing,

  /// No server has this name.
  unknownHost,

  /// The server answered, but not whether the link exists: it may refuse
  /// scripts, or be failing.
  unverified,

  /// The server did not answer.
  unreachable,
}

/// The [LinkState] that the status code of an HTTP response tells, after its
/// redirections were followed.
@internal
LinkState linkStateOf(int statusCode) => switch (statusCode) {
  >= 200 && < 300 => LinkState.found,
  404 || 410 => LinkState.missing,
  _ => LinkState.unverified,
};

/// What [checkExternalLinks] found.
@internal
final class ExternalLinkCheck {
  ExternalLinkCheck({
    required this.problems,
    required this.unverified,
    required this.isOffline,
  });

  /// The broken links, one per line.
  final List<String> problems;

  /// The links that could not be checked, one per line. Those do not fail the
  /// check, as their website may only be down, or refusing scripts.
  final List<String> unverified;

  /// Whether no website could be reached at all, in which case nothing is
  /// reported as broken.
  final bool isOffline;
}

/// Reports the [LinkCheck.external] links that do not exist, at each place
/// that links them, from the [states] that requesting them gave, and their
/// details, such as the status code.
///
/// A link is broken when its server says so, or when its host does not
/// exist. Anything else is only listed as unverified.
@internal
ExternalLinkCheck checkExternalLinks(
  Map<Uri, List<String>> external,
  Map<Uri, ({LinkState state, String detail})> states,
) {
  const noAnswer = {LinkState.unknownHost, LinkState.unreachable};
  final isOffline =
      states.isNotEmpty &&
      states.values.every((result) => noAnswer.contains(result.state));
  final problems = <String>[];
  final unverified = <String>[];

  for (final MapEntry(key: url, value: locations) in external.entries) {
    final result = states[url];
    if (result == null || isOffline) continue;
    final List<String> list;
    switch (result.state) {
      case LinkState.found:
        continue;
      case LinkState.missing || LinkState.unknownHost:
        list = problems;
      case LinkState.unverified || LinkState.unreachable:
        list = unverified;
    }
    for (final location in locations) {
      list.add('$location: `$url`: ${result.detail}.');
    }
  }

  return ExternalLinkCheck(
    problems: problems,
    unverified: unverified,
    isOffline: isOffline,
  );
}
