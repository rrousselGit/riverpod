// Провайдер, контролирующий текущую страницу
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

final pageIndexProvider = StateProvider<int>((ref) => 0);

// Провайдер, который определяет, может ли пользователь вернуться на
// предыдущую страницу
/* highlight-start */
final canGoToPreviousPageProvider = Provider<bool>((ref) {
/* highlight-end */
  return ref.watch(pageIndexProvider) != 0;
});

class PreviousButton extends ConsumerWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Наблюдаем за нашим провайдером
    // Наш виджет больше не определяет, можно ли вернуться на 
    // предыдущую страницу или нет
/* highlight-start */
    final canGoToPreviousPage = ref.watch(canGoToPreviousPageProvider);
/* highlight-end */

    void goToPreviousPage() {
      ref.read(pageIndexProvider.notifier).update((state) => state - 1);
    }

    return ElevatedButton(
      onPressed: canGoToPreviousPage ? goToPreviousPage : null,
      child: const Text('previous'),
    );
  }
}