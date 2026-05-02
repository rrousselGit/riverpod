import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

final class _TestNotifier extends Notifier<int> {
  @override
  int build() => 0;
}

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

  group('generated devtool bytes', () {
    test('writes presence markers for nullable fields', () {
      final previousDebugTrackProviderCreation = debugTrackProviderCreation;
      debugTrackProviderCreation = true;
      addTearDown(
        () => debugTrackProviderCreation = previousDebugTrackProviderCreation,
      );

      final simpleProvider = Provider((ref) => 0);
      final notifierProvider = NotifierProvider<_TestNotifier, int>(
        _TestNotifier.new,
      );
      final container = ProviderContainer.test();

      container.read(simpleProvider);
      container.read(notifierProvider);

      final simpleElement = container.readProviderElement(simpleProvider);
      final notifierElement = container.readProviderElement(notifierProvider);

      final providerMetaBytes = ProviderMeta.from(
        simpleElement,
      ).toBytes(path: 'provider');
      final originMetaBytes = OriginMeta.from(
        simpleElement,
      ).toBytes(path: 'origin');
      final simpleEventBytes = ProviderElementAddEvent(
        simpleElement,
      ).toBytes(path: 'simpleEvent');
      final notifierEventBytes = ProviderElementAddEvent(
        notifierElement,
      ).toBytes(path: 'notifierEvent');

      expect(providerMetaBytes['provider.creationStackTrace.__present'], true);
      expect(originMetaBytes['origin.creationStackTrace.__present'], true);
      expect(simpleEventBytes['simpleEvent.notifier.__present'], false);
      expect(notifierEventBytes['notifierEvent.notifier.__present'], true);
    });
  });
}
