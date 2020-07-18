import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  ProviderContainer container;
  final mayHaveChanged = MayHaveChangedMock<int>();
  final didChange = DidChangedMock<int>();

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    reset(mayHaveChanged);
    reset(didChange);
    container.dispose();
  });

  group('combining providers', () {
    StreamController<int> controller;
    final streamProvider = StreamProvider((ref) => controller.stream);

    setUp(() {
      controller = StreamController<int>(sync: true);
    });
    tearDown(() {
      controller.close();
    });

    test("read doesn't cause recomputing", () {
      var callCount = 0;
      final provider = Provider((ref) {
        callCount++;
        return ref.read(streamProvider).data?.value;
      });

      expect(callCount, 0);
      expect(container.read(provider), null);
      expect(callCount, 1);

      controller.add(42);

      expect(callCount, 1);
      expect(container.read(provider), null);
      expect(callCount, 1);
    });
    test('watch cause recomputing when dependency changes', () {
      var callCount = 0;
      final provider = Provider((ref) {
        callCount++;
        return ref.watch(streamProvider).data?.value;
      });

      expect(callCount, 0);
      expect(container.read(provider), null);
      expect(callCount, 1);

      controller.add(42);

      expect(callCount, 1);
      expect(container.read(provider), 42);
      expect(callCount, 2);
    });
    test("watch is no-op if dependency didn't change", () {
      var callCount = 0;
      final provider = Provider((ref) {
        callCount++;
        return ref.watch(streamProvider).data?.value;
      });

      expect(callCount, 0);
      expect(container.read(provider), null);
      expect(callCount, 1);

      expect(callCount, 1);
      expect(container.read(provider), null);
      expect(callCount, 1);
    });
  });

  test('re-evaluating a provider can stop listening to a dependency', () {
    final first = StateProvider((ref) => 0);
    final second = StateProvider((ref) => 0);
    final computed = Provider<String>((ref) {
      if (ref.watch(first).state == 0) {
        return ref.watch(second).state.toString();
      }
      return 'fallback';
    });
    final firstElement = container.readProviderElement(first);
    final secondElement = container.readProviderElement(second);
    final computedElement = container.readProviderElement(computed);
    final sub = container.listen(computed);

    expect(sub.read(), '0');
    expect(firstElement.dependents, {computedElement});
    expect(firstElement.hasListeners, true);
    expect(secondElement.dependents, {computedElement});
    expect(secondElement.hasListeners, true);

    container.read(first).state++;
    expect(sub.read(), 'fallback');

    expect(firstElement.dependents, {computedElement});
    expect(firstElement.hasListeners, true);
    expect(secondElement.dependents, <ProviderElement>{});
    expect(secondElement.hasListeners, false);
  });

  test('remove dependencies on dispose', () async {
    final first = StateProvider((ref) => 0);
    final computed = Provider.autoDispose((ref) {
      return ref.watch(first).state;
    });
    final firstElement = container.readProviderElement(first);
    final computedElement = container.readProviderElement(computed);
    final sub = container.listen(computed);

    expect(sub.read(), 0);
    expect(firstElement.dependents, {computedElement});
    expect(firstElement.hasListeners, true);

    sub.close();
    await Future<void>.value();

    expect(firstElement.dependents, <ProviderElement>{});
    expect(firstElement.hasListeners, false);
  });

  group('Element.listen', () {
    group('didChange', () {
      test('is called next sub.read', () {
        final counter = Counter();
        final provider = StateNotifierProvider((ref) => counter);

        final sub = container.listen(
          provider.state,
          didChange: didChange,
        );

        verifyZeroInteractions(didChange);

        counter.increment();

        verifyZeroInteractions(didChange);
        expect(sub.read(), 1);
        verifyOnly(didChange, didChange(sub));
      });
      test('is called at most once per read', () {
        final counter = Counter();
        final provider = StateNotifierProvider((ref) => counter);

        final sub = container.listen(
          provider.state,
          didChange: didChange,
        );

        verifyZeroInteractions(didChange);

        counter.increment();
        counter.increment();
        counter.increment();

        verifyZeroInteractions(didChange);
        expect(sub.read(), 3);
        verifyOnly(didChange, didChange(sub));
      });
      test('are all executed after one read call', () {
        final counter = Counter();
        final provider = StateNotifierProvider((ref) => counter);
        final didChange2 = DidChangedMock<int>();

        final sub = container.listen(
          provider.state,
          didChange: didChange,
        );
        final sub2 = container.listen(
          provider.state,
          didChange: didChange2,
        );

        counter.increment();

        verifyZeroInteractions(didChange);
        verifyZeroInteractions(didChange2);

        expect(sub.read(), 1);

        verifyOnly(didChange, didChange(sub));
        verifyOnly(didChange2, didChange2(sub2));
      });
      test('is guarded', () {
        final counter = Counter();
        final provider = StateNotifierProvider((ref) => counter);
        final didChange2 = DidChangedMock<int>();
        when(didChange(any)).thenThrow(42);
        when(didChange2(any)).thenThrow(21);

        final sub = container.listen(
          provider.state,
          didChange: didChange,
        );
        final sub2 = container.listen(
          provider.state,
          didChange: didChange2,
        );

        counter.increment();

        final errors = errorsOf(sub.read);

        verifyOnly(didChange, didChange(sub));
        verifyOnly(didChange2, didChange2(sub2));

        expect(errors, unorderedEquals(<Object>[42, 21]));
      });
    });
    group('mayHaveChanged', () {
      test('is optional', () {
        final counter = Counter();
        final counterProvider = StateNotifierProvider((ref) => counter);
        final provider = Provider((ref) => ref.watch(counterProvider.state));

        container.listen(provider);

        // Does not crash
        counter.increment();
      });
      test(
          'is synchronously after a change'
          ' without re-evaluating the provider', () {
        final counter = Counter();
        final counterProvider = StateNotifierProvider((ref) => counter);
        var callCount = 0;
        final provider = Provider((ref) {
          callCount++;
          return ref.watch(counterProvider.state);
        });

        final sub = container.listen(provider, mayHaveChanged: mayHaveChanged);

        expect(callCount, 1);
        verifyNoMoreInteractions(mayHaveChanged);

        counter.increment();

        expect(callCount, 1);
        verifyOnly(mayHaveChanged, mayHaveChanged(sub));
      });
      test(
          're-evaluating the provider with a new value calls mayHaveChanged only once',
          () {
        final counter = Counter();
        final counterProvider = StateNotifierProvider((ref) => counter);
        final provider = Provider((ref) {
          return ref.watch(counterProvider.state);
        });

        final sub = container.listen(provider, mayHaveChanged: mayHaveChanged);

        counter.increment();
        sub.read();

        verifyOnly(mayHaveChanged, mayHaveChanged(sub));
      });
      test('is called only onces after multiple changes', () {
        final counter = Counter();
        final counterProvider = StateNotifierProvider((ref) => counter);
        final provider = Provider((ref) {
          return ref.watch(counterProvider.state);
        });

        final sub = container.listen(provider, mayHaveChanged: mayHaveChanged);

        counter.increment();
        counter.increment();

        verifyOnly(mayHaveChanged, mayHaveChanged(sub));
      });
    });
    test("doesn't trow when creating a provider that failed", () {
      final provider = Provider((ref) {
        throw Error();
      });

      final sub = container.listen(provider);

      expect(sub, isA<ProviderSubscription>());
    });
    test('is guarded', () {
      final counter = Counter();
      final provider = StateNotifierProvider((ref) => counter);
      final mayHaveChanged2 = MayHaveChangedMock<int>();
      when(mayHaveChanged(any)).thenThrow(42);
      when(mayHaveChanged2(any)).thenThrow(21);

      final sub = container.listen(
        provider.state,
        mayHaveChanged: mayHaveChanged,
      );
      final sub2 = container.listen(
        provider.state,
        mayHaveChanged: mayHaveChanged2,
      );

      final errors = errorsOf(counter.increment);

      verifyOnly(mayHaveChanged, mayHaveChanged(sub));
      verifyOnly(mayHaveChanged2, mayHaveChanged2(sub2));

      expect(errors, unorderedEquals(<Object>[42, 21]));
    });
  });
  group('ProviderSubscription', () {
    test('no-longer call listeners anymore after close', () {
      final counter = Counter();
      final first = StateNotifierProvider((ref) => counter);
      final provider = Provider((ref) => ref.watch(first.state));
      final element = container.readProviderElement(provider);

      expect(element.hasListeners, false);

      final sub = container.listen(
        provider,
        mayHaveChanged: mayHaveChanged,
        didChange: didChange,
      );

      expect(element.hasListeners, true);

      sub.close();
      counter.increment();

      expect(element.hasListeners, false);
      verifyZeroInteractions(mayHaveChanged);
      verifyZeroInteractions(didChange);
    });
    group('.read', () {
      test('rethrows the exception thrown when building a provider', () {
        final error = Error();
        final provider = Provider<int>((ref) => throw error, name: 'hello');

        final sub = container.listen(provider);

        expect(
          sub.read,
          throwsA(
            isA<ProviderException>()
                .having((s) => s.exception, 'exception', error)
                .having((s) => s.provider, 'provider', provider)
                .having((s) => s.stackTrace, 'stackTrace', isA<StackTrace>())
                .having(
                  (s) => s.toString().split('\n').first,
                  'toString',
                  equalsIgnoringHashCodes(
                    'An exception was thrown while building Provider<int>#00000(name: hello).',
                  ),
                ),
          ),
        );
      });
      test('flushes the provider', () {
        final counter = Counter();
        final first = StateNotifierProvider((ref) => counter);
        final provider = Provider((ref) => ref.watch(first.state));

        final sub = container.listen(provider);

        expect(sub.read(), 0);

        counter.increment();

        expect(sub.read(), 1);
      });
    });
    group('.flush', () {
      test('initialized to true', () {
        final provider = Provider((ref) => 0);
        final sub = container.listen(provider);

        expect(sub.flush(), true);
      });
      test('updates to false after a read', () {
        final provider = Provider((ref) => 0);
        final sub = container.listen(provider);

        sub.read();

        expect(sub.flush(), false);
      });
      test('updates to true after a change', () {
        final counter = Counter();
        final provider = StateNotifierProvider((ref) => counter);

        final sub = container.listen(provider.state);

        sub.read();

        counter.increment();

        expect(sub.flush(), true);
      });
      test('flushes providers', () {
        final counter = Counter();
        final first = StateNotifierProvider((ref) => counter);
        var callCount = 0;
        final provider = Provider((ref) {
          callCount++;
          return ref.watch(first.state);
        });

        expect(callCount, 0);
        final sub = container.listen(provider);
        expect(sub.read(), 0);
        expect(callCount, 1);
        expect(sub.flush(), false);

        counter.increment();

        expect(callCount, 1);
        expect(sub.flush(), true);
        expect(callCount, 2);
      });
    });
  });
}
