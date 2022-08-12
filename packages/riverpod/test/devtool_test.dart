// ignore_for_file: avoid_types_on_closure_parameters

import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import 'matchers.dart';
import 'utils.dart';

void main() {
  tearDown(() {
    RiverpodBinding.debugInstance.containers = {};
    stopSpyPostEvent();
  });

  test('should have the right binding version', () {
    expect(RiverpodBinding.debugInstance.bindingVersion, equals(1));
  });

  test('should add container to containers map', () {
    final firstContainer = createContainer();
    final secondContainer = createContainer();

    final container = RiverpodBinding.debugInstance.containers;

    expect(
      container,
      equals({
        firstContainer.debugId: firstContainer,
        secondContainer.debugId: secondContainer,
      }),
    );
  });

  test('should map containers to ContainerNode', () {
    final firstContainer = createContainer();
    final secondContainer = createContainer();
    final stringProvider = Provider(
      (_) => 'some string',
      name: 'stringProvider',
    );
    final intProvider = Provider((_) => 10);
    firstContainer.read(stringProvider);
    secondContainer.read(intProvider);
    final stringProviderId = firstContainer.debugIdForProvider(stringProvider);
    final intProviderId = secondContainer.debugIdForProvider(intProvider);

    final containerNodes = RiverpodBinding.debugInstance.containerNodes;

    expect(
      containerNodes,
      equals(
        {
          firstContainer.debugId: ContainerNode(
            firstContainer.debugId,
            {
              stringProviderId: RiverpodNode(
                id: stringProviderId,
                containerId: firstContainer.debugId,
                name: 'stringProvider',
                state: Result<dynamic>.data('some string'),
                type: stringProvider.runtimeType.toString(),
                mightBeOutdated: false,
              )
            },
          ),
          secondContainer.debugId: ContainerNode(
            secondContainer.debugId,
            {
              intProviderId: RiverpodNode(
                id: intProviderId,
                containerId: secondContainer.debugId,
                state: Result<dynamic>.data(10),
                type: intProvider.runtimeType.toString(),
                mightBeOutdated: false,
              )
            },
          ),
        },
      ),
    );
  });

  test('should get provider with contanerId and providerId', () {
    final container = createContainer();
    final firstProvider = Provider(
      (_) => 'some string',
      name: 'firstProvider',
    );
    final secondProvider = Provider(
      (_) => 'some other string',
      name: 'secondProvider',
    );
    container.read(firstProvider);
    container.read(secondProvider);

    final secondProviderId = container.debugIdForProvider(secondProvider);

    expect(
      RiverpodBinding.debugInstance.getProvider(
        container.debugId,
        secondProviderId,
      ),
      equals(
        RiverpodNode(
          id: secondProviderId,
          containerId: container.debugId,
          type: secondProvider.runtimeType.toString(),
          mightBeOutdated: false,
          name: 'secondProvider',
          state: Result<dynamic>.data('some other string'),
        ),
      ),
    );
  });

  test('should send debug event when provider list changes', () {
    final spy = spyPostEvent();
    final container = createContainer();
    final provider = Provider((_) => 'some string');
    container.read(provider);

    expect(
      spy.logs.last,
      isPostEventCall(
        'riverpod:provider_list_changed',
        {'container_id': container.debugId},
      ),
    );
  });

  test('should send debug event when container list changes', () {
    final spy = spyPostEvent();
    createContainer();

    expect(
      spy.logs.last,
      isPostEventCall('riverpod:container_list_changed'),
    );
  });

  test('should send debug event on provider listened', () {
    final spy = spyPostEvent();
    final container = createContainer();
    final provider = Provider((_) => 'some string');

    container.listen(provider, (previous, next) {});

    final providerId = container.debugIdForProvider(provider);

    expect(
      spy.logs.last,
      isPostEventCall('riverpod:provider_changed', {
        'container_id': container.debugId,
        'provider_id': providerId,
      }),
    );
  });
}

extension on ProviderContainer {
  String debugIdForProvider(ProviderBase provider) {
    return getAllProviderElements()
        .firstWhere((element) => element.origin == provider)
        .debugId;
  }
}
