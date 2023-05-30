import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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

    Consumer(
      builder: (context, ref, _) {
        // ignore: omit_local_variable_types, unused_local_variable, prefer_final_locals
        int providerValue = ref.read(provider);
        // ignore: omit_local_variable_types, unused_local_variable, prefer_final_locals
        AsyncValue<int> futureProviderValue = ref.read(futureProvider);
        // ignore: omit_local_variable_types, unused_local_variable, prefer_final_locals
        AsyncValue<int> streamProviderValue = ref.read(streamProvider);
        // ignore: omit_local_variable_types, unused_local_variable, prefer_final_locals
        ValueNotifier<int> changeNotifierProviderValue =
            ref.read(changeNotifierProvider);

        return Container();
      },
    );
  });

  testWidgets('no onDispose does not crash', (tester) async {
    final provider = Provider<int>((ref) => 42);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (c, ref, _) {
            return Text(
              ref.watch(provider).toString(),
              textDirection: TextDirection.ltr,
            );
          },
        ),
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
      ref
        ..onDispose(dispose1.call)
        ..onDispose(dispose2.call)
        ..onDispose(dispose3.call);
      return 42;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (c, ref, _) {
            return Text(
              ref.watch(provider).toString(),
              textDirection: TextDirection.ltr,
            );
          },
        ),
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
      callCount++;
      return 42;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (c, ref, _) {
            return Text(
              ref.watch(provider).toString(),
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(callCount, 1);
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('override updates preserve state', (tester) async {
    var callCount = 0;
    final dep = Provider((ref) => 0);
    final provider = Provider((ref) {
      callCount++;
      return ref.watch(dep);
    });
    final child = Consumer(
      builder: (c, ref, _) {
        return Text(
          ref.watch(provider).toString(),
          textDirection: TextDirection.ltr,
        );
      },
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dep.overrideWithValue(42),
          provider,
        ],
        child: child,
      ),
    );

    expect(callCount, 1);
    expect(find.text('42'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dep.overrideWithValue(42),
          provider,
        ],
        child: child,
      ),
    );

    expect(callCount, 1);
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('provider1 uses override if the override is at root',
      (tester) async {
    final provider = Provider((_) => 0);

    final provider1 = Provider((ref) {
      return ref.watch(provider).toString();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideWithValue(1),
        ],
        child: Consumer(
          builder: (c, ref, _) {
            return Text(ref.watch(provider1), textDirection: TextDirection.ltr);
          },
        ),
      ),
    );

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('provider1 chain', (tester) async {
    final first = Provider((_) => 1);
    final second = Provider<int>((ref) {
      return ref.watch(first) + 1;
    });
    final third = Provider<int>((ref) {
      return ref.watch(second) + 1;
    });
    final fourth = Provider<int>((ref) {
      return ref.watch(third) + 1;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (c, ref, _) {
            return Text(
              ref.watch(fourth).toString(),
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('overridden provider1 chain', (tester) async {
    final first = Provider((_) => 1);
    final second = Provider<int>((ref) {
      return ref.watch(first) + 1;
    });
    final third = Provider<int>((ref) {
      return ref.watch(second) + 1;
    });
    final fourth = Provider<int>((ref) {
      return ref.watch(third) + 1;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          first.overrideWithValue(42),
        ],
        child: Consumer(
          builder: (c, ref, _) {
            return Text(
              ref.watch(fourth).toString(),
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('45'), findsOneWidget);
  });

  testWidgets('partial override provider1 chain', (tester) async {
    final first = Provider((_) => 1);
    final second = Provider<int>((ref) {
      return ref.watch(first) + 1;
    });
    final third = Provider<int>((ref) {
      return ref.watch(second) + 1;
    });
    final fourth = Provider<int>((ref) {
      return ref.watch(third) + 1;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          second.overrideWithValue(0),
        ],
        child: Consumer(
          builder: (c, ref, _) {
            return Text(
              ref.watch(fourth).toString(),
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('ProviderBuilder1', (tester) async {
    final provider = Provider((_) => 42);

    // These check the type safety
    Ref? ref;

    // ignore: omit_local_variable_types
    final Provider<int> provider1 = Provider<int>((r) {
      final first = r.watch(provider);
      ref = r;
      return first * 2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (c, ref, _) {
            return Text(
              ref.watch(provider1).toString(),
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(ref, isNotNull);
    expect(find.text('84'), findsOneWidget);
  });
}

class OnDisposeMock extends Mock {
  void call();
}
