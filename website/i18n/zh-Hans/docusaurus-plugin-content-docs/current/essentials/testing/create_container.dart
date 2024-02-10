import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

/// 一种测试工具，用于创建一个 [ProviderContainer]，
/// 并在测试结束时自动将其处置。
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // 创建一个 ProviderContainer，并可选的允许指定参数。
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // 测试结束后，处置容器。
  addTearDown(container.dispose);

  return container;
}
