import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  testSource(
    'Parses import aliases',
    runGenerator: true,
    files: {
      'file.dart': '''
import 'package:riverpod_annotation/riverpod_annotation.dart';
final aProvider = Provider<int>((ref) => 0);
''',
    },
    source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'file.dart' as alias;
part 'foo.g.dart';

@Riverpod(keepAlive: true)
int aliased(AliasedRef ref) {
  ref.watch(alias.aProvider);
  return 0;
}
''',
    (resolver) async {
      final result = await resolver.resolveRiverpodAnalysisResult();

      expect(result.refWatchInvocations, hasLength(1));
      expect(result.refInvocations.single.function.toSource(), 'watch');
      expect(
        result.refInvocations.single.node.toSource(),
        'ref.watch(alias.aProvider)',
      );

      expect(
        result.refWatchInvocations.single.provider.provider?.toSource(),
        'aProvider',
      );
      expect(
        result.refWatchInvocations.single.provider.providerPrefix?.toSource(),
        'alias',
      );
    },
  );

  testSource('Decode watch expressions with syntax errors', source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@ProviderFor(gibberish)
final gibberishProvider = Provider((ref) => 0);

final dependency = Provider((ref) {
  ref.watch(gibberishProvider);
});
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult(
      ignoreErrors: true,
    );

    expect(result.refWatchInvocations, hasLength(1));
    expect(result.refInvocations.single.function.toSource(), 'watch');
    expect(
      result.refInvocations.single.node.toSource(),
      'ref.watch(gibberishProvider)',
    );
    expect(result.refWatchInvocations.single.provider.familyArguments, null);
    expect(
      result.refWatchInvocations.single.provider.node.toSource(),
      'gibberishProvider',
    );
    expect(
      result.refWatchInvocations.single.provider.provider?.toSource(),
      'gibberishProvider',
    );
    expect(result.refWatchInvocations.single.provider.providerElement, null);
  });

  testSource('Decodes ref expressions in Notifier methods',
      runGenerator: true, source: r'''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  int build() => 0;

  void method() {
    ref.watch(generatedScopedProvider);
  }
}

''', (resolver) async {
// Regression test for https://github.com/rrousselGit/riverpod/issues/2417
    final result = await resolver.resolveRiverpodAnalysisResult();

    final notifier = result.classBasedProviderDeclarations.single;

    expect(result.refInvocations, hasLength(1));
    expect(
      result.refWatchInvocations.single.provider.node.toSource(),
      'generatedScopedProvider',
    );
    expect(
      notifier.refInvocations.single,
      isA<RefWatchInvocation>().having(
        (e) => e.provider.node.toSource(),
        'provider',
        'generatedScopedProvider',
      ),
    );
  });

  testSource('Decodes ..watch', runGenerator: true, source: r'''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

final dep = FutureProvider((ref) => 0);

@Riverpod(keepAlive: true)
Future<int> dep2(Dep2Ref ref) async => 0;

@Riverpod(keepAlive: true)
class Dep3 extends _$Dep3 {
  @override
  Future<int> build() async => 0;
}

final provider = Provider<int>((ref) {
  ref
    ..watch(dep)
    ..watch(dep2Provider)
    ..watch(dep3Provider);

  return 0;
});

''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.refWatchInvocations, hasLength(3));
    expect(result.refInvocations, result.refWatchInvocations);

    expect(
      result.refWatchInvocations[0].node.toSource(),
      '..watch(dep)',
    );
    expect(result.refWatchInvocations[0].function.toSource(), 'watch');
    expect(result.refWatchInvocations[0].provider.node.toSource(), 'dep');
    expect(result.refWatchInvocations[0].provider.familyArguments, null);
    expect(result.refWatchInvocations[0].provider.provider?.toSource(), 'dep');
    expect(
      result.refWatchInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.refWatchInvocations[1].node.toSource(),
      '..watch(dep2Provider)',
    );
    expect(result.refWatchInvocations[1].function.toSource(), 'watch');
    expect(
      result.refWatchInvocations[1].provider.node.toSource(),
      'dep2Provider',
    );
    expect(
      result.refWatchInvocations[1].provider.provider?.toSource(),
      'dep2Provider',
    );
    expect(
      result.refWatchInvocations[1].provider.providerElement,
      same(
        result.functionalProviderDeclarations
            .findByName('dep2')
            .providerElement,
      ),
    );
    expect(result.refWatchInvocations[1].provider.familyArguments, null);

    expect(
      result.refWatchInvocations[2].node.toSource(),
      '..watch(dep3Provider)',
    );
    expect(result.refWatchInvocations[2].function.toSource(), 'watch');
    expect(
      result.refWatchInvocations[2].provider.node.toSource(),
      'dep3Provider',
    );
    expect(
      result.refWatchInvocations[2].provider.provider?.toSource(),
      'dep3Provider',
    );
    expect(
      result.refWatchInvocations[2].provider.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Dep3')
            .providerElement,
      ),
    );
    expect(result.refWatchInvocations[2].provider.familyArguments, null);
  });

  testSource('Decodes simple ref.watch usages', runGenerator: true, source: r'''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

extension on Ref {
  void fn() {}
}

final dep = FutureProvider((ref) => 0);

@Riverpod(keepAlive: true)
Future<int> dep2(Dep2Ref ref) async => 0;

@Riverpod(keepAlive: true)
class Dep3 extends _$Dep3 {
  @override
  Future<int> build() async => 0;
}

final provider = Provider<int>((ref) {
  ref.watch(dep);
  ref.watch(dep2Provider);
  ref.watch(dep3Provider);

  ref.fn();
  return 0;
});

class _Ref {
  void watch(ProviderBase provider) {}
}
void fn(_Ref ref) {
  ref.watch(dep);
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.refWatchInvocations, hasLength(3));
    expect(result.refInvocations, result.refWatchInvocations);

    expect(
      result.refWatchInvocations[0].node.toSource(),
      'ref.watch(dep)',
    );
    expect(result.refWatchInvocations[0].function.toSource(), 'watch');
    expect(result.refWatchInvocations[0].provider.node.toSource(), 'dep');
    expect(result.refWatchInvocations[0].provider.familyArguments, null);
    expect(result.refWatchInvocations[0].provider.provider?.toSource(), 'dep');
    expect(
      result.refWatchInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.refWatchInvocations[1].node.toSource(),
      'ref.watch(dep2Provider)',
    );
    expect(result.refWatchInvocations[1].function.toSource(), 'watch');
    expect(
      result.refWatchInvocations[1].provider.node.toSource(),
      'dep2Provider',
    );
    expect(
      result.refWatchInvocations[1].provider.provider?.toSource(),
      'dep2Provider',
    );
    expect(
      result.refWatchInvocations[1].provider.providerElement,
      same(
        result.functionalProviderDeclarations
            .findByName('dep2')
            .providerElement,
      ),
    );
    expect(result.refWatchInvocations[1].provider.familyArguments, null);

    expect(
      result.refWatchInvocations[2].node.toSource(),
      'ref.watch(dep3Provider)',
    );
    expect(result.refWatchInvocations[2].function.toSource(), 'watch');
    expect(
      result.refWatchInvocations[2].provider.node.toSource(),
      'dep3Provider',
    );
    expect(
      result.refWatchInvocations[2].provider.provider?.toSource(),
      'dep3Provider',
    );
    expect(
      result.refWatchInvocations[2].provider.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Dep3')
            .providerElement,
      ),
    );
    expect(result.refWatchInvocations[2].provider.familyArguments, null);
  });

  testSource('Decodes ref.listen usages', runGenerator: true, source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

final dep = FutureProvider((ref) => 0);

final provider = Provider<int>((ref) {
  ref.listen<AsyncValue<int>>(dep, (prev, next) {});
  ref.listen<AsyncValue<int>>(dep, (prev, next) {}, fireImmediately: true);
  ref.listen<AsyncValue<int>>(fireImmediately: true, dep, (prev, next) {});

  return 0;
});
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.refListenInvocations, hasLength(3));
    expect(result.refInvocations, result.refListenInvocations);

    expect(
      result.refListenInvocations[0].node.toSource(),
      'ref.listen<AsyncValue<int>>(dep, (prev, next) {})',
    );
    expect(result.refListenInvocations[0].function.toSource(), 'listen');
    expect(
      result.refListenInvocations[0].listener.toSource(),
      '(prev, next) {}',
    );
    expect(
      result.refListenInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.refListenInvocations[1].node.toSource(),
      'ref.listen<AsyncValue<int>>(dep, (prev, next) {}, fireImmediately: true)',
    );
    expect(result.refListenInvocations[1].function.toSource(), 'listen');
    expect(
      result.refListenInvocations[1].listener.toSource(),
      '(prev, next) {}',
    );
    expect(
      result.refListenInvocations[1].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.refListenInvocations[2].node.toSource(),
      'ref.listen<AsyncValue<int>>(fireImmediately: true, dep, (prev, next) {})',
    );
    expect(result.refListenInvocations[2].function.toSource(), 'listen');
    expect(
      result.refListenInvocations[2].listener.toSource(),
      '(prev, next) {}',
    );
    expect(
      result.refListenInvocations[2].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );
  });

  testSource('Decodes ref.read usages', runGenerator: true, source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

final dep = FutureProvider((ref) => 0);
final dep2 = FutureProvider((ref) => 0);

final provider = Provider<int>((ref) {
  ref.read(dep);
  ref.read(dep2);

  return 0;
});
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.refReadInvocations, hasLength(2));
    expect(result.refInvocations, result.refReadInvocations);

    expect(result.refReadInvocations[0].node.toSource(), 'ref.read(dep)');
    expect(result.refReadInvocations[0].function.toSource(), 'read');
    expect(
      result.refReadInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(result.refReadInvocations[1].node.toSource(), 'ref.read(dep2)');
    expect(result.refReadInvocations[1].function.toSource(), 'read');
    expect(
      result.refReadInvocations[1].provider.providerElement,
      same(
        result.legacyProviderDeclarations.findByName('dep2').providerElement,
      ),
    );
  });

  testSource('Decodes unknown ref usages', source: '''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final dep = FutureProvider((ref) => 0);
final dep2 = FutureProvider((ref) => 0);

void fn(Ref<int> ref) {
  ref.read(dep);
  ref.read(dep2);
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final libraryResult = result.resolvedRiverpodLibraryResults.single;

    expect(libraryResult.unknownRefInvocations, hasLength(2));
    expect(result.refReadInvocations, libraryResult.unknownRefInvocations);
    expect(result.refInvocations, result.refReadInvocations);

    expect(result.refReadInvocations[0].node.toSource(), 'ref.read(dep)');
    expect(result.refReadInvocations[0].function.toSource(), 'read');
    expect(
      result.refReadInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(result.refReadInvocations[1].node.toSource(), 'ref.read(dep2)');
    expect(result.refReadInvocations[1].function.toSource(), 'read');
    expect(
      result.refReadInvocations[1].provider.providerElement,
      same(
        result.legacyProviderDeclarations.findByName('dep2').providerElement,
      ),
    );
  });

  testSource('Decodes family ref.watch usages', runGenerator: true, source: r'''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

extension on Ref {
  void fn() {}
}

final family = FutureProvider.family<int, int>((ref, id) => 0);

@Riverpod(keepAlive: true)
Future<int> family2(Family2Ref ref, {required int id}) async => 0;

@Riverpod(keepAlive: true)
class Family3 extends _$Family3 {
  @override
  Future<int> build({required int id}) async => 0;
}

final provider = Provider<int>((ref) {
  ref.watch(family(0));
  ref.watch(family2Provider(id: 0));
  ref.watch(family3Provider(id: 0));

  ref.fn();
  return 0;
});

class _Ref {
  void watch(ProviderBase provider) {}
}
void fn(_Ref ref) {
  ref.watch(family(0));
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    final libraryResult = result.resolvedRiverpodLibraryResults.single;

    expect(libraryResult.unknownRefInvocations, isEmpty);
    expect(libraryResult.unknownWidgetRefInvocations, isEmpty);

    final providerRefInvocations = libraryResult.legacyProviderDeclarations
        .where((e) => e.providerElement.name == 'provider')
        .single
        .refInvocations
        .cast<RefWatchInvocation>();

    expect(providerRefInvocations, hasLength(3));
    expect(result.refInvocations, providerRefInvocations);

    expect(
      providerRefInvocations[0].node.toSource(),
      'ref.watch(family(0))',
    );
    expect(providerRefInvocations[0].function.toSource(), 'watch');
    expect(providerRefInvocations[0].provider.node.toSource(), 'family(0)');
    expect(
      providerRefInvocations[0].provider.provider?.toSource(),
      'family',
    );
    expect(
      providerRefInvocations[0].provider.providerElement,
      same(
        result.legacyProviderDeclarations.findByName('family').providerElement,
      ),
    );
    expect(
      providerRefInvocations[0].provider.familyArguments?.toSource(),
      '(0)',
    );

    expect(
      providerRefInvocations[1].node.toSource(),
      'ref.watch(family2Provider(id: 0))',
    );
    expect(providerRefInvocations[1].function.toSource(), 'watch');
    expect(
      providerRefInvocations[1].provider.node.toSource(),
      'family2Provider(id: 0)',
    );
    expect(
      providerRefInvocations[1].provider.provider?.toSource(),
      'family2Provider',
    );
    expect(
      providerRefInvocations[1].provider.providerElement,
      same(
        result.functionalProviderDeclarations
            .findByName('family2')
            .providerElement,
      ),
    );
    expect(
      providerRefInvocations[1].provider.familyArguments?.toSource(),
      '(id: 0)',
    );

    expect(
      result.refWatchInvocations[2].node.toSource(),
      'ref.watch(family3Provider(id: 0))',
    );
    expect(result.refWatchInvocations[2].function.toSource(), 'watch');
    expect(
      result.refWatchInvocations[2].provider.node.toSource(),
      'family3Provider(id: 0)',
    );
    expect(
      result.refWatchInvocations[2].provider.provider?.toSource(),
      'family3Provider',
    );
    expect(
      result.refWatchInvocations[2].provider.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Family3')
            .providerElement,
      ),
    );
    expect(
      result.refWatchInvocations[2].provider.familyArguments?.toSource(),
      '(id: 0)',
    );
  });

  testSource('Decodes provider.query ref.watch usages',
      runGenerator: true, source: r'''
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

extension on Ref {
  void fn() {}
}

final dep = FutureProvider((ref) => 0);

@Riverpod(keepAlive: true)
Future<int> dep2(Dep2Ref ref) async => 0;

@Riverpod(keepAlive: true)
class Dep3 extends _$Dep3 {
  @override
  Future<int> build() async => 0;
}

@Riverpod(keepAlive: true)
class Family extends _$Family {
  @override
  Future<int> build({required int id}) async => 0;
}

final provider = Provider<int>((ref) {
  ref.watch(dep.select((e) => e));
  ref.watch(dep2Provider.select((e) => e));
  ref.watch(dep3Provider.select((e) => e));

  ref.watch(familyProvider(id: 42).notifier.select((e) => e).getter.method()[0]);

  ref.fn();
  return 0;
});

extension<T> on T {
  T get getter => this;

  T method() => this;

  T operator[](Object key) => this;
}

class _Ref {
  void watch(ProviderBase provider) {}
}
void fn(_Ref ref) {
  ref.watch(dep);
}
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();

    expect(result.refWatchInvocations, hasLength(4));
    expect(result.refInvocations, result.refWatchInvocations);

    expect(
      result.refWatchInvocations[0].node.toSource(),
      'ref.watch(dep.select((e) => e))',
    );
    expect(result.refWatchInvocations[0].function.toSource(), 'watch');
    expect(
      result.refWatchInvocations[0].provider.node.toSource(),
      'dep.select((e) => e)',
    );
    expect(result.refWatchInvocations[0].provider.familyArguments, null);
    expect(result.refWatchInvocations[0].provider.provider?.toSource(), 'dep');
    expect(
      result.refWatchInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations.findByName('dep').providerElement),
    );

    expect(
      result.refWatchInvocations[1].node.toSource(),
      'ref.watch(dep2Provider.select((e) => e))',
    );
    expect(result.refWatchInvocations[1].function.toSource(), 'watch');
    expect(
      result.refWatchInvocations[1].provider.node.toSource(),
      'dep2Provider.select((e) => e)',
    );
    expect(result.refWatchInvocations[1].provider.familyArguments, null);
    expect(
      result.refWatchInvocations[1].provider.provider?.toSource(),
      'dep2Provider',
    );
    expect(
      result.refWatchInvocations[1].provider.providerElement,
      same(
        result.functionalProviderDeclarations
            .findByName('dep2')
            .providerElement,
      ),
    );

    expect(
      result.refWatchInvocations[2].node.toSource(),
      'ref.watch(dep3Provider.select((e) => e))',
    );
    expect(result.refWatchInvocations[2].function.toSource(), 'watch');
    expect(
      result.refWatchInvocations[2].provider.node.toSource(),
      'dep3Provider.select((e) => e)',
    );
    expect(result.refWatchInvocations[2].provider.familyArguments, null);
    expect(
      result.refWatchInvocations[2].provider.provider?.toSource(),
      'dep3Provider',
    );
    expect(
      result.refWatchInvocations[2].provider.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Dep3')
            .providerElement,
      ),
    );

    expect(
      result.refWatchInvocations[3].node.toSource(),
      'ref.watch(familyProvider(id: 42).notifier.select((e) => e).getter.method()[0])',
    );
    expect(result.refWatchInvocations[3].function.toSource(), 'watch');
    expect(
      result.refWatchInvocations[3].provider.node.toSource(),
      'familyProvider(id: 42).notifier.select((e) => e).getter.method()[0]',
    );
    expect(
      result.refWatchInvocations[3].provider.familyArguments?.toSource(),
      '(id: 42)',
    );
    expect(
      result.refWatchInvocations[3].provider.provider?.toSource(),
      'familyProvider',
    );
    expect(
      result.refWatchInvocations[3].provider.providerElement,
      same(
        result.classBasedProviderDeclarations
            .findByName('Family')
            .providerElement,
      ),
    );
  });
}
