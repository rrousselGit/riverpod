// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/* SNIPPET START */

// 一个使用 Flutter 实现和测试的计数器示例

// 我们在全局声明了一个 provider，并将在两个测试中使用它，以查看状态是否正确地重置为 `0` 。
final counterProvider = StateProvider((ref) => 0);

// 渲染当前状态和一个允许增加状态的按钮
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
      }),
    );
  }
}

void main() {
  testWidgets('update the UI when incrementing the state', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // 我们在我们的 provider 中声明的默认值是 `0`
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // 增加状态并重新渲染
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // 状态已正确增加
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('the counter state is not shared between tests', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // 状态已重置为 `0`，无需 tearDown/setUp
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
