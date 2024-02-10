import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/* SNIPPET START */

final counterProvider = StateProvider<int>((ref) => 0);

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Обновляем состояние провайдера, основываясь на предыдущем состоянии
          // И в итоге, мы дважды читаем значение провайдера!
          ref.read(counterProvider.notifier).state =
              ref.read(counterProvider.notifier).state + 1;
        },
      ),
    );
  }
}
