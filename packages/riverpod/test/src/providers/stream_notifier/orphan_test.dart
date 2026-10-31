import 'dart:async';

import 'package:riverpod/misc.dart' show Refreshable, ProviderListenable;
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../matrix.dart';
import '../../utils.dart';

void main() {
  test('Throws if using notifier properties in its constructor', () {
    final errors = captureErrors([
      () => CtorNotifier().state,
      () => CtorNotifier().state = const AsyncData(42),
      () => CtorNotifier().future,
      () => CtorNotifier().ref,
    ]);
  });

  test('supports overrideWith', () async {
    final provider = StreamNotifierProvider<DeferredStreamNotifier<int>, int>(
      () => DeferredStreamNotifier((ref, _) => Stream.value(0)),
    );
    final autoDispose =
        StreamNotifierProvider.autoDispose<DeferredStreamNotifier<int>, int>(
          () => DeferredStreamNotifier((ref, _) => Stream.value(0)),
        );
    final container = ProviderContainer.test(
      overrides: [
        provider.overrideWith(
          () => DeferredStreamNotifier((ref, _) => Stream.value(42)),
        ),
        autoDispose.overrideWith(
          () => DeferredStreamNotifier((ref, _) => Stream.value(84)),
        ),
      ],
    );

    // Skip the loading
    await container.listen(provider.future, (previous, next) {}).read();
    await container.listen(autoDispose.future, (previous, next) {}).read();

    expect(container.read(provider).value, 42);
    expect(container.read(autoDispose).value, 84);
  });

  group('modifiers', () {
    void canBeAssignedToRefreshable<StateT>(Refreshable<StateT> provider) {}

    void canBeAssignedToProviderListenable<StateT>(
      ProviderListenable<StateT> provider,
    ) {}

    test('provider', () {
      final provider = StreamNotifierProvider<DeferredStreamNotifier<int>, int>(
        () => DeferredStreamNotifier((ref, _) => Stream.value(0)),
      );

      provider.select((AsyncValue<int> value) => 0);
      provider.selectAsync((int value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<int>>(provider);
      canBeAssignedToRefreshable<AsyncValue<int>>(provider);

      canBeAssignedToProviderListenable<Future<int>>(provider.future);
      canBeAssignedToRefreshable<Future<int>>(provider.future);

      canBeAssignedToProviderListenable<StreamNotifier<int>>(provider.notifier);
      canBeAssignedToRefreshable<StreamNotifier<int>>(provider.notifier);
    });

    test('autoDispose', () {
      final autoDispose =
          StreamNotifierProvider.autoDispose<DeferredStreamNotifier<int>, int>(
            () => DeferredStreamNotifier((ref, _) => Stream.value(0)),
          );

      autoDispose.select((AsyncValue<int> value) => 0);
      autoDispose.selectAsync((int value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<int>>(autoDispose);
      canBeAssignedToRefreshable<AsyncValue<int>>(autoDispose);

      canBeAssignedToProviderListenable<Future<int>>(autoDispose.future);
      canBeAssignedToRefreshable<Future<int>>(autoDispose.future);

      canBeAssignedToProviderListenable<StreamNotifier<int>>(
        autoDispose.notifier,
      );
      canBeAssignedToRefreshable<StreamNotifier<int>>(autoDispose.notifier);
    });
  });
}

class CtorNotifier extends StreamNotifier<int> {
  @override
  Stream<int> build() => Stream.value(0);
}
