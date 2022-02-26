// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/* SNIPPET START */

// 플러터를 사용해 구현된 카운터 앱 테스트 하기

// provider를 전역변수로 선언하합니다. 그리고 만약 테스트간 상태가 `0`으로 초기화 되는것을
// 확인하기 위한 2개의 테스트를 실행해볼겁니다.
final counterProvider = StateProvider((ref) => 0);

// 현재의 상태값과 버튼을 누르면 상태가 값이 증가하는 기능을 가지는 화면을 생성합니다.
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

    // 프로바이더에서 선언한 그대로 기본값은 `0`입니다.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // ElevatedButton를 찾아 탭을 수행하여 상태를 증가시킵니다.
    // 그리고 다시 랜더링을 실행합니다.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // 상태가 적절하게 증가되어 있는지 확인합니다.
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('the counter state is not shared between tests', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // 상태가 공유되어있지 않기떄문에 다시 `0`값을 가집니다.
    // tearDown/setUp 작업이 필요없습니다.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
