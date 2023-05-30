import 'package:flutter/widgets.dart' hide Listener;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'utils.dart';

void main() {
  test('auto-dispose notifier when stop listening', () async {
    final container = createContainer();
    final onDispose = OnDisposeMock();
    final provider = ChangeNotifierProvider.autoDispose((ref) {
      ref.onDispose(onDispose.call);
      return ValueNotifier(0);
    });

    final sub = container.listen<ValueNotifier<int>>(
      provider,
      (prev, value) {},
    );

    sub.close();

    verifyNoMoreInteractions(onDispose);

    await container.pump();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });

  test('family', () {
    final container = createContainer();
    final provider = ChangeNotifierProvider.autoDispose
        .family<ValueNotifier<int>, int>((ref, value) {
      return ValueNotifier(value);
    });
    final listener1 = Listener<ValueNotifier<int>>();
    final listener2 = Listener<ValueNotifier<int>>();

    container.listen(provider(0), listener1.call, fireImmediately: true);
    container.listen(provider(42), listener2.call, fireImmediately: true);

    verifyOnly(
      listener1,
      listener1(
        argThat(isNull),
        argThat(
          isA<ValueNotifier<int>>().having((s) => s.value, 'value', 0),
        ),
      ),
    );

    verifyOnly(
      listener2,
      listener2(
        argThat(isNull),
        argThat(
          isA<ValueNotifier<int>>().having((s) => s.value, 'value', 42),
        ),
      ),
    );
  });

  test('.notifier obtains the controller without listening to it', () async {
    final dep = StateProvider((ref) => 0);
    final notifier = TestNotifier();
    final notifier2 = TestNotifier();
    final provider = ChangeNotifierProvider.autoDispose((ref) {
      return ref.watch(dep) == 0 ? notifier : notifier2;
    });
    final container = createContainer();
    addTearDown(container.dispose);

    var callCount = 0;
    final sub = container.listen(
      provider.notifier,
      (_, __) => callCount++,
    );

    expect(sub.read(), notifier);
    expect(callCount, 0);

    notifier.count++;

    await container.pump();
    expect(callCount, 0);

    container.read(dep.notifier).state++;

    expect(sub.read(), notifier2);

    await container.pump();
    expect(sub.read(), notifier2);
    expect(callCount, 1);
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
        child: Consumer(
          builder: (c, ref, _) {
            return Text(
              ref.watch(provider).count.toString(),
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    notifier.count++;
    await tester.pump();

    expect(find.text('1'), findsOneWidget);

    await tester.pumpWidget(Container());

    expect(notifier.mounted, isFalse);
  });

  // test(
  //     'overrideWithValue listens to the notifier, support notifier change, and does not dispose of the notifier',
  //     () async {
  //   final provider = ChangeNotifierProvider.autoDispose((_) => TestNotifier());
  //   final notifier = TestNotifier();
  //   final notifier2 = TestNotifier();
  //   final container = ProviderContainer(overrides: [
  //     provider.overrideWithValue(notifier),
  //   ]);
  //   addTearDown(container.dispose);

  //   var callCount = 0;
  //   final sub = container.listen(provider, (_, __) => callCount++);
  //   final notifierSub = container.listen(provider.notifier, (_, __) {});

  //   expect(sub.read(), notifier);
  //   expect(callCount, 0);
  //   expect(notifierSub.read(), notifier);
  //   expect(notifier.hasListeners, true);

  //   notifier.count++;

  //   await container.pump();
  //   expect(callCount, 1);

  //   container.updateOverrides([
  //     provider.overrideWithValue(notifier2),
  //   ]);

  //   await container.pump();
  //   expect(callCount, 2);
  //   expect(notifier.hasListeners, false);
  //   expect(notifier2.hasListeners, true);
  //   expect(notifier.mounted, true);
  //   expect(notifierSub.read(), notifier2);

  //   notifier2.count++;

  //   await container.pump();
  //   expect(callCount, 3);

  //   container.dispose();

  //   expect(callCount, 3);
  //   expect(notifier2.hasListeners, false);
  //   expect(notifier2.mounted, true);
  //   expect(notifier.mounted, true);
  // });
}

class OnDisposeMock extends Mock {
  void call();
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
