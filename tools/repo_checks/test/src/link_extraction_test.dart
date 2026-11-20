import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:repo_checks/src/link_extraction.dart';
import 'package:test/test.dart';

/// The targets of [links], with a `document:` or `undefined:`
/// prefix for those that are not destinations.
List<String> _targets(List<FoundLink> links) => [
  for (final link in links)
    switch (link.kind) {
      LinkKind.destination => link.target,
      LinkKind.document => 'document:${link.target}',
      LinkKind.undefinedReference => 'undefined:${link.target}',
    },
];

List<String> _markdown(String content) => _targets(linksInMarkdown(content));

List<String> _dart(String content) =>
    _targets(linksInDart(parseString(content: content).unit));

void main() {
  group('linksInMarkdown', () {
    test('finds inline links and images', () {
      expect(
        _markdown('''
A [link](./a.md), an ![image](/img/a.png "title"), <brackets>:
[spaced]( <a b.md> ) and [parentheses](https://a.dev/a_(b)).
[empty]()
'''),
        ['./a.md', '/img/a.png', 'a b.md', 'https://a.dev/a_(b)', ''],
      );
    });

    test('finds the definitions of reference links', () {
      expect(
        _markdown('''
[Label][label], [other][Two  Words] and [collapsed][].

[LABEL]: https://a.dev
   [two words]: <./b c.md>
[^1]: A footnote.
'''),
        ['https://a.dev', './b c.md'],
      );
    });

    test('reports the reference links that nothing defines', () {
      expect(
        _markdown('''
[text][ missing ] and [a [nested] text][other]

[label]: https://a.dev
'''),
        ['undefined:missing', 'undefined:other', 'https://a.dev'],
      );
    });

    test('finds the href, src and to attributes of tags', () {
      expect(
        _markdown('''
<a href="https://a.dev"><img
  src='/img/a.png' alt="a" /></a>
<Link to={"/docs/a"} className="b">text</Link>
<Tab value="href" /> List<int> a <b> c
'''),
        ['https://a.dev', '/img/a.png', '/docs/a'],
      );
    });

    test('finds what the components of the website link', () {
      expect(
        _markdown('''
See <Link documentID="a/b" />, <Link documentID="a/b" hash="c"/>
and <Link hash="c" documentID='a/d' />.
<DartPad id="abc" /> <Other id="abc" documentID="a" /> <Link hash="c" />
<DartPad />
'''),
        [
          'document:a/b',
          'document:a/b#c',
          'document:a/d#c',
          'https://gist.github.com/abc',
        ],
      );
    });

    test('finds the URLs in the text, without its punctuation', () {
      expect(
        _markdown('''
See https://a.dev/a. Or <http://b.dev/b?c=d#e>, (https://c.dev/c),
https://d.dev/d_(e)! And **https://e.dev/e**
'''),
        [
          'https://a.dev/a',
          'http://b.dev/b?c=d#e',
          'https://c.dev/c',
          'https://d.dev/d_(e)',
          'https://e.dev/e',
        ],
      );
    });

    test('finds a URL that is a destination once', () {
      expect(_markdown('[a](https://a.dev) <a href="https://b.dev">b</a>'), [
        'https://a.dev',
        'https://b.dev',
      ]);
    });

    test('has no links in code nor comments', () {
      expect(
        _markdown('''
`[a](./a.md)` and ``a ` https://a.dev``
```md
[b](./b.md)
```dart
```
> ~~~
> https://c.dev
> ~~~~
<!-- [d](./d.md)
https://d.dev -->
{/* [e](./e.md) */}
[f](./f.md)
'''),
        ['./f.md'],
      );
    });

    test('does not end code at a shorter or different fence', () {
      expect(
        _markdown('''
````
```
[a](./a.md)
~~~~
````
[b](./b.md)
'''),
        ['./b.md'],
      );
    });

    test('has no code in comments, nor comments in code', () {
      expect(
        _markdown('''
<!--
~~~
-->
[a](./a.md) <!-- b --> [c](./c.md) {/* d */} [e](./e.md) <!-- f
```
[g](./g.md) --> [h](./h.md)
```
<!-- [i](./i.md)
```
[j](./j.md)
'''),
        ['./a.md', './c.md', './e.md', './h.md', './j.md'],
      );
    });

    test('does not let a lone backtick hide the next paragraphs', () {
      expect(
        _markdown('''
A ` alone.

[a](./a.md) and `code`.
'''),
        ['./a.md'],
      );
    });

    test('gives the offset of the targets, in order', () {
      const content = '''
<Link documentID="a" hash="b" />
[c](<./c.md>) https://d.dev
[e]: ./e.md
[f][g]
''';
      expect(
        [
          for (final link in linksInMarkdown(content))
            content.substring(link.offset).split(RegExp('[">) \n]')).first,
        ],
        ['a', './c.md', 'https://d.dev', './e.md', '[f][g]'],
      );
    });
  });

  group('linksInDart', () {
    test('finds the URLs of the comments', () {
      expect(
        _dart('''
/// See [the docs](https://a.dev/a), or <https://b.dev>.
// https://c.dev/c.
/* https://d.dev
 * https://e.dev */
void fn() {} // https://f.dev
// https://g.dev
'''),
        [
          'https://a.dev/a',
          'https://b.dev',
          'https://c.dev/c',
          'https://d.dev',
          'https://e.dev',
          'https://f.dev',
          'https://g.dev',
        ],
      );
    });

    test('ignores the URLs of the code', () {
      expect(
        _dart('''
/// A [link](./a.md) and [Symbol].
const a = 'https://a.dev'; // b
'''),
        isEmpty,
      );
    });

    test('ignores the code of the comments', () {
      expect(
        _dart('''
/// `https://a.dev`
/// ```yaml
/// # https://b.dev
/// ```
/// https://c.dev
/// ```
/// https://d.dev
void fn() {}

/// https://e.dev
/**
 * ```
 * https://f.dev
 * ```
 * https://g.dev
 */
void fn2() {}
'''),
        ['https://c.dev', 'https://e.dev', 'https://g.dev'],
      );
    });

    test('ends the code of a comment like Markdown does', () {
      expect(
        _dart('''
/// ~~~~
/// ~~~
/// https://a.dev
/// ```
/// ~~~~ info
/// https://b.dev
/// ~~~~~
/// https://c.dev
void fn() {}

/**
 * ~~~
 * https://d.dev
 * ~~~
 * https://e.dev <!-- https://f.dev -->
 */
void fn2() {}

/// ```
/// https://g.dev
// https://h.dev
void fn3() {}
'''),
        ['https://c.dev', 'https://e.dev', 'https://f.dev', 'https://h.dev'],
      );
    });

    test('gives the offset of the URLs', () {
      const content = '''
/// A
/// B https://a.dev.
void fn() {}
''';
      final link = linksInDart(parseString(content: content).unit).single;
      expect(content.substring(link.offset), startsWith('https://a.dev.'));
    });
  });

  group('anchorsOf', () {
    test('names headings like GitHub and Docusaurus', () {
      expect(
        anchorsOf(r'''
# Title
## provider_dependencies (riverpod_generator only)
### All `updateShouldNotify` now use `==`
#### A [link](./a.md), an ![image](a.png) & a [reference][ref]
##### **Bold** _italic_ ~~struck~~ <b>html</b> \*escaped\* ##
###### Émoji 🎉 日本語 `_code_`
'''),
        {
          'title',
          'provider_dependencies-riverpod_generator-only',
          'all-updateshouldnotify-now-use-',
          'a-link-an-image--a-reference',
          'bold-italic-struck-html-escaped',
          'émoji--日本語-_code_',
        },
      );
    });

    test('numbers the headings of the same name', () {
      expect(anchorsOf('# A\n## A\n### a\n# B'), {'a', 'a-1', 'a-2', 'b'});
    });

    test('numbers a heading whose name is a numbered one', () {
      expect(anchorsOf('# A\n# A\n# A-1\n# A'), {'a', 'a-1', 'a-1-1', 'a-2'});
    });

    test('names the underlined headings', () {
      expect(
        anchorsOf('''
---
title: Not a heading
---
Title
=====
Some text.

  A `second` one  
  ---
# Title

| a |
|---|
'''),
        {'title', 'a-second-one', 'title-1'},
      );
    });

    test('uses the id that a heading sets', () {
      expect(anchorsOf('## A heading {#custom-id}\n## Other'), {
        'custom-id',
        'other',
      });
    });

    test('finds the ids and the names of tags', () {
      expect(
        anchorsOf(
          '<a name="a"></a> <h2 id=\'b\'>B</h2> <div id={"c"} /> '
          '<p data-id="d" aria-name="e" x:id="f" />',
        ),
        {'a', 'b', 'c'},
      );
    });

    test('has no anchors in code nor comments', () {
      expect(
        anchorsOf('''
```sh
# A comment
```
<!-- # Hidden -->
<!--
~~~
-->
# After a comment
#NotAHeading
    # Code
# Shown
'''),
        {'after-a-comment', 'shown'},
      );
    });
  });
}
