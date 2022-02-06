import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('implements ProviderSubscription.read', () async {
    final container = createContainer();
    final dep = StateProvider((ref) => 0);
    final provider = FutureProvider((ref) async => ref.watch(dep));

    final sub = container.listen(
      provider.selectAsync((data) => data.isEven),
      (prev, next) {},
    );

    print('a');
    expect(await sub.read(), true);
    print('b');

    container.read(dep.notifier).state += 2;
    await container.pump();
    print('c');

    expect(await sub.read(), true);
    print('d');

    container.read(dep.notifier).state++;
    await container.pump();

    print('e');
    expect(await sub.read(), false);
    print('f');
  });

  test('handles fireImmediately: true', () async {
    final container = createContainer();
    final dep = StateProvider((ref) => 0);
    final provider = FutureProvider((ref) async => ref.watch(dep));
    final listener = Listener<Future<bool>>();

    container.listen(
      provider.selectAsync((data) => data.isEven),
      listener,
      fireImmediately: true,
    );

    final result =
        verify(listener(null, captureAny)).captured.single as Future<bool>;
    verifyNoMoreInteractions(listener);
    expect(await result, true);
  });

  test('handles fireImmediately: false', () async {
    final container = createContainer();
    final dep = StateProvider((ref) => 0);
    final provider = FutureProvider((ref) async => ref.watch(dep));
    final listener = Listener<Future<bool>>();

    container.listen(
      provider.selectAsync((data) => data.isEven),
      listener,
      fireImmediately: false,
    );

    verifyZeroInteractions(listener);
  });

  test('handles multiple AsyncLoading at once then data', () {});

  test('asyncSelect on a isRefreshing provider waits until the refresh', () {});

  test('can watch async selectors', () async {
    final container = createContainer();
    var buildCount = 0;
    final dep = StateProvider((ref) => 0);
    final a = FutureProvider((ref) async => ref.watch(dep));
    final b = FutureProvider((ref) {
      buildCount++;
      return ref.watch(a.selectAsync((value) => value % 10));
    });

    expect(buildCount, 0);
    expect(container.read(b), const AsyncLoading<int>());
    expect(container.read(b), const AsyncLoading<int>());
    expect(await container.read(b.future), 0);
    expect(buildCount, 1);

    container.read(dep.notifier).state = 1;
    expect(container.read(a), const AsyncData(0, isRefreshing: true));
    expect(container.read(b), const AsyncData(0));
    expect(buildCount, 1);

    await container.pump();
    expect(await container.read(b.future), 1);
    expect(buildCount, 2);

    container.read(dep.notifier).state = 11;
    expect(container.read(a), const AsyncData(1, isRefreshing: true));
    expect(container.read(b), const AsyncData(1));
    expect(buildCount, 2);

    await container.pump();
    expect(await container.read(b.future), 1);
    expect(buildCount, 2);
  });
}
