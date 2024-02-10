// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import 'create_container.dart';

final provider = FutureProvider((_) async => 42);

void main() {
  test('Some description', () async {
    // 이 테스트에 대한 ProviderContainer를 생성합니다.
    // DO NOT: 테스트 간에 ProviderContainer를 공유하지 마세요.
    final container = createContainer();

    /* SNIPPET START */
    // TODO: 컨테이너를 사용하여 애플리케이션을 테스트합니다.
    // 기대는 비동기적이므로 "expectLater"를 사용해야 합니다.
    await expectLater(
      // "provider"대신 "provider.future"를 읽습니다.
      // 이는 비동기 provider에서 가능하며, provider의 value로 resolve되는 future를 반환합니다.
      container.read(provider.future),
      // future가 예상 값으로 resolve되는지 확인할 수 있습니다.
      // 또는 오류에 "throwsA"를 사용할 수 있습니다.
      completion('some value'),
    );
    /* SNIPPET END */
  });
}
