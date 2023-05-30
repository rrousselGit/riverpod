import 'dart:async';

import 'package:flutter/material.dart' hide Listener;
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ErrorListener;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'utils.dart';

void main() {
  group('WidgetRef.listenManual', () {
    testWidgets('returns a subscription that can be used within State.dispose',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DisposeListenManual()),
      );

      // Unmounting DisposeListenManual will throw if this is not allowed
      await tester.pumpWidget(ProviderScope(child: Container()));
    });

    testWidgets('listens to changes', (tester) async {
      final provider = StateProvider((ref) => 0);
      final listener = Listener<int>();

      late WidgetRef ref;
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, r, _) {
              ref = r;
              ref.watch(provider);
              return Container();
            },
          ),
        ),
      );

      ref.listenManual(provider, listener.call);

      ref.read(provider.notifier).state++;
      verifyOnly(listener, listener(0, 1));

      await tester.pump();

      ref.read(provider.notifier).state++;
      verifyOnly(listener, listener(1, 2));
    });

    testWidgets('removes listeners on dispose', (tester) async {
      final provider = StateProvider((ref) => 0);
      final listener = Listener<int>();
      final listener2 = Listener<int>();

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

      final container = ProviderScope.containerOf(
        tester.element(find.byType(Consumer)),
      );

      ref.listenManual(provider, listener.call);
      ref.listenManual(provider, listener2.call);

      await tester.pumpWidget(ProviderScope(child: Container()));

      container.read(provider.notifier).state++;
      verifyZeroInteractions(listener);
      verifyZeroInteractions(listener2);
    });

    testWidgets('supports fireImmediately', (tester) async {
      final provider = StateProvider((ref) => 0);
      final listener = Listener<int>();

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

      ref.listenManual(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));
    });

    testWidgets('can use ProviderSubscription.read to get the current value',
        (tester) async {
      final provider = StateProvider((ref) => 0);

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

      final sub = ref.listenManual(provider, (prev, next) {});

      expect(sub.read(), 0);

      ref.read(provider.notifier).state++;

      expect(sub.read(), 1);
    });

    testWidgets('can cancel the listener early', (tester) async {
      final provider = StateProvider((ref) => 0);
      final listener = Listener<int>();

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

      final sub = ref.listenManual(provider, listener.call);

      ref.read(provider.notifier).state++;
      verifyOnly(listener, listener(0, 1));

      sub.close();

      ref.read(provider.notifier).state++;
      verifyNoMoreInteractions(listener);
    });
  });

  group('WidgetRef.listen', () {
    testWidgets('expose previous and new value on change', (tester) async {
      final container = createContainer();
      final dep = StateNotifierProvider<StateController<int>, int>(
        (ref) => StateController(0),
      );
      final listener = Listener<int>();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) {
              ref.listen<int>(dep, listener.call);
              return Container();
            },
          ),
        ),
      );

      container.read(dep.notifier).state++;

      verifyOnly(listener, listener(0, 1));
    });

    testWidgets(
        'when using selectors, `previous` is the latest notification instead of latest event',
        (tester) async {
      final container = createContainer();
      final dep = StateNotifierProvider<StateController<int>, int>(
        (ref) => StateController(0),
      );
      final listener = Listener<bool>();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) {
              ref.listen<bool>(
                dep.select((value) => value.isEven),
                listener.call,
              );
              return Container();
            },
          ),
        ),
      );

      container.read(dep.notifier).state += 2;

      verifyNoMoreInteractions(listener);

      container.read(dep.notifier).state++;

      verifyOnly(listener, listener(true, false));
    });

    testWidgets(
        'when no onError is specified, fallbacks to handleUncaughtError',
        (tester) async {
      final isErrored = StateProvider((ref) => false);
      final dep = Provider<int>((ref) {
        if (ref.watch(isErrored)) throw UnimplementedError();
        return 0;
      });
      final listener = Listener<int>();
      final errors = <Object>[];

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              runZonedGuarded(
                () => ref.listen(dep, listener.call),
                (err, stack) => errors.add(err),
              );

              return Container();
            },
          ),
        ),
      );

      verifyZeroInteractions(listener);
      expect(errors, isEmpty);

      final context = tester.element(find.byType(Consumer));
      final container = ProviderScope.containerOf(context);

      container.read(isErrored.notifier).state = true;

      await tester.pump();

      verifyZeroInteractions(listener);
      expect(errors, [isUnimplementedError]);
    });

    testWidgets(
        'when no onError is specified, selectors fallbacks to handleUncaughtError',
        (tester) async {
      final isErrored = StateProvider((ref) => false);
      final dep = Provider<int>((ref) {
        if (ref.watch(isErrored)) throw UnimplementedError();
        return 0;
      });
      final listener = Listener<int>();
      final errors = <Object>[];

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              runZonedGuarded(
                () => ref.listen(dep.select((value) => value), listener.call),
                (err, stack) => errors.add(err),
              );

              return Container();
            },
          ),
        ),
      );

      verifyZeroInteractions(listener);
      expect(errors, isEmpty);

      final context = tester.element(find.byType(Consumer));
      final container = ProviderScope.containerOf(context);

      container.read(isErrored.notifier).state = true;

      await tester.pump();

      verifyZeroInteractions(listener);
      expect(errors, [isUnimplementedError]);
    });

    testWidgets('when rebuild throws, calls onError', (tester) async {
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) {
        if (ref.watch(dep) != 0) {
          throw UnimplementedError();
        }
        return 0;
      });
      final errorListener = ErrorListener();
      final listener = Listener<int>();

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              ref.listen(provider, listener.call, onError: errorListener.call);
              return Container();
            },
          ),
        ),
      );

      verifyZeroInteractions(errorListener);
      verifyZeroInteractions(listener);

      final context = tester.element(find.byType(Consumer));
      final container = ProviderScope.containerOf(context);

      container.read(dep.notifier).state++;

      await tester.pump();

      verifyZeroInteractions(listener);
      verifyOnly(
        errorListener,
        errorListener(isUnimplementedError, any),
      );
    });

    testWidgets('when rebuild throws on selector, calls onError',
        (tester) async {
      final dep = StateProvider((ref) => 0);
      var buildCount = 0;
      final provider = Provider((ref) {
        buildCount++;
        if (ref.watch(dep) != 0) {
          throw UnimplementedError();
        }
        return 0;
      });
      final errorListener = ErrorListener();
      final listener = Listener<int>();

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              ref.listen(
                provider.select((value) => value),
                listener.call,
                onError: errorListener.call,
              );
              return Container();
            },
          ),
        ),
      );

      expect(buildCount, 1);
      verifyZeroInteractions(errorListener);
      verifyZeroInteractions(listener);

      final context = tester.element(find.byType(Consumer));
      final container = ProviderScope.containerOf(context);

      container.read(dep.notifier).state++;

      await tester.pump();

      expect(buildCount, 2);
      verifyZeroInteractions(listener);
      verifyOnly(
        errorListener,
        errorListener(isUnimplementedError, any),
      );
    });
  });
}

final _provider = Provider<String>((ref) => '');

class DisposeListenManual extends ConsumerStatefulWidget {
  const DisposeListenManual({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DisposeListenOnceState();
}

class _DisposeListenOnceState extends ConsumerState<DisposeListenManual> {
  late final ProviderSubscription<String> sub;

  @override
  void initState() {
    super.initState();
    sub = ref.listenManual(_provider, (prev, next) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    sub.read();
    super.dispose();
  }
}
