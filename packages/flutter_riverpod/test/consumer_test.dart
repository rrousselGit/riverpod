import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/src/internal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:state_notifier/state_notifier.dart';

void main() {
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
