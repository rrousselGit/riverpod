import 'package:riverpod/misc.dart' show Refreshable, ProviderListenable;
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../matrix.dart';
import '../../utils.dart';

void main() {
  test('Throws if using notifier properties in its constructor', () {
    final errors = captureErrors([
      () => CtorNotifier().state,
      () => CtorNotifier().state = 42,
      () => CtorNotifier().ref,
    ]);
  });

  test('supports overrideWith', () {
    final provider = NotifierProvider<DeferredNotifier<int>, int>(
      () => DeferredNotifier((ref, _) => 0),
    );
    final autoDispose =
        NotifierProvider.autoDispose<DeferredNotifier<int>, int>(
          () => DeferredNotifier((ref, _) => 0),
        );
    final container = ProviderContainer.test(
      overrides: [
        provider.overrideWith(() => DeferredNotifier((ref, _) => 42)),
        autoDispose.overrideWith(() => DeferredNotifier((ref, _) => 84)),
      ],
    );

    expect(container.read(provider), 42);
    expect(container.read(autoDispose), 84);
  });

  group('modifiers', () {
    void canBeAssignedToRefreshable<StateT>(Refreshable<StateT> provider) {}

    void canBeAssignedToProviderListenable<StateT>(
      ProviderListenable<StateT> provider,
    ) {}

    test('provider', () {
      final provider = NotifierProvider<DeferredNotifier<int>, int>(
        () => DeferredNotifier((ref, _) => 0),
      );

      provider.select((int value) => 0);

      canBeAssignedToProviderListenable<int>(provider);
      canBeAssignedToRefreshable<int>(provider);

      canBeAssignedToProviderListenable<Notifier<int>>(provider.notifier);
      canBeAssignedToRefreshable<Notifier<int>>(provider.notifier);
    });

    test('autoDispose', () {
      final autoDispose =
          NotifierProvider.autoDispose<DeferredNotifier<int>, int>(
            () => DeferredNotifier((ref, _) => 0),
          );

      autoDispose.select((int value) => 0);

      canBeAssignedToProviderListenable<int>(autoDispose);
      canBeAssignedToRefreshable<int>(autoDispose);

      canBeAssignedToProviderListenable<DeferredNotifier<int>>(
        autoDispose.notifier,
      );
      canBeAssignedToRefreshable<DeferredNotifier<int>>(autoDispose.notifier);
    });
  });
}

class CtorNotifier extends Notifier<int> {
  @override
  int build() => 0;
}
