import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/src/internals.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'utils.dart';

void main() {
  testWidgets(
      'cannot attach a ProviderContainer to an ProviderScope if the container has pending tasks',
      (tester) async {},
      skip: true);

  testWidgets('ref.read works with providers that returns null',
      (tester) async {
    final nullProvider = Provider((ref) => null);
    late WidgetRef ref;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(builder: (context, r, _) {
          ref = r;
          return Container();
        }),
      ),
    );

    expect(ref.read(nullProvider), null);
  });

  testWidgets('ref.read can read ScopedProviders', (tester) async {
    final provider = Provider((watch) => 42);
    late WidgetRef ref;

    await tester.pumpWidget(ProviderScope(
      child: Consumer(
        builder: (context, r, _) {
          ref = r;
          return Container();
        },
      ),
    ));

    expect(ref.read(provider), 42);
  });

  testWidgets('ref.read obtains the nearest Provider possible', (tester) async {
    late WidgetRef ref;
    final provider = Provider((watch) => 42);

    await tester.pumpWidget(
      ProviderScope(
        child: ProviderScope(
          overrides: [provider.overrideWithValue(21)],
          child: Consumer(
            builder: (context, r, _) {
              ref = r;
              return Container();
            },
          ),
        ),
      ),
    );

    expect(ref.read(provider), 21);
  });

  testWidgets('widgets cannot modify providers in their build method',
      (tester) async {
    final onError = FlutterError.onError;
    Object? error;
    FlutterError.onError = (details) {
      error = details.exception;
    };

    final provider = StateProvider((ref) => 0);
    final container = createContainer();

    // using runZonedGuarded as StateNotifier will emit an handleUncaughtError
    // if a listener threw
    await runZonedGuarded(
      () => tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(builder: (context, ref, _) {
            ref.watch(provider).state++;
            return Container();
          }),
        ),
      ),
      (error, stack) {},
    );

    FlutterError.onError = onError;
    expect(error, isNotNull);
  });

  testWidgets(
      'UncontrolledProviderScope gracefully handles ProviderContainer.vsync',
      (tester) async {
    final container = createContainer();
    final container2 = createContainer();

    expect(container.vsyncOverride, null);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Container(),
      ),
    );

    expect(container.vsyncOverride, isNotNull);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container2,
        child: Container(),
      ),
    );

    expect(container.vsyncOverride, null);
    expect(container2.vsyncOverride, isNotNull);

    await tester.pumpWidget(Container());

    expect(container.vsyncOverride, null);
    expect(container2.vsyncOverride, null);
  });

  testWidgets(
      'UncontrolledProviderScope gracefully handles ProviderContainer.debugCanModifyProviders',
      (tester) async {
    final container = createContainer();
    final container2 = createContainer();

    expect(container.debugCanModifyProviders, null);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Container(),
      ),
    );

    expect(container.debugCanModifyProviders, isNotNull);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container2,
        child: Container(),
      ),
    );

    expect(container.debugCanModifyProviders, null);
    expect(container2.debugCanModifyProviders, isNotNull);

    await tester.pumpWidget(Container());

    expect(container.debugCanModifyProviders, null);
    expect(container2.debugCanModifyProviders, null);
  });

  testWidgets('context.refresh forces a provider to refresh', (tester) async {
    var future = Future<int>.value(21);
    final provider = FutureProvider<int>((ref) => future);
    late WidgetRef ref;

    await tester.pumpWidget(ProviderScope(
      child: Consumer(
        builder: (context, r, _) {
          ref = r;
          return Container();
        },
      ),
    ));

    await expectLater(ref.read(provider.future), completion(21));

    future = Future<int>.value(42);

    ref.refresh(provider);
    await expectLater(ref.read(provider.future), completion(42));
  });

  testWidgets('context.refresh forces a provider of nullable type to refresh',
      (tester) async {
    int? value = 42;
    final provider = Provider<int?>((ref) => value);
    late WidgetRef ref;

    await tester.pumpWidget(ProviderScope(
      child: Consumer(
        builder: (context, r, _) {
          ref = r;
          return Container();
        },
      ),
    ));

    expect(ref.read(provider), 42);

    value = null;

    expect(ref.refresh(provider), null);
  });

  testWidgets('ProviderScope allows specifying a ProviderContainer',
      (tester) async {
    final provider = FutureProvider((ref) async => 42);
    late WidgetRef ref;
    final container = createContainer(overrides: [
      provider.overrideWithValue(const AsyncValue.data(42)),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, r, _) {
            ref = r;
            return Container();
          },
        ),
      ),
    );

    expect(ref.read(provider), const AsyncValue.data(42));
  });

  testWidgets('AlwaysAliveProviderBase.read(context) inside initState',
      (tester) async {
    final provider = Provider((_) => 42);
    int? result;

    await tester.pumpWidget(
      ProviderScope(
        child: InitState(
          initState: (context, ref) => result = ref.read(provider),
        ),
      ),
    );

    expect(result, 42);
  });

  testWidgets('AlwaysAliveProviderBase.read(context) inside build',
      (tester) async {
    final provider = Provider((_) => 42);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            // Allowed even if not a good practice. Will have a lint instead
            final value = ref.read(provider);
            return Text(
              '$value',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('adding overrides throws', (tester) async {
    final provider = Provider((_) => 0);

    await tester.pumpWidget(ProviderScope(child: Container()));

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideWithProvider(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('removing overrides is no-op', (tester) async {
    final provider = Provider((_) => 0);

    final consumer = Consumer(builder: (context, ref, _) {
      return Text(
        ref.watch(provider).toString(),
        textDirection: TextDirection.ltr,
      );
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideWithProvider(Provider((_) => 1)),
        ],
        child: consumer,
      ),
    );

    expect(find.text('1'), findsOneWidget);

    await tester.pumpWidget(ProviderScope(child: consumer));

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('overrive origin mismatch throws', (tester) async {
    final provider = Provider((_) => 0);
    final provider2 = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideWithProvider(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider2.overrideWithProvider(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('throws if no ProviderScope found', (tester) async {
    final provider = Provider((_) => 'foo');

    await tester.pumpWidget(
      Consumer(builder: (context, ref, _) {
        ref.watch(provider);
        return Container();
      }),
    );

    expect(
      tester.takeException(),
      isA<StateError>()
          .having((e) => e.message, 'message', 'No ProviderScope found'),
    );
  });

  testWidgets('providers can be overriden', (tester) async {
    final provider = Provider((_) => 'root');
    final provider2 = Provider((_) => 'root2');

    final builder = Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: <Widget>[
          Consumer(builder: (c, ref, _) => Text(ref.watch(provider))),
          Consumer(builder: (c, ref, _) => Text(ref.watch(provider2))),
        ],
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
          provider.overrideWithProvider(Provider((_) => 'override')),
        ],
        child: builder,
      ),
    );

    expect(find.text('root'), findsNothing);
    expect(find.text('override'), findsOneWidget);
    expect(find.text('root2'), findsOneWidget);
  });

  testWidgets('ProviderScope can be nested', (tester) async {
    final provider = Provider((_) => 'root');
    final provider2 = Provider((_) => 'root2');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideWithProvider(Provider((_) => 'rootoverride')),
        ],
        child: ProviderScope(
          child: Consumer(builder: (c, ref, _) {
            final first = ref.watch(provider);
            final second = ref.watch(provider2);
            return Text(
              '$first $second',
              textDirection: TextDirection.ltr,
            );
          }),
        ),
      ),
    );

    expect(find.text('root root2'), findsNothing);
    expect(find.text('rootoverride root2'), findsOneWidget);
  });

  testWidgets('ProviderScope throws if ancestorOwner changed', (tester) async {
    final key = GlobalKey();

    await tester.pumpWidget(
      ProviderScope(
        child: ProviderScope(
          key: key,
          child: Container(),
        ),
      ),
    );

    expect(find.byType(Container), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        child: ProviderScope(
          child: ProviderScope(
            key: key,
            child: Container(),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isUnsupportedError);
  });

  testWidgets('ProviderScope throws if ancestorOwner removed', (tester) async {
    final key = GlobalKey();

    await tester.pumpWidget(
      Stack(
        textDirection: TextDirection.ltr,
        children: [
          ProviderScope(
            key: const Key('foo'),
            child: ProviderScope(
              key: key,
              child: Container(),
            ),
          ),
        ],
      ),
    );

    expect(find.byType(Container), findsOneWidget);

    await tester.pumpWidget(
      Stack(
        textDirection: TextDirection.ltr,
        children: [
          ProviderScope(
            key: const Key('foo'),
            child: Container(),
          ),
          ProviderScope(
            key: key,
            child: Container(),
          ),
        ],
      ),
    );

    expect(tester.takeException(), isUnsupportedError);

    // re-pump the original tree so that it disposes correctly
    await tester.pumpWidget(
      Stack(
        textDirection: TextDirection.ltr,
        children: [
          ProviderScope(
            key: const Key('foo'),
            child: ProviderScope(
              key: key,
              child: Container(),
            ),
          ),
        ],
      ),
    );
  });

  testWidgets(
      'autoDispose initState and ProviderListener does not destroy the state',
      (tester) async {
    var disposeCount = 0;
    final counterProvider = StateProvider.autoDispose((ref) {
      ref.onDispose(() => disposeCount++);
      return 0;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Demo(
          initState: (context, ref) {
            ref.read(counterProvider).addListener((state) {});
          },
          builder: (context, ref) {
            // ignore: deprecated_member_use_from_same_package
            return ProviderListener(
              onChange: (_, __) {},
              provider: counterProvider,
              child: Container(),
            );
          },
        ),
      ),
    );

    expect(disposeCount, 0);
  });

  testWidgets('autoDispose states are kept alive during pushReplacement',
      (tester) async {
    var disposeCount = 0;
    final counterProvider = StateProvider.autoDispose((ref) {
      ref.onDispose(() => disposeCount++);
      return 0;
    });

    final container = createContainer();
    final key = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          navigatorKey: key,
          home: Consumer(
            builder: (context, ref, _) {
              final count = ref.watch(counterProvider).state;
              return Text('$count');
            },
          ),
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    container.read(counterProvider).state++;
    await tester.pump();

    expect(find.text('1'), findsOneWidget);

    // ignore: unawaited_futures
    key.currentState!.pushReplacement<void, void>(
      PageRouteBuilder<void>(pageBuilder: (_, __, ___) {
        return Consumer(
          builder: (context, ref, _) {
            final count = ref.watch(counterProvider).state;
            return Text('new $count');
          },
        );
      }),
    );

    await tester.pumpAndSettle();

    expect(find.text('1'), findsNothing);
    expect(find.text('new 0'), findsNothing);
    expect(find.text('new 1'), findsOneWidget);
  });
}

class Counter extends StateNotifier<int> {
  Counter() : super(0);
}

class MockCreateState extends Mock {
  void call();
}

class InitState extends ConsumerStatefulWidget {
  const InitState({
    Key? key,
    required this.initState,
  }) : super(key: key);

  // ignore: diagnostic_describe_all_properties
  final void Function(BuildContext context, WidgetRef ref) initState;

  @override
  _InitStateState createState() => _InitStateState();
}

class _InitStateState extends ConsumerState<InitState> {
  @override
  void initState() {
    super.initState();
    widget.initState(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Demo extends ConsumerStatefulWidget {
  const Demo({
    Key? key,
    required this.initState,
    required this.builder,
  }) : super(key: key);

  // ignore: diagnostic_describe_all_properties
  final void Function(BuildContext context, WidgetRef ref) initState;
  // ignore: diagnostic_describe_all_properties
  final Widget Function(BuildContext context, WidgetRef ref) builder;

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends ConsumerState<Demo> {
  @override
  void initState() {
    super.initState();
    widget.initState(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, ref);
  }
}
