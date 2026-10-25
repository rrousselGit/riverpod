import 'dart:async';

import 'package:riverpod/misc.dart' show Refreshable, ProviderListenable;
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../matrix.dart';

void main() {
  test('supports family overrideWith', () {
    final family =
        AsyncNotifierProvider.family<DeferredAsyncNotifier<int>, int, int>(
          (arg) => DeferredAsyncNotifier((ref, _) => 0),
        );
    final autoDisposeFamily = AsyncNotifierProvider.autoDispose
        .family<DeferredAsyncNotifier<int>, int, int>(
          (arg) => DeferredAsyncNotifier((ref, _) => 0),
        );
    final container = ProviderContainer.test(
      overrides: [
        family.overrideWith2(
          (arg) => DeferredAsyncNotifier<int>((ref, _) => 42 + arg),
        ),
        autoDisposeFamily.overrideWith2(
          (arg) => DeferredAsyncNotifier<int>((ref, _) => 84 + arg),
        ),
      ],
    );

    expect(container.read(family(10)).value, 52);
    expect(container.read(autoDisposeFamily(10)).value, 94);
  });

  group('modifiers', () {
    void canBeAssignedToRefreshable<StateT>(Refreshable<StateT> provider) {}

    void canBeAssignedToProviderListenable<StateT>(
      ProviderListenable<StateT> provider,
    ) {}

    test('family', () {
      final family =
          AsyncNotifierProvider.family<
            DeferredAsyncNotifier<String>,
            String,
            int
          >((arg) => DeferredAsyncNotifier((ref, _) => '0'));

      family(0).select((AsyncValue<String> value) => 0);
      family(0).selectAsync((String value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<String>>(family(0));
      canBeAssignedToRefreshable<AsyncValue<String>>(family(0));

      canBeAssignedToProviderListenable<Future<String>>(family(0).future);
      canBeAssignedToRefreshable<Future<String>>(family(0).future);
    });

    test('autoDisposeFamily', () {
      expect(
        AsyncNotifierProvider.autoDispose.family,
        same(AsyncNotifierProvider.family.autoDispose),
      );

      final autoDisposeFamily = AsyncNotifierProvider.autoDispose
          .family<DeferredAsyncNotifier<String>, String, int>(
            (arg) => DeferredAsyncNotifier((ref, _) => '0'),
          );

      autoDisposeFamily(0).select((AsyncValue<String> value) => 0);
      autoDisposeFamily(0).selectAsync((String value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<String>>(
        autoDisposeFamily(0),
      );
      canBeAssignedToRefreshable<AsyncValue<String>>(autoDisposeFamily(0));

      canBeAssignedToProviderListenable<Future<String>>(
        autoDisposeFamily(0).future,
      );
      canBeAssignedToRefreshable<Future<String>>(autoDisposeFamily(0).future);
    });
  });
}
