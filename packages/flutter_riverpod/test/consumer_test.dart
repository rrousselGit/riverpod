import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/src/internals.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:state_notifier/state_notifier.dart';

void main() {
  testWidgets(
      'Consumer removing one of multiple listeners on a provider still listen to the provider',
      (tester) async {
    final stateProvider = StateProvider((ref) => 0, name: 'state');
    final notifier0 = TestNotifier();
    final notifier1 = TestNotifier(42);
    final provider0 = StateNotifierProvider((_) => notifier0, name: '0');
    final provider1 = StateNotifierProvider((_) => notifier1, name: '1');
    var buildCount = 0;

    await tester.pumpWidget(ProviderScope(
      child: Consumer((c, watch) {
        buildCount++;
        final state = watch(stateProvider).state;
        final value =
            state == 0 ? watch(provider0.state) : watch(provider1.state);

        return Text(
          '${watch(provider0.state)} $value',
          textDirection: TextDirection.ltr,
        );
      }),
    ));
    final container = tester //
        .state<ProviderScopeState>(find.byType(ProviderScope))
        .container;

    container.read(provider0.state);
    container.read(provider1.state);
    final familyState0 = container.debugProviderStates.firstWhere((p) {
      return p.provider == provider0.state;
    });
    final familyState1 = container.debugProviderStates.firstWhere((p) {
      return p.provider == provider1.state;
    });

    expect(buildCount, 1);
    expect(familyState0.hasListeners, true);
    expect(familyState1.hasListeners, false);
    expect(find.text('0 0'), findsOneWidget);

    notifier0.increment();
    await tester.pump();

    expect(buildCount, 2);
    expect(find.text('1 1'), findsOneWidget);

    notifier1.increment();
    await tester.pump();

    expect(buildCount, 2);

    // changing the provider that computed is subscribed to
    container.read(stateProvider).state = 1;
    await tester.pump();

    expect(buildCount, 3);
    expect(find.text('1 43'), findsOneWidget);
    expect(familyState1.hasListeners, true);
    expect(familyState0.hasListeners, true);

    notifier1.increment();
    await tester.pump();

    expect(buildCount, 4);
    expect(find.text('1 44'), findsOneWidget);

    notifier0.increment();
    await tester.pump();

    expect(buildCount, 5);
    expect(find.text('2 44'), findsOneWidget);
  });

  testWidgets(
      'Stops listening to a provider when recomputed but no longer using it',
      (tester) async {
    final stateProvider = StateProvider((ref) => 0, name: 'state');
    final notifier0 = TestNotifier();
    final notifier1 = TestNotifier(42);
    final provider0 = StateNotifierProvider((_) => notifier0, name: '0');
    final provider1 = StateNotifierProvider((_) => notifier1, name: '1');
    var buildCount = 0;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((c, watch) {
          buildCount++;
          final state = watch(stateProvider).state;
          final result = state == 0 //
              ? watch(provider0.state)
              : watch(provider1.state);
          return Text('$result', textDirection: TextDirection.ltr);
        }),
      ),
    );
    final container = tester //
        .state<ProviderScopeState>(find.byType(ProviderScope))
        .container;

    container.read(provider0.state);
    container.read(provider1.state);
    final familyState0 = container.debugProviderStates.firstWhere((p) {
      return p.provider == provider0.state;
    });
    final familyState1 = container.debugProviderStates.firstWhere((p) {
      return p.provider == provider1.state;
    });

    expect(buildCount, 1);
    expect(familyState0.hasListeners, true);
    expect(familyState1.hasListeners, false);
    expect(find.text('0'), findsOneWidget);

    notifier0.increment();
    await tester.pump();

    expect(buildCount, 2);
    expect(find.text('1'), findsOneWidget);

    notifier1.increment();
    await tester.pump();

    expect(buildCount, 2);

    // changing the provider that computed is subscribed to
    container.read(stateProvider).state = 1;
    await tester.pump();

    expect(buildCount, 3);
    expect(find.text('43'), findsOneWidget);
    expect(familyState1.hasListeners, true);
    expect(familyState0.hasListeners, false);

    notifier1.increment();
    await tester.pump();

    expect(buildCount, 4);
    expect(find.text('44'), findsOneWidget);

    notifier0.increment();
    await tester.pump();

    expect(buildCount, 4);
  });

  testWidgets('Consumer supports changing the provider', (tester) async {
    final notifier1 = TestNotifier();
    final provider1 = StateNotifierProvider((_) => notifier1);
    final notifier2 = TestNotifier(42);
    final provider2 = StateNotifierProvider((_) => notifier2);
    var buildCount = 0;

    Widget build(StateNotifierProvider<TestNotifier> provider) {
      return ProviderScope(
        child: Consumer((c, watch) {
          buildCount++;
          final value = watch(provider.state);
          return Text('$value', textDirection: TextDirection.ltr);
        }),
      );
    }

    await tester.pumpWidget(build(provider1));

    expect(find.text('0'), findsOneWidget);
    expect(buildCount, 1);

    await tester.pumpWidget(build(provider2));

    expect(find.text('42'), findsOneWidget);
    expect(buildCount, 2);

    notifier1.increment();
    await tester.pump();

    expect(find.text('42'), findsOneWidget);
    expect(buildCount, 2);

    notifier2.increment();
    await tester.pump();

    expect(find.text('43'), findsOneWidget);
    expect(buildCount, 3);
  });

  testWidgets(
      'mutliple watch, when one of them forces rebuild, all dependencies are still flushed',
      (tester) async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider((_) => notifier);
    var callCount = 0;
    final computed = Provider((ref) {
      callCount++;
      return ref.watch(provider.state);
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((context, watch) {
          final first = watch(provider.state);
          final second = watch(computed);
          return Text(
            '$first $second',
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('0 0'), findsOneWidget);
    expect(callCount, 1);

    notifier.increment();
    await tester.pump();

    expect(find.text('1 1'), findsOneWidget);
    expect(callCount, 2);
  });

  testWidgets("don't rebuild if Provider ref't actually change",
      (tester) async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider((_) => notifier);
    final computed = Provider((ref) => !ref.watch(provider.state).isNegative);
    var buildCount = 0;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((c, watch) {
          buildCount++;
          return Text(
            'isPositive ${watch(computed)}',
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('isPositive true'), findsOneWidget);
    expect(buildCount, 1);

    notifier.increment();
    await tester.pump();

    expect(find.text('isPositive true'), findsOneWidget);
    expect(buildCount, 1);

    notifier.value = -10;
    await tester.pump();

    expect(find.text('isPositive false'), findsOneWidget);
    expect(buildCount, 2);

    notifier.value = -5;
    await tester.pump();

    expect(find.text('isPositive false'), findsOneWidget);
    expect(buildCount, 2);
  });

  testWidgets('remove listener when changing container', (tester) async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider((_) => notifier, name: 'provider');
    final notifier2 = TestNotifier(42);
    final override = StateNotifierProvider((_) => notifier2, name: 'override');
    const firstOwnerKey = Key('first');
    const secondOwnerKey = Key('second');
    final key = GlobalKey();

    final consumer = Consumer((context, watch) {
      final value = watch(provider.state);
      return Text('$value', textDirection: TextDirection.ltr);
    }, key: key);

    await tester.pumpWidget(
      Column(
        children: [
          ProviderScope(
            key: firstOwnerKey,
            child: consumer,
          ),
          ProviderScope(
            key: secondOwnerKey,
            overrides: [
              provider.overrideWithProvider(override),
            ],
            child: Container(),
          ),
        ],
      ),
    );

    final owner1 = tester //
        .firstState<ProviderScopeState>(find.byKey(firstOwnerKey))
        .container;

    final state1 = owner1.debugProviderStates
        .firstWhere((s) => s.provider == provider.state);

    expect(state1.hasListeners, true);
    expect(find.text('0'), findsOneWidget);

    await tester.pumpWidget(
      Column(
        children: [
          ProviderScope(
            key: firstOwnerKey,
            child: Container(),
          ),
          ProviderScope(
            key: secondOwnerKey,
            overrides: [
              provider.overrideWithProvider(override),
            ],
            child: consumer,
          ),
        ],
      ),
    );

    final container2 = tester //
        .firstState<ProviderScopeState>(find.byKey(secondOwnerKey))
        .container;

    final state2 = container2.debugProviderStates
        .firstWhere((s) => s.provider is StateNotifierStateProvider);

    expect(find.text('0'), findsNothing);
    expect(find.text('42'), findsOneWidget);
    expect(state1.hasListeners, false);
    expect(state2.hasListeners, true);

    notifier2.increment();
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('43'), findsOneWidget);
    expect(state1.hasListeners, false);
    expect(state2.hasListeners, true);
  });

  testWidgets('remove listener when destroying the consumer', (tester) async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider((_) => notifier);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((context, watch) {
          final value = watch(provider.state);
          return Text('$value', textDirection: TextDirection.ltr);
        }),
      ),
    );

    final container = tester //
        .firstState<ProviderScopeState>(find.byType(ProviderScope))
        .container;

    final state = container.debugProviderStates
        .firstWhere((s) => s.provider == provider.state);

    expect(state.hasListeners, true);
    expect(find.text('0'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        child: Container(),
      ),
    );

    expect(state.hasListeners, false);
  });

  testWidgets('Multiple providers', (tester) async {
    final notifier = TestNotifier();
    final firstProvider = StateNotifierProvider((_) => notifier);
    final notifier2 = TestNotifier();
    final secondProvider = StateNotifierProvider((_) => notifier2);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((context, watch) {
          final first = watch(firstProvider.state);
          final second = watch(secondProvider.state);
          return Text(
            'first $first second $second',
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('first 0 second 0'), findsOneWidget);

    notifier.increment();
    await tester.pump();

    expect(find.text('first 1 second 0'), findsOneWidget);

    notifier2.increment();
    notifier2.increment();
    await tester.pump();

    expect(find.text('first 1 second 2'), findsOneWidget);
  });

  testWidgets('Consumer', (tester) async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider((_) => notifier);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((context, watch) {
          final count = watch(provider.state);
          return Text('$count', textDirection: TextDirection.ltr);
        }),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    notifier.increment();
    await tester.pump();

    expect(find.text('1'), findsOneWidget);

    await tester.pumpWidget(ProviderScope(child: Container()));

    notifier.increment();
    await tester.pump();
  });

  testWidgets('changing provider', (tester) async {
    final provider = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((context, watch) {
          final value = watch(provider);
          return Text(
            '$value',
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    final provider2 = Provider((_) => 42);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((context, watch) {
          final value = watch(provider2);
          return Text(
            '$value',
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('0'), findsNothing);
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('can read scoped providers', (tester) async {
    final provider = ScopedProvider((_) => 0);

    final child = Consumer((context, watch) {
      final value = watch(provider);
      return Text(
        '$value',
        textDirection: TextDirection.ltr,
      );
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideWithValue(42),
        ],
        child: child,
      ),
    );

    expect(find.text('42'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideWithValue(21),
        ],
        child: child,
      ),
    );

    expect(find.text('21'), findsOneWidget);
  });
}

class TestNotifier extends StateNotifier<int> {
  TestNotifier([int initialValue = 0]) : super(initialValue);

  void increment() => state++;

  // ignore: avoid_setters_without_getters
  set value(int value) => state = value;
}

class Listener<T> extends Mock {
  void call(T value);
}
