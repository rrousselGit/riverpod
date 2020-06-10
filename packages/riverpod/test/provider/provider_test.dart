import 'package:riverpod/src/framework/framework.dart' show AlwaysAliveProvider;
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  test('can specify name', () {
    final provider = Provider(
      (_) => 0,
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 = Provider((_) => 0);

    expect(provider2.name, isNull);
  });
  test('is AlwaysAliveProvider', () {
    final provider = Provider((_) async => 42);

    expect(provider, isA<AlwaysAliveProvider>());
  });
  group('depend on', () {
    final dependency = Provider((_) => 1);
    final dependency2 = Provider((_) => '2');

    test('Provider1', () {
      final owner = ProviderStateOwner();

      final provider = Provider((ref) {
        final first = ref.dependOn(dependency);
        return first.value * 2;
      });

      expect(provider.readOwner(owner), 2);

      owner.dispose();
    });
    test('Provider2', () {
      final owner = ProviderStateOwner();

      final provider = Provider((ref) {
        final first = ref.dependOn(dependency);
        final second = ref.dependOn(dependency2);

        return '${first.value} ${second.value}';
      });

      expect(provider.readOwner(owner), '1 2');

      owner.dispose();
    });
  });
  test('readOwner', () {
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

  test('subscribe', () {
    final owner = ProviderStateOwner();
    final provider = Provider((_) => 42);

    int value;
    var callCount = 0;

    final removeListener = provider.watchOwner(owner, (v) {
      value = v;
      callCount++;
    });

    expect(callCount, 1);
    expect(value, 42);

    removeListener();
    expect(callCount, 1);
  });

  test('dispose', () {
    final owner = ProviderStateOwner();
    final onDispose = OnDisposeMock();
    final provider = Provider((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    expect(provider.readOwner(owner), 42);

    verifyZeroInteractions(onDispose);

    owner.dispose();

    verify(onDispose()).called(1);
  }, skip: true);
}

class OnDisposeMock extends Mock {
  void call();
}
