import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mockito/mockito.dart';
import 'package:hooks_river_pod/hooks_river_pod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('.read(context)', (tester) async {
    final futureProvider = FutureProvider((_) async => 42);
    final streamProvider = StreamProvider((_) async* {
      yield 42;
    });
    final provider = Provider((_) => 42);
    final changeNotifierProvider = ChangeNotifierProvider((_) {
      return ValueNotifier(0);
    });

    Builder(builder: (context) {
      // ignore: omit_local_variable_types, unused_local_variable, prefer_final_locals
      int providerValue = provider.read(context);
      // ignore: omit_local_variable_types, unused_local_variable, prefer_final_locals
      AsyncValue<int> futureProviderValue = futureProvider.read(context);
      // ignore: omit_local_variable_types, unused_local_variable, prefer_final_locals
      AsyncValue<int> streamProviderValue = streamProvider.read(context);
      // ignore: omit_local_variable_types, unused_local_variable, prefer_final_locals
      ValueNotifier<int> changeNotifierProviderValue =
          changeNotifierProvider.read(context);

      return Container();
    });
  });
  testWidgets('mounted', (tester) async {
    ProviderState providerState;
    bool mountedOnDispose;
    final useProvider = Provider<int>((state) {
      providerState = state;
      state.onDispose(() => mountedOnDispose = state.mounted);
      return 42;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          return Text(
            useProvider().toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('42'), findsOneWidget);
    expect(providerState.mounted, isTrue);

    await tester.pumpWidget(Container());

    expect(mountedOnDispose, isTrue);
    expect(providerState.mounted, isFalse);
  });

  testWidgets('no onDispose does not crash', (tester) async {
    final useProvider = Provider<int>((state) => 42);

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          return Text(
            useProvider().toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('42'), findsOneWidget);

    await tester.pumpWidget(Container());
  });
  testWidgets('onDispose can read state', (tester) async {
    // int onDisposeState;
    // final useProvider = Provider<int>((state) {
    //   state.onDispose(() => onDisposeState = state.value);
    //   return 42;
    // });

    // await tester.pumpWidget(
    //   ProviderScope(
    //     child: HookBuilder(builder: (c) {
    //       return Text(
    //         useProvider().toString(),
    //         textDirection: TextDirection.ltr,
    //       );
    //     }),
    //   ),
    // );

    // expect(find.text('42'), findsOneWidget);

    // await tester.pumpWidget(Container());

    // expect(onDisposeState, 42);
  }, skip: true);
  testWidgets("can't read state after dispose", (tester) async {
    // ProviderState<int> providerState;
    // final useProvider = Provider<int>((state) {
    //   providerState = state;
    //   return 42;
    // });

    // await tester.pumpWidget(
    //   ProviderScope(
    //     child: HookBuilder(builder: (c) {
    //       return Text(
    //         useProvider().toString(),
    //         textDirection: TextDirection.ltr,
    //       );
    //     }),
    //   ),
    // );

    // expect(find.text('42'), findsOneWidget);

    // await tester.pumpWidget(Container());

    // expect(() => providerState.value, throwsStateError);
  }, skip: true);
  testWidgets('onDispose calls all callbacks in order', (tester) async {
    final dispose1 = OnDisposeMock();

    final dispose2 = OnDisposeMock();
    final error2 = Error();
    when(dispose2()).thenThrow(error2);

    final dispose3 = OnDisposeMock();

    final useProvider = Provider<int>((state) {
      state..onDispose(dispose1)..onDispose(dispose2)..onDispose(dispose3);
      return 42;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          return Text(
            useProvider().toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('42'), findsOneWidget);
    verifyZeroInteractions(dispose1);
    verifyZeroInteractions(dispose2);
    verifyZeroInteractions(dispose3);

    await tester.pumpWidget(Container());

    verifyInOrder([
      dispose1(),
      dispose2(),
      dispose3(),
    ]);
    verifyNoMoreInteractions(dispose1);
    verifyNoMoreInteractions(dispose2);
    verifyNoMoreInteractions(dispose3);

    expect(tester.takeException(), error2);
  });

  testWidgets('expose value as is', (tester) async {
    var callCount = 0;
    final useProvider = Provider((state) {
      assert(state != null, '');
      callCount++;
      return 42;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          return Text(
            useProvider().toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(callCount, 1);
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('override updates rebuild dependents with new value',
      (tester) async {
    final useProvider = Provider((_) => 0);
    final child = HookBuilder(builder: (c) {
      return Text(
        useProvider().toString(),
        textDirection: TextDirection.ltr,
      );
    });

    var callCount = 0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(
            Provider((state) {
              assert(state != null, '');
              callCount++;
              return 42;
            }),
          ),
        ],
        child: child,
      ),
    );

    expect(callCount, 1);
    expect(find.text('42'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(
            Provider((state) {
              assert(state != null, '');
              callCount++;
              throw Error();
            }),
          ),
        ],
        child: child,
      ),
    );

    expect(callCount, 1);
    expect(find.text('42'), findsOneWidget);
  });
}

class OnDisposeMock extends Mock {
  void call();
}
