import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../matrix.dart';
import '../utils.dart';

void main() {
  group('ClassProvider', () {
    notifierProviderFactory.createGroup((factory) {
      test('overrideWithBuild', () {
        final provider = factory.simpleTestProvider((ref, _) => 0);
        final overrideWithBuild =
            OverrideWithBuildMock<TestNotifier<int>, int, int>(-1);

        when(overrideWithBuild.call(any, any)).thenReturn(42);

        final container = ProviderContainer.test(
          overrides: [provider.overrideWithBuild(overrideWithBuild.call)],
        );

        verifyZeroInteractions(overrideWithBuild);

        container.read(provider);

        final [ref as Ref, notifier as TestNotifier<int>] = verify(
          overrideWithBuild.call(captureAny, captureAny),
        ).captured;

        // ignore: invalid_use_of_protected_member
        expect(ref, same(notifier.ref));

        expect(notifier.state, 42);
      });
    });
  });

  group('ClassFamily', () {
    notifierProviderFactory.createGroup((factory) {
      if (!factory.isFamily) return;

      test('overrideWithBuild', () {
        final provider = factory.simpleTestProvider((ref, _) => 0).from!;
        provider as NotifierProviderFamily<DeferredNotifier<int>, int, Object?>;

        final overrideWithBuild =
            OverrideWithBuildMock<TestNotifier<int>, int, int>(-1);

        when(overrideWithBuild.call(any, any)).thenReturn(42);

        final container = ProviderContainer.test(
          overrides: [provider.overrideWithBuild(overrideWithBuild.call)],
        );

        verifyZeroInteractions(overrideWithBuild);

        container.read(provider(0));

        final [ref as Ref, notifier as TestNotifier<int>] = verify(
          overrideWithBuild.call(captureAny, captureAny),
        ).captured;

        // ignore: invalid_use_of_protected_member
        expect(ref, same(notifier.ref));

        expect(notifier.state, 42);
      });
    });
  });

  group('FunctionalFamily', () {
    test('caches the provider per value', () {
      final family = Provider.family<String, int>((ref, a) => '$a');
      final container = ProviderContainer.test();

      expect(family(42), family(42));
      expect(container.read(family(42)), '42');

      expect(family(21), family(21));
      expect(container.read(family(21)), '21');
    });

    test('each provider updates their dependents independently', () {
      final controllers = {
        0: StreamController<String>(sync: true),
        1: StreamController<String>(sync: true),
      };
      final family = StreamProvider.family<String, int>((ref, a) {
        return controllers[a]!.stream;
      });
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<String>>();
      final listener2 = Listener<AsyncValue<String>>();

      container.listen(family(0), listener.call, fireImmediately: true);
      verify(listener(null, const AsyncValue.loading()));
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);

      container.listen(family(1), listener2.call, fireImmediately: true);
      verify(listener2(null, const AsyncValue.loading()));
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);

      controllers[0]!.add('42');

      verify(listener(const AsyncValue.loading(), const AsyncValue.data('42')));
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);

      controllers[1]!.add('21');

      verify(
        listener2(const AsyncValue.loading(), const AsyncValue.data('21')),
      );
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
    });

    test('Pass family and argument properties', () {
      final family = NotifierProvider.family<Counter, int, int>(
        (a) => Counter(),
      );
      expect(
        family(0),
        isA<NotifierProvider<Counter, int>>()
            .having((p) => p.argument, 'argument', 0)
            .having((p) => p.from, 'from', family),
      );
      expect(
        family(1),
        isA<NotifierProvider<Counter, int>>()
            .having((p) => p.from, 'from', family)
            .having((p) => p.argument, 'argument', 1),
      );
    });

    group('Provider.name', () {
      test('is directed by the family, if any', () {
        final family = Provider.family<int, int>((ref, _) => 0);

        expect(family(0).name, null);

        final family2 = Provider.family<int, int>((ref, _) => 0, name: 'name');

        expect(family2(0).name, 'name');
        expect(family2(0).toString(), equalsIgnoringHashCodes('name(0)'));

        expect(family2(1).name, 'name');
        expect(family2(1).toString(), equalsIgnoringHashCodes('name(1)'));
      });
    });

    group('FutureProvider.autoDispose.family', () {
      test('specifies `from` & `argument` for related providers', () {
        final provider = FutureProvider.autoDispose.family<int, int>(
          (ref, _) => 0,
        );

        expect(provider(0).from, provider);
        expect(provider(0).argument, 0);
      });
    });

    group('FutureProvider.family', () {
      test('specifies `from` & `argument` for related providers', () {
        final provider = FutureProvider.family<int, int>((ref, _) => 0);

        expect(provider(0).from, provider);
        expect(provider(0).argument, 0);
      });
    });

    group('StreamProvider.autoDispose.family', () {
      test('specifies `from` & `argument` for related providers', () {
        final provider = StreamProvider.autoDispose.family<int, int>(
          (ref, _) => Stream.value(0),
        );

        expect(provider(0).from, provider);
        expect(provider(0).argument, 0);
      });
    });

    group('StreamProvider.family', () {
      test('specifies `from` & `argument` for related providers', () {
        final provider = StreamProvider.family<int, int>(
          (ref, _) => Stream.value(0),
        );

        expect(provider(0).from, provider);
        expect(provider(0).argument, 0);
      });
    });
  });
}
