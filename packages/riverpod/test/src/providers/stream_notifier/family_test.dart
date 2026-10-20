// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:async';

import 'package:riverpod/misc.dart' show Refreshable, ProviderListenable;
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../matrix.dart';

void main() {
  test('supports family overrideWith', () async {
    final family =
        StreamNotifierProvider.family<DeferredStreamNotifier<int>, int, int>(
          (arg) => DeferredStreamNotifier<int>((ref, _) => Stream.value(0)),
        );
    final autoDisposeFamily = StreamNotifierProvider.autoDispose
        .family<DeferredStreamNotifier<int>, int, int>(
          (arg) => DeferredStreamNotifier<int>((ref, _) => Stream.value(0)),
        );
    final container = ProviderContainer.test(
      overrides: [
        family.overrideWith2(
          (arg) =>
              DeferredStreamNotifier<int>((ref, _) => Stream.value(42 + arg)),
        ),
        autoDisposeFamily.overrideWith2(
          (arg) =>
              DeferredStreamNotifier<int>((ref, _) => Stream.value(84 + arg)),
        ),
      ],
    );

    // Skip the loading
    await container.listen(family(10).future, (previous, next) {}).read();
    await container
        .listen(autoDisposeFamily(10).future, (previous, next) {})
        .read();

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
          StreamNotifierProvider.family<
            DeferredStreamNotifier<String>,
            String,
            int
          >((arg) => DeferredStreamNotifier((ref, _) => Stream.value('0')));

      family(0).select((AsyncValue<String> value) => 0);
      family(0).selectAsync((String value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<String>>(family(0));
      canBeAssignedToRefreshable<AsyncValue<String>>(family(0));

      canBeAssignedToProviderListenable<Future<String>>(family(0).future);
      canBeAssignedToRefreshable<Future<String>>(family(0).future);
    });

    test('autoDisposeFamily', () {
      expect(
        StreamNotifierProvider.autoDispose.family,
        same(StreamNotifierProvider.family.autoDispose),
      );

      final autoDisposeFamily = StreamNotifierProvider.autoDispose
          .family<DeferredStreamNotifier<String>, String, int>(
            (arg) => DeferredStreamNotifier((ref, _) => Stream.value('0')),
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
