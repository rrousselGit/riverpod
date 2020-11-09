import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/src/internals.dart';

import 'package:mockito/mockito.dart';
import 'utils.dart';

void main() {
  testWidgets('useProviderListener onChange is invoked', (tester) async {
    final container = ProviderContainer();
    final countProvider = StateProvider((_) => 0);
    final onChange = ListenerMock<int>();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: HookBuilder(
          builder: (context) {
            useProviderListener<StateController<int>>(
                countProvider, (context, value) => onChange(value.state));
            return Container();
          },
        ),
      ),
    );

    verifyZeroInteractions(onChange);

    container.read(countProvider).state = 1;
    await tester.pump();

    verify(onChange(1)).called(1);

    container.read(countProvider).state = 8;
    await tester.pump();

    verify(onChange(8)).called(1);

    verifyNoMoreInteractions(onChange);
  });

  testWidgets(
      'useProviderListener calls onChange at the end of frame after a mayHaveChanged',
      (tester) async {
    final container = ProviderContainer();
    final provider = StateProvider((ref) => 0);
    final onChange = ListenerMock<int>();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: HookBuilder(builder: (context) {
          useProviderListener<StateController<int>>(
              provider, (_, value) => onChange(value.state));
          return Container();
        }),
      ),
    );

    verifyZeroInteractions(onChange);

    container.read(provider).state++;

    await Future<void>.value();

    verifyOnly(onChange, onChange(1));
  });

  testWidgets('useProviderListener onChange is called on new provider change',
      (tester) async {
    final container = ProviderContainer();
    final provider = StateProvider.family<int, int>((ref, _) => 0);
    final onChange = ListenerMock<int>();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: HookBuilder(
          builder: (context) {
            useProviderListener<StateController<int>>(
                provider(0), (_, value) => onChange(value.state));
            return Container();
          },
        ),
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: HookBuilder(
          builder: (context) {
            useProviderListener<StateController<int>>(
                provider(1), (_, value) => onChange(value.state));
            return Container();
          },
        ),
      ),
    );

    verifyZeroInteractions(onChange);

    container.read(provider(0)).state++;
    container.read(provider(1)).state = 42;

    await Future<void>.value();

    verifyOnly(onChange, onChange(42));
  });

  testWidgets(
      'useProviderListener onChange is invoked when using useProvider(select)',
      (tester) async {
    final container = ProviderContainer();
    final provider = StateProvider((_) => 0);
    final key = GlobalKey();
    final onChange = ListenerMock<bool>();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: HookBuilder(
            key: key,
            builder: (c) {
              useProviderListener<bool>(
                  provider.select((value) => value.state.isNegative),
                  (context, value) => onChange(value));
              return Container();
            }),
      ),
    );

    container.read(provider).state = -1;
    await tester.pump();
    verify(onChange(true)).called(1);

    container.read(provider).state = 2;
    await tester.pump();
    verify(onChange(false)).called(1);
  });

  testWidgets('can mark parents as dirty during onChange', (tester) async {
    final container = ProviderContainer();
    final provider = StateProvider((ref) => 0);
    final onChange = ListenerMock<int>();

    await tester.pumpWidget(
      StatefulBuilder(builder: (context, setState) {
        return UncontrolledProviderScope(
          container: container,
          child: HookBuilder(
            builder: (context) {
              useProviderListener<StateController<int>>(
                  provider, (_, value) => onChange(value.state));
              return Container();
            },
          ),
        );
      }),
    );

    verifyZeroInteractions(onChange);

    container.read(provider).state++;
    await Future<void>.value();
  });

  testWidgets('calls onChange at most once per frame', (tester) async {
    final provider = StateProvider((ref) => 0);
    final onChange = ListenerMock<int>();
    final container = ProviderContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: HookBuilder(builder: (context) {
          useProviderListener<StateController<int>>(
              provider, (_, value) => onChange(value.state));
          return Container();
        }),
      ),
    );
    verifyZeroInteractions(onChange);

    container.read(provider).state++;
    container.read(provider).state++;
    container.read(provider).state++;
    await Future<void>.value();

    verifyOnly(onChange, onChange(3));
  });

  testWidgets('supports Changing the ProviderContainer', (tester) async {
    final provider = Provider((ref) => 0);
    final onChange = ListenerMock<int>();
    final onChange2 = ListenerMock<int>();

    final container = ProviderContainer(overrides: [
      provider.overrideWithValue(0),
    ]);
    final container2 = ProviderContainer(overrides: [
      provider.overrideWithValue(0),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: HookBuilder(builder: (context) {
          useProviderListener<int>(provider, (_, value) {
            onChange(value);
          });
          return Container();
        }),
      ),
    );

    container.updateOverrides([
      provider.overrideWithValue(21),
    ]);

    await Future<void>.value();

    verifyOnly(onChange, onChange(21));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container2,
        child: HookBuilder(builder: (context) {
          useProviderListener<int>(provider, (_, value) => onChange2(value));
          return Container();
        }),
      ),
    );

    container2.updateOverrides([
      provider.overrideWithValue(42),
    ]);

    await Future<void>.value();

    verifyOnly(onChange2, onChange2(42));
  });

  testWidgets('supports ScopedProvider', (tester) async {
    final provider = ScopedProvider((ref) => 0);
    final onChange = ListenerMock<int>();
    final container = ProviderContainer(overrides: [
      provider.overrideWithValue(42),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: HookBuilder(builder: (context) {
          useProviderListener<int>(provider, (_, value) => onChange(value));
          return Container();
        }),
      ),
    );

    container.updateOverrides([
      provider.overrideWithValue(21),
    ]);

    await Future<void>.value();

    verifyOnly(onChange, onChange(21));
  });

  testWidgets('didUpdateWidget recognizes SelectorSubscription',
      (tester) async {
    final stateProvider = StateProvider((_) => [42, 43]);
    final provider = Provider((ref) => ref.watch(stateProvider).state);
    final container = ProviderContainer();

    final onChange = ListenerMock<int>();

    final consumer = HookBuilder(
      key: GlobalKey(),
      builder: (c) {
        final listenable = provider.select((value) => value[0]);
        final count = useProvider(listenable);
        useProviderListener<int>(listenable, (_, value) => onChange(value));
        return Text('$count', textDirection: TextDirection.ltr);
      },
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Column(
          textDirection: TextDirection.ltr,
          children: <Widget>[
            consumer,
          ],
        ),
      ),
    );
  });

  testWidgets('didUpdateWidget supports Provider change', (tester) async {
    //
    final counter = Counter2();
    final provider = StateNotifierProvider((_) => counter);

    final counter1 = Counter2(state: 42);
    final provider1 = StateNotifierProvider((_) => counter1);

    final onChange = ListenerMock<int>();

    Widget build(StateNotifierProvider<Counter2> provider) {
      return ProviderScope(
        child: HookBuilder(builder: (c) {
          final val = useProvider(provider.state);

          useProviderListener<int>(provider.select((value) => value.current),
              (_, value) => onChange(value));
          return Text('$val', textDirection: TextDirection.ltr);
        }),
      );
    }

    await tester.pumpWidget(build(provider));
    counter.setState(5);
    await tester.pump();
    expect(find.text('5'), findsOneWidget);

    await tester.pumpWidget(build(provider1));
    counter1.setState(30);
    await tester.pump();
    expect(find.text('30'), findsOneWidget);
  });
}

class Counter2 extends StateNotifier<int> {
  Counter2({int state = 0}) : super(state);

  int get current => state;

  // ignore: use_setters_to_change_properties
  void setState(int n) {
    state = n;
  }
}
