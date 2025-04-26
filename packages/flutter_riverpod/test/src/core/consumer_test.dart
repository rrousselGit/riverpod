// ignore_for_file: invalid_use_of_internal_member

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/src/internals.dart' show ProviderScopeState;
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/src/internals.dart'
    show NodeInternal, InternalProviderContainer;

class SimpleVisibility extends StatelessWidget {
  const SimpleVisibility({
    super.key,
    required this.visible,
    required this.child,
  });

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      maintainInteractivity: true,
      child: child,
    );
  }
}

void main() {
  group('_ListenManual', () {
    testWidgets('handles pause/resume', (tester) async {
      late WidgetRef ref;
      late ProviderSubscription<int> sub;
      final provider = Provider((ref) => 0);

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, r, child) {
              ref = r;
              sub = ref.listenManual(
                provider,
                (_, __) {},
              );
              return const SizedBox();
            },
          ),
        ),
      );

      final container = ProviderScope.containerOf(ref.context);
      final element = container.readProviderElement(provider);

      expect(element.isActive, true);

      sub.pause();

      expect(element.isActive, false);

      sub.resume();

      expect(element.isActive, true);
    });
  });

  group('Handles Visibility', () {
    testWidgets(
        'when adding a listener, initializes pause state based on visibility',
        (tester) async {
      final providerForVisible = Provider((ref) => 0);

      await tester.pumpWidget(
        ProviderScope(
          child: Column(
            children: [
              Consumer(
                builder: (c, ref, _) {
                  ref.listen(providerForVisible, (_, __) {});
                  ref.watch(providerForVisible);
                  ref.listenManual(providerForVisible, (_, __) {});

                  return const SizedBox();
                },
              ),
              SimpleVisibility(
                visible: false,
                child: Consumer(
                  builder: (c, ref, _) {
                    ref.listen(_provider, (_, __) {});
                    ref.watch(_provider);
                    ref.listenManual(_provider, (_, __) {});

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(Column)),
      );
      final visibleElement = container.readProviderElement(providerForVisible);
      final hiddenElement = container.readProviderElement(_provider);

      expect(
        hiddenElement.dependents,
        everyElement(
          isA<ProviderSubscription>()
              .having((e) => e.isPaused, 'isPaused', true),
        ),
      );
      expect(
        visibleElement.dependents,
        everyElement(
          isA<ProviderSubscription>()
              .having((e) => e.isPaused, 'isPaused', false),
        ),
      );
    });

    testWidgets(
        'listenManual inside life-cycles before didChangeDependencies '
        'on non-visible widgets does not paused twice', (tester) async {
      late ProviderSubscription sub;
      final widget = CallbackConsumerWidget(
        initState: (context, ref) {
          sub = ref.listenManual(_provider, (_, __) {});
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          child: SimpleVisibility(visible: false, child: widget),
        ),
      );

      sub.resume();

      expect(sub.isPaused, false);
    });

    testWidgets('when visibility changes, pause/resume listeners',
        (tester) async {
      late WidgetRef ref;
      final widget = Consumer(
        builder: (c, r, _) {
          ref = r;

          return const SizedBox();
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          child: SimpleVisibility(visible: true, child: widget),
        ),
      );

      final sub = ref.listenManual(_provider, (_, __) {});

      await tester.pumpWidget(
        ProviderScope(
          child: SimpleVisibility(visible: false, child: widget),
        ),
      );

      expect(sub.isPaused, true);

      await tester.pumpWidget(
        ProviderScope(
          child: SimpleVisibility(visible: true, child: widget),
        ),
      );

      expect(sub.isPaused, false);
    });

    testWidgets(
        'when a dependency changes but visibility does not, do not pause/resume listeners',
        (tester) async {
      late WidgetRef ref;
      final widget = Consumer(
        builder: (context, r, _) {
          // Subscribe to Theme
          Theme.of(context);
          ref = r;

          return const SizedBox();
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          child: Theme(
            data: ThemeData.dark(),
            child: SimpleVisibility(visible: false, child: widget),
          ),
        ),
      );

      final sub = ref.listenManual(_provider, (_, __) {});

      await tester.pumpWidget(
        ProviderScope(
          child: Theme(
            data: ThemeData.light(),
            child: SimpleVisibility(visible: false, child: widget),
          ),
        ),
      );

      expect(sub.isPaused, true);

      sub.resume();

      expect(sub.isPaused, false);
    });
  });

  testWidgets('Riverpod test', (tester) async {
    // Regression test for https://github.com/rrousselGit/riverpod/pull/3156

    final streamProvider = StreamProvider.autoDispose((ref) async* {});
    final provider1 = Provider.autoDispose((ref) {
      ref.keepAlive();

      ref.watch(streamProvider);
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, child) {
            ref.watch(provider1);

            return const SizedBox();
          },
        ),
      ),
    );
  });

  testWidgets('Passes key', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          key: const Key('42'),
          builder: (context, ref, _) {
            return Container();
          },
        ),
      ),
    );

    expect(find.byKey(const Key('42')), findsOneWidget);
  });

  testWidgets('Ref is unusable after dispose', (tester) async {
    late WidgetRef ref;
    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, r, child) {
            ref = r;
            return Container();
          },
        ),
      ),
    );

    await tester.pumpWidget(ProviderScope(child: Container()));

    final throwsDisposeError = throwsA(
      isA<StateError>().having(
        (e) => e.message,
        'message',
        'Cannot use "ref" after the widget was disposed.',
      ),
    );

    expect(() => ref.read(_provider), throwsDisposeError);
    expect(() => ref.watch(_provider), throwsDisposeError);
    expect(() => ref.refresh(_provider), throwsDisposeError);
    expect(() => ref.invalidate(_provider), throwsDisposeError);
    expect(() => ref.listen(_provider, (_, __) {}), throwsDisposeError);
    expect(() => ref.listenManual(_provider, (_, __) {}), throwsDisposeError);
  });

  group('WidgetRef.exists', () {
    testWidgets('simple use-case', (tester) async {
      late WidgetRef ref;
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, r, child) {
              ref = r;
              return Container();
            },
          ),
        ),
      );

      final provider = Provider((ref) => 0);

      expect(ref.exists(provider), false);
      expect(ref.exists(provider), false);

      ref.read(provider);

      expect(ref.exists(provider), true);
    });
  });

  testWidgets('WidgetRef.context exposes the BuildContext', (tester) async {
    late WidgetRef ref;

    await tester.pumpWidget(
      CallbackConsumerWidget(
        key: const Key('initState'),
        initState: (ctx, r) {
          ref = r;
        },
      ),
    );

    final consumerElement = tester.element(find.byType(CallbackConsumerWidget));

    expect(ref.context, same(consumerElement));
  });

  testWidgets('throws if listen is used outside of `build`', (tester) async {
    final provider = Provider((ref) => 0);

    await tester.pumpWidget(
      CallbackConsumerWidget(
        key: const Key('initState'),
        initState: (ctx, ref) {
          ref.listen(provider, (prev, value) {});
        },
      ),
    );

    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('works with providers that returns null', (tester) async {
    final nullProvider = Provider((ref) => null);

    Consumer(
      builder: (context, ref, _) {
        // should compile
        ref.watch(nullProvider);
        return Container();
      },
    );
  });

  testWidgets('can use "watch" inside ListView.builder', (tester) async {
    final provider = Provider((ref) => 'hello world');

    await tester.pumpWidget(
      ProviderScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Consumer(
            builder: (context, ref, _) {
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Text(ref.watch(provider));
                },
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('hello world'), findsOneWidget);
  });

  testWidgets('can extend ConsumerWidget', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyWidget()));

    expect(find.text('hello world'), findsOneWidget);
  });

  testWidgets('hot-reload forces the widget to refresh', (tester) async {
    var buildCount = 0;
    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            buildCount++;
            return Container();
          },
        ),
      ),
    );

    expect(find.byType(Container), findsOneWidget);
    expect(buildCount, 1);

    unawaited(tester.binding.reassembleApplication());
    await tester.pump();

    expect(find.byType(Container), findsOneWidget);
    expect(buildCount, 2);
  });

  testWidgets(
      'Consumer removing one of multiple listeners on a provider still listen to the provider',
      (tester) async {
    final stateProvider = StateProvider((ref) => 0, name: 'state');
    final notifier0 = TestNotifier();
    final notifier1 = TestNotifier(42);
    final provider0 = StateNotifierProvider<TestNotifier, int>(
      name: '0',
      (_) => notifier0,
    );
    final provider1 = StateNotifierProvider<TestNotifier, int>(
      name: '1',
      (_) => notifier1,
    );
    var buildCount = 0;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (c, ref, _) {
            buildCount++;
            final state = ref.watch(stateProvider);
            final value =
                state == 0 ? ref.watch(provider0) : ref.watch(provider1);

            return Text(
              '${ref.watch(provider0)} $value',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );
    final container = tester //
        .state<ProviderScopeState>(find.byType(ProviderScope))
        .container;

    container.read(provider0);
    container.read(provider1);
    final familyState0 = container.getAllProviderElements().firstWhere((p) {
      return p.provider == provider0;
    });
    final familyState1 = container.getAllProviderElements().firstWhere((p) {
      return p.provider == provider1;
    });

    expect(buildCount, 1);
    expect(familyState0.hasNonWeakListeners, true);
    expect(familyState1.hasNonWeakListeners, false);
    expect(find.text('0 0'), findsOneWidget);

    notifier0.increment();
    await tester.pump();

    expect(buildCount, 2);
    expect(find.text('1 1'), findsOneWidget);

    notifier1.increment();
    await tester.pump();

    expect(buildCount, 2);

    // changing the provider that computed is subscribed to
    container.read(stateProvider.notifier).state = 1;
    await tester.pump();

    expect(buildCount, 3);
    expect(find.text('1 43'), findsOneWidget);
    expect(familyState1.hasNonWeakListeners, true);
    expect(familyState0.hasNonWeakListeners, true);

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
    final provider0 = StateNotifierProvider<TestNotifier, int>(
      name: '0',
      (_) => notifier0,
    );
    final provider1 = StateNotifierProvider<TestNotifier, int>(
      name: '1',
      (_) => notifier1,
    );
    var buildCount = 0;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (c, ref, _) {
            buildCount++;
            final state = ref.watch(stateProvider);
            final result = state == 0 //
                ? ref.watch(provider0)
                : ref.watch(provider1);
            return Text('$result', textDirection: TextDirection.ltr);
          },
        ),
      ),
    );
    final container = tester //
        .state<ProviderScopeState>(find.byType(ProviderScope))
        .container;

    container.read(provider0);
    container.read(provider1);
    final familyState0 = container.getAllProviderElements().firstWhere((p) {
      return p.provider == provider0;
    });
    final familyState1 = container.getAllProviderElements().firstWhere((p) {
      return p.provider == provider1;
    });

    expect(buildCount, 1);
    expect(familyState0.hasNonWeakListeners, true);
    expect(familyState1.hasNonWeakListeners, false);
    expect(find.text('0'), findsOneWidget);

    notifier0.increment();
    await tester.pump();

    expect(buildCount, 2);
    expect(find.text('1'), findsOneWidget);

    notifier1.increment();
    await tester.pump();

    expect(buildCount, 2);

    // changing the provider that computed is subscribed to
    container.read(stateProvider.notifier).state = 1;
    await tester.pump();

    expect(buildCount, 3);
    expect(find.text('43'), findsOneWidget);
    expect(familyState1.hasNonWeakListeners, true);
    expect(familyState0.hasNonWeakListeners, false);

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
    final provider1 = StateNotifierProvider<TestNotifier, int>((_) {
      return notifier1;
    });
    final notifier2 = TestNotifier(42);
    final provider2 = StateNotifierProvider<TestNotifier, int>((_) {
      return notifier2;
    });
    var buildCount = 0;

    Widget build(StateNotifierProvider<TestNotifier, int> provider) {
      return ProviderScope(
        child: Consumer(
          builder: (c, ref, _) {
            buildCount++;
            final value = ref.watch(provider);
            return Text('$value', textDirection: TextDirection.ltr);
          },
        ),
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
      'multiple watch, when one of them forces rebuild, all dependencies are still flushed',
      (tester) async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider<TestNotifier, int>((_) {
      return notifier;
    });
    var callCount = 0;
    final computed = Provider<int>((ref) {
      callCount++;
      return ref.watch(provider);
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            final first = ref.watch(provider);
            final second = ref.watch(computed);
            return Text(
              '$first $second',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('0 0'), findsOneWidget);
    expect(callCount, 1);

    notifier.increment();
    await tester.pump();

    expect(find.text('1 1'), findsOneWidget);
    expect(callCount, 2);
  });

  testWidgets("don't rebuild if Provider ref't actually change",
      (tester) async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider<TestNotifier, int>((_) => notifier);
    final computed = Provider((ref) => !ref.watch(provider).isNegative);
    var buildCount = 0;
    final container = ProviderContainer.test();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (c, ref, _) {
            buildCount++;
            return Text(
              'isPositive ${ref.watch(computed)}',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('isPositive true'), findsOneWidget);
    expect(buildCount, 1);

    notifier.increment();
    await tester.pump();

    expect(find.text('isPositive true'), findsOneWidget);
    expect(buildCount, 1);

    notifier.state = -10;
    await tester.pump();

    expect(find.text('isPositive false'), findsOneWidget);
    expect(buildCount, 2);

    notifier.state = -5;
    await tester.pump();

    expect(find.text('isPositive false'), findsOneWidget);
    expect(buildCount, 2);
  });

  testWidgets('remove listener when destroying the consumer', (tester) async {
    final notifier = TestNotifier();
    final provider = StateNotifierProvider<TestNotifier, int>((_) => notifier);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            final value = ref.watch(provider);
            return Text('$value', textDirection: TextDirection.ltr);
          },
        ),
      ),
    );

    final container = tester //
        .firstState<ProviderScopeState>(find.byType(ProviderScope))
        .container;

    final state = container
        .getAllProviderElements()
        .firstWhere((s) => s.provider == provider);

    expect(state.hasNonWeakListeners, true);
    expect(find.text('0'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        child: Container(),
      ),
    );

    expect(state.hasNonWeakListeners, false);
  });

  testWidgets('Multiple providers', (tester) async {
    final notifier = TestNotifier();
    final firstProvider = StateNotifierProvider<TestNotifier, int>((_) {
      return notifier;
    });
    final notifier2 = TestNotifier();
    final secondProvider = StateNotifierProvider<TestNotifier, int>((_) {
      return notifier2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            final first = ref.watch(firstProvider);
            final second = ref.watch(secondProvider);
            return Text(
              'first $first second $second',
              textDirection: TextDirection.ltr,
            );
          },
        ),
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
    final provider = StateNotifierProvider<TestNotifier, int>((_) => notifier);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            final count = ref.watch(provider);
            return Text('$count', textDirection: TextDirection.ltr);
          },
        ),
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

  testWidgets('changing provider', (tester) async {
    final provider = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            final value = ref.watch(provider);
            return Text(
              '$value',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    final provider2 = Provider((_) => 42);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            final value = ref.watch(provider2);
            return Text(
              '$value',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('0'), findsNothing);
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('can read scoped providers', (tester) async {
    final provider = Provider((_) => 0);

    final child = Consumer(
      builder: (context, ref, _) {
        final value = ref.watch(provider);
        return Text(
          '$value',
          textDirection: TextDirection.ltr,
        );
      },
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideWithValue(42),
        ],
        child: child,
      ),
    );

    expect(find.text('42'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideWithValue(21),
        ],
        child: child,
      ),
    );

    expect(find.text('21'), findsOneWidget);
  });
}

class TestNotifier extends StateNotifier<int> {
  TestNotifier([super.initialValue = 0]);

  void increment() => state++;

  @override
  int get state;
}

final _provider = Provider((ref) => 'hello world');

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(ref.watch(_provider), textDirection: TextDirection.rtl);
  }
}

class CallbackConsumerWidget extends ConsumerStatefulWidget {
  const CallbackConsumerWidget({
    super.key,
    this.initState,
    this.didChangeDependencies,
    this.dispose,
    this.didUpdateWidget,
    this.reassemble,
  });

  final void Function(BuildContext context, WidgetRef ref)? initState;
  final void Function(BuildContext context, WidgetRef ref)?
      didChangeDependencies;
  final void Function(BuildContext context, WidgetRef ref)? dispose;
  final void Function(
    BuildContext context,
    WidgetRef ref,
    CallbackConsumerWidget oldWidget,
  )? didUpdateWidget;
  final void Function(BuildContext context, WidgetRef ref)? reassemble;

  @override
  // ignore: library_private_types_in_public_api
  _CallbackConsumerWidgetState createState() => _CallbackConsumerWidgetState();
}

class _CallbackConsumerWidgetState
    extends ConsumerState<CallbackConsumerWidget> {
  @override
  void initState() {
    super.initState();
    widget.initState?.call(context, ref);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(context, ref);
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose?.call(context, ref);
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.reassemble?.call(context, ref);
  }

  @override
  void didUpdateWidget(covariant CallbackConsumerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidget?.call(context, ref, oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
