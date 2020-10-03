import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'utils.dart';

void main() {
  testWidgets('useProviderListener onChange is invoked', (tester) async {
    final countProvider = StateProvider((_) => 0);
    final textProvider = StateProvider((_) => 'initial');
    final key = GlobalKey();
    await tester.pumpWidget(ProviderScope(
      child: HookBuilder(
        key: key,
        builder: (context) {
          final count = useProvider(countProvider).state;
          final text = useProvider(textProvider).state;
          useProviderListener<StateController<int>>(countProvider,
              (context, value) {
            if (value.state.isEven) {
              context.read(textProvider).state = 'even';
            } else {
              context.read(textProvider).state = 'odd';
            }
          });
          return Column(
            children: [
              Text(
                '$count',
                textDirection: TextDirection.ltr,
              ),
              Text(
                text,
                textDirection: TextDirection.ltr,
              )
            ],
          );
        },
      ),
    ));

    expect(find.text('0'), findsOneWidget);
    expect(find.text('initial'), findsOneWidget);

    key.currentContext.read(countProvider).state = 1;
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('odd'), findsOneWidget);

    key.currentContext.read(countProvider).state = 8;
    await tester.pump();

    expect(find.text('8'), findsOneWidget);
    expect(find.text('even'), findsOneWidget);
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
          child: HookBuilder(
            builder: (context) {
              useProviderListener<StateController<int>>(
                  provider, (_, value) => onChange(value.state));
              return Container();
            },
          )),
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
          )),
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
          )),
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
    final provider = StateProvider((_) => 0);
    final key = GlobalKey();
    final selector = SelectorSpy<int>();
    final onChange = ListenerMock<int>();

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(
            key: key,
            builder: (c) {
              useProvider(provider.select((value) {
                selector(value.state);
                return value.state.isNegative;
              }));
              useProviderListener<StateController<int>>(
                  provider, (context, value) => onChange(value.state));
              return Container();
            }),
      ),
    );

    key.currentContext.read(provider).state = 4;
    await tester.pump();
    verify(onChange(4)).called(1);
  });

  testWidgets('can mark parents as dirty during onChange', (tester) async {
    final container = ProviderContainer();
    final provider = StateProvider((ref) => 0);
    final onChange = ListenerMock<int>();

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
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
        },
      ),
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
        child: HookBuilder(
          builder: (context) {
            useProviderListener<StateController<int>>(
                provider, (_, value) => onChange(value.state));
            return Container();
          },
        ),
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
    final container = ProviderContainer(overrides: [
      provider.overrideWithValue(0),
    ]);
    final container2 = ProviderContainer(overrides: [
      provider.overrideWithValue(0),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: HookBuilder(
          builder: (context) {
            useProviderListener<int>(provider, (_, value) => onChange(value));
            return Container();
          },
        ),
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container2,
        child: HookBuilder(
          builder: (context) {
            useProviderListener<int>(provider, (_, value) => onChange(value));
            return Container();
          },
        ),
      ),
    );

    container.updateOverrides([
      provider.overrideWithValue(21),
    ]);
    container2.updateOverrides([
      provider.overrideWithValue(42),
    ]);

    await Future<void>.value();

    verifyOnly(onChange, onChange(42));
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
        child: HookBuilder(
          builder: (context) {
            useProviderListener<int>(provider, (_, value) => onChange(value));
            return Container();
          },
        ),
      ),
    );

    container.updateOverrides([
      provider.overrideWithValue(21),
    ]);

    await Future<void>.value();

    verifyOnly(onChange, onChange(21));
  });
}
