import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  // test(
  //     'after a state is destroyed, Owner.traverse states does not visit the state',
  //     () async {
  //   final provider = Provider.autoDispose((ref) {});
  //   final container = ProviderContainer();

  //   final sub = container.listen(provider);
  //   sub.close();

  //   await idle();

  //   expect(container.debugProviderElements, <ProviderElement>[]);
  // });

  test('setting maintainState to false destroys the state when not listener',
      () async {
    final onDispose = OnDisposeMock();
    late AutoDisposeProviderReference ref;
    final provider = Provider.autoDispose((_ref) {
      ref = _ref;
      ref.onDispose(onDispose);
      ref.maintainState = true;
    });
    final container = ProviderContainer();

    final sub = container.listen(provider, (value) {});
    sub.close();
    await container.pump();

    verifyZeroInteractions(onDispose);

    ref.maintainState = false;

    verifyZeroInteractions(onDispose);

    await container.pump();

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

    final sub = container.listen(provider, listener);
    verify(listener(42)).called(1);
    verifyNoMoreInteractions(listener);
    sub.close();
    await container.pump();

    verifyZeroInteractions(onDispose);

    value = 21;
    container.listen(provider, listener);

    verify(listener(42)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('maintainState defaults to false', () {
    late bool maintainState;
    final provider = Provider.autoDispose((ref) {
      maintainState = ref.maintainState;
      return 42;
    });
    final container = ProviderContainer();

    container.listen(provider, (value) {});

    expect(maintainState, false);
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
      ref.watch(a);
      return '42';
    });

    final subA = container.listen(a, (value) {});
    subA.close();

    final subB = container.listen(b, (value) {});
    subB.close();

    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);

    await container.pump();

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
      return ref.watch(provider);
    });
    final listener = Listener();

    var sub = container.listen(provider2, listener);

    verify(listener(42)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);

    sub.close();

    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);

    await container.pump();

    verifyNoMoreInteractions(listener);
    verifyInOrder([
      onDispose2(),
      onDispose(),
    ]);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);

    value = 21;
    sub = container.listen(provider2, listener);

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

    var subA = container.listen(a, (value) {});
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);
    subA.close();

    await container.pump();

    verify(aDispose()).called(1);
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);

    subA = container.listen(a, (value) {});
    final subB = container.listen(b, (value) {});

    subB.close();

    await container.pump();

    verify(bDispose()).called(1);
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);
  });

  test('ProviderContainer was disposed before AutoDisposer handled the dispose',
      () async {
    final container = ProviderContainer();
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    final sub = container.listen(provider, (value) {});

    verifyNoMoreInteractions(onDispose);

    sub.close();
    verifyNoMoreInteractions(onDispose);

    container.dispose();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);

    await container.pump();

    verifyNoMoreInteractions(onDispose);
  });

  test('unsub no-op if another sub is added before event-loop', () async {
    final container = ProviderContainer();
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    final sub = container.listen(provider, (value) {});

    verifyNoMoreInteractions(onDispose);

    sub.close();
    verifyNoMoreInteractions(onDispose);

    final sub2 = container.listen(provider, (value) {});

    await container.pump();

    verifyNoMoreInteractions(onDispose);

    sub2.close();
    await container.pump();

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

    final sub = container.listen(provider, (value) {});
    final sub2 = container.listen(provider, (value) {});

    verifyNoMoreInteractions(onDispose);

    sub.close();
    await container.pump();

    verifyNoMoreInteractions(onDispose);

    sub2.close();
    await container.pump();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });

  // test('unmount on container.listen(removing async {
  //   final container = ProviderContainer();
  //   final onDispose = OnDisposeMock();
  //   final unrelated = Provider((_) => 42);
  //   var value = 42;
  //   final provider = Provider.autoDispose((ref) {
  //     ref.onDispose(onDispose);
  //     return value;
  //   });
  //   final listener = Listener();

  //   expect(container.read(unrelated), 42);
  //   var removeListener = container.listen(provider, listener);

  //   expect(
  //     container.debugProviderElements,
  //     unorderedMatches(<Matcher>[
  //       isA<ProviderElement<Object?, int>>(),
  //       isA<AutoDisposeProviderElement<Object?, int>>(),
  //     ]),
  //   );
  //   verify(listener(42)).called(1);
  //   verifyNoMoreInteractions(listener);
  //   verifyNoMoreInteractions(onDispose);

  //   removeListener();

  //   verifyNoMoreInteractions(listener);
  //   verifyNoMoreInteractions(onDispose);

  //   await idle();

  //   verify(onDispose()).called(1);
  //   verifyNoMoreInteractions(listener);
  //   verifyNoMoreInteractions(onDispose);
  //   expect(container.debugProviderElements,
  //       [isA<ProviderElement<Object?, int>>()]);

  //   value = 21;
  //   removeListener = container.listen(provider, listener);

  //   verify(listener(21)).called(1);
  //   verifyNoMoreInteractions(listener);
  //   verifyNoMoreInteractions(onDispose);
  //   expect(
  //     container.debugProviderElements,
  //     unorderedMatches(<Matcher>[
  //       isA<ProviderElement<Object?, int>>(),
  //       isA<AutoDisposeProviderElement<Object?, int>>(),
  //     ]),
  //   );
  // });

  test('Do not dispose twice when ProviderContainer is disposed first',
      () async {
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return 42;
    });
    final container = ProviderContainer();

    final sub = container.listen(provider, (_) {});
    sub.close();

    container.dispose();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);

    await container.pump();

    verifyNoMoreInteractions(onDispose);
  });
}

class Listener extends Mock {
  void call(int value);
}
