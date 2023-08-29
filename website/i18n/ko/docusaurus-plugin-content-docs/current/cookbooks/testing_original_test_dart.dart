import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */

// Dart만을 사용하여 구현된 카운터 앱을 테스트해봅시다. (플러터에 의존하지 않은 앱)

// provider를 전역변수로 선언하합니다. 그리고 만약 테스트간 상태가 `0`으로 초기화 되는것을
// 확인하기 위한 2개의 테스트를 실행해볼겁니다.

final counterProvider = StateProvider((ref) => 0);

// mockito를 사용하여 프로바이더가 notify할 때의 값을 추적하기 위한 listeners 객체를 생성합니다.
class Listener extends Mock {
  void call(int? previous, int value);
}

void main() {
  test('defaults to 0 and notify listeners when value changes', () {
    // 프로바이더를 사용하기위한 객체
    // 테스트간 공유되지 않습니다.
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    // 프로바이더를 관찰하고 값 변화를 검출합니다.
    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // 리스너는 0을 기본값으로 호출됩니다.
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);

    // 여기서 상태 값을 증가시켜 봅니다.
    container.read(counterProvider.notifier).state++;

    // 리스터는 다시 호출되고 상태 값은 1을 가집니다.
    verify(listener(0, 1)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('the counter state is not shared between tests', () {
    // 프로바이더를 사용하기 위해 다른 ProviderContainer를 사용합니다.
    // 이걸로 테스트간 상태를 재사용하지 않는것을 확인할 수 있습니다.
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // 새로운 테스트는 기본 값을 0으로 가진 상태를 출력하는 것을 확인할 수 있습니다.
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);
  });
}
