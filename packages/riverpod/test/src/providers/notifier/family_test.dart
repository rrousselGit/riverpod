// ignore_for_file: avoid_types_on_closure_parameters

import 'package:riverpod/misc.dart' show Refreshable, ProviderListenable;
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../matrix.dart';

void main() {
  test('supports family overrideWith', () {
    final family = NotifierProvider.family<DeferredNotifier<int>, int, int>(
      (arg) => DeferredNotifier<int>((ref, _) => 0),
    );
    final autoDisposeFamily = NotifierProvider.autoDispose
        .family<DeferredNotifier<int>, int, int>(
          (arg) => DeferredNotifier<int>((ref, _) => 0),
        );
    final container = ProviderContainer.test(
      overrides: [
        family.overrideWith2(
          (arg) => DeferredNotifier<int>((ref, _) => 42 + arg),
        ),
        autoDisposeFamily.overrideWith2(
          (arg) => DeferredNotifier<int>((ref, _) => 84 + arg),
        ),
      ],
    );

    expect(container.read(family(10)), 52);
    expect(container.read(autoDisposeFamily(10)), 94);
  });

  group('modifiers', () {
    void canBeAssignedToRefreshable<StateT>(Refreshable<StateT> provider) {}

    void canBeAssignedToProviderListenable<StateT>(
      ProviderListenable<StateT> provider,
    ) {}

    test('family', () {
      final family =
          NotifierProvider.family<DeferredNotifier<String>, String, int>(
            (arg) => DeferredNotifier((ref, _) => '0'),
          );

      family(0).select((String value) => 0);

      canBeAssignedToProviderListenable<String>(family(0));
      canBeAssignedToRefreshable<String>(family(0));

      canBeAssignedToProviderListenable<Notifier<String>>(family(0).notifier);
      canBeAssignedToRefreshable<Notifier<String>>(family(0).notifier);
    });

    test('autoDisposeFamily', () {
      expect(
        NotifierProvider.autoDispose.family,
        same(NotifierProvider.family.autoDispose),
      );

      final autoDisposeFamily = NotifierProvider.autoDispose
          .family<DeferredNotifier<String>, String, int>(
            (arg) => DeferredNotifier((ref, _) => '0'),
          );

      autoDisposeFamily(0).select((String value) => 0);

      canBeAssignedToProviderListenable<String>(autoDisposeFamily(0));
      canBeAssignedToRefreshable<String>(autoDisposeFamily(0));

      canBeAssignedToProviderListenable<Notifier<String>>(
        autoDisposeFamily(0).notifier,
      );
      canBeAssignedToRefreshable<Notifier<String>>(
        autoDisposeFamily(0).notifier,
      );
    });
  });
}
