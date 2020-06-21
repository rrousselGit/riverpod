import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  // TODO: no-top if when removing watchOwner there is still a watchOwner
  // TODO: no-top if when removing watchOwner there is still a ref.read
  // TODO: unmount on removing ref.read
  // TODO: no-top if when removing ref.read there is still a watchOwner
  // TODO: no-top if when removing ref.read there is still a ref.read
  // TODO chain
  // TODO unsub no-op if another sub is added before event-loop
  test(' unmount on removing watchOwner', () {
    final owner = ProviderStateOwner();
    final onDispose = OnDisposeMock();
    final provider = AutoDisposeProvider((ref) {
      ref.onDispose(onDispose);
    });
  });
}

class OnDisposeMock extends Mock {
  void call();
}
