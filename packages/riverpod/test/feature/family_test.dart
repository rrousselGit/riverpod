import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  test('.allOf returns active providers of a family', () async {
    final family = Provider.autoDispose.family<int, int>((ref, arg) => arg);
    final otherFamily = Provider.autoDispose.family<int, int>(
      (ref, arg) => arg,
    );
    final container = ProviderContainer.test();

    final sub0 = container.listen(family(0), (_, _) {});
    final sub1 = container.listen(family(1), (_, _) {});
    final otherSub = container.listen(otherFamily(2), (_, _) {});

    expect(
      family.allOf(container),
      unorderedEquals(<ProviderBase<Object?>>[family(0), family(1)]),
    );

    sub0.close();
    await container.pump();

    expect(
      family.allOf(container),
      unorderedEquals(<ProviderBase<Object?>>[family(1)]),
    );

    sub1.close();
    otherSub.close();
    await container.pump();

    expect(family.allOf(container), isEmpty);
  });

  test('.allOf includes active providers from parent containers too', () async {
    final family = Provider.autoDispose.family<int, int>((ref, arg) => arg);
    final unrelated = Provider((ref) => 0);
    final root = ProviderContainer.test();
    final container = ProviderContainer.test(
      parent: root,
      overrides: [unrelated],
    );

    container.listen(family(1), (_, _) {});
    root.listen(family(0), (_, _) {});

    expect(
      family.allOf(container),
      unorderedEquals(<ProviderBase<Object?>>[family(0), family(1)]),
    );
  });
}
