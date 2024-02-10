// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';

/* SNIPPET START */

// Счетчик, реализованный и протестированный с использованием Flutter

// Объявляем провайдер глобально.
// Используем этот провайдер в двух тестах, чтобы проверить, правильно ли
// состояние сбрасывается до нуля между тестами.

final counterProvider = StateProvider((ref) => 0);

// Отрисовывает текущее состояние и кнопку для увеличения счетчика
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer(builder: (context, ref, _) {
        final counter = ref.watch(counterProvider);
        return ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: Text('$counter'),
        );
      },),
    );
  }
}

void main() {
  testWidgets('update the UI when incrementing the state', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // `0` - значение по умолчанию, как это было объявлено в провайдере
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Увеличение счетчика и переотрисовка
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Состояние счетчика действительно увеличилось
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('the counter state is not shared between tests', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // Состояние счетчика снова стало равно `0`
    // без использования tearDown/setUp
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
