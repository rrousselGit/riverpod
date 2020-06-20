import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
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
  test('does not trigger an update if the new value is == to the old one', () {
    final owner = ProviderStateOwner();
    final provider = StateProvider((ref) => 0);
    final listener = Listener();

    final controller = provider.readOwner(owner);
    expect(controller.state, 0);

    provider.watchOwner(owner, listener);
    verify(listener(controller));
    verifyNoMoreInteractions(listener);

    controller.state = 0;

    verifyNoMoreInteractions(listener);
  });
}

class Listener extends Mock {
  void call(StateController<int> value);
}
