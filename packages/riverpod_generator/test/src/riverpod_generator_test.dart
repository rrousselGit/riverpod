// Resolving the sources takes a while, even more so with coverage.
@Timeout.factor(4)
library;

import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('refers to dependencies using the import prefix of their library', () {
    // Both libraries declare the same names: only the prefix tells them apart.
    const providers = r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(dependencies: [])
int root(Ref ref) => 0;

@Riverpod(dependencies: [root])
int functional(Ref ref) => 0;

@Riverpod(dependencies: [])
class ClassBased extends _$ClassBased {
  @override
  int build() => 0;
}
''';

    late final String generated;

    setUpAll(() async {
      generated = await generate({
        'unprefixed.dart': providers,
        'prefixed.dart': providers,
        'main.dart': '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'prefixed.dart' as p;
import 'unprefixed.dart';

part 'main.g.dart';

@Riverpod(dependencies: [p.functional, p.ClassBased, root])
int single(Ref ref) => 0;

@Riverpod(dependencies: [p.functional])
int family(Ref ref, int id) => 0;

const scoped = Riverpod(dependencies: [root]);

@scoped
int alias(Ref ref) => 0;
''',
      });
    });

    test('in dependencies', () {
      expect(
        generated,
        contains(
          'dependencies:<ProviderOrFamily>'
          '[p.functionalProvider,p.classBasedProvider,rootProvider]',
        ),
      );
      expect(
        generated,
        contains('dependencies:<ProviderOrFamily>[p.functionalProvider]'),
      );
      // A constant annotation has no list to read prefixes from.
      expect(
        generated,
        contains(
          "name:r'aliasProvider',isAutoDispose:true,"
          'dependencies:<ProviderOrFamily>[rootProvider]',
        ),
      );
    });

    test('in transitive dependencies', () {
      expect(
        generated,
        contains(
          r'staticfinal$allTransitiveDependencies0=p.functionalProvider;'
          r'staticfinal$allTransitiveDependencies1='
          r'p.FunctionalProvider.$allTransitiveDependencies0;'
          r'staticfinal$allTransitiveDependencies2=p.classBasedProvider;'
          r'staticfinal$allTransitiveDependencies3=rootProvider;',
        ),
      );
    });
  });
}
