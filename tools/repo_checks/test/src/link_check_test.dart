import 'package:repo_checks/src/link_check.dart';
import 'package:test/test.dart';

const _docs = 'website/i18n/fr/docusaurus-plugin-content-docs/current';

void main() {
  final policy = LinkPolicy.parse('''
ignored:
  - ignored/**
ignored_links:
  - https://example.com
''');

  LinkCheck check(Map<String, String> files) {
    return checkLinks(
      policy: policy,
      website: (root: 'website', host: 'site.dev'),
      repository: (slug: 'Owner/Repo', branch: 'main'),
      files: files.keys.toList(),
      read: (path) => files[path]!,
    );
  }

  /// The problems of the links of a file at [path], among [others].
  List<String> problemsOf(
    String content, {
    String path = 'docs/a.md',
    Map<String, String> others = const {},
  }) => check({path: content, ...others}).problems;

  group('LinkPolicy.parse', () {
    test('reads the ignored files and links', () {
      expect(policy.isIgnored('ignored/a/b.md'), isTrue);
      expect(policy.isIgnored('lib/a.md'), isFalse);
      expect(policy.ignoresLink('https://example.com/a'), isTrue);
      expect(policy.ignoresLink('https://a.dev'), isFalse);
    });

    test('defaults to ignoring nothing', () {
      final policy = LinkPolicy.parse('{}');
      expect(policy.ignored, isEmpty);
      expect(policy.ignoredLinks, isEmpty);
    });

    test('rejects malformed content', () {
      for (final content in [
        '- a',
        'unknown: []',
        'ignored: a',
        'ignored: [1]',
        'ignored_links: {a: b}',
      ]) {
        expect(
          () => LinkPolicy.parse(content),
          throwsFormatException,
          reason: content,
        );
      }
    });
  });

  group('checkLinks', () {
    test('accepts the paths of files and folders', () {
      expect(
        problemsOf(
          '''
[a](./b.md) [b](b.md?plain=1) [c](../lib/src/c.dart) [d](../lib/)
[e](../lib/src) [f](..) [g](/lib/src/c.dart) [h](/) [i](sub%20folder/d.md)
[j](mailto:a@b.dev)
''',
          others: {
            'docs/b.md': '',
            'lib/src/c.dart': '',
            'docs/sub folder/d.md': '',
          },
        ),
        isEmpty,
      );
    });

    test('reports the paths of missing files, with their line', () {
      expect(
        problemsOf('''
[a](./missing.md)

[b](/docs/missing) [c](../../outside.md) [d]()
[e](%zz.md) [f](%ff.md) [g](http://) [h](http://[a)
'''),
        [
          'docs/a.md:1: `./missing.md`: no such file.',
          'docs/a.md:3: `/docs/missing`: no such file.',
          'docs/a.md:3: `../../outside.md`: it links outside of the repository.',
          'docs/a.md:3: ``: the link is empty.',
          'docs/a.md:4: `%zz.md`: not a valid URL.',
          'docs/a.md:4: `%ff.md`: not a valid URL.',
          'docs/a.md:4: `http://`: not a valid URL.',
          'docs/a.md:4: `http://[a`: not a valid URL.',
        ],
      );
    });

    test('checks the fragments against the anchors of Markdown files', () {
      expect(
        problemsOf(
          '''
# Title
[a](#title) [b](#missing) [c](./b.mdx#in-b) [d](./b.mdx#title) [e](#)
[f](./c.dart#anything) [g](./b.mdx#%C3%A9t%C3%A9) [h](../lib#read-me)
[i](../lib#missing) [j](../docs#anything)
''',
          others: {
            'docs/b.mdx': '## In B\n## Été',
            'docs/c.dart': '',
            'lib/README.md': '# Read me',
            'lib/a.dart': '',
          },
        ),
        [
          'docs/a.md:2: `#missing`: docs/a.md has no heading or id `#missing`.',
          'docs/a.md:2: `./b.mdx#title`: docs/b.mdx has no heading or id '
              '`#title`.',
          'docs/a.md:4: `../lib#missing`: lib/README.md has no heading or id '
              '`#missing`.',
        ],
      );
    });

    test('reports the reference links that nothing defines', () {
      expect(problemsOf('[a][b]'), [
        'docs/a.md:1: `b`: no `[b]: ...` defines this reference.',
      ]);
    });

    test('checks the URLs of the files of the repository locally', () {
      final result = check({
        'README.md': '''
# Title
https://github.com/owner/repo https://github.com/owner/repo#title
https://github.com/Owner/Repo/blob/main/lib/a.dart#L10-L12
https://github.com/Owner/Repo/tree/main/lib#in-lib
https://github.com/Owner/Repo/blob/main/a%20b.png?raw=true
https://raw.githubusercontent.com/Owner/Repo/main/lib/a.dart
//github.com/Owner/Repo/blob/main/README.md#title
https://github.com/Owner/Repo/blob/main/missing.md
https://github.com/Owner/Repo/tree/main/lib#missing
https://github.com/Owner/Repo#missing
https://raw.githubusercontent.com/Owner/Repo/main/missing.png
''',
        'lib/a.dart': '',
        'lib/README.md': '# In lib',
        'a b.png': '',
      });

      expect(result.external, isEmpty);
      expect(result.problems, [
        'README.md:8: `https://github.com/Owner/Repo/blob/main/missing.md`: '
            'no such file.',
        'README.md:9: `https://github.com/Owner/Repo/tree/main/lib#missing`: '
            'lib/README.md has no heading or id `#missing`.',
        'README.md:10: `https://github.com/Owner/Repo#missing`: README.md has '
            'no heading or id `#missing`.',
        'README.md:11: '
            '`https://raw.githubusercontent.com/Owner/Repo/main/missing.png`: '
            'no such file.',
      ]);
    });

    test('returns the other URLs, without their fragment', () {
      final result = check({
        'a.md': '''
https://a.dev/a#b [a](https://a.dev/a)

https://github.com/Owner/Repo/issues/1
https://github.com/Owner/Repo/blob/v1/a.md
https://github.com/Owner/Other/blob/main/a.md
https://raw.githubusercontent.com/Owner/Repo/v1/a.md
https://example.com/ignored
''',
        'lib/a.dart': '// See https://a.dev/a.\n',
      });

      expect(result.problems, isEmpty);
      expect(result.external, {
        Uri.parse('https://a.dev/a'): ['a.md:1', 'a.md:1', 'lib/a.dart:1'],
        Uri.parse('https://github.com/Owner/Repo/issues/1'): ['a.md:3'],
        Uri.parse('https://github.com/Owner/Repo/blob/v1/a.md'): ['a.md:4'],
        Uri.parse('https://github.com/Owner/Other/blob/main/a.md'): ['a.md:5'],
        Uri.parse('https://raw.githubusercontent.com/Owner/Repo/v1/a.md'): [
          'a.md:6',
        ],
      });
    });

    test('skips the ignored and the generated files, and other types', () {
      final result = check({
        'ignored/a.md': '[a](./missing.md)',
        'lib/a.g.dart': '// https://a.dev',
        'lib/a.freezed.dart': '// https://a.dev',
        'lib/b.dart': '// GENERATED\n// https://b.dev',
        'lib/c.dart': "// No link\nconst a = '[a](./missing.md)';",
        'lib/d.txt': '[a](./missing.md) https://d.dev',
      });

      expect(result.problems, isEmpty);
      expect(result.external, isEmpty);
    });

    group('in the website', () {
      const site = {
        'website/docs/a.mdx': '# In A',
        'website/docs/folder/b.mdx': '# In B',
        'website/docs/folder/folder.mdx': '# In folder',
        'website/docs/home/index.md': '',
        'website/docs/guide/README.md': '',
        'website/docs/image.png': '',
        '$_docs/a.mdx': '# Dans A',
        '$_docs/only_fr.mdx': '',
        'website/i18n/fr/code.json': '',
        'website/static/img/a.png': '',
        'website/src/pages/index.tsx': '',
        'website/src/pages/about.tsx': '',
        'website/src/pages/blog/index.tsx': '',
        'website/src/css/a.css': '',
        'website/README.md': '',
      };

      List<String> inSite(
        String content, {
        String path = 'website/docs/p.mdx',
      }) => problemsOf(content, path: path, others: site);

      test('accepts the paths of pages and of static files', () {
        expect(
          inSite('''
[a](/docs/a) [b](/docs/folder/b#in-b) [c](/img/a.png) [d](/) [e](/about)
[f](/blog) [g](/fr/docs/a#dans-a) [h](/fr/docs/folder/b) [i](/docs/folder)
[j](/docs/guide/) [k](/fr/docs/only_fr) [l](/fr) [m](/docs/folder#in-folder) [n](/docs/home)
'''),
          isEmpty,
        );
      });

      test('reports the paths that are not on the website', () {
        expect(
          inSite('''
[a](/docs/missing) [b](/img/missing.png) [c](/docs/a#missing)
[d](/docs/only_fr) [e](/README) [f](/docs) [g](/docs/folder/folder)
'''),
          [
            'website/docs/p.mdx:1: `/docs/missing`: the website has no such '
                'page.',
            'website/docs/p.mdx:1: `/img/missing.png`: the website has no '
                'such page.',
            'website/docs/p.mdx:1: `/docs/a#missing`: website/docs/a.mdx has '
                'no heading or id `#missing`.',
            'website/docs/p.mdx:2: `/docs/only_fr`: the website has no such '
                'page.',
            'website/docs/p.mdx:2: `/README`: the website has no such page.',
            'website/docs/p.mdx:2: `/docs`: the website has no such page.',
            'website/docs/p.mdx:2: `/docs/folder/folder`: the website has no '
                'such page.',
          ],
        );
      });

      test('resolves relative paths as files, then as pages', () {
        expect(
          inSite('''
[a](./b.mdx#in-b) [b](b) [c](../a#in-a) [d](../a.mdx) [e](../image.png)
[f](./missing.mdx) [g](missing) [h](b#missing)
''', path: 'website/docs/folder/p.mdx'),
          [
            'website/docs/folder/p.mdx:2: `./missing.mdx`: no such file.',
            'website/docs/folder/p.mdx:2: `missing`: no such file.',
            'website/docs/folder/p.mdx:2: `b#missing`: '
                'website/docs/folder/b.mdx has no heading or id `#missing`.',
          ],
        );
      });

      test('resolves the links of a translation in its language first', () {
        expect(
          inSite('''
[a](/docs/a#dans-a) [b](/docs/folder/b#in-b) [c](./a.mdx#dans-a)
[d](./folder/b.mdx#in-b) [e](/docs/only_fr) [f](only_fr)
<Link documentID="a" hash="dans-a" /> <Link documentID="folder/b" />
[g](/docs/a#in-a) <Link documentID="a" hash="in-a" />
''', path: '$_docs/p.mdx'),
          [
            '$_docs/p.mdx:4: `/docs/a#in-a`: $_docs/a.mdx has no heading or '
                'id `#in-a`.',
            '$_docs/p.mdx:4: `a#in-a`: $_docs/a.mdx has no heading or id '
                '`#in-a`.',
          ],
        );
      });

      test('checks the pages that the Link component links', () {
        expect(
          inSite('''
<Link documentID="a" /> <Link documentID="folder/b" hash="in-b" />
<Link documentID="missing" /> <Link documentID="a" hash="missing" />
<Link documentID="only_fr" /> <Link documentID="folder/folder" />
'''),
          [
            'website/docs/p.mdx:2: `missing`: the website has no page with '
                'this id.',
            'website/docs/p.mdx:2: `a#missing`: website/docs/a.mdx has no '
                'heading or id `#missing`.',
            'website/docs/p.mdx:3: `only_fr`: the website has no page with '
                'this id.',
            'website/docs/p.mdx:3: `folder/folder`: the id of this page is '
                'not its path on the website, which `<Link>` requires.',
          ],
        );
      });

      test('checks the URLs of the website locally, from any file', () {
        final result = check({
          ...site,
          'README.md': '''
https://site.dev https://www.site.dev/docs/a#in-a http://site.dev/fr/docs/a
https://site.dev/img/a.png
https://site.dev/docs/missing https://site.dev/docs/a#missing
[a](/website/docs/a.mdx) [b](/docs/a)
''',
          'lib/a.dart': '// https://site.dev/docs/gone\n',
        });

        expect(result.external, isEmpty);
        expect(result.problems, [
          'README.md:3: `https://site.dev/docs/missing`: the website has no '
              'such page.',
          'README.md:3: `https://site.dev/docs/a#missing`: website/docs/a.mdx '
              'has no heading or id `#missing`.',
          'README.md:4: `/docs/a`: no such file.',
          'lib/a.dart:1: `https://site.dev/docs/gone`: the website has no '
              'such page.',
        ]);
      });
    });
  });

  group('linkStateOf', () {
    test('tells whether the link exists from the status code', () {
      expect(linkStateOf(200), LinkState.found);
      expect(linkStateOf(299), LinkState.found);
      expect(linkStateOf(404), LinkState.missing);
      expect(linkStateOf(410), LinkState.missing);
      for (final statusCode in [199, 300, 401, 403, 429, 500, 503]) {
        expect(linkStateOf(statusCode), LinkState.unverified);
      }
    });
  });

  group('checkExternalLinks', () {
    final a = Uri.parse('https://a.dev');
    final b = Uri.parse('https://b.dev');
    final c = Uri.parse('https://c.dev');
    final d = Uri.parse('https://d.dev');
    final e = Uri.parse('https://e.dev');
    final external = {
      a: ['a.md:1'],
      b: ['a.md:2', 'b.md:1'],
      c: ['a.md:3'],
      d: ['a.md:4'],
      e: ['a.md:5'],
    };

    test('reports the links that do not exist, where they are', () {
      final result = checkExternalLinks(external, {
        a: (state: LinkState.found, detail: 'the server answered 200'),
        b: (state: LinkState.missing, detail: 'the server answered 404'),
        c: (state: LinkState.unknownHost, detail: 'no such host'),
        d: (state: LinkState.unverified, detail: 'the server answered 403'),
        e: (state: LinkState.unreachable, detail: 'no answer in time'),
      });

      expect(result.isOffline, isFalse);
      expect(result.problems, [
        'a.md:2: `https://b.dev`: the server answered 404.',
        'b.md:1: `https://b.dev`: the server answered 404.',
        'a.md:3: `https://c.dev`: no such host.',
      ]);
      expect(result.unverified, [
        'a.md:4: `https://d.dev`: the server answered 403.',
        'a.md:5: `https://e.dev`: no answer in time.',
      ]);
    });

    test('skips the links that were not requested', () {
      final result = checkExternalLinks(external, {
        a: (state: LinkState.found, detail: ''),
      });

      expect(result.isOffline, isFalse);
      expect(result.problems, isEmpty);
      expect(result.unverified, isEmpty);
    });

    test('reports nothing when no website could be reached', () {
      final result = checkExternalLinks(external, {
        a: (state: LinkState.unknownHost, detail: 'no such host'),
        b: (state: LinkState.unreachable, detail: 'could not connect'),
      });

      expect(result.isOffline, isTrue);
      expect(result.problems, isEmpty);
      expect(result.unverified, isEmpty);
    });

    test('is not offline when there is nothing to request', () {
      expect(checkExternalLinks({}, {}).isOffline, isFalse);
    });
  });
}
