import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('StateProvideyFamily', () async {
    final provider = StateProvider.family<String, int>((ref, a) {
      return '$a';
    });
    final container = ProviderContainer();

    expect(
      container.read(provider(0)),
      isA<StateController>().having((s) => s.state, 'state', '0'),
    );
    expect(
      container.read(provider(1)),
      isA<StateController>().having((s) => s.state, 'state', '1'),
    );
  });

  test('StateProvideyFamily override', () async {
    final provider = StateProvider.family<String, int>((ref, a) {
      return '$a';
    });
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider((ref, a) => 'override $a'),
    ]);

    expect(
      container.read(provider(0)),
      isA<StateController>().having((s) => s.state, 'state', 'override 0'),
    );
    expect(
      container.read(provider(1)),
      isA<StateController>().having((s) => s.state, 'state', 'override 1'),
    );
  });

  test('Expose a state and allows modifying it', () {
    final container = ProviderContainer();
    final provider = StateProvider((ref) => 0);
    final listener = Listener();

    final controller = container.read(provider);
    expect(controller.state, 0);

    provider.watchOwner(container, listener);
    verify(listener(controller));
    verifyNoMoreInteractions(listener);

    controller.state = 42;

    verify(listener(controller));
    verifyNoMoreInteractions(listener);
  });

  test('disposes the controller when the container is disposed', () {
    final container = ProviderContainer();
    final provider = StateProvider((ref) => 0);

    final controller = container.read(provider);

    expect(controller.mounted, true);

    container.dispose();

    expect(controller.mounted, false);
  });

  test('disposes the notifier when provider is unmounted or on set state',
      () async {
    final ctrl = StateController<int>(0);
    final completer = Completer<void>();
    final provider = StateProvider<int>((ref) {
      Future.microtask(() {}).then((value) {
        ref.setState(ctrl);
        completer.complete();
      });
      return -1;
    });
    final container = ProviderContainer();

    final initialCtrl = container.read(provider);
    await completer.future;

    expect(initialCtrl.mounted, isFalse);
    expect(container.read(provider), ctrl);
    expect(ctrl.mounted, isTrue);

    container.read(provider).state = 100;
    expect(container.read(provider), ctrl);

    container.dispose();
    expect(ctrl.mounted, isFalse);
  });

  test('disposes the controller when the provider is re-evaluated', () {
    final container = ProviderContainer();
    final other = StateProvider((ref) => 0);
    final provider = StateProvider((ref) => ref.watch(other).state * 2);

    final otherController = container.read(other);
    final firstController = container.read(provider);

    final sub = container.listen(provider);

    expect(sub.read(), firstController);
    expect(firstController.mounted, true);

    otherController.state++;

    final secondController = sub.read();
    expect(secondController, isNot(firstController));
    expect(secondController.mounted, true);
    expect(secondController.state, 2);
    expect(firstController.mounted, false);
  });
}

class Listener extends Mock {
  void call(StateController<int> value);
}
