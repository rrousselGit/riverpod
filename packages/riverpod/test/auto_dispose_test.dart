import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

void main() {
  test(
      'after a state is destroyed, Owner.traverse states does not visit the state',
      () async {
    final provider = AutoDisposeProvider((ref) {});
    final owner = ProviderStateOwner();

    provider.watchOwner(owner, (value) {})();

    await idle();

    expect(owner.debugProviderStates, <ProviderState>[]);
  });
  test('setting maintainState to false destroys the state when not listener',
      () async {
    final onDispose = OnDisposeMock();
    AutoDisposeProviderReference ref;
    final provider = AutoDisposeProvider((_ref) {
      ref = _ref;
      ref.onDispose(onDispose);
      ref.maintainState = true;
    });
    final owner = ProviderStateOwner();

    final removeListener = provider.watchOwner(owner, (value) {});
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
    final provider = AutoDisposeProvider((ref) {
      ref.onDispose(onDispose);
      ref.maintainState = true;
      return value;
    });
    final owner = ProviderStateOwner();
    final listener = Listener();

    final removeListener = provider.watchOwner(owner, listener);
    verify(listener(42)).called(1);
    verifyNoMoreInteractions(listener);
    removeListener();
    await idle();

    verifyZeroInteractions(onDispose);

    value = 21;
    provider.watchOwner(owner, listener);

    verify(listener(42)).called(1);
    verifyNoMoreInteractions(listener);
  });
  test('maintainState defaults to false', () {
    bool maintainState;
    final provider = AutoDisposeProvider((ref) {
      maintainState = ref.maintainState;
      return 42;
    });
    final owner = ProviderStateOwner();

    provider.watchOwner(owner, (value) {});

    expect(maintainState, false);
  });
  test('overridable provider can be overriden by anything', () {
    final provider = AutoDisposeProvider((_) => 42);
    final ProviderBase<ProviderDependency<int>, int> override = Provider((_) {
      return 21;
    });
    final owner = ProviderStateOwner(overrides: [
      provider.overrideAs(override),
    ]);
    final listener = Listener();

    provider.watchOwner(owner, listener);

    verify(listener(21)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('cross-owner dispose in order', () async {
    final aDispose = OnDisposeMock();
    final a = AutoDisposeProvider((ref) {
      ref.onDispose(aDispose);
      return 42;
    });
    final bDispose = OnDisposeMock();
    final b = AutoDisposeProvider((ref) {
      ref.onDispose(bDispose);
      ref.dependOn(a);
      return '42';
    });
    final root = ProviderStateOwner();
    final owner = ProviderStateOwner(parent: root, overrides: [b]);

    final bRemoveListener = b.watchOwner(owner, (value) {});

    expect(
      owner.debugProviderStates,
      [isA<AutoDisposeProviderState<String>>()],
    );
    expect(
      root.debugProviderStates,
      [isA<AutoDisposeProviderState<int>>()],
    );

    bRemoveListener();

    await idle();

    expect(owner.debugProviderStates, isEmpty);
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
    final owner = ProviderStateOwner();
    final aDispose = OnDisposeMock();
    final a = AutoDisposeProvider((ref) {
      ref.onDispose(aDispose);
      return 42;
    });
    final bDispose = OnDisposeMock();
    final b = AutoDisposeProvider((ref) {
      ref.onDispose(bDispose);
      ref.dependOn(a);
      return '42';
    });

    final aRemoveListener = a.watchOwner(owner, (value) {});
    aRemoveListener();

    final bRemoveListener = b.watchOwner(owner, (value) {});
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
    final owner = ProviderStateOwner();
    final onDispose = OnDisposeMock();
    var value = 42;
    final provider = AutoDisposeProvider((ref) {
      ref.onDispose(onDispose);
      return value;
    });
    final onDispose2 = OnDisposeMock();
    final provider2 = AutoDisposeProvider((ref) {
      ref.onDispose(onDispose2);
      return ref.dependOn(provider).value;
    });
    final listener = Listener();

    var removeListener = provider2.watchOwner(owner, listener);

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
    removeListener = provider2.watchOwner(owner, listener);

    verify(listener(21)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);
  });
  test("auto dispose A then auto dispose B doesn't dispose A again", () async {
    final owner = ProviderStateOwner();
    final aDispose = OnDisposeMock();
    final a = AutoDisposeProvider((ref) {
      ref.onDispose(aDispose);
      return 42;
    });
    final bDispose = OnDisposeMock();
    final b = AutoDisposeProvider((ref) {
      ref.onDispose(bDispose);
      return 42;
    });

    var aRemoveListener = a.watchOwner(owner, (value) {});
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);
    aRemoveListener();

    await idle();

    verify(aDispose()).called(1);
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);

    aRemoveListener = a.watchOwner(owner, (value) {});
    final bRemoveListener = b.watchOwner(owner, (value) {});

    bRemoveListener();

    await idle();

    verify(bDispose()).called(1);
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);
  });

  // test("auto dispose A then auto dispose B doesn't dispose A again", () {
  //   final owner = ProviderStateOwner();
  //   final aDispose = OnDisposeMock();
  //   final bDispose = OnDisposeMock();

  //   final a = AutoDisposeProvider((ref) {
  //     ref.onDispose(aDispose);
  //     return 42;
  //   });
  //   final a = AutoDisposeProvider((ref) {
  //     ref.onDispose(aDispose);
  //     return 42;
  //   });
  // });

  test(
      'ProviderStateOwner was disposed before AutoDisposer handled the dispose',
      () async {
    final owner = ProviderStateOwner();
    final onDispose = OnDisposeMock();
    final provider = AutoDisposeProvider((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    final removeListener = provider.watchOwner(owner, (value) {});

    verifyNoMoreInteractions(onDispose);

    removeListener();
    verifyNoMoreInteractions(onDispose);

    owner.dispose();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);

    await idle();

    verifyNoMoreInteractions(onDispose);
  });
  test('unsub no-op if another sub is added before event-loop', () async {
    final owner = ProviderStateOwner();
    final onDispose = OnDisposeMock();
    final provider = AutoDisposeProvider((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    final removeListener = provider.watchOwner(owner, (value) {});

    verifyNoMoreInteractions(onDispose);

    removeListener();
    verifyNoMoreInteractions(onDispose);

    final removeListener2 = provider.watchOwner(owner, (value) {});

    await idle();

    verifyNoMoreInteractions(onDispose);

    removeListener2();
    await idle();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });
  test('no-op if when removing listener if there is still a listener',
      () async {
    final owner = ProviderStateOwner();
    final onDispose = OnDisposeMock();
    final provider = AutoDisposeProvider((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    final removeListener = provider.watchOwner(owner, (value) {});
    final removeListener2 = provider.watchOwner(owner, (value) {});

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
    final owner = ProviderStateOwner();
    final onDispose = OnDisposeMock();
    final unrelated = Provider((_) => 42);
    var value = 42;
    final provider = AutoDisposeProvider((ref) {
      ref.onDispose(onDispose);
      return value;
    });
    final listener = Listener();

    expect(unrelated.readOwner(owner), 42);
    var removeListener = provider.watchOwner(owner, listener);

    expect(
      owner.debugProviderStates,
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
    expect(owner.debugProviderStates, [isA<ProviderState<int>>()]);

    value = 21;
    removeListener = provider.watchOwner(owner, listener);

    verify(listener(21)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    expect(
      owner.debugProviderStates,
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
    final provider = AutoDisposeProvider((ref) {
      ref.onDispose(onDispose);
      return value;
    });
    final dependent = Provider((ref) => ref.dependOn(provider).value);
    final root = ProviderStateOwner();
    final owner = ProviderStateOwner(parent: root, overrides: [dependent]);
    final owner2 = ProviderStateOwner(parent: root, overrides: [dependent]);

    expect(unrelated.readOwner(owner), 42);
    expect(owner.ref.dependOn(dependent).value, 42);

    expect(
      root.debugProviderStates,
      unorderedMatches(<Matcher>[
        isA<ProviderState<int>>(),
        isA<AutoDisposeProviderState<int>>(),
      ]),
    );
    verifyNoMoreInteractions(onDispose);

    owner.dispose();

    verifyNoMoreInteractions(onDispose);

    await idle();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
    expect(root.debugProviderStates, [isA<ProviderState<int>>()]);

    value = 21;
    expect(owner2.ref.dependOn(dependent).value, 21);
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
