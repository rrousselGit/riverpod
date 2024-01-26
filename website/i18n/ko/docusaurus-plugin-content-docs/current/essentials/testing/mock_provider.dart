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
    // 단위 테스트에서는 이전의 "createContainer" 유틸리티를 재사용합니다.
    final container = createContainer(
      // 모킹할 provider 목록을 지정할 수 있습니다:
      overrides: [
        // 이 경우 "exampleProvider"를 모킹하고 있습니다.
        exampleProvider.overrideWith((ref) {
          // 이 함수는 provider의 일반적인 초기화 함수입니다.
          // 일반적으로 "ref.watch"를 호출하여 초기 상태를 반환하는 곳입니다.

          // 기본값인 "Hello world"를 사용자 정의 값으로 바꾸어 보겠습니다.
          // 그러면 `exampleProvider`와 상호 작용하면 이 값이 반환됩니다.
          return 'Hello from tests';
        }),
      ],
    );

    // ProviderScope를 사용하여 위젯 테스트에서도 동일한 작업을 수행할 수 있습니다:
    await tester.pumpWidget(
      ProviderScope(
        // ProviderScopes에는 정확히 동일한 "overrides" 매개변수가 있습니다.
        overrides: [
          // 이전과 동일
          exampleProvider.overrideWith((ref) => 'Hello from tests'),
        ],
        child: const YourWidgetYouWantToTest(),
      ),
    );
    /* SNIPPET END */
  });
}
