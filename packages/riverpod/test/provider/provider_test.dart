import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import '../utils.dart';

void main() {
  test('Provider.autoDispose.family', () async {
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose.family<String, int>((ref, value) {
      ref.onDispose(onDispose);
      return '$value';
    });
    final listener = Listener();
    final container = ProviderContainer();

    final removeListener = provider(0).watchOwner(container, listener);

    verify(listener('0')).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);

    removeListener();

    verifyNoMoreInteractions(onDispose);
    await Future<void>.value();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });

  test('Provider.autoDispose.family override', () async {
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose.family<String, int>((ref, value) {
      return '$value';
    });
    final listener = Listener();
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider((ref, value) {
        ref.onDispose(onDispose);
        return '$value override';
      })
    ]);

    final removeListener = provider(0).watchOwner(container, listener);

    verify(listener('0 override')).called(1);
    verifyNoMoreInteractions(listener);

    removeListener();

    verifyNoMoreInteractions(onDispose);
    await Future<void>.value();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });

  test('can specify name', () {
    final provider = Provider(
      (_) => 0,
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 = Provider((_) => 0);

    expect(provider2.name, isNull);
  });

  test('is AlwaysAliveProviderBase', () {
    final provider = Provider((_) async => 42);

    expect(provider, isA<AlwaysAliveProviderBase>());
  });
  group('depend on', () {
    final dependency = Provider((_) => 1);
    final dependency2 = Provider((_) => '2');

    test('ProviderFamily', () {
      final container = ProviderContainer();

      final provider = Provider((ref) {
        final first = ref.watch(dependency);
        return first * 2;
      });

      expect(container.read(provider), 2);

      container.dispose();
    });
    test('Provider2', () {
      final container = ProviderContainer();

      final provider = Provider((ref) {
        final first = ref.watch(dependency);
        final second = ref.watch(dependency2);

        return '$first $second';
      });

      expect(container.read(provider), '1 2');

      container.dispose();
    });
  });

  test('ProviderContainer.read', () {
    var result = 42;
    final container = ProviderContainer();
    var callCount = 0;
    final provider = Provider((_) {
      callCount++;
      return result;
    });

    expect(callCount, 0);
    expect(container.read(provider), 42);
    expect(callCount, 1);
    expect(container.read(provider), 42);
    expect(callCount, 1);

    final container2 = ProviderContainer();

    result = 21;
    expect(container2.read(provider), 21);
    expect(callCount, 2);
    expect(container2.read(provider), 21);
    expect(callCount, 2);
    expect(container.read(provider), 42);
    expect(callCount, 2);
  });

  test('subscribe', () {
    final container = ProviderContainer();
    final provider = Provider((_) => 42);

    int value;
    var callCount = 0;

    final removeListener = provider.watchOwner(container, (v) {
      value = v;
      callCount++;
    });

    expect(callCount, 1);
    expect(value, 42);

    removeListener();
    expect(callCount, 1);
  });

  test('dispose', () {
    final container = ProviderContainer();
    final onDispose = OnDisposeMock();
    final provider = Provider((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    expect(container.read(provider), 42);

    verifyZeroInteractions(onDispose);

    container.dispose();

    verify(onDispose()).called(1);
  });
}

class OnDisposeMock extends Mock {
  void call();
}

class Listener extends Mock {
  void call(String value);
}
