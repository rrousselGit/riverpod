import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test("initState can't mark dirty other provider", () {
    final provider = StateProvider((ref) => 0);
    final container = ProviderContainer();

    final provider2 = Provider((ref) {
      ref.read(provider).state = 42;
      return 0;
    });

    expect(container.read(provider).state, 0);

    expect(
      errorsOf(() => container.read(provider2)),
      [isStateError],
    );
  });
  test("nested initState can't mark dirty other providers", () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final nested = Provider((_) => 0);
    final container = ProviderContainer();
    final provider2 = Provider((ref) {
      ref.read(nested);
      counter.increment();
      return 0;
    });

    expect(container.read(provider.state), 0);

    expect(errorsOf(() => container.read(provider2)), [
      isStateError,
      isA<Error>(),
    ]);
  });

  test("auto dispose can't dirty anything", () async {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    List<Object> errors;
    var didDispose = false;
    final provider2 = Provider.autoDispose((ref) {
      ref.onDispose(() {
        didDispose = true;
        errors = errorsOf(counter.increment);
      });
      return 0;
    });
    final container = ProviderContainer();

    expect(container.read(provider.state), 0);
    final sub = container.listen(provider2);
    sub.close();

    await Future<void>.value();

    expect(didDispose, true);
    expect(errors, [isStateError, isA<Error>()]);
  });
  test(
      'watchOwner initial read cannot update the provider and its dependencies',
      () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final container = ProviderContainer();

    expect(container.read(provider.state), 0);

    List<Object> errors;
    provider.state.watchOwner(container, (value) {
      errors = errorsOf(counter.increment);
    });

    expect(errors, [isA<AssertionError>(), isA<Error>()]);
  });

  test("Provider can't dirty anything on create", () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final container = ProviderContainer();
    List<Object> errors;
    final computed = Provider((ref) {
      errors = errorsOf(counter.increment);
      return 0;
    });
    final listener = Listener();

    expect(container.read(provider.state), 0);

    computed.watchOwner(container, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(errors, [isA<StateError>(), isA<Error>()]);
  });
  test("Provider can't dirty anything on update", () {
    // TODO
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final container = ProviderContainer();
    List<Object> errors;
    final computed = Provider((ref) {
      final value = ref.watch(provider.state);
      if (value > 0) {
        errors = errorsOf(counter.increment);
      }
      return value;
    });
    final listener = Listener();

    expect(container.read(provider.state), 0);

    final sub = computed.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(errors, isNull);

    counter.increment();
    verifyNoMoreInteractions(listener);

    sub.flush();

    verify(listener(1));
    verifyNoMoreInteractions(listener);
    expect(errors, [isA<StateError>(), isA<Error>()]);
  });
}

class Listener extends Mock {
  void call(int value);
}
