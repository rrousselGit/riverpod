import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

void main() {
  test('can read value', () {
    var result = 42;
    final owner = ProviderStateOwner();
    var callCount = 0;
    final provider = Provider((_) {
      callCount++;
      return result;
    });

    expect(callCount, 0);
    expect(provider.readOwner(owner), 42);
    expect(callCount, 1);
    expect(provider.readOwner(owner), 42);
    expect(callCount, 1);

    final owner2 = ProviderStateOwner();

    result = 21;
    expect(provider.readOwner(owner2), 21);
    expect(callCount, 2);
    expect(provider.readOwner(owner2), 21);
    expect(callCount, 2);
    expect(provider.readOwner(owner), 42);
    expect(callCount, 2);
  });

  test('dispose', () {
    final owner = ProviderStateOwner();
    final onDispose = OnDisposeMock();
    final provider = Provider((state) {
      state.onDispose(onDispose);
      return 42;
    });

    expect(provider.readOwner(owner), 42);

    verifyZeroInteractions(onDispose);

    owner.dispose();

    verify(onDispose()).called(1);
  });
}

class OnDisposeMock extends Mock {
  void call();
}
