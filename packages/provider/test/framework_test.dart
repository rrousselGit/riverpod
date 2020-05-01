import 'package:test/test.dart';
import 'package:provider/provider.dart';

void main() {
  group('onError', () {
    // TODO error handling initState
    // TODO error handling didUpdateProvider
    // TODO error handling dispose
    // TODO error handling watchOwner callback
    // TODO error handling state.onDispose callback
    // TODO error handling state.onChange (if any) callback
    // TODO no onError fallback to zone
  });
  // TODO test dependOn disposes the provider state (keep alive?)
  // TODO circular dependencies
  // TODO dispose providers in dependency order
  // TODO update providers in dependency order
  test('dependOn used on same provider multiple times returns same instance',
      () {
    final owner = ProviderStateOwner();
    final provider = Provider((_) => 42);

    ProviderValue<int> other;
    ProviderValue<int> other2;

    final provider1 = Provider((state) {
      other = state.dependOn(provider);
      other2 = state.dependOn(provider);
      return other.value;
    });

    expect(provider1.readOwner(owner), 42);
    expect(other, other2);

    owner.dispose();
  });
  // TODO ProviderState is unusable after dispose (dependOn/onDispose)
}
