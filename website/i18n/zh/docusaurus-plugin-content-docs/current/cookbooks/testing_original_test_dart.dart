import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */

// 一个使用 Dart 实现和测试的计数器示例（无依赖于 Flutter）

// 我们在全局声明了一个 provider，并将在两个测试中使用它，以查看状态是否正确地重置为 `0` 。
final counterProvider = StateProvider((ref) => 0);

// 使用 mockito 来跟踪 provider 何时通知其监听器
class Listener extends Mock {
  void call(int? previous, int value);
}

void main() {
  test('defaults to 0 and notify listeners when value changes', () {
    // 一个允许我们读取 provider 的对象
    // 不要在测试之间共享它。
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    // 监听 provider 并跟踪其变化
    container.listen<int>(
      counterProvider,
      listener,
      fireImmediately: true,
    );

    // 监听器被立即调用，值为 0，即默认值
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);

    // 我们增加状态
    container.read(counterProvider.notifier).state++;

    // 监听器再次被调用，但此时值为 1
    verify(listener(0, 1)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('the counter state is not shared between tests', () {
    // 我们使用不同的 ProviderContainer 来读取我们的 provider
    // 这可确保了测试之间没有状态被重用
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    container.listen<int>(
      counterProvider,
      listener,
      fireImmediately: true,
    );

    // 新测试正确使用了默认值：0
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);
  });
}
