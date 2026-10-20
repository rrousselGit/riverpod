// ignore_for_file: avoid_types_on_closure_parameters, invalid_use_of_protected_member

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

  test('supports overrideWith', () {
    final provider = AsyncNotifierProvider<DeferredAsyncNotifier<int>, int>(
      () => DeferredAsyncNotifier((ref, _) => 0),
    );
    final autoDispose =
        AsyncNotifierProvider.autoDispose<DeferredAsyncNotifier<int>, int>(
          () => DeferredAsyncNotifier((ref, _) => 0),
        );
    final container = ProviderContainer.test(
      overrides: [
        provider.overrideWith(() => DeferredAsyncNotifier((ref, _) => 42)),
        autoDispose.overrideWith(() => DeferredAsyncNotifier((ref, _) => 84)),
      ],
    );

    expect(container.read(provider).value, 42);
    expect(container.read(autoDispose).value, 84);
  });

  group('modifiers', () {
    void canBeAssignedToRefreshable<StateT>(Refreshable<StateT> provider) {}

    void canBeAssignedToProviderListenable<StateT>(
      ProviderListenable<StateT> provider,
    ) {}

    test('provider', () {
      final provider = AsyncNotifierProvider<DeferredAsyncNotifier<int>, int>(
        () => DeferredAsyncNotifier((ref, _) => 0),
      );

      provider.select((AsyncValue<int> value) => 0);
      provider.selectAsync((int value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<int>>(provider);
      canBeAssignedToRefreshable<AsyncValue<int>>(provider);

      canBeAssignedToProviderListenable<Future<int>>(provider.future);
      canBeAssignedToRefreshable<Future<int>>(provider.future);

      canBeAssignedToProviderListenable<AsyncNotifier<int>>(provider.notifier);
      canBeAssignedToRefreshable<AsyncNotifier<int>>(provider.notifier);
    });

    test('autoDispose', () {
      final autoDispose =
          AsyncNotifierProvider.autoDispose<DeferredAsyncNotifier<int>, int>(
            () => DeferredAsyncNotifier((ref, _) => 0),
          );

      autoDispose.select((AsyncValue<int> value) => 0);
      autoDispose.selectAsync((int value) => 0);

      canBeAssignedToProviderListenable<AsyncValue<int>>(autoDispose);
      canBeAssignedToRefreshable<AsyncValue<int>>(autoDispose);

      canBeAssignedToProviderListenable<Future<int>>(autoDispose.future);
      canBeAssignedToRefreshable<Future<int>>(autoDispose.future);

      canBeAssignedToProviderListenable<AsyncNotifier<int>>(
        autoDispose.notifier,
      );
      canBeAssignedToRefreshable<AsyncNotifier<int>>(autoDispose.notifier);
    });
  });
}

class CtorNotifier extends AsyncNotifier<int> {
  @override
  FutureOr<int> build() => 0;
}
