import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_river_pod/hooks_river_pod.dart';
import 'package:flutter_river_pod/src/internal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  testWidgets('overrive type mismatch throws', (tester) async {
    final provider = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideForSubtree(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideForSubtree(MyImmutableProvider()),
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

    testWidgets('calls all dispose in order even if one crashes',
        (tester) async {
      final provider = TestProvider(0, onDispose: MockDispose());
      final provider2 = TestProvider(0, onDispose: MockDispose());
      final error2 = Error();
      when(provider2.onDispose(any)).thenThrow(error2);
      final provider3 = TestProvider(0, onDispose: MockDispose());

      await tester.pumpWidget(
        ProviderScope(
          child: HookBuilder(builder: (c) {
            useProvider(provider);
            useProvider(provider2);
            useProvider(provider3);
            return Container();
          }),
        ),
      );

      await tester.pumpWidget(Container());

      expect(tester.takeException(), error2);
      verify(provider.onDispose(argThat(isNotNull))).called(1);
      verify(provider2.onDispose(argThat(isNotNull))).called(1);
      verify(provider3.onDispose(argThat(isNotNull))).called(1);
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
          overrides: [provider.overrideForSubtree(override)],
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
          overrides: [provider.overrideForSubtree(override2)],
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
          overrides: [provider.overrideForSubtree(override)],
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
            provider.overrideForSubtree(override),
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

class TestProviderValue extends ProviderBaseSubscription {
  TestProviderValue(this.value);

  final int value;
}

class TestProvider extends ProviderBase<TestProviderValue, int> {
  TestProvider(
    this.value, {
    this.onCreateState,
    this.onDidUpdateProvider,
    this.onDispose,
    this.onInitState,
  });

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
    extends ProviderBaseState<TestProviderValue, int, TestProvider> {
  @override
  int initState() {
    provider.onInitState?.call(
      this,
    );
    return provider.value;
  }

  @override
  void didUpdateProvider(TestProvider oldProvider) {
    super.didUpdateProvider(oldProvider);
    provider.onDidUpdateProvider?.call(this, oldProvider);
    $state = provider.value;
  }

  @override
  void dispose() {
    provider.onDispose?.call(this);
    super.dispose();
  }

  @override
  TestProviderValue createProviderSubscription() {
    return TestProviderValue($state);
  }
}

class MyImmutableProvider extends ProviderBase<ProviderSubscription<int>, int> {
  @override
  MyImmutableProviderState createState() {
    return MyImmutableProviderState();
  }
}

class MyImmutableProviderState extends ProviderBaseState<
    ProviderSubscription<int>, int, MyImmutableProvider> {
  @override
  int initState() {
    throw UnimplementedError();
  }

  @override
  ProviderSubscription<int> createProviderSubscription() {
    throw UnimplementedError();
  }
}
