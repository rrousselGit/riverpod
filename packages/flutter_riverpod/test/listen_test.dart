import 'dart:async';

import 'package:flutter/material.dart' hide Listener;
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ErrorListener;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'utils.dart';

void main() {
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
              ref.listen<int>(dep, listener);
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
                listener,
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
        if (ref.watch(isErrored.state).state) throw UnimplementedError();
        return 0;
      });
      final listener = Listener<int>();
      final errors = <Object>[];

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              ref.listen(dep, listener);
              return Container();
            },
          ),
        ),
      );

      verifyZeroInteractions(listener);
      expect(errors, isEmpty);

      final context = tester.element(find.byType(Consumer));
      final container = ProviderScope.containerOf(context);

      container.read(isErrored.state).state = true;

      await runZonedGuarded(
        () => tester.pump(),
        (err, stack) => errors.add(err),
      );

      verifyZeroInteractions(listener);
      expect(errors, [
        isA<ProviderException>()
            .having((e) => e.exception, 'exception', isUnimplementedError)
            .having((e) => e.provider, 'provider', dep),
      ]);
    });

    testWidgets(
        'when no onError is specified, selectors fallbacks to handleUncaughtError',
        (tester) async {
      final isErrored = StateProvider((ref) => false);
      final dep = Provider<int>((ref) {
        if (ref.watch(isErrored.state).state) throw UnimplementedError();
        return 0;
      });
      final listener = Listener<int>();
      final errors = <Object>[];

      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              ref.listen(dep.select((value) => value), listener);
              return Container();
            },
          ),
        ),
      );

      verifyZeroInteractions(listener);
      expect(errors, isEmpty);

      final context = tester.element(find.byType(Consumer));
      final container = ProviderScope.containerOf(context);

      container.read(isErrored.state).state = true;

      await runZonedGuarded(
        () => tester.pump(),
        (err, stack) => errors.add(err),
      );

      verifyZeroInteractions(listener);
      expect(errors, [
        isA<ProviderException>()
            .having((e) => e.exception, 'exception', isUnimplementedError)
            .having((e) => e.provider, 'provider', dep),
      ]);
    });

    testWidgets('when rebuild throws, calls onError', (tester) async {
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) {
        if (ref.watch(dep.state).state != 0) {
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
              ref.listen(provider, listener, onError: errorListener);
              return Container();
            },
          ),
        ),
      );

      verifyZeroInteractions(errorListener);
      verifyZeroInteractions(listener);

      final context = tester.element(find.byType(Consumer));
      final container = ProviderScope.containerOf(context);

      container.read(dep.state).state++;

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
        if (ref.watch(dep.state).state != 0) {
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
                listener,
                onError: errorListener,
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

      container.read(dep.state).state++;

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
