// ignore_for_file: avoid_types_on_closure_parameters

import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

void main() {
  tearDown(() {
    RiverpodBinding.debugInstance.containers = {};
    stopSpyPostEvent();
  });

  test('should add container to containers map', () {
    final firstContainer = ProviderContainer();
    final secondContainer = ProviderContainer();

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
    final firstContainer = ProviderContainer();
    final secondContainer = ProviderContainer();
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
      predicate(
        (_) => containerNodes.isEqualTo(
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
      ),
    );
  });

  test('should get provider with contanerId and providerId', () {
    final container = ProviderContainer();
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
      predicate(
        (RiverpodNode node) => node.isEqualTo(
          RiverpodNode(
            id: secondProviderId,
            containerId: container.debugId,
            type: secondProvider.runtimeType.toString(),
            mightBeOutdated: false,
            name: 'secondProvider',
            state: Result<dynamic>.data('some other string'),
          ),
        ),
      ),
    );
  });

  test('should send debug event when provider list changes', () {
    final spy = spyPostEvent();
    final container = ProviderContainer();
    final provider = Provider((_) => 'some string');
    container.read(provider);

    expect(
      spy.logs.last,
      isA<PostEventCall>()
          .having(
            (p) => p.eventKind,
            'eventKind',
            equals('riverpod:provider_list_changed'),
          )
          .having(
            (p) => p.event,
            'event',
            equals({'container_id': container.debugId}),
          ),
    );
  });

  test('should send debug event when container list changes', () {
    final spy = spyPostEvent();
    ProviderContainer();

    expect(
      spy.logs.last,
      isA<PostEventCall>().having(
        (p) => p.eventKind,
        'eventKind',
        equals('riverpod:container_list_changed'),
      ),
    );
  });

  test('should send debug event on provider listened', () {
    final spy = spyPostEvent();
    final container = ProviderContainer();
    final provider = Provider((_) => 'some string');

    container.listen(provider, (previous, next) {});

    final providerId = container.debugIdForProvider(provider);

    expect(
      spy.logs.last,
      isA<PostEventCall>()
          .having(
            (p) => p.eventKind,
            'eventKind',
            equals('riverpod:provider_changed'),
          )
          .having(
            (p) => p.event,
            'event',
            equals({
              'container_id': container.debugId,
              'provider_id': providerId,
            }),
          ),
    );
  });
}

extension on Map<String, ContainerNode> {
  bool isEqualTo(Map<String, ContainerNode> other) {
    return entries.fold(
      true,
      (previousValue, entry) {
        return entry.value.isEqualTo(other[entry.key]!);
      },
    );
  }
}

extension on ContainerNode {
  bool isEqualTo(ContainerNode other) {
    final areRiverpodNodesEqual = riverpodNodes.entries.fold(
      true,
      (previousValue, entry) {
        return entry.value.isEqualTo(other.riverpodNodes[entry.key]!);
      },
    );
    return id == other.id && areRiverpodNodesEqual;
  }
}

extension on RiverpodNode {
  bool isEqualTo(RiverpodNode other) {
    return id == other.id &&
        containerId == other.containerId &&
        name == other.name &&
        state?.stateOrNull == other.state?.stateOrNull &&
        type == other.type &&
        mightBeOutdated == other.mightBeOutdated;
  }
}

extension on ProviderContainer {
  String debugIdForProvider(ProviderBase provider) {
    return getAllProviderElements()
        .firstWhere((element) => element.origin == provider)
        .debugId;
  }
}
