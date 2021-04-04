import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'utils.dart';

void main() {
  test('auto-dispose notifier when stop listening', () async {
    final container = ProviderContainer();
    final onDispose = OnDisposeMock();
    final provider = ChangeNotifierProvider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return ValueNotifier(0);
    });

    final removeListener = provider.watchOwner(container, (value) {});

    removeListener();

    verifyNoMoreInteractions(onDispose);

    await Future<void>.value();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });

  test('family', () {
    final container = ProviderContainer();
    final provider = ChangeNotifierProvider.autoDispose
        .family<ValueNotifier<int>, int>((ref, value) {
      return ValueNotifier(value);
    });
    final listener1 = Listener<ValueNotifier<int>>();
    final listener2 = Listener<ValueNotifier<int>>();

    provider(0).watchOwner(container, listener1);
    provider(42).watchOwner(container, listener2);

    verify(listener1(argThat(
      isA<ValueNotifier<int>>().having((s) => s.value, 'value', 0),
    ))).called(1);
    verifyNoMoreInteractions(listener1);

    verify(listener2(argThat(
      isA<ValueNotifier<int>>().having((s) => s.value, 'value', 42),
    ))).called(1);
    verifyNoMoreInteractions(listener2);
  });

  test('.notifier obtains the controller without listening to it', () {
    final dep = StateProvider((ref) => 0);
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final provider = ChangeNotifierProvider.autoDispose((ref) {
      return ref.watch(dep).state == 0 ? notifier : notifier2;
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(
      provider.notifier,
      didChange: (_) => callCount++,
    );

    expect(sub.read(), notifier);
    expect(callCount, 0);

    notifier.count++;

    sub.flush();
    expect(callCount, 0);

    container.read(dep).state++;

    expect(sub.read(), notifier2);

    sub.flush();
    expect(sub.read(), notifier2);
    expect(callCount, 1);
  });

  test('family override', () {
    final provider = ChangeNotifierProvider.autoDispose
        .family<ValueNotifier<int>, int>((ref, value) {
      return ValueNotifier(value);
    });
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider((ref, value) => ValueNotifier(value * 2))
    ]);
    final listener1 = Listener<ValueNotifier<int>>();
    final listener2 = Listener<ValueNotifier<int>>();

    provider(0).watchOwner(container, listener1);
    provider(42).watchOwner(container, listener2);

    verify(listener1(argThat(
      isA<ValueNotifier<int>>().having((s) => s.value, 'value', 0),
    ))).called(1);
    verifyNoMoreInteractions(listener1);

    verify(listener2(argThat(
      isA<ValueNotifier<int>>().having((s) => s.value, 'value', 84),
    ))).called(1);
    verifyNoMoreInteractions(listener2);
  });

  test('can specify name', () {
    final provider = ChangeNotifierProvider.autoDispose(
      (_) => ValueNotifier(0),
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 =
        ChangeNotifierProvider.autoDispose((_) => ValueNotifier(0));

    expect(provider2.name, isNull);
  });

  testWidgets('listen to the notifier', (tester) async {
    final notifier = TestNotifier();
    final provider = ChangeNotifierProvider.autoDispose((_) => notifier);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(builder: (c, watch, _) {
          return Text(
            watch(provider).count.toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    notifier.count++;
    await tester.pump();

    expect(find.text('1'), findsOneWidget);

    await tester.pumpWidget(Container());

    expect(notifier.mounted, isFalse);
  });

  test(
      'overrideWithValue listens to the notifier, support notifier change, and does not dispose of the notifier',
      () async {
    final provider = ChangeNotifierProvider.autoDispose((_) => TestNotifier());
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final container = ProviderContainer(overrides: [
      provider.overrideWithValue(notifier),
    ]);
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(provider, didChange: (_) => callCount++);
    final notifierSub = container.listen(provider.notifier);

    expect(sub.read(), notifier);
    expect(callCount, 0);
    expect(notifierSub.read(), notifier);
    expect(notifier.hasListeners, true);

    notifier.count++;

    sub.flush();
    expect(callCount, 1);

    container.updateOverrides([
      provider.overrideWithValue(notifier2),
    ]);

    sub.flush();
    expect(callCount, 2);
    expect(notifier.hasListeners, false);
    expect(notifier2.hasListeners, true);
    expect(notifier.mounted, true);
    expect(notifierSub.read(), notifier2);

    notifier2.count++;

    sub.flush();
    expect(callCount, 3);

    container.dispose();

    expect(callCount, 3);
    expect(notifier2.hasListeners, false);
    expect(notifier2.mounted, true);
    expect(notifier.mounted, true);
  });

  test('overrideWithProvider preserves the state accross update', () {
    final provider = ChangeNotifierProvider.autoDispose((_) {
      return TestNotifier();
    });
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider(
        ChangeNotifierProvider.autoDispose((_) => notifier),
      ),
    ]);
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(provider, didChange: (_) => callCount++);

    expect(sub.read(), notifier);
    expect(container.read(provider.notifier), notifier);
    expect(notifier.hasListeners, true);
    expect(callCount, 0);

    notifier.count++;

    sub.flush();
    expect(callCount, 1);

    container.updateOverrides([
      provider.overrideWithProvider(
        ChangeNotifierProvider.autoDispose((_) => notifier2),
      ),
    ]);

    sub.flush();
    expect(callCount, 1);
    expect(container.read(provider.notifier), notifier);
    expect(notifier2.hasListeners, false);

    notifier.count++;

    sub.flush();
    expect(callCount, 2);
    expect(container.read(provider.notifier), notifier);
    expect(notifier.mounted, true);

    container.dispose();

    expect(callCount, 2);
    expect(notifier.mounted, false);
  });
}

class OnDisposeMock extends Mock {
  void call();
}

class Listener<T> extends Mock {
  void call(T? value);
}

class TestNotifier extends ChangeNotifier {
  bool mounted = true;

  @override
  // ignore: unnecessary_overrides
  bool get hasListeners => super.hasListeners;

  int _count = 0;
  int get count => _count;
  set count(int count) {
    _count = count;
    notifyListeners();
  }

  @override
  void dispose() {
    mounted = false;
    super.dispose();
  }
}
