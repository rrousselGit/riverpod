import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

/// [ProviderContainer]를 생성하고
/// 테스트가 끝나면 자동으로 폐기하는 테스트 유틸리티입니다.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // ProviderContainer를 생성하고 선택적으로 매개변수 지정을 허용합니다.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // 테스트가 끝나면 container를 폐기합니다.
  addTearDown(container.dispose);

  return container;
}
