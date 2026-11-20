import 'package:internal_lint/src/lints/generic_name.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('reports generics that are not suffixed with T', () async {
    final root = createFixture({
      'a.dart': '''
class Good<ValueT> {}
class TooShort<T> {}
class NoSuffix<Value> {}
''',
    });

    final diagnostics = await runRule(
      GenericName(),
      p.join(root.path, 'a.dart'),
    );

    expect(diagnostics.map((e) => e.offset), [
      'class Good<ValueT> {}\nclass TooShort<'.length,
      'class Good<ValueT> {}\nclass TooShort<T> {}\nclass NoSuffix<'.length,
    ]);
  });

  test('skips generated parts', () async {
    final root = createFixture({
      'a.dart': '''
part 'a.g.dart';
part 'a.freezed.dart';
class Bad<T> {}
''',
      'a.g.dart': '''
part of 'a.dart';
class GeneratedBad<T> {}
''',
      'a.freezed.dart': '''
part of 'a.dart';
class FreezedBad<T> {}
''',
    });

    final diagnostics = await runRule(
      GenericName(),
      p.join(root.path, 'a.dart'),
    );

    expect(diagnostics, hasLength(1));
    expect(diagnostics.single.source.fullName, endsWith('a.dart'));
    expect(diagnostics.single.source.fullName, isNot(endsWith('.g.dart')));
  });
}
