import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

void main() {
  test(
      'after a state is destroyed, Owner.traverse states does not visit the state',
      () async {
    final provider = Provider.autoDispose((ref) {});
    final container = ProviderContainer();

    provider.watchOwner(container, (value) {})();

    await idle();

    expect(container.debugProviderStates, <ProviderState>[]);
  });
  test('setting maintainState to false destroys the state when not listener',
      () async {
    final onDispose = OnDisposeMock();
    AutoDisposeProviderReference ref;
    final provider = Provider.autoDispose((_ref) {
      ref = _ref;
      ref.onDispose(onDispose);
      ref.maintainState = true;
    });
    final container = ProviderContainer();

    final removeListener = provider.watchOwner(container, (value) {});
    removeListener();
    await idle();

    verifyZeroInteractions(onDispose);

    ref.maintainState = false;

    verifyZeroInteractions(onDispose);

    await idle();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });
  test("maintainState to true don't dispose the state when no-longer listened",
      () async {
    var value = 42;
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose);
      ref.maintainState = true;
      return value;
    });
    final container = ProviderContainer();
    final listener = Listener();

    final removeListener = provider.watchOwner(container, listener);
    verify(listener(42)).called(1);
    verifyNoMoreInteractions(listener);
    removeListener();
    await idle();

    verifyZeroInteractions(onDispose);

    value = 21;
    provider.watchOwner(container, listener);

    verify(listener(42)).called(1);
    verifyNoMoreInteractions(listener);
  });
  test('maintainState defaults to false', () {
    bool maintainState;
    final provider = Provider.autoDispose((ref) {
      maintainState = ref.maintainState;
      return 42;
    });
    final container = ProviderContainer();

    provider.watchOwner(container, (value) {});

    expect(maintainState, false);
  });
  test('overridable provider can be overriden by anything', () {
    final provider = Provider.autoDispose((_) => 42);
    final ProviderBase<ProviderDependency<int>, int> override = Provider((_) {
      return 21;
    });
    final container = ProviderContainer(overrides: [
      provider.overrideAs(override),
    ]);
    final listener = Listener();

    provider.watchOwner(container, listener);

    verify(listener(21)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('cross-container dispose in order', () async {
    final aDispose = OnDisposeMock();
    final a = Provider.autoDispose((ref) {
      ref.onDispose(aDispose);
      return 42;
    });
    final bDispose = OnDisposeMock();
    final b = Provider.autoDispose((ref) {
      ref.onDispose(bDispose);
      ref.dependOn(a);
      return '42';
    });
    final root = ProviderContainer();
    final container = ProviderContainer(parent: root, overrides: [b]);

    final bRemoveListener = b.watchOwner(container, (value) {});

    expect(
      container.debugProviderStates,
      [isA<AutoDisposeProviderState<String>>()],
    );
    expect(
      root.debugProviderStates,
      [isA<AutoDisposeProviderState<int>>()],
    );

    bRemoveListener();

    await idle();

    expect(container.debugProviderStates, isEmpty);
    expect(root.debugProviderStates, isEmpty);

    verifyInOrder([
      bDispose(),
      aDispose(),
    ]);
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);
  });

  test('unsub to A then make B sub to A then unsub to B disposes B before A',
      () async {
    final container = ProviderContainer();
    final aDispose = OnDisposeMock();
    final a = Provider.autoDispose((ref) {
      ref.onDispose(aDispose);
      return 42;
    });
    final bDispose = OnDisposeMock();
    final b = Provider.autoDispose((ref) {
      ref.onDispose(bDispose);
      ref.dependOn(a);
      return '42';
    });

    final aRemoveListener = a.watchOwner(container, (value) {});
    aRemoveListener();

    final bRemoveListener = b.watchOwner(container, (value) {});
    bRemoveListener();

    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);

    await idle();

    verifyInOrder([
      bDispose(),
      aDispose(),
    ]);
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);
  });

  test('chain', () async {
    final container = ProviderContainer();
    final onDispose = OnDisposeMock();
    var value = 42;
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return value;
    });
    final onDispose2 = OnDisposeMock();
    final provider2 = Provider.autoDispose((ref) {
      ref.onDispose(onDispose2);
      return ref.dependOn(provider).value;
    });
    final listener = Listener();

    var removeListener = provider2.watchOwner(container, listener);

    verify(listener(42)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);

    removeListener();

    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);

    await idle();

    verifyNoMoreInteractions(listener);
    verifyInOrder([
      onDispose2(),
      onDispose(),
    ]);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);

    value = 21;
    removeListener = provider2.watchOwner(container, listener);

    verify(listener(21)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);
  });
  test("auto dispose A then auto dispose B doesn't dispose A again", () async {
    final container = ProviderContainer();
    final aDispose = OnDisposeMock();
    final a = Provider.autoDispose((ref) {
      ref.onDispose(aDispose);
      return 42;
    });
    final bDispose = OnDisposeMock();
    final b = Provider.autoDispose((ref) {
      ref.onDispose(bDispose);
      return 42;
    });

    var aRemoveListener = a.watchOwner(container, (value) {});
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);
    aRemoveListener();

    await idle();

    verify(aDispose()).called(1);
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);

    aRemoveListener = a.watchOwner(container, (value) {});
    final bRemoveListener = b.watchOwner(container, (value) {});

    bRemoveListener();

    await idle();

    verify(bDispose()).called(1);
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);
  });

  // test("auto dispose A then auto dispose B doesn't dispose A again", () {
  //   final container = ProviderContainer();
  //   final aDispose = OnDisposeMock();
  //   final bDispose = OnDisposeMock();

  //   final a = Provider.autoDispose((ref) {
  //     ref.onDispose(aDispose);
  //     return 42;
  //   });
  //   final a = Provider.autoDispose((ref) {
  //     ref.onDispose(aDispose);
  //     return 42;
  //   });
  // });

  test('ProviderContainer was disposed before AutoDisposer handled the dispose',
      () async {
    final container = ProviderContainer();
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    final removeListener = provider.watchOwner(container, (value) {});

    verifyNoMoreInteractions(onDispose);

    removeListener();
    verifyNoMoreInteractions(onDispose);

    container.dispose();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);

    await idle();

    verifyNoMoreInteractions(onDispose);
  });
  test('unsub no-op if another sub is added before event-loop', () async {
    final container = ProviderContainer();
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    final removeListener = provider.watchOwner(container, (value) {});

    verifyNoMoreInteractions(onDispose);

    removeListener();
    verifyNoMoreInteractions(onDispose);

    final removeListener2 = provider.watchOwner(container, (value) {});

    await idle();

    verifyNoMoreInteractions(onDispose);

    removeListener2();
    await idle();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });
  test('no-op if when removing listener if there is still a listener',
      () async {
    final container = ProviderContainer();
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    final removeListener = provider.watchOwner(container, (value) {});
    final removeListener2 = provider.watchOwner(container, (value) {});

    verifyNoMoreInteractions(onDispose);

    removeListener();
    await idle();

    verifyNoMoreInteractions(onDispose);

    removeListener2();
    await idle();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });
  test('unmount on removing watchOwner', () async {
    final container = ProviderContainer();
    final onDispose = OnDisposeMock();
    final unrelated = Provider((_) => 42);
    var value = 42;
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return value;
    });
    final listener = Listener();

    expect(unrelated.readOwner(container), 42);
    var removeListener = provider.watchOwner(container, listener);

    expect(
      container.debugProviderStates,
      unorderedMatches(<Matcher>[
        isA<ProviderState<int>>(),
        isA<AutoDisposeProviderState<int>>(),
      ]),
    );
    verify(listener(42)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);

    removeListener();

    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);

    await idle();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    expect(container.debugProviderStates, [isA<ProviderState<int>>()]);

    value = 21;
    removeListener = provider.watchOwner(container, listener);

    verify(listener(21)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    expect(
      container.debugProviderStates,
      unorderedMatches(<Matcher>[
        isA<ProviderState<int>>(),
        isA<AutoDisposeProviderState<int>>(),
      ]),
    );
  });
  test('unmount on removing ref.read', () async {
    final onDispose = OnDisposeMock();
    final unrelated = Provider((_) => 42);
    var value = 42;
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return value;
    });
    final dependent = Provider((ref) => ref.dependOn(provider).value);
    final root = ProviderContainer();
    final container = ProviderContainer(parent: root, overrides: [dependent]);
    final container2 = ProviderContainer(parent: root, overrides: [dependent]);

    expect(unrelated.readOwner(container), 42);
    expect(container.ref.dependOn(dependent).value, 42);

    expect(
      root.debugProviderStates,
      unorderedMatches(<Matcher>[
        isA<ProviderState<int>>(),
        isA<AutoDisposeProviderState<int>>(),
      ]),
    );
    verifyNoMoreInteractions(onDispose);

    container.dispose();

    verifyNoMoreInteractions(onDispose);

    await idle();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
    expect(root.debugProviderStates, [isA<ProviderState<int>>()]);

    value = 21;
    expect(container2.ref.dependOn(dependent).value, 21);
    verifyNoMoreInteractions(onDispose);
    expect(
      root.debugProviderStates,
      unorderedMatches(<Matcher>[
        isA<ProviderState<int>>(),
        isA<AutoDisposeProviderState<int>>(),
      ]),
    );
  });
}

Future<void> idle() => Future<void>.value();

class OnDisposeMock extends Mock {
  void call();
}

class Listener extends Mock {
  void call(int value);
}
