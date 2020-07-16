import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    ProviderReference providerState;
    bool mountedOnDispose;
    final provider = Provider<int>((ref) {
      providerState = ref;
      ref.onDispose(() => mountedOnDispose = ref.mounted);
      return 42;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((c, watch) {
          return Text(
            watch(provider).toString(),
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
        child: Consumer((c, watch) {
          return Text(
            watch(provider).toString(),
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
        child: Consumer((c, watch) {
          return Text(
            watch(provider).toString(),
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
        child: Consumer((c, watch) {
          return Text(
            watch(provider).toString(),
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
    final child = Consumer((c, watch) {
      return Text(
        watch(provider).toString(),
        textDirection: TextDirection.ltr,
      );
    });

    var callCount = 0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideAs(
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
          provider.overrideAs(
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
  testWidgets('provider1 as override of normal provider', (tester) async {
    final provider = Provider((_) => 42);
    final provider2 = Provider((_) => 42);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider2.overrideAs(
            Provider<int>((ref) {
              final other = ref.dependOn(provider);
              return other.value * 2;
            }),
          ),
        ],
        child: Consumer((c, watch) {
          return Text(
            watch(provider2).toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('84'), findsOneWidget);
  });

  testWidgets('provider1 uses override if the override is at root',
      (tester) async {
    final provider = Provider((_) => 0);

    final provider1 = Provider((ref) {
      final other = ref.dependOn(provider);
      return other.value.toString();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideAs(Provider((_) => 1)),
        ],
        child: Consumer((c, watch) {
          return Text(watch(provider1), textDirection: TextDirection.ltr);
        }),
      ),
    );

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
  testWidgets('provider1 chain', (tester) async {
    final first = Provider((_) => 1);
    final second = Provider<int>((ref) {
      final other = ref.dependOn(first);
      return other.value + 1;
    });
    final third = Provider<int>((ref) {
      final other = ref.dependOn(second);
      return other.value + 1;
    });
    final forth = Provider<int>((ref) {
      final other = ref.dependOn(third);
      return other.value + 1;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((c, watch) {
          return Text(
            watch(forth).toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('4'), findsOneWidget);
  });
  testWidgets('overriden provider1 chain', (tester) async {
    final first = Provider((_) => 1);
    final second = Provider<int>((ref) {
      final other = ref.dependOn(first);
      return other.value + 1;
    });
    final third = Provider<int>((ref) {
      final other = ref.dependOn(second);
      return other.value + 1;
    });
    final forth = Provider<int>((ref) {
      final other = ref.dependOn(third);
      return other.value + 1;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          first.overrideAs(Provider((_) => 42)),
        ],
        child: Consumer((c, watch) {
          return Text(
            watch(forth).toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('45'), findsOneWidget);
  });
  testWidgets('partial override provider1 chain', (tester) async {
    final first = Provider((_) => 1);
    final second = Provider<int>((ref) {
      final other = ref.dependOn(first);
      return other.value + 1;
    });
    final third = Provider<int>((ref) {
      final other = ref.dependOn(second);
      return other.value + 1;
    });
    final forth = Provider<int>((ref) {
      final other = ref.dependOn(third);
      return other.value + 1;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          second.overrideAs(Provider((_) => 0)),
        ],
        child: Consumer((c, watch) {
          return Text(
            watch(forth).toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('2'), findsOneWidget);
  });
  testWidgets('ProviderBuilder1', (tester) async {
    final provider = Provider((_) => 42);

    // These check the type safety
    ProviderReference ref;
    ProviderDependency<int> firstState;

    // ignore: omit_local_variable_types
    final Provider<int> provider1 = Provider<int>((r) {
      final first = r.dependOn(provider);
      ref = r;
      firstState = first;
      return first.value * 2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((c, watch) {
          return Text(
            watch(provider1).toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(ref, isNotNull);
    expect(firstState, isNotNull);
    expect(find.text('84'), findsOneWidget);
  });
}

class OnDisposeMock extends Mock {
  void call();
}
