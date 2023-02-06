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
final family = FutureProvider.family<int, int>((ref, id) => 0);

@Riverpod(keepAlive: true)
Future<int> dep2(Dep2Ref ref) async => 0;
@Riverpod(keepAlive: true)
Future<int> family2(Family2Ref ref, int id) async => 0;

@Riverpod(keepAlive: true)
class Dep3 extends _$Dep3 {
  @override
  Future<int> build() async => 0;
}

@Riverpod(keepAlive: true)
class Family3 extends _$Family3 {
  @override
  Future<int> build(int id) async => 0;
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

//   testSource('Decodes simple ref.watch usages', runGenerator: true, source: r'''
// import 'package:riverpod/riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'foo.g.dart';

// extension on Ref {
//   void fn() {}
// }

// final dep = FutureProvider((ref) => 0);
// final family = FutureProvider.family<int, int>((ref, id) => 0);

// @Riverpod(keepAlive: true)
// Future<int> dep2(Dep2Ref ref) async => 0;
// @Riverpod(keepAlive: true)
// Future<int> family2(Family2Ref ref, int id) async => 0;

// @Riverpod(keepAlive: true)
// class Dep3 extends _$Dep3 {
//   @override
//   Future<int> build() async => 0;
// }

// @Riverpod(keepAlive: true)
// class Family3 extends _$Family3 {
//   @override
//   Future<int> build(int id) async => 0;
// }

// final provider = Provider<int>((ref) {
//   ref.watch(dep);
//   ref.watch(dep.select((e) => e));
//   ref.watch(dep.selectAsync((e) => e));
//   ref.watch(family(0));
//   ref.watch(family(0).select((e) => e));
//   ref.watch(family(0).selectAsync((e) => e));

//   ref.watch(dep2Provider);
//   ref.watch(dep2Provider.select((e) => e));
//   ref.watch(dep2Provider.selectAsync((e) => e));
//   ref.watch(family2Provider(0));
//   ref.watch(family2Provider(0).select((e) => e));
//   ref.watch(family2Provider(0).selectAsync((e) => e));

//   ref.watch(dep3Provider);
//   ref.watch(dep3Provider.select((e) => e));
//   ref.watch(dep3Provider.selectAsync((e) => e));
//   ref.watch(family3Provider(0));
//   ref.watch(family3Provider(0).select((e) => e));
//   ref.watch(family3Provider(0).selectAsync((e) => e));

//   ref.fn();
//   return 0;
// });

// class _Ref {
//   void watch(ProviderBase provider) {}
// }
// void fn(_Ref ref) {
//   ref.watch(dep);
// }
// ''', (resolver) async {
//     final result = await resolver.resolveRiverpodAnalyssiResult();

//     expect(result.refWatchInvocations, hasLength(3));
//     expect(result.refInvocations, result.refWatchInvocations);
//   });
}
