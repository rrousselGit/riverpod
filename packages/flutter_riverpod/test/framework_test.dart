// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';

import 'package:flutter/material.dart' hide Listener;
import 'package:flutter_riverpod/src/internals.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'utils.dart';

void main() {
  testWidgets('Supports recreating ProviderScope', (tester) async {
    final provider = Provider<String>((ref) => 'foo');

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            ref.watch(provider);
            return Consumer(
              builder: (context, ref, _) {
                ref.watch(provider);
                return Container();
              },
            );
          },
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        child: Consumer(
          builder: (context, ref, _) {
            ref.watch(provider);
            return Consumer(
              builder: (context, ref, _) {
                ref.watch(provider);
                return Container();
              },
            );
          },
        ),
      ),
    );
  });

  testWidgets('Supports multiple ProviderScope roots in the same tree',
      (tester) async {
    final a = StateProvider((_) => 0);
    final b = Provider((ref) => ref.watch(a));

    await tester.pumpWidget(
      // No root scope. We want to test cases where there are multiple roots
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 2; i++)
            SizedBox(
              width: 100,
              height: 100,
              child: ProviderScope(
                child: Consumer(
                  builder: (context, ref, _) {
                    ref.watch(a);
                    ref.watch(b);
                    return Container();
                  },
                ),
              ),
            ),
        ],
      ),
    );

    final containers = tester.allElements
        .where((e) => e.widget is Consumer)
        .map(ProviderScope.containerOf)
        .toList();

    expect(containers, hasLength(2));

    for (final container in containers) {
      container.read(a.notifier).state++;
    }

    await tester.pump();
  });

  testWidgets('ref.invalidate can invalidate a family', (tester) async {
    final listener = Listener<String>();
    final listener2 = Listener<String>();
    var result = 0;
    final provider = Provider.family<String, int>((r, i) => '$result-$i');
    late WidgetRef ref;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, r, _) {
            ref = r;
            ref.listen(provider(0), listener.call);
            ref.listen(provider(1), listener2.call);
            return Container();
          },
        ),
      ),
    );

    verifyZeroInteractions(listener);

    ref.invalidate(provider);
    result = 1;

    verifyZeroInteractions(listener);

    await tester.pumpAndSettle();

    verifyOnly(listener, listener('0-0', '1-0'));
    verifyOnly(listener2, listener2('0-1', '1-1'));
  });

  testWidgets('ref.invalidate triggers a rebuild on next frame',
      (tester) async {
    final listener = Listener<int>();
    var result = 0;
    final provider = Provider((r) => result);
    late WidgetRef ref;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, r, _) {
            ref = r;
            ref.listen(provider, listener.call);
            return Container();
          },
        ),
      ),
    );

    verifyZeroInteractions(listener);

    ref.invalidate(provider);
    ref.invalidate(provider);
    result = 1;

    verifyZeroInteractions(listener);

    await tester.pumpAndSettle();

    verifyOnly(listener, listener(0, 1));
  });

  testWidgets('ProviderScope can receive a custom parent', (tester) async {
    final provider = Provider((ref) => 0);

    final container = createContainer(
      overrides: [provider.overrideWithValue(42)],
    );

    await tester.pumpWidget(
      ProviderScope(
        // ignore: deprecated_member_use_from_same_package
        parent: container,
        child: Consumer(
          builder: (context, ref, _) {
            return Text(
              '${ref.watch(provider)}',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('ProviderScope.parent cannot change', (tester) async {
    final container = createContainer();
    final container2 = createContainer();

    await tester.pumpWidget(
      ProviderScope(
        // ignore: deprecated_member_use_from_same_package
        parent: container,
        child: Container(),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        // ignore: deprecated_member_use_from_same_package
        parent: container2,
        child: Container(),
      ),
    );

    expect(tester.takeException(), isUnsupportedError);
  });

  testWidgets('ref.read works with providers that returns null',
      (tester) async {
    final nullProvider = Provider((ref) => null);
    late WidgetRef ref;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, r, _) {
            ref = r;
            return Container();
          },
        ),
      ),
    );

    expect(ref.read(nullProvider), null);
  });

  testWidgets('ref.read can read ScopedProviders', (tester) async {
    final provider = Provider((watch) => 42);
    late WidgetRef ref;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, r, _) {
            ref = r;
            return Container();
          },
        ),
      ),
    );

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
          child: Consumer(
            builder: (context, ref, _) {
              ref.watch(provider.notifier).state++;
              return Container();
            },
          ),
        ),
      ),
      (error, stack) {},
    );

    FlutterError.onError = onError;
    expect(error, isNotNull);
  });

  testWidgets('ref.watch within a build method can flush providers',
      (tester) async {
    final container = createContainer();
    final dep = StateProvider((ref) => 0);
    final provider = Provider((ref) => ref.watch(dep));

    // reading `provider` but not listening to it, so that it is active
    // but with no listener – causing "ref.watch" inside Consumer to flush it
    container.read(provider);

    // We need to use runAsync as the container isn't attached to a ProviderScope
    // yet, so the WidgetTester is preventing the scheduler from start microtasks
    await tester.runAsync<void>(() async {
      // marking `provider` as out of date
      container.read(dep.notifier).state++;
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, _) {
            return Text(
              ref.watch(provider).toString(),
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('UncontrolledProviderScope gracefully handles vsync',
      (tester) async {
    final container = createContainer();
    final container2 = createContainer(parent: container);

    expect(container.scheduler.flutterVsyncs, isEmpty);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Container(),
      ),
    );

    expect(container.scheduler.flutterVsyncs, hasLength(1));
    expect(container2.scheduler.flutterVsyncs, isEmpty);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: UncontrolledProviderScope(
          container: container2,
          child: Container(),
        ),
      ),
    );

    expect(container.scheduler.flutterVsyncs, hasLength(1));
    expect(container2.scheduler.flutterVsyncs, hasLength(1));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Container(),
      ),
    );

    expect(container.scheduler.flutterVsyncs, hasLength(1));
    expect(container2.scheduler.flutterVsyncs, isEmpty);

    await tester.pumpWidget(Container());

    expect(container.scheduler.flutterVsyncs, isEmpty);
    expect(container2.scheduler.flutterVsyncs, isEmpty);
  });

  testWidgets('When there are multiple vsyncs, rebuild providers only once',
      (tester) async {
    var buildCount = 0;
    final dep = StateProvider((ref) => 0);
    final provider = Provider((ref) {
      buildCount++;
      return ref.watch(dep);
    });

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ProviderScope(
          child: ProviderScope(
            child: Consumer(
              builder: (context, ref, _) {
                return Text('Hello ${ref.watch(provider)}');
              },
            ),
          ),
        ),
      ),
    );

    expect(buildCount, 1);
    expect(find.text('Hello 0'), findsOneWidget);
    expect(find.text('Hello 1'), findsNothing);

    final consumerElement = tester.element(find.byType(Consumer));
    final container = ProviderScope.containerOf(consumerElement);

    container.read(dep.notifier).state++;

    await tester.pump();

    expect(buildCount, 2);
    expect(find.text('Hello 1'), findsOneWidget);
    expect(find.text('Hello 0'), findsNothing);
  });

  testWidgets(
      'UncontrolledProviderScope gracefully handles debugCanModifyProviders',
      (tester) async {
    final container = createContainer();

    expect(debugCanModifyProviders, null);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Container(),
      ),
    );

    expect(debugCanModifyProviders, isNotNull);

    await tester.pumpWidget(Container());

    expect(debugCanModifyProviders, null);
  });

  testWidgets('ref.refresh forces a provider to refresh', (tester) async {
    var future = Future<int>.value(21);
    final provider = FutureProvider<int>((ref) => future);
    late WidgetRef ref;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, r, _) {
            ref = r;
            return Container();
          },
        ),
      ),
    );

    await expectLater(ref.read(provider.future), completion(21));

    future = Future<int>.value(42);

    ref.invalidate(provider);
    await expectLater(ref.read(provider.future), completion(42));
  });

  testWidgets('ref.refresh forces a provider of nullable type to refresh',
      (tester) async {
    int? value = 42;
    final provider = Provider<int?>((ref) => value);
    late WidgetRef ref;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, r, _) {
            ref = r;
            return Container();
          },
        ),
      ),
    );

    expect(ref.read(provider), 42);

    value = null;

    expect(ref.refresh(provider), null);
  });

  // testWidgets('ProviderScope allows specifying a ProviderContainer',
  //     (tester) async {
  //   final provider = FutureProvider((ref) async => 42);
  //   late WidgetRef ref;
  //   final container = createContainer(overrides: [
  //     provider.overrideWithValue(const AsyncValue.data(42)),
  //   ]);

  //   await tester.pumpWidget(
  //     UncontrolledProviderScope(
  //       container: container,
  //       child: Consumer(
  //         builder: (context, r, _) {
  //           ref = r;
  //           return Container();
  //         },
  //       ),
  //     ),
  //   );

  //   expect(ref.read(provider), const AsyncValue.data(42));
  // });

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

    await tester.pumpWidget(
      ProviderScope(
        child: Container(),
      ),
    );

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [provider],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('removing overrides throws', (tester) async {
    final provider = Provider((_) => 0);

    final consumer = Consumer(
      builder: (context, ref, _) {
        return Text(
          ref.watch(provider).toString(),
          textDirection: TextDirection.ltr,
        );
      },
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [provider],
        child: consumer,
      ),
    );

    expect(find.text('0'), findsOneWidget);

    await tester.pumpWidget(ProviderScope(child: consumer));

    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('override origin mismatch throws', (tester) async {
    final provider = Provider((_) => 0);
    final provider2 = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [provider],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [provider2],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('throws if no ProviderScope found', (tester) async {
    final provider = Provider((_) => 'foo');

    await tester.pumpWidget(
      Consumer(
        builder: (context, ref, _) {
          ref.watch(provider);
          return Container();
        },
      ),
    );

    expect(
      tester.takeException(),
      isA<StateError>()
          .having((e) => e.message, 'message', 'No ProviderScope found'),
    );
  });

  testWidgets('providers can be overridden', (tester) async {
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
          provider.overrideWithValue('override'),
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
          provider.overrideWithValue('rootOverride'),
        ],
        child: ProviderScope(
          child: Consumer(
            builder: (c, ref, _) {
              final first = ref.watch(provider);
              final second = ref.watch(provider2);
              return Text(
                '$first $second',
                textDirection: TextDirection.ltr,
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('root root2'), findsNothing);
    expect(find.text('rootOverride root2'), findsOneWidget);
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

  group('ProviderScope.containerOf', () {
    testWidgets('throws if no container is found independently from `listen`',
        (tester) async {
      await tester.pumpWidget(Container());

      final context = tester.element(find.byType(Container));

      expect(
        () => ProviderScope.containerOf(context, listen: false),
        throwsStateError,
      );
      expect(
        () => ProviderScope.containerOf(context),
        throwsStateError,
      );
    });
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
              final count = ref.watch(counterProvider);
              return Text('$count');
            },
          ),
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    container.read(counterProvider.notifier).state++;
    await tester.pump();

    expect(find.text('1'), findsOneWidget);

    // ignore: unawaited_futures
    key.currentState!.pushReplacement<void, void>(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) {
          return Consumer(
            builder: (context, ref, _) {
              final count = ref.watch(counterProvider);
              return Text('new $count');
            },
          );
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('1'), findsNothing);
    expect(find.text('new 0'), findsNothing);
    expect(find.text('new 1'), findsOneWidget);
  });
}

class InitState extends ConsumerStatefulWidget {
  const InitState({super.key, required this.initState});

  // ignore: diagnostic_describe_all_properties
  final void Function(BuildContext context, WidgetRef ref) initState;

  @override
  // ignore: library_private_types_in_public_api
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
