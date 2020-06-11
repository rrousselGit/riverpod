import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

void main() {
  test("initState can't mark dirty other provider", () {
    final provider = SetStateProvider<Object>((ref) {
      return ref;
    });
    final owner = ProviderStateOwner();
    final setStateRef =
        provider.readOwner(owner) as SetStateProviderReference<Object>;

    final provider2 = Provider((_) {
      setStateRef.state = 42;
      return 0;
    });

    expect(setStateRef, isNotNull);

    expect(errorsOf(() => provider2.readOwner(owner)), [isStateError]);
  });
  test("nested initState can't mark dirty other providers", () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final nested = Provider((_) => 0);
    final owner = ProviderStateOwner();
    final provider2 = Provider((ref) {
      ref.dependOn(nested);
      counter.increment();
      return 0;
    });

    expect(provider.state.readOwner(owner), 0);

    expect(errorsOf(() => provider2.readOwner(owner)), [
      isStateError,
      isA<Error>(),
    ]);
  });

  test("dispose can't dirty anything", () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final root = ProviderStateOwner();
    List<Object> errors;
    final provider2 = Provider((ref) {
      ref.onDispose(() => errors = errorsOf(counter.increment));
      return 0;
    });
    final owner = ProviderStateOwner(parent: root, overrides: [provider2]);

    expect(provider.state.readOwner(owner), 0);
    expect(provider2.readOwner(owner), 0);

    owner.dispose();

    expect(errors, [isStateError, isA<Error>()]);
  });
  test(
      'watchOwner initial read cannot update the provider and its dependencies',
      () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final owner = ProviderStateOwner();

    expect(provider.state.readOwner(owner), 0);

    List<Object> errors;
    provider.state.watchOwner(owner, (value) {
      errors = errorsOf(counter.increment);
    });

    expect(errors, [isA<AssertionError>(), isA<Error>()]);
  });
  test(
      'notifyListeners cannot dirty nodes that were already traversed across multiple ownwers',
      () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final root = ProviderStateOwner();
    final counter2 = Counter();
    final provider2 = StateNotifierProvider((_) => counter2);
    final owner = ProviderStateOwner(
      parent: root,
      overrides: [provider2, provider2.state],
    );
    final listener = Listener();
    List<Object> errors;

    expect(provider.state.readOwner(owner), 0);

    final sub = provider2.state.addLazyListener(
      owner,
      mayHaveChanged: () {},
      onChange: (value) {
        listener(value);
        if (value > 0) {
          errors = errorsOf(counter.increment);
        }
      },
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);

    counter.increment();
    counter2.increment();

    verifyNoMoreInteractions(listener);

    sub.flush();

    expect(errors, [isA<AssertionError>(), isA<Error>()]);
    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test("Computed can't dirty anything on create", () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final owner = ProviderStateOwner();
    List<Object> errors;
    final computed = Computed((read) {
      errors = errorsOf(counter.increment);
      return 0;
    });
    final listener = Listener();

    expect(provider.state.readOwner(owner), 0);

    computed.watchOwner(owner, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(errors, [isA<StateError>(), isA<Error>()]);
  });
  test("Computed can't dirty anything on update", () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final owner = ProviderStateOwner();
    List<Object> errors;
    final computed = Computed((read) {
      final value = read(provider.state);
      if (value > 0) {
        errors = errorsOf(counter.increment);
      }
      return value;
    });
    final listener = Listener();

    expect(provider.state.readOwner(owner), 0);

    final sub = computed.addLazyListener(
      owner,
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

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

class Listener extends Mock {
  void call(int value);
}

List<Object> errorsOf(void Function() cb) {
  final errors = <Object>[];
  runZonedGuarded(cb, (err, _) => errors.add(err));
  return [...errors];
}
