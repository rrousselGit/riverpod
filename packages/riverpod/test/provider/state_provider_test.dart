import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  test('StateNotifierProviderDependency can be assigned to ProviderDependency',
      () async {
    final provider = StateProvider((ref) => 0);
    final owner = ProviderStateOwner();

    // ignore: omit_local_variable_types
    final ProviderDependency<StateController<int>> dep =
        owner.ref.dependOn(provider);

    await expectLater(dep.value.state, 0);
  });
  test('StateProvideyFamily', () async {
    final provider = StateProvider.family<String, int>((ref, a) {
      return '$a';
    });
    final owner = ProviderStateOwner();

    expect(
      provider(0).readOwner(owner),
      isA<StateController>().having((s) => s.state, 'state', '0'),
    );
    expect(
      provider(1).readOwner(owner),
      isA<StateController>().having((s) => s.state, 'state', '1'),
    );
  });

  test('StateProvideyFamily override', () async {
    final provider = StateProvider.family<String, int>((ref, a) {
      return '$a';
    });
    final owner = ProviderStateOwner(overrides: [
      provider.overrideAs((ref, a) => 'override $a'),
    ]);

    expect(
      provider(0).readOwner(owner),
      isA<StateController>().having((s) => s.state, 'state', 'override 0'),
    );
    expect(
      provider(1).readOwner(owner),
      isA<StateController>().having((s) => s.state, 'state', 'override 1'),
    );
  });
  test('Expose a state and allows modifying it', () {
    final owner = ProviderStateOwner();
    final provider = StateProvider((ref) => 0);
    final listener = Listener();

    final controller = provider.readOwner(owner);
    expect(controller.state, 0);

    provider.watchOwner(owner, listener);
    verify(listener(controller));
    verifyNoMoreInteractions(listener);
    expect(controller.mounted, true);

    controller.state = 42;

    verify(listener(controller));
    verifyNoMoreInteractions(listener);

    owner.dispose();

    expect(controller.mounted, false);
  });
}

class Listener extends Mock {
  void call(StateController<int> value);
}
