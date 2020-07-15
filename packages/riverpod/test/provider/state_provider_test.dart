import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  test('StateNotifierProviderDependency can be assigned to ProviderDependency',
      () async {
    final provider = StateProvider((ref) => 0);
    final container = ProviderContainer();

    // ignore: omit_local_variable_types
    final ProviderDependency<StateController<int>> dep =
        container.ref.dependOn(provider);

    await expectLater(dep.value.state, 0);
  });
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
      provider.overrideAs((ref, a) => 'override $a'),
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
    expect(controller.mounted, true);

    controller.state = 42;

    verify(listener(controller));
    verifyNoMoreInteractions(listener);

    container.dispose();

    expect(controller.mounted, false);
  });
}

class Listener extends Mock {
  void call(StateController<int> value);
}
