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

    expect(() => provider2.readOwner(owner), throwsStateError);
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

    expect(() => provider2.readOwner(owner), throwsA(isA<Error>()));
  });

  test("dispose can't dirty anything", () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final root = ProviderStateOwner();
    Object error;
    final provider2 = Provider((ref) {
      ref.onDispose(() {
        try {
          counter.increment();
        } catch (err) {
          error = err;
        }
      });
      return 0;
    });
    final owner = ProviderStateOwner(parent: root, overrides: [provider2]);

    expect(provider.state.readOwner(owner), 0);
    expect(provider2.readOwner(owner), 0);

    owner.dispose();

    expect(error, isNotNull);
  });
  test(
      'watchOwner initial read cannot update the provider and its dependencies',
      () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final owner = ProviderStateOwner();

    expect(provider.state.readOwner(owner), 0);

    Object error;
    provider.state.watchOwner(owner, (value) {
      try {
        counter.increment();
      } catch (err) {
        error = err;
      }
    });

    expect(error, isNotNull);
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
    Object error;

    expect(provider.state.readOwner(owner), 0);

    provider2.state.watchOwner(owner, (value) {
      listener(value);
      if (value > 0) {
        try {
          counter.increment();
        } catch (err) {
          error = err;
        }
      }
    });

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);

    counter.increment();
    counter2.increment();
    root.update();

    verifyNoMoreInteractions(listener);

    owner.update();

    expect(error, isNotNull);
    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);
  });

  // TODO: didUpdate cannot dirty nodes that were already traversed
  test("Computed can't dirty anything on create", () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final owner = ProviderStateOwner();
    Object error;
    final computed = Computed((read) {
      try {
        counter.increment();
      } catch (err) {
        error = err;
      }
      return 0;
    });
    final listener = Listener();

    expect(provider.state.readOwner(owner), 0);

    computed.watchOwner(owner, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(error, isNotNull);
  });
  test("Computed can't dirty anything on update", () {
    final counter = Counter();
    final provider = StateNotifierProvider((_) => counter);
    final owner = ProviderStateOwner();
    Object error;
    final computed = Computed((read) {
      final value = read(provider.state);
      try {
        if (value > 0) {
          counter.increment();
        }
      } catch (err) {
        error = err;
      }
      return value;
    });
    final listener = Listener();

    expect(provider.state.readOwner(owner), 0);

    computed.watchOwner(owner, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(error, isNull);

    counter.increment();
    verifyNoMoreInteractions(listener);

    owner.update();

    verify(listener(1));
    verifyNoMoreInteractions(listener);
    expect(error, isNotNull);
  });
}

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

class Listener extends Mock {
  void call(int value);
}
