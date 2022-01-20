// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/* SNIPPET START */

// Flutter により実装されたカウンターアプリのテスト

// グローバル定義したプロバイダを2つのテストで使用する
// テスト間でステートが正しく `0` にリセットされるかの確認

final counterProvider = StateProvider((ref) => 0);

// 現在のステートを表示し、その数字を増やす機能を持つボタンを描画
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

    // プロバイダ作成時に宣言した通りデフォルト値は `0`
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // ステートの数字を増やし、ボタンを再描画する
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // 増やしたステートの数字が正しく反映されているか
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('the counter state is not shared between tests', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // ステートは共有されないため、tearDown/setUp がなくても `0` から
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
