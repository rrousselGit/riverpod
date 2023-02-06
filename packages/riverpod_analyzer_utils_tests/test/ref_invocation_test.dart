import 'package:test/test.dart';

import 'analyser_test_utils.dart';

void main() {
  testSource('Decodes ref.watch usages', source: '''
import 'package:riverpod/riverpod.dart';

extension on Ref {
  void fn() {}
}

final dep = FutureProvider((ref) => 0);
final family = FutureProvider.family<int, int>((ref, id) => 0);

final provider = Provider<int>((ref) {
  ref.watch(dep);
  ref.watch(dep.select((e) => e));
  ref.watch(dep.selectAsync((e) => e));
  ref.watch(family(0));
  ref.watch(family(0).select((e) => e));
  ref.watch(family(0).selectAsync((e) => e));

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

    expect(result.refWatchInvocations, hasLength(6));
    expect(result.refInvocations, result.refWatchInvocations);

    expect(
      result.refWatchInvocations[0].node.toSource(),
      'ref.watch(dep)',
    );
    expect(result.refWatchInvocations[0].function.toSource(), 'watch');
    expect(result.refWatchInvocations[0].provider.node.toSource(), 'dep');
    expect(result.refWatchInvocations[0].provider.provider?.toSource(), 'dep');
    expect(
      result.refWatchInvocations[0].provider.providerElement,
      same(result.legacyProviderDeclarations['dep']),
    );
  });
}
