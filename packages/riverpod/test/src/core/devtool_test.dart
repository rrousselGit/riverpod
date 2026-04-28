import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

void main() {
  group('ProviderDependencyChangeEvent', () {
    test('maps weakDependents from element.weakDependents', () {
      final container = ProviderContainer.test();
      final provider = Provider((ref) => 0);
      final dependent = Provider(
        name: 'dependent',
        (ref) => ref.watch(provider),
      );
      final weakDependent = Provider(name: 'weakDependent', (ref) {
        ref.listen(provider, weak: true, (previous, value) {});
      });

      final weakSubscription = container.listen(
        provider.select((value) => value),
        weak: true,
        (previous, value) {},
      );
      container.read(dependent);
      container.read(weakDependent);

      final providerElement = container.readProviderElement(provider);
      final event = ProviderDependencyChangeEvent(providerElement);

      final dependentElement = container.readProviderElement(dependent);
      final weakDependentElement = container.readProviderElement(weakDependent);

      expect(
        event.dependents.cast<ProviderNodeMeta>().map(
          (e) => e.provider.element,
        ),
        [dependentElement],
      );
      expect(event.weakDependents, [
        isA<ContainerNodeMeta>(),
        isA<ProviderNodeMeta>().having(
          (e) => e.provider.element,
          'provider element',
          weakDependentElement,
        ),
      ]);
    });
  });
}
