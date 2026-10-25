import 'package:internal_lint/src/yaml_comments.dart';
import 'package:test/test.dart';

/// The texts of the comments of [content].
List<String> _texts(String content) => [
  for (final (offset: _, :text) in yamlCommentsOf(content)) text,
];

void main() {
  test('finds the comments, to the end of their line', () {
    expect(
      [
        for (final (:offset, :text) in yamlCommentsOf(
          '# a\nkey: value # b\r\n  #c\n',
        ))
          (offset, text),
      ],
      [(0, '# a'), (15, '# b'), (22, '#c')],
    );
  });

  test('skips a `#` that does not follow whitespace', () {
    expect(_texts('key: a#b\nurl: https://a.dev/#c\n'), isEmpty);
  });

  test('skips quoted scalars', () {
    expect(
      _texts(r'''
a: '# a'
b: "# b"
c: 'it''s # c'
d: "\" # d"
e: ['# e', "# e"]
f: 'multi
  # f
  line' # 1
g: it's # 2
h: a "b # 3"
'''),
      ['# 1', '# 2', '# 3"'],
    );
  });

  test('skips block scalars', () {
    expect(
      _texts('''
run: | # a
  echo # in the scalar

  echo # also in the scalar
other: >-
  # in the scalar
list:
  - !!str |
    # in the scalar
  # b
# c
'''),
      ['# a', '# b', '# c'],
    );
  });
}
