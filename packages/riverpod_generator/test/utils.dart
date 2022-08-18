import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
  Duration? cacheTime,
  Duration? disposeDelay,
}) {
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
    cacheTime: cacheTime,
    disposeDelay: disposeDelay,
  );
  addTearDown(container.dispose);
  return container;
}
