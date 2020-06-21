import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/src/internal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:state_notifier/state_notifier.dart';

void main() {
  testWidgets('overrive type mismatch throws', (tester) async {
    final provider = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideAs(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideAs(MyImmutableProvider()),
        ],
        child: Container(),
      ),
    );

    expect(
      tester.takeException(),
      isUnsupportedError.having((s) => s.message, 'message', '''
Replaced the override at index 0 of type Provider<int> with an override of type MyImmutableProvider, which is different.
Changing the kind of override or reordering overrides is not supported.
'''),
    );
  });

  group('lifecycles', () {
    final onCreateState = MockCreateState();
    final onInitState = MockInitState();
    final onDidUpdateProvider = MockDidUpdateProvider();
    final onDispose = MockDispose();

    final provider = TestProvider(
      42,
      onCreateState: onCreateState,
      onInitState: onInitState,
      onDidUpdateProvider: onDidUpdateProvider,
      onDispose: onDispose,
    );

    var consumerBuildCount = 0;

    final consumer = HookBuilder(builder: (context) {
      consumerBuildCount++;
      final value = useProvider(provider);
      return Text(value.toString(), textDirection: TextDirection.ltr);
    });

    setUp(() {
      consumerBuildCount = 0;
    });
    tearDown(() {
      reset(onCreateState);
      reset(onInitState);
      reset(onDidUpdateProvider);
      reset(onDispose);
    });

    testWidgets('override to override on same scope calls didUpdateProvider',
        (tester) async {
      final override = TestProvider(
        21,
        onCreateState: MockCreateState(),
        onInitState: MockInitState(),
        onDidUpdateProvider: MockDidUpdateProvider(),
        onDispose: MockDispose(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [provider.overrideAs(override)],
          child: consumer,
        ),
      );

      expect(find.text('42'), findsNothing);
      expect(find.text('21'), findsOneWidget);
      clearInteractions(override.onInitState);
      clearInteractions(override.onCreateState);

      final override2 = TestProvider(
        84,
        onCreateState: MockCreateState(),
        onInitState: MockInitState(),
        onDidUpdateProvider: MockDidUpdateProvider(),
        onDispose: MockDispose(),
      );

      // replace the override with another of thes same type
      await tester.pumpWidget(
        ProviderScope(
          overrides: [provider.overrideAs(override2)],
          child: consumer,
        ),
      );

      expect(find.text('21'), findsNothing);
      expect(find.text('84'), findsOneWidget);
      verifyZeroInteractions(override.onInitState);
      verifyZeroInteractions(override.onCreateState);
      verifyZeroInteractions(override.onDidUpdateProvider);
      verifyZeroInteractions(override.onDispose);

      verifyZeroInteractions(override2.onCreateState);
      verifyZeroInteractions(override2.onInitState);

      verify(override2.onDidUpdateProvider(argThat(isNotNull), override))
          .called(1);
      verifyNoMoreInteractions(override2.onDidUpdateProvider);
    });
    testWidgets('unmount non-override', (tester) async {
      await tester.pumpWidget(ProviderScope(child: consumer));

      clearInteractions(onCreateState);
      clearInteractions(onInitState);

      await tester.pumpWidget(Container());

      verifyZeroInteractions(onCreateState);
      verifyZeroInteractions(onInitState);
      verifyZeroInteractions(onDidUpdateProvider);

      verify(onDispose(argThat(isNotNull))).called(1);
    });
    testWidgets('unmount overrides', (tester) async {
      final override = TestProvider(
        21,
        onCreateState: MockCreateState(),
        onInitState: MockInitState(),
        onDidUpdateProvider: MockDidUpdateProvider(),
        onDispose: MockDispose(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [provider.overrideAs(override)],
          child: consumer,
        ),
      );

      clearInteractions(override.onCreateState);
      clearInteractions(override.onInitState);

      await tester.pumpWidget(Container());

      verifyZeroInteractions(onCreateState);
      verifyZeroInteractions(onInitState);
      verifyZeroInteractions(onDidUpdateProvider);
      verifyZeroInteractions(onDispose);

      verifyZeroInteractions(override.onCreateState);
      verifyZeroInteractions(override.onInitState);
      verifyZeroInteractions(override.onDidUpdateProvider);

      verify(override.onDispose(argThat(isNotNull))).called(1);
    });
    testWidgets('first mount calls createState and initState', (tester) async {
      TestProvider onInitStateProvider;
      provider.onInitState.mock((state) {
        onInitStateProvider = state.provider;
      });
      await tester.pumpWidget(ProviderScope(child: consumer));

      expect(find.text('42'), findsOneWidget);
      verifyInOrder([
        onCreateState(),
        onInitState(argThat(isNotNull)),
      ]);
      verifyZeroInteractions(onDispose);
      verifyZeroInteractions(onDidUpdateProvider);
      expect(onInitStateProvider, provider);
    });
    testWidgets('first override mount calls createState and initState',
        (tester) async {
      TestProvider onInitStateProvider;
      final override = TestProvider(
        21,
        onCreateState: MockCreateState(),
        onInitState: MockInitState((state) {
          onInitStateProvider = state.provider;
        }),
        onDidUpdateProvider: MockDidUpdateProvider(),
        onDispose: MockDispose(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            provider.overrideAs(override),
          ],
          child: consumer,
        ),
      );

      expect(onInitStateProvider, override);
      expect(find.text('42'), findsNothing);
      expect(find.text('21'), findsOneWidget);
      verifyZeroInteractions(onCreateState);
      verifyZeroInteractions(onInitState);
      verifyZeroInteractions(onDispose);
      verifyZeroInteractions(onDidUpdateProvider);

      verifyInOrder([
        override.onCreateState(),
        override.onInitState(argThat(isNotNull)),
      ]);
      verifyZeroInteractions(override.onDispose);
      verifyZeroInteractions(override.onDidUpdateProvider);
    });
    testWidgets('non-override to non-override calls nothing', (tester) async {
      await tester.pumpWidget(ProviderScope(child: consumer));

      expect(find.text('42'), findsOneWidget);
      clearInteractions(onCreateState);
      clearInteractions(onInitState);

      expect(consumerBuildCount, 1);

      await tester.pumpWidget(ProviderScope(child: consumer));

      expect(find.text('42'), findsOneWidget);
      verifyZeroInteractions(onCreateState);
      verifyZeroInteractions(onInitState);
      verifyZeroInteractions(onDispose);
      verifyZeroInteractions(onDidUpdateProvider);

      expect(consumerBuildCount, 1);
    });
  });

  group('useProvider(provider.select)', () {
    testWidgets('simple flow', (tester) async {
      final notifier = Counter();
      final provider = StateNotifierProvider((_) => notifier);
      final selector = SelectorSpy<int>();
      var buildCount = 0;
      Object lastSelectedValue;

      await tester.pumpWidget(
        ProviderScope(child: HookBuilder(builder: (c) {
          buildCount++;
          lastSelectedValue = useProvider(provider.state.select((value) {
            selector(value);
            return value.isNegative;
          }));
          return Container();
        })),
      );

      expect(lastSelectedValue, false);
      expect(buildCount, 1);
      verify(selector(0)).called(1);
      verifyNoMoreInteractions(selector);

      notifier.increment();

      verifyNoMoreInteractions(selector);

      await tester.pump();

      expect(lastSelectedValue, false);
      expect(buildCount, 1);
      verify(selector(1)).called(1);
      verifyNoMoreInteractions(selector);
    });
    testWidgets('deeply compares collections', (tester) async {
      final notifier = ValueNotifier([0]);
      final provider = ChangeNotifierProvider((_) => notifier);
      var buildCount = 0;

      await tester.pumpWidget(
        ProviderScope(child: HookBuilder(builder: (c) {
          buildCount++;
          useProvider(provider.select((value) => value.value));
          return Container();
        })),
      );

      expect(buildCount, 1);

      notifier.value = [0];
      await tester.pump();

      expect(buildCount, 1);

      notifier.value = [1];
      await tester.pump();

      expect(buildCount, 2);
    });
    testWidgets('recompute value when changing selector', (tester) async {
      final notifier = Counter();
      final provider = StateNotifierProvider((_) => notifier);
      final selector = SelectorSpy<String>();
      String value2;
      final build = BuildSpy();
      when(build()).thenAnswer((_) => value2 = 'foo');
      Object lastSelectedValue;

      await tester.pumpWidget(
        ProviderScope(child: HookBuilder(builder: (c) {
          build();
          lastSelectedValue = useProvider(provider.state.select((value) {
            selector('$value $value2');
            return '$value $value2';
          }));
          return Container();
        })),
      );

      expect(lastSelectedValue, '0 foo');
      verifyInOrder([
        build(),
        selector('0 foo'),
      ]);
      verifyNoMoreInteractions(selector);
      verifyNoMoreInteractions(build);

      notifier.increment();
      when(build()).thenAnswer((_) => value2 = 'bar');

      await tester.pump();

      expect(lastSelectedValue, '1 bar');
      verifyInOrder([
        selector('1 foo'),
        build(),
        selector('1 bar'),
      ]);
      verifyNoMoreInteractions(selector);
      verifyNoMoreInteractions(build);
    });
    testWidgets('stop calling selectors after one cause rebuild',
        (tester) async {
      final notifier = Counter();
      final provider = StateNotifierProvider((_) => notifier);
      bool lastSelectedValue;
      final selector = SelectorSpy<int>();
      int lastSelectedValue2;
      final selector2 = SelectorSpy<int>();
      Object lastSelectedValue3;
      final selector3 = SelectorSpy<int>();
      final build = BuildSpy();

      await tester.pumpWidget(
        ProviderScope(child: HookBuilder(builder: (c) {
          build();
          lastSelectedValue = useProvider(provider.state.select((value) {
            selector(value);
            return value.isNegative;
          }));
          lastSelectedValue2 = useProvider(provider.state.select((value) {
            selector2(value);
            return value;
          }));
          lastSelectedValue3 = useProvider(provider.state.select((value) {
            selector3(value);
            return value;
          }));
          return Container();
        })),
      );

      verifyInOrder([
        build(),
        selector(0),
        selector2(0),
        selector3(0),
      ]);
      verifyNoMoreInteractions(build);
      verifyNoMoreInteractions(selector);
      verifyNoMoreInteractions(selector2);
      verifyNoMoreInteractions(selector3);
      expect(lastSelectedValue, false);
      expect(lastSelectedValue2, 0);
      expect(lastSelectedValue3, 0);

      notifier.increment();

      verifyNoMoreInteractions(build);
      verifyNoMoreInteractions(selector);
      verifyNoMoreInteractions(selector2);
      verifyNoMoreInteractions(selector3);

      await tester.pump();

      verifyInOrder([
        selector(1),
        selector2(1),
        build(),
        selector(1),
        selector2(1),
        selector3(1),
      ]);
      verifyNoMoreInteractions(build);
      verifyNoMoreInteractions(selector);
      verifyNoMoreInteractions(selector2);
      verifyNoMoreInteractions(selector3);
      expect(lastSelectedValue, false);
      expect(lastSelectedValue2, 1);
      expect(lastSelectedValue3, 1);
    });
  });
}

class SelectorSpy<T> extends Mock {
  void call(T value);
}

class BuildSpy extends Mock {
  void call();
}

class MockCreateState extends Mock {
  void call();
}

class MockInitState extends Mock {
  MockInitState([void Function(TestProviderState) cb]) {
    if (cb != null) {
      mock(cb);
    }
  }

  void mock(void Function(TestProviderState) cb) {
    when(this(any)).thenAnswer((realInvocation) {
      cb(realInvocation.positionalArguments.first as TestProviderState);
    });
  }

  void call(TestProviderState state);
}

class MockDispose extends Mock {
  void call(TestProviderState state);
}

class MockDidUpdateProvider extends Mock {
  void call(TestProviderState state, TestProvider oldProvider);
}

class TestProviderValue extends ProviderDependencyBase {
  TestProviderValue(this.value);

  final int value;
}

class TestProvider extends AlwaysAliveProviderBase<TestProviderValue, int> {
  TestProvider(
    this.value, {
    this.onCreateState,
    this.onDidUpdateProvider,
    this.onDispose,
    this.onInitState,
    String name,
  }) : super(name);

  final MockCreateState onCreateState;
  final MockInitState onInitState;
  final MockDispose onDispose;
  final MockDidUpdateProvider onDidUpdateProvider;
  final int value;

  @override
  TestProviderState createState() {
    onCreateState?.call();
    return TestProviderState();
  }
}

class TestProviderState
    extends ProviderStateBase<TestProviderValue, int, TestProvider> {
  int _state;
  @override
  int get state => _state;
  set state(int state) {
    _state = state;
    markMayHaveChanged();
  }

  @override
  void initState() {
    provider.onInitState?.call(
      this,
    );
    _state = provider.value;
  }

  @override
  void didUpdateProvider(TestProvider oldProvider) {
    super.didUpdateProvider(oldProvider);
    provider.onDidUpdateProvider?.call(this, oldProvider);
    state = provider.value;
  }

  @override
  void dispose() {
    provider.onDispose?.call(this);
    super.dispose();
  }

  @override
  TestProviderValue createProviderDependency() {
    return TestProviderValue(state);
  }
}

class MyImmutableProvider
    extends AlwaysAliveProviderBase<ProviderDependency<int>, int> {
  MyImmutableProvider({String name}) : super(name);

  @override
  MyImmutableProviderState createState() {
    return MyImmutableProviderState();
  }
}

class MyImmutableProviderState extends ProviderStateBase<
    ProviderDependency<int>, int, MyImmutableProvider> {
  @override
  void initState() {
    throw UnimplementedError();
  }

  @override
  ProviderDependency<int> createProviderDependency() {
    throw UnimplementedError();
  }

  @override
  int get state => throw UnimplementedError();
}

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}
