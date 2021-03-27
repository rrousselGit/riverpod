import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  test('can listen to other provider', () async {
    final listen = ListenIntMock();
    final container = ProviderContainer();
    final event = StateProvider((_) => 1);
    final provider = Provider((ref) {
      ref.listenTo<StateController<int>>(event, (ctrl) {
        listen(ctrl.state);
      });

      return 0;
    });

    container.read(provider);
    verifyZeroInteractions(listen);

    container.read(event).state++;
    container.read(provider);

    await Future<void>.value();

    container.read(event).state++;
    container.read(provider);

    await Future<void>.value();

    verify(listen(2)).called(1);
    verify(listen(3)).called(1);
  });

  test('family can listen', () async {
    final listen = ListenIntMock();
    final container = ProviderContainer();
    final event = StateProvider((_) => 1);
    final provider = Provider.family<int, int>((ref, i) {
      ref.listenTo<StateController<int>>(event, (ctrl) {
        listen(ctrl.state);
      });

      return i;
    });

    container.read(provider(0));
    container.read(provider(1));
    verifyZeroInteractions(listen);

    container.read(event).state++;
    container.read(provider(0));
    container.read(provider(1));

    await Future<void>.value();

    container.read(event).state++;
    container.read(provider(0));
    container.read(provider(1));

    await Future<void>.value();

    verifyInOrder([listen(2), listen(2), listen(3), listen(3)]);
  });

  test('listenTo does not rebuild provider', () async {
    final build1 = CallCountMock();
    final build2 = CallCountMock();
    final listen = CallCountMock();
    final container = ProviderContainer();
    final event = StateProvider((_) => 0);
    final provider1 = StateNotifierProvider<StateController<int>>((ref) {
      build1();
      final stateNotifier = StateController(0);
      ref.listenTo<StateController<int>>(event, (ctrl) {
        stateNotifier.state = ctrl.state;
      });
      return stateNotifier;
    });
    final provider2 = Provider((ref) {
      build2();
      ref.listenTo<int>(provider1.state, (ctrl) {
        listen();
      });
      return 0;
    });

    container.read(provider2);

    container.read(event).state++;

    await Future<void>.value();
    await Future<void>.value();
    verify(listen()).called(1);

    container.read(event).state++;

    await Future<void>.value();
    await Future<void>.value();
    verify(listen()).called(1);

    verify(build1()).called(1);
    verify(build2()).called(1);
  });

  test('rebuild of listened will trigger listener', () async {
    final container = ProviderContainer();
    var i = 0;
    final event = Provider((_) => i);
    final provider = Provider((ref) {
      ref.listenTo(event, (state) {
        i++;
      });
      return -1;
    });

    container.read(provider);
    container.refresh(event);

    await Future<void>.value();
    expect(i, 1);
  });

  test('remove listener on dispose', () async {
    final container = ProviderContainer();
    final event = StateProvider((_) => 1);
    final provider = Provider.autoDispose((ref) {
      ref.listenTo<StateController<int>>(event, (ctrl) {});

      return 0;
    });

    final sub = container.listen(provider);

    expect(container.readProviderElement(event).hasListeners, isTrue);
    sub.close();
    await Future<void>.value();
    expect(container.readProviderElement(event).hasListeners, isFalse);
  });
}

class ListenIntMock extends Mock {
  void call(int i);
}

class CallCountMock extends Mock {
  void call();
}
