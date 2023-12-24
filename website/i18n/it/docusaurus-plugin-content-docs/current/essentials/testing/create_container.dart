import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

/// Un'utilità di test che crea un [ProviderContainer] e lo distrugge automaticamente
/// alla fine del test
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Crea un ProviderContainer, permettendo di specificare dei parametri.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // Alla fine del test, distrugge il container
  addTearDown(container.dispose);

  return container;
}
