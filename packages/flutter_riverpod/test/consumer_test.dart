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
      child: Consumer((c, read) {
        buildCount++;
        final state = read(stateProvider).state;
        final value =
            state == 0 ? read(provider0.state) : read(provider1.state);

        return Text(
          '${read(provider0.state)} $value',
          textDirection: TextDirection.ltr,
        );
      }),
    ));
    final owner = tester //
        .state<ProviderScopeState>(find.byType(ProviderScope))
        .owner;

    provider0.state.readOwner(owner);
    provider1.state.readOwner(owner);
    final familyState0 = owner.debugProviderStates.firstWhere((p) {
      return p.provider == provider0.state;
    });
    final familyState1 = owner.debugProviderStates.firstWhere((p) {
      return p.provider == provider1.state;
    });

    expect(buildCount, 1);
    expect(familyState0.$hasListeners, true);
    expect(familyState1.$hasListeners, false);
    expect(find.text('0 0'), findsOneWidget);

    notifier0.increment();
    await tester.pump();

    expect(buildCount, 2);
    expect(find.text('1 1'), findsOneWidget);

    notifier1.increment();
    await tester.pump();

    expect(buildCount, 2);

    // changing the provider that computed is subscribed to
    stateProvider.readOwner(owner).state = 1;
    await tester.pump();

    expect(buildCount, 3);
    expect(find.text('1 43'), findsOneWidget);
    expect(familyState1.$hasListeners, true);
    expect(familyState0.$hasListeners, true);

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
        child: Consumer((c, read) {
          buildCount++;
          final state = read(stateProvider).state;
          final result = state == 0 //
              ? read(provider0.state)
              : read(provider1.state);
          return Text('$result', textDirection: TextDirection.ltr);
        }),
      ),
    );
    final owner = tester //
        .state<ProviderScopeState>(find.byType(ProviderScope))
        .owner;

    provider0.state.readOwner(owner);
    provider1.state.readOwner(owner);
    final familyState0 = owner.debugProviderStates.firstWhere((p) {
      return p.provider == provider0.state;
    });
    final familyState1 = owner.debugProviderStates.firstWhere((p) {
      return p.provider == provider1.state;
    });

    expect(buildCount, 1);
    expect(familyState0.$hasListeners, true);
    expect(familyState1.$hasListeners, false);
    expect(find.text('0'), findsOneWidget);

    notifier0.increment();
    await tester.pump();

    expect(buildCount, 2);
    expect(find.text('1'), findsOneWidget);

    notifier1.increment();
    await tester.pump();

    expect(buildCount, 2);

    // changing the provider that computed is subscribed to
    stateProvider.readOwner(owner).state = 1;
    await tester.pump();

    expect(buildCount, 3);
    expect(find.text('43'), findsOneWidget);
    expect(familyState1.$hasListeners, true);
    expect(familyState0.$hasListeners, false);

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
        child: Consumer((c, read) {
          buildCount++;
          final value = read(provider.state);
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
      'mutliple useProviders/read, when one of them forces rebuild, all dependencies are still flushed',
      (tester) async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider((_) => notifier);
    var callCount = 0;
    final computed = Computed((read) {
      callCount++;
      return read(provider.state);
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((context, read) {
          final first = read(provider.state);
          final second = read(computed);
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
  testWidgets("don't rebuild if Computed didn't actually change",
      (tester) async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider((_) => notifier);
    final computed = Computed((read) => !read(provider.state).isNegative);
    var buildCount = 0;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((c, read) {
          buildCount++;
          return Text(
            'isPositive ${read(computed)}',
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

  testWidgets('remove listener when changing owner', (tester) async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider((_) => notifier, name: 'provider');
    final notifier2 = TestNotifier(42);
    final override = StateNotifierProvider((_) => notifier2, name: 'override');
    const firstOwnerKey = Key('first');
    const secondOwnerKey = Key('second');
    final key = GlobalKey();

    final consumer = Consumer((context, read) {
      final value = read(provider.state);
      return Text('$value', textDirection: TextDirection.ltr);
    }, key: key);

    await tester.pumpWidget(
      ProviderScope(
        key: firstOwnerKey,
        child: consumer,
      ),
    );

    final owner1 = tester //
        .firstState<ProviderScopeState>(find.byKey(firstOwnerKey))
        .owner;

    final state1 = owner1.debugProviderStates
        .firstWhere((s) => s.provider == provider.state);

    expect(state1.$hasListeners, true);
    expect(find.text('0'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        key: firstOwnerKey,
        child: ProviderScope(
          key: secondOwnerKey,
          overrides: [
            provider.overrideAs(override),
          ],
          child: consumer,
        ),
      ),
    );

    final owner2 = tester //
        .firstState<ProviderScopeState>(find.byKey(secondOwnerKey))
        .owner;

    final state2 = owner2.debugProviderStates
        .firstWhere((s) => s.provider is StateNotifierStateProvider);

    expect(find.text('0'), findsNothing);
    expect(find.text('42'), findsOneWidget);
    expect(state1.$hasListeners, false);
    expect(state2.$hasListeners, true);

    notifier2.increment();
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('43'), findsOneWidget);
    expect(state1.$hasListeners, false);
    expect(state2.$hasListeners, true);
  });
  testWidgets('remove listener when destroying the consumer', (tester) async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider((_) => notifier);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((context, read) {
          final value = read(provider.state);
          return Text('$value', textDirection: TextDirection.ltr);
        }),
      ),
    );

    final owner = tester //
        .firstState<ProviderScopeState>(find.byType(ProviderScope))
        .owner;

    final state = owner.debugProviderStates
        .firstWhere((s) => s.provider == provider.state);

    expect(state.$hasListeners, true);
    expect(find.text('0'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        child: Container(),
      ),
    );

    expect(state.$hasListeners, false);
  });

  testWidgets('Multiple providers', (tester) async {
    final notifier = TestNotifier();
    final firstProvider = StateNotifierProvider((_) => notifier);
    final notifier2 = TestNotifier();
    final secondProvider = StateNotifierProvider((_) => notifier2);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((context, read) {
          final first = read(firstProvider.state);
          final second = read(secondProvider.state);
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
        child: Consumer((context, read) {
          final count = read(provider.state);
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
  testWidgets('relocating consumer with GlobalKey', (tester) async {
    final notifier = TestNotifier();
    final notifier2 = TestNotifier(42);

    final provider = StateNotifierProvider((_) => notifier);
    final override = provider.overrideAs(
      StateNotifierProvider((_) => notifier2),
    );

    var buildCount = 0;
    final consumer = Consumer((context, read) {
      buildCount++;
      final count = read(provider.state);
      return Text('$count', textDirection: TextDirection.ltr);
    }, key: GlobalKey());

    await tester.pumpWidget(
      ProviderScope(
        child: Column(
          textDirection: TextDirection.ltr,
          children: <Widget>[
            ProviderScope(
              overrides: [override],
              child: consumer,
            ),
          ],
        ),
      ),
    );

    expect(find.text('42'), findsOneWidget);
    expect(buildCount, 1);

    notifier2.increment();
    await tester.pump();

    expect(find.text('43'), findsOneWidget);
    expect(buildCount, 2);

    // move the consumer without disposing the currently listener notifier
    await tester.pumpWidget(
      ProviderScope(
        child: Column(
          textDirection: TextDirection.ltr,
          children: <Widget>[
            ProviderScope(
              overrides: [override],
              child: Container(),
            ),
            consumer,
          ],
        ),
      ),
    );

    expect(buildCount, 3);
    expect(find.text('42'), findsNothing);
    expect(find.text('0'), findsOneWidget);

    // does nothing because listener was removed
    notifier2.increment();
    await tester.pump();

    expect(buildCount, 3);

    notifier.increment();
    await tester.pump();

    expect(buildCount, 4);
    expect(find.text('1'), findsOneWidget);
  });
  testWidgets('changing provider', (tester) async {
    final provider = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer((context, read) {
          final value = read(provider);
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
        child: Consumer((context, read) {
          final value = read(provider2);
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
