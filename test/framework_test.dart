import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider_hooks/provider_hooks.dart';
import 'package:provider_hooks/src/framework.dart'
    show BaseProvider, BaseProviderState;
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
  testWidgets('adding overrides throws', (tester) async {
    final useProvider = Provider((_) => 0);

    await tester.pumpWidget(ProviderScope(child: Container()));

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(
      tester.takeException(),
      isUnsupportedError.having((s) => s.message, 'message',
          'Adding or removing provider overrides is not supported'),
    );
  });
  testWidgets('removing overrides throws', (tester) async {
    final useProvider = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(ProviderScope(child: Container()));

    expect(
      tester.takeException(),
      isUnsupportedError.having((s) => s.message, 'message',
          'Adding or removing provider overrides is not supported'),
    );
  });

  testWidgets('overrive type mismatch throws', (tester) async {
    final useProvider = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(MyImmutableProvider(0)),
        ],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(
      tester.takeException(),
      isUnsupportedError.having((s) => s.message, 'message', '''
Replaced the override at index 0 of type MyImmutableProvider with an override of type _ProviderCreate<int>, which is different.
Changing the kind of override or reordering overrides is not supported.
'''),
    );
  });
  testWidgets('overrive origin mismatch throws', (tester) async {
    final useProvider = Provider((_) => 0);
    final useProvider2 = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider2.overrideForSubtree(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(
      tester.takeException(),
      isUnsupportedError.having(
        (s) => s.message,
        'message',
        'The provider overriden at the index 0 changed, which is unsupported.',
      ),
    );
  });
  testWidgets('calls all dispose in order even if one crashes', (tester) async {
    final useProvider = TestProvider(0, onDispose: MockDispose());
    final useProvider2 = TestProvider(0, onDispose: MockDispose());
    final error2 = Error();
    when(useProvider2.onDispose(any)).thenThrow(error2);
    final useProvider3 = TestProvider(0, onDispose: MockDispose());

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          useProvider();
          useProvider2();
          useProvider3();
          return Container();
        }),
      ),
    );

    await tester.pumpWidget(Container());

    expect(tester.takeException(), error2);
    verify(useProvider.onDispose(argThat(isNotNull))).called(1);
    verify(useProvider2.onDispose(argThat(isNotNull))).called(1);
    verify(useProvider3.onDispose(argThat(isNotNull))).called(1);
  });
  test('ProviderScope requires a child', () {
    expect(() => ProviderScope(child: null), throwsAssertionError);
  });
  testWidgets('throws if no ProviderScope found', (tester) async {
    final useProvider = Provider((_) => 'foo');

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
          overrides: [useProvider.overrideForSubtree(override)],
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
          overrides: [useProvider.overrideForSubtree(override2)],
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
          overrides: [useProvider.overrideForSubtree(override)],
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
            useProvider.overrideForSubtree(override),
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
    final useProvider = Provider((_) => 'root');
    final useProvider2 = Provider((_) => 'root2');

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
      ProviderScope(
        key: UniqueKey(),
        child: builder,
      ),
    );

    expect(find.text('root'), findsOneWidget);
    expect(find.text('root2'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [
          useProvider.overrideForSubtree(Provider((_) => 'override')),
        ],
        child: builder,
      ),
    );

    expect(find.text('root'), findsNothing);
    expect(find.text('override'), findsOneWidget);
    expect(find.text('root2'), findsOneWidget);
  });
  testWidgets(
      "don't rebuild a dependent if another unrelated useProvider is updated",
      (tester) async {
    // final useProvider = Provider.value('root');
    // final useProvider2 = Provider.value('root2');

    // var buildCount = 0;
    // var buildCount2 = 0;

    // final builder = Directionality(
    //   textDirection: TextDirection.ltr,
    //   child: Column(
    //     children: <Widget>[
    //       HookBuilder(builder: (context) {
    //         buildCount++;
    //         final provider = useProvider();
    //         return Text(provider);
    //       }),
    //       HookBuilder(builder: (context) {
    //         buildCount2++;
    //         final provider2 = useProvider2();
    //         return Text(provider2);
    //       }),
    //     ],
    //   ),
    // );

    // await tester.pumpWidget(
    //   ProviderScope(
    //     overrides: [
    //       useProvider.overrideForSubtree(Provider.value('override1')),
    //     ],
    //     child: builder,
    //   ),
    // );

    // expect(find.text('override1'), findsOneWidget);
    // expect(find.text('root2'), findsOneWidget);
    // expect(buildCount, 1);
    // expect(buildCount2, 1);

    // await tester.pumpWidget(
    //   ProviderScope(
    //     overrides: [
    //       useProvider.overrideForSubtree(Provider.value('override2')),
    //     ],
    //     child: builder,
    //   ),
    // );

    // expect(find.text('override2'), findsOneWidget);
    // expect(find.text('root2'), findsOneWidget);
    // expect(buildCount, 2);
    // expect(buildCount2, 1);
  }, skip: true);
  testWidgets('ProviderScope can be nested', (tester) async {
    final useProvider = Provider((_) => 'root');
    final useProvider2 = Provider((_) => 'root2');

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
        useProvider2.overrideForSubtree(Provider((_) => 'override2')),
      ],
      child: builder,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(Provider((_) => 'rootoverride')),
        ],
        child: secondScope,
      ),
    );

    expect(buildCount, 1);
    expect(buildCount2, 1);
    expect(find.text('rootoverride'), findsOneWidget);
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

class TestProvider extends BaseProvider<int> {
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

  int call() => BaseProvider.use(this);

  @override
  TestProviderState createState() {
    onCreateState?.call();
    return TestProviderState();
  }
}

class TestProviderState extends BaseProviderState<int, TestProvider> {
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
    state = provider.value;
  }

  @override
  void dispose() {
    provider.onDispose?.call(this);
    super.dispose();
  }
}

class MyImmutableProvider extends BaseProvider<ProviderValue<int>> {
  MyImmutableProvider(this.value);

  final int value;

  @override
  MyImmutableProviderState createState() {
    return MyImmutableProviderState();
  }
}

class MyImmutableProviderState
    extends BaseProviderState<ProviderValue<int>, MyImmutableProvider> {
  @override
  ProviderValue<int> initState() {
    return ProviderValue(provider.value);
  }
}
