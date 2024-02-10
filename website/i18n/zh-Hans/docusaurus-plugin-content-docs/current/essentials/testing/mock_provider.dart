// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'create_container.dart';
import 'full_widget_test.dart';
import 'provider_to_mock/raw.dart';

void main() {
  testWidgets('Some description', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: YourWidgetYouWantToTest()),
    );
    /* SNIPPET START */
    // 在单元测试中，重用我们之前的 "createContainer "工具。
    final container = createContainer(
      // 我们可以指定要模拟的提供者程序列表：
      overrides: [
        // 在本例中，我们模拟的是 "exampleProvider"。
        exampleProvider.overrideWith((ref) {
          // 该函数是典型的提供者程序初始化函数。
          // 通常在此调用 "ref.watch "并返回初始状态。

          // 让我们用自定义值替换默认的 "Hello world"。
          // 然后，与 `exampleProvider` 交互时将返回此值。
          return 'Hello from tests';
        }),
      ],
    );

    // 我们还可以使用 ProviderScope 在 widget 测试中做同样的事情：
    await tester.pumpWidget(
      ProviderScope(
        // ProviderScopes 具有完全相同的 "overrides" 参数
        overrides: [
          // 和之前一样
          exampleProvider.overrideWith((ref) => 'Hello from tests'),
        ],
        child: const YourWidgetYouWantToTest(),
      ),
    );
    /* SNIPPET END */
  });
}
