import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:internal_lint/src/lints/avoid_annotation_api_in_strings.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('reports string literals naming the annotation public API', () async {
    final root = createFixture({
      'my_generator/lib/a.dart': r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

void fn(String type) {
  'final class Foo extends \$FunctionalProvider<int> {}';
  '\$Notifier$type';
  '\$FutureProvider${'<int>'}';
  'class Foo with \$NotifierProvider<$type> {}';
  'Ref ref, Override override';
  'ProviderFor(foo)';
  'Storage<String, Object?>';
}
''',
    });

    final diagnostics = await runRule(
      AvoidAnnotationApiInStrings(),
      p.join(root.path, 'my_generator', 'lib', 'a.dart'),
    );

    expect(diagnostics.map((e) => e.message), [
      contains(r'`$FunctionalProvider`'),
      contains(r'`$Notifier`'),
      contains(r'`$FutureProvider`'),
      contains(r'`$NotifierProvider`'),
      contains('`Ref`, `Override` are'),
      contains('`ProviderFor`'),
      // From riverpod_annotation/experimental
      contains('`Storage`'),
    ]);
  });

  test('ignores partial matches, URIs and annotations', () async {
    final root = createFixture({
      'my_generator/lib/a.dart': r'''
@Deprecated('Ref')
import 'package:riverpod_annotation/riverpod_annotation.dart';

void fn(String a) {
  '${a}Ref';
  '#{{$a|Ref}}';
  'Reference';
  'riverpod';
  '#{{riverpod_annotation|\$Ref}} ref';
  '/// {@macro riverpod.Ref}';
  r'$Refs';
  'myRef';
}
''',
    });

    final diagnostics = await runRule(
      AvoidAnnotationApiInStrings(),
      p.join(root.path, 'my_generator', 'lib', 'a.dart'),
    );

    expect(diagnostics, isEmpty);
  });

  test('only applies to the lib folder of generators', () async {
    final root = createFixture({
      'my_generator/test/a.dart': "void fn() => print('Ref');",
      'my_package/lib/a.dart': "void fn() => print('Ref');",
    });

    for (final path in ['my_generator/test/a.dart', 'my_package/lib/a.dart']) {
      final diagnostics = await runRule(
        AvoidAnnotationApiInStrings(),
        p.join(root.path, path),
      );
      expect(diagnostics, isEmpty, reason: path);
    }
  });

  test('collects the declarations and exports of public libraries', () {
    final root = createFixture({
      'lib/a.dart': '''
export 'src/exported.dart';
export 'src/shown.dart' show Shown;
export 'a.dart';

const variable = 0, other = 1;
const _private = 0;
void function() {}
typedef Alias = int;
class Class {}
enum Enum { value }
mixin Mixin {}
extension Extension on int {}
extension on String {}
''',
      'lib/nested/b.dart': 'class Nested {}',
      'lib/src/exported.dart': 'class Exported {}',
      'lib/src/shown.dart': 'class Shown {}\nclass Hidden {}',
      'lib/src/private.dart': 'class Private {}',
    });
    final lib = p.join(root.path, 'lib');
    final session = AnalysisContextCollection(
      includedPaths: [lib],
    ).contextFor(lib).currentSession;

    expect(AnnotationApi.publicApiOf(session, lib), {
      'variable',
      'other',
      'function',
      'Alias',
      'Class',
      'Enum',
      'Mixin',
      'Extension',
      'Nested',
      'Exported',
      'Shown',
    });
  });
}
