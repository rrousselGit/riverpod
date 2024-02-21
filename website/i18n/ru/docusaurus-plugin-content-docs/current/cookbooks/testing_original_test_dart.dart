import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */

// Счетчик, реализованный и протестированный с использованием Dart (без Flutter)

// Объявляем провайдер глобально.
// Используем этот провайдер в двух тестах, чтобы проверить, правильно ли
// состояние сбрасывается до нуля между тестами.

final counterProvider = StateProvider((ref) => 0);

// Используем mockito, чтобы отслеживать, когда провайдер уведомляет своих слушателей
class Listener extends Mock {
  void call(int? previous, int value);
}

void main() {
  test('defaults to 0 and notify listeners when value changes', () {
    // Объект, с помощью которого мы можем читать провайдеры
    // Не используйте один и тот же экземпляр этого
    // класса в разных тестах
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    // Наблюдение за провайдером и его изменениями
    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // listener мгновенно вызывается со значением 0 (значение по умолчанию)
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);

    // Увеличиваем значение
    container.read(counterProvider.notifier).state++;

    // listener был снова вызван, но в этот раз со значением 1
    verify(listener(0, 1)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('the counter state is not shared between tests', () {
    // Используем другой ProviderContainer для чтения наших провайдеров.
    // Таким образом мы можем убедиться, что состояние не разделяется
    // между тестами
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // Новый тест верно использует значение по умолчанию: 0
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);
  });
}
