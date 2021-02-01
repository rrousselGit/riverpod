import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mockito/mockito.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
      int providerValue = context.read(provider);
      // ignore: omit_local_variable_types, unused_local_variable, prefer_final_locals
      AsyncValue<int> futureProviderValue = context.read(futureProvider);
      // ignore: omit_local_variable_types, unused_local_variable, prefer_final_locals
      AsyncValue<int> streamProviderValue = context.read(streamProvider);
      // ignore: omit_local_variable_types, unused_local_variable, prefer_final_locals
      ValueNotifier<int> changeNotifierProviderValue =
          context.read(changeNotifierProvider);

      return Container();
    });
  });

  testWidgets('mounted', (tester) async {
    ProviderReference providerState;
    bool mountedOnDispose;
    final provider = Provider<int>((ref) {
      providerState = ref;
      ref.onDispose(() => mountedOnDispose = ref.mounted);
      return 42;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          return Text(
            useProvider(provider).toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('42'), findsOneWidget);
    expect(providerState.mounted, isTrue);

    await tester.pumpWidget(Container());

    expect(mountedOnDispose, isFalse);
    expect(providerState.mounted, isFalse);
  });

  testWidgets('no onDispose does not crash', (tester) async {
    final provider = Provider<int>((ref) => 42);

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          return Text(
            useProvider(provider).toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('42'), findsOneWidget);

    await tester.pumpWidget(Container());
  });

  testWidgets('onDispose calls all callbacks in order', (tester) async {
    final dispose1 = OnDisposeMock();

    final dispose2 = OnDisposeMock();
    final error2 = Error();
    when(dispose2()).thenThrow(error2);

    final dispose3 = OnDisposeMock();

    final provider = Provider<int>((ref) {
      ref..onDispose(dispose1)..onDispose(dispose2)..onDispose(dispose3);
      return 42;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          return Text(
            useProvider(provider).toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('42'), findsOneWidget);
    verifyZeroInteractions(dispose1);
    verifyZeroInteractions(dispose2);
    verifyZeroInteractions(dispose3);

    final errors = <Object>[];
    await runZonedGuarded(
      () => tester.pumpWidget(Container()),
      (err, _) => errors.add(err),
    );

    verifyInOrder([
      dispose1(),
      dispose2(),
      dispose3(),
    ]);
    verifyNoMoreInteractions(dispose1);
    verifyNoMoreInteractions(dispose2);
    verifyNoMoreInteractions(dispose3);

    expect(errors, [error2]);
  });

  testWidgets('expose value as is', (tester) async {
    var callCount = 0;
    final provider = Provider((ref) {
      assert(ref != null, '');
      callCount++;
      return 42;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          return Text(
            useProvider(provider).toString(),
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
    final provider = Provider((_) => 0);
    final child = HookBuilder(builder: (c) {
      return Text(
        useProvider(provider).toString(),
        textDirection: TextDirection.ltr,
      );
    });

    var callCount = 0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideWithProvider(
            Provider((ref) {
              assert(ref != null, '');
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
          provider.overrideWithProvider(
            Provider((ref) {
              assert(ref != null, '');
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
