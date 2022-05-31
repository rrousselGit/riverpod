import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('NotifierProvider', () {
    test(
        'uses notifier.build as initial state and update listeners when state changes',
        () {
      final provider = TestNotifierProvider((ref) => 0);
      final container = createContainer();
      final listener = Listener<int>();

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      container.read(provider.notifier).update((state) => state + 1);

      verifyOnly(listener, listener(0, 1));
    });

    test('can override the Notifier with a matching custom implementation',
        () {});

    test('can override Notifier.build', () {});

    test('listening to provider.notifier never emit updates', () {});

    test('supports ref.refresh(provider) and ref.refresh(provider.notifier)',
        () {});

    test('during an initialization error, the notifier is still available',
        () {});

    test('.state rethrows initilization error, if any', () {});

    test('supports listenSelf((State? prev, State next) {})', () {});

    test('is preserved between watch updates', () {});

    test('calls notifier.build on every watch update', () {});

    test('calls notifier.initState once', () {});

    test(
        'calls to onDispose inside initState are executed when the element is destroyed',
        () {});
  });
}

// ignore: non_constant_identifier_names
NotifierProvider<TestNotifier<T>, T> TestNotifierProvider<T>(
    T Function(Ref ref) init) {
  return NotifierProvider<TestNotifier<T>, T>(() => TestNotifier(init));
}

class TestNotifier<T> extends Notifier<T> {
  TestNotifier(this._init);

  final T Function(Ref ref) _init;

  @override
  T build() => _init(ref);

  void update(T Function(T state) cb) => state = cb(state);
}
