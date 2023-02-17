import 'package:test/test.dart';

import 'analyser_test_utils.dart';

void main() {
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
    final result = await resolver.resolveRiverpodAnalyssiResult();

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
      same(result.legacyProviderDeclarations['dep']?.providerElement),
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
      same(result.statelessProviderDeclarations['dep2']?.providerElement),
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
      same(result.statefulProviderDeclarations['Dep3']?.providerElement),
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
    final result = await resolver.resolveRiverpodAnalyssiResult();

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
      same(result.legacyProviderDeclarations['dep']?.providerElement),
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
      same(result.legacyProviderDeclarations['dep']?.providerElement),
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
      same(result.legacyProviderDeclarations['dep']?.providerElement),
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
    final result = await resolver.resolveRiverpodAnalyssiResult();

    expect(result.refReadInvocations, hasLength(2));
    expect(result.refInvocations, result.refReadInvocations);

    expect(result.refReadInvocations[0].node.toSource(), 'ref.read(dep)');
    expect(result.refReadInvocations[0].function.toSource(), 'read');
    expect(
      result.refReadInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations['dep']?.providerElement),
    );

    expect(result.refReadInvocations[1].node.toSource(), 'ref.read(dep2)');
    expect(result.refReadInvocations[1].function.toSource(), 'read');
    expect(
      result.refReadInvocations[1].provider.providerElement,
      same(result.legacyProviderDeclarations['dep2']?.providerElement),
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
    final result = await resolver.resolveRiverpodAnalyssiResult();

    expect(result.refWatchInvocations, hasLength(3));
    expect(result.refInvocations, result.refWatchInvocations);

    expect(
      result.refWatchInvocations[0].node.toSource(),
      'ref.watch(family(0))',
    );
    expect(result.refWatchInvocations[0].function.toSource(), 'watch');
    expect(result.refWatchInvocations[0].provider.node.toSource(), 'family(0)');
    expect(
      result.refWatchInvocations[0].provider.provider?.toSource(),
      'family',
    );
    expect(
      result.refWatchInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations['family']?.providerElement),
    );
    expect(
      result.refWatchInvocations[0].provider.familyArguments?.toSource(),
      '(0)',
    );

    expect(
      result.refWatchInvocations[1].node.toSource(),
      'ref.watch(family2Provider(id: 0))',
    );
    expect(result.refWatchInvocations[1].function.toSource(), 'watch');
    expect(
      result.refWatchInvocations[1].provider.node.toSource(),
      'family2Provider(id: 0)',
    );
    expect(
      result.refWatchInvocations[1].provider.provider?.toSource(),
      'family2Provider',
    );
    expect(
      result.refWatchInvocations[1].provider.providerElement,
      same(result.statelessProviderDeclarations['family2']?.providerElement),
    );
    expect(
      result.refWatchInvocations[1].provider.familyArguments?.toSource(),
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
      same(result.statefulProviderDeclarations['Family3']?.providerElement),
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
    final result = await resolver.resolveRiverpodAnalyssiResult();

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
      same(result.legacyProviderDeclarations['dep']?.providerElement),
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
      same(result.statelessProviderDeclarations['dep2']?.providerElement),
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
      same(result.statefulProviderDeclarations['Dep3']?.providerElement),
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
      same(result.statefulProviderDeclarations['Family']?.providerElement),
    );
  });
}
