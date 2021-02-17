import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  test('can listen to other provider', () {
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

    container.read(event).state++;
    container.read(provider);

    verify(listen(2)).called(1);
    verify(listen(3)).called(1);
  });

  test('family can listen', () {
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

    container.read(event).state++;
    container.read(provider(0));
    container.read(provider(1));

    verifyInOrder([listen(2), listen(2), listen(3), listen(3)]);
  });

  test('listenTo does not rebuild provider', () {
    final build1 = CallCountMock();
    final build2 = CallCountMock();
    final listen = CallCountMock();
    final container = ProviderContainer();
    final event = StateProvider((_) => 1);
    final provider1 = Provider((ref) {
      build1();
      ref.listenTo<StateController<int>>(event, (ctrl) {
        ref.state = ctrl.state;
      });
      return 0;
    });
    final provider2 = Provider((ref) {
      build2();
      ref.listenTo<int>(provider1, (ctrl) {
        listen();
      });
      return 0;
    });

    container.read(provider2);

    container.read(event).state++;
    container.read(provider2);

    container.read(event).state++;
    container.read(provider2);

    verify(build1()).called(1);
    verify(build2()).called(1);
    verify(listen()).called(2);
  });

  test('rebuild of listened will trigger listener', () {
    final container = ProviderContainer();
    var i = 0;
    final event = Provider((_) => i);
    final provider = Provider((ref) {
      ref.listenTo(event, (state) {
        ref.state = state;
      });
      return -1;
    });

    container.read(provider);
    i++;
    container.refresh(event);
    expect(container.read(provider), 1);
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
