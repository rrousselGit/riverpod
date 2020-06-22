import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('auto-dispose notifier when stop listening', () async {
    final owner = ProviderStateOwner();
    final onDispose = OnDisposeMock();
    final provider = AutoDisposeChangeNotifierProvider((ref) {
      ref.onDispose(onDispose);
      return ValueNotifier(0);
    });

    final removeListener = provider.watchOwner(owner, (value) {});

    removeListener();

    verifyNoMoreInteractions(onDispose);

    await Future<void>.value();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });
  test('family', () {
    final owner = ProviderStateOwner();
    final provider =
        AutoDisposeChangeNotifierProviderFamily<ValueNotifier<int>, int>(
            (ref, value) {
      return ValueNotifier(value);
    });
    final listener1 = Listener<ValueNotifier<int>>();
    final listener2 = Listener<ValueNotifier<int>>();

    provider(0).watchOwner(owner, listener1);
    provider(42).watchOwner(owner, listener2);

    verify(listener1(argThat(
      isA<ValueNotifier<int>>().having((s) => s.value, 'value', 0),
    ))).called(1);
    verifyNoMoreInteractions(listener1);

    verify(listener2(argThat(
      isA<ValueNotifier<int>>().having((s) => s.value, 'value', 42),
    ))).called(1);
    verifyNoMoreInteractions(listener2);
  });
  test('family override', () {
    final provider =
        AutoDisposeChangeNotifierProviderFamily<ValueNotifier<int>, int>(
            (ref, value) {
      return ValueNotifier(value);
    });
    final owner = ProviderStateOwner(overrides: [
      provider.overrideAs((ref, value) => ValueNotifier(value * 2))
    ]);
    final listener1 = Listener<ValueNotifier<int>>();
    final listener2 = Listener<ValueNotifier<int>>();

    provider(0).watchOwner(owner, listener1);
    provider(42).watchOwner(owner, listener2);

    verify(listener1(argThat(
      isA<ValueNotifier<int>>().having((s) => s.value, 'value', 0),
    ))).called(1);
    verifyNoMoreInteractions(listener1);

    verify(listener2(argThat(
      isA<ValueNotifier<int>>().having((s) => s.value, 'value', 84),
    ))).called(1);
    verifyNoMoreInteractions(listener2);
  });
  test('can be assigned to provider', () {
    // ignore: unused_local_variable
    final AutoDisposeProvider<ValueNotifier<int>> provider =
        AutoDisposeChangeNotifierProvider((_) {
      return ValueNotifier(0);
    });
  });
  test('can specify name', () {
    final provider = AutoDisposeChangeNotifierProvider(
      (_) => ValueNotifier(0),
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 =
        AutoDisposeChangeNotifierProvider((_) => ValueNotifier(0));

    expect(provider2.name, isNull);
  });

  testWidgets('listen to the notifier', (tester) async {
    final notifier = TestNotifier();
    final provider = AutoDisposeChangeNotifierProvider((_) => notifier);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((c, read) {
          return Text(
            read(provider).count.toString(),
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
}

class OnDisposeMock extends Mock {
  void call();
}

class Listener<T> extends Mock {
  void call(T value);
}

class TestNotifier extends ChangeNotifier {
  bool mounted = true;

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
