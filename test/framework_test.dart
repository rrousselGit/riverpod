import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider_hooks/provider_hooks.dart';
import 'package:provider_hooks/src/framework.dart' show ProviderState;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// class AsyncResult<T> {}

// class Configurations {
//   Configurations.fromJson(dynamic json);
// }

// class FutureProvider<T> extends Provider<AsyncResult<T>> {
//   FutureProvider(FutureOr<T> Function() value) : super(value);
// }

// /// Loads configurations from a file
// /// [FutureProvider] works like it does in `provider`, as the exception
// /// that reading the configuration returns an equivalent to [AsyncSnapshot].
// final useConfig = FutureProvider<Configurations>(() async {
//   final source = await File('path').readAsString();
//   return Configurations.fromJson(json.decode(source));
// });

// /// Creates a ChangeNotifier from the configurations.
// /// [FutureProxyProvider1] listens to "1" provider and build another
// /// provider out of it.
// final useModel = FutureProxyProvider1(useConfig, (configNotifier) async {
//   // `configNotifier` expose a bunch of utilities to read the config provider.
//   // It exposes things like "onChange", "currentValue", "asStream" and more.

//   // Reads the first value emited by the configuration provider
//   final config = await configNotifier.first;
//   return ChangeNotifierProvider(() => Model(config));
// });

// class Example extends HookWidget {
//   @override
//   Widget build(BuildContext context) {
//     /// Since [useModel] is created from asyncronous data, then
//     /// we don't have direct access to the [Model] object.
//     /// Instead we have a sealed class that we can use to switch over
//     /// loading/error/data states.
//     final model = useModel();

//     return model.when(
//       loading: () => const CircularProgressIndicator(),
//       error: (error) => Text('Oops'),
//       data: (model) {
//         // The Text will rebuild when content of `model` changes.
//         return Text(model.person.name);
//       },
//     );
//   }
// }

void main() {
  test('ProviderScope requires a child', () {
    expect(() => ProviderScope(child: null), throwsAssertionError);
  });
  testWidgets('throws if no ProviderScope found', (tester) async {
    final useProvider = Provider('foo');

    await tester.pumpWidget(
      HookBuilder(builder: (context) {
        useProvider();
        return Container();
      }),
    );

    expect(
      tester.takeException(),
      isA<StateError>()
          .having((e) => e.message, 'message', 'No ProviderScope found'),
    );
  });

  group('lifecycles', () {
    final onCreateState = MockCreateState();
    final onInitState = MockInitState();
    final onDidUpdateProvider = MockDidUpdateProvider();
    final onDispose = MockDispose();

    final useProvider = TestProvider(
      42,
      onCreateState: onCreateState,
      onInitState: onInitState,
      onDidUpdateProvider: onDidUpdateProvider,
      onDispose: onDispose,
    );

    var consumerBuildCount = 0;

    final consumer = HookBuilder(builder: (context) {
      consumerBuildCount++;
      final value = useProvider();
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

    testWidgets(
        'override to non-override on different scope calls dispose+createState',
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
          child: ProviderScope(
            overrides: [useProvider.overrideForSubstree(override)],
            child: consumer,
          ),
        ),
      );

      expect(find.text('21'), findsOneWidget);
      clearInteractions(override.onInitState);
      clearInteractions(override.onCreateState);

      // stop overriding from child scope
      await tester.pumpWidget(
        ProviderScope(child: ProviderScope(child: consumer)),
      );

      expect(find.text('21'), findsNothing);
      expect(find.text('42'), findsOneWidget);
      verifyInOrder([
        override.onDispose(argThat(isNotNull)),
        onCreateState(),
        onInitState(argThat(isNotNull)),
      ]);

      verifyZeroInteractions(override.onCreateState);
      verifyZeroInteractions(override.onInitState);
      verifyZeroInteractions(override.onDidUpdateProvider);
      verifyNoMoreInteractions(override.onDispose);

      verifyNoMoreInteractions(onCreateState);
      verifyNoMoreInteractions(onInitState);
      verifyZeroInteractions(onDidUpdateProvider);
      verifyZeroInteractions(onDispose);
    });
    testWidgets(
        'non-override to override on same scope calls dispose+createState ',
        (tester) async {
      await tester.pumpWidget(ProviderScope(child: consumer));

      expect(find.text('42'), findsOneWidget);
      clearInteractions(onInitState);
      clearInteractions(onCreateState);

      final override = TestProvider(
        21,
        onCreateState: MockCreateState(),
        onInitState: MockInitState(),
        onDidUpdateProvider: MockDidUpdateProvider(),
        onDispose: MockDispose(),
      );

      // move the override to a different ProviderScope
      await tester.pumpWidget(
        ProviderScope(
          overrides: [useProvider.overrideForSubstree(override)],
          child: consumer,
        ),
      );

      expect(find.text('42'), findsNothing);
      expect(find.text('21'), findsOneWidget);
      verifyInOrder([
        onDispose(argThat(isNotNull)),
        override.onCreateState(),
        override.onInitState(argThat(isNotNull)),
      ]);

      verifyZeroInteractions(onCreateState);
      verifyZeroInteractions(onInitState);
      verifyZeroInteractions(onDidUpdateProvider);
      verifyNoMoreInteractions(onDispose);

      verifyNoMoreInteractions(override.onCreateState);
      verifyNoMoreInteractions(override.onInitState);
      verifyZeroInteractions(override.onDidUpdateProvider);
      verifyZeroInteractions(override.onDispose);
    });

    testWidgets(
        'override to non-override on same scope calls dispose+createState',
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
          overrides: [useProvider.overrideForSubstree(override)],
          child: consumer,
        ),
      );

      expect(find.text('21'), findsOneWidget);
      clearInteractions(override.onInitState);
      clearInteractions(override.onCreateState);

      // no longer override
      await tester.pumpWidget(
        ProviderScope(
          child: ProviderScope(child: consumer),
        ),
      );

      expect(find.text('21'), findsNothing);
      expect(find.text('42'), findsOneWidget);
      verifyInOrder([
        override.onDispose(argThat(isNotNull)),
        onCreateState(),
        onInitState(argThat(isNotNull)),
      ]);

      verifyZeroInteractions(override.onCreateState);
      verifyZeroInteractions(override.onInitState);
      verifyZeroInteractions(override.onDidUpdateProvider);
      verifyNoMoreInteractions(override.onDispose);

      verifyNoMoreInteractions(onCreateState);
      verifyNoMoreInteractions(onInitState);
      verifyZeroInteractions(onDidUpdateProvider);
      verifyZeroInteractions(onDispose);
    });

    testWidgets(
        'override to override on different scope calls dispose+createState '
        '(child to parent)', (tester) async {
      final override = TestProvider(
        21,
        onCreateState: MockCreateState(),
        onInitState: MockInitState(),
        onDidUpdateProvider: MockDidUpdateProvider(),
        onDispose: MockDispose(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: ProviderScope(
            overrides: [useProvider.overrideForSubstree(override)],
            child: consumer,
          ),
        ),
      );

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

      // move the override to a different ProviderScope
      await tester.pumpWidget(
        ProviderScope(
          overrides: [useProvider.overrideForSubstree(override2)],
          child: ProviderScope(child: consumer),
        ),
      );

      expect(find.text('21'), findsNothing);
      expect(find.text('84'), findsOneWidget);
      verifyInOrder([
        override.onDispose(argThat(isNotNull)),
        override2.onCreateState(),
        override2.onInitState(argThat(isNotNull)),
      ]);

      verifyZeroInteractions(override.onCreateState);
      verifyZeroInteractions(override.onInitState);
      verifyZeroInteractions(override.onDidUpdateProvider);
      verifyNoMoreInteractions(override.onDispose);

      verifyNoMoreInteractions(override2.onCreateState);
      verifyNoMoreInteractions(override2.onInitState);
      verifyZeroInteractions(override2.onDidUpdateProvider);
      verifyZeroInteractions(override2.onDispose);
    });
    testWidgets(
        'override to override on different scope calls dispose+createState '
        '(parent to child)', (tester) async {
      final override = TestProvider(
        21,
        onCreateState: MockCreateState(),
        onInitState: MockInitState(),
        onDidUpdateProvider: MockDidUpdateProvider(),
        onDispose: MockDispose(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [useProvider.overrideForSubstree(override)],
          child: ProviderScope(
            child: consumer,
          ),
        ),
      );

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

      // move the override to a different ProviderScope
      await tester.pumpWidget(
        ProviderScope(
          child: ProviderScope(
            overrides: [useProvider.overrideForSubstree(override2)],
            child: consumer,
          ),
        ),
      );

      expect(find.text('21'), findsNothing);
      expect(find.text('84'), findsOneWidget);
      verifyInOrder([
        override.onDispose(argThat(isNotNull)),
        override2.onCreateState(),
        override2.onInitState(argThat(isNotNull)),
      ]);

      verifyZeroInteractions(override.onCreateState);
      verifyZeroInteractions(override.onInitState);
      verifyZeroInteractions(override.onDidUpdateProvider);
      verifyNoMoreInteractions(override.onDispose);

      verifyNoMoreInteractions(override2.onCreateState);
      verifyNoMoreInteractions(override2.onInitState);
      verifyZeroInteractions(override2.onDidUpdateProvider);
      verifyZeroInteractions(override2.onDispose);
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
          overrides: [useProvider.overrideForSubstree(override)],
          child: consumer,
        ),
      );

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
          overrides: [useProvider.overrideForSubstree(override2)],
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
          overrides: [useProvider.overrideForSubstree(override)],
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
      useProvider.onInitState.mock((state) {
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
      expect(onInitStateProvider, useProvider);
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
            useProvider.overrideForSubstree(override),
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

  testWidgets('providers can be overriden', (tester) async {
    final useProvider = Provider('root');
    final useProvider2 = Provider('root2');

    final builder = Directionality(
      textDirection: TextDirection.ltr,
      child: HookBuilder(
        builder: (context) {
          final provider = useProvider();
          final provider2 = useProvider2();
          return Column(
            children: <Widget>[
              Text(provider),
              Text(provider2),
            ],
          );
        },
      ),
    );

    await tester.pumpWidget(
      ProviderScope(child: builder),
    );

    expect(find.text('root'), findsOneWidget);
    expect(find.text('root2'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubstree(Provider('override')),
        ],
        child: builder,
      ),
    );

    expect(find.text('root'), findsNothing);
    expect(find.text('override'), findsOneWidget);
    expect(find.text('root2'), findsOneWidget);
  });
  testWidgets(
      "don't rebuild a dependent if another unrelated useProvider is overriden",
      (tester) async {
    final useProvider = Provider('root');
    final useProvider2 = Provider('root2');

    var buildCount = 0;
    var buildCount2 = 0;

    final builder = Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: <Widget>[
          HookBuilder(builder: (context) {
            buildCount++;
            final provider = useProvider();
            return Text(provider);
          }),
          HookBuilder(builder: (context) {
            buildCount2++;
            final provider2 = useProvider2();
            return Text(provider2);
          }),
        ],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(child: builder),
    );

    expect(find.text('root'), findsOneWidget);
    expect(find.text('root2'), findsOneWidget);
    expect(buildCount, 1);
    expect(buildCount2, 1);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubstree(Provider('override')),
        ],
        child: builder,
      ),
    );

    expect(find.text('root'), findsNothing);
    expect(find.text('override'), findsOneWidget);
    expect(find.text('root2'), findsOneWidget);
    expect(buildCount, 2);
    expect(buildCount2, 1);
  });
  testWidgets('ProviderScope can be nested', (tester) async {
    final useProvider = Provider('root');
    final useProvider2 = Provider('root2');

    var buildCount = 0;
    var buildCount2 = 0;

    final builder = Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: <Widget>[
          HookBuilder(builder: (context) {
            buildCount++;
            final provider = useProvider();
            return Text(provider);
          }),
          HookBuilder(builder: (context) {
            buildCount2++;
            final provider2 = useProvider2();
            return Text(provider2);
          }),
        ],
      ),
    );

    final secondScope = ProviderScope(
      overrides: [
        useProvider2.overrideForSubstree(Provider('override2')),
      ],
      child: builder,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubstree(Provider('override')),
        ],
        child: secondScope,
      ),
    );

    expect(buildCount, 1);
    expect(buildCount2, 1);
    expect(find.text('override'), findsOneWidget);
    expect(find.text('override2'), findsOneWidget);

    await tester.pumpWidget(ProviderScope(child: secondScope));

    expect(buildCount, 2);
    expect(buildCount2, 1);
    expect(find.text('root'), findsOneWidget);
    expect(find.text('override2'), findsOneWidget);
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

class TestProvider extends Provider<int> {
  TestProvider(
    this.value, {
    this.onCreateState,
    this.onDidUpdateProvider,
    this.onDispose,
    this.onInitState,
  }) : super(value);

  final MockCreateState onCreateState;
  final MockInitState onInitState;
  final MockDispose onDispose;
  final MockDidUpdateProvider onDidUpdateProvider;
  final int value;

  @override
  TestProviderState createState() {
    onCreateState?.call();
    return TestProviderState(value);
  }
}

class TestProviderState extends ProviderState<int, TestProvider> {
  TestProviderState(int state) : super(state);

  @override
  void initState() {
    super.initState();
    provider.onInitState?.call(
      this,
    );
  }

  @override
  void didUpdateProvider(TestProvider oldProvider) {
    super.didUpdateProvider(oldProvider);
    provider.onDidUpdateProvider?.call(this, oldProvider);
  }

  @override
  void dispose() {
    provider.onDispose?.call(this);
    super.dispose();
  }
}
