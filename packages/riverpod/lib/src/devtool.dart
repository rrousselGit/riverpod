// ignore_for_file: public_member_api_docs

part of 'framework.dart';

@immutable
class RiverpodNode {
  const RiverpodNode({
    required this.id,
    required this.containerId,
    this.name,
    this.state,
    required this.type,
    required this.mightBeOutdated,
  });

  final String id;
  final String containerId;
  final String? name;
  final Result<dynamic>? state;
  final String type;
  final bool mightBeOutdated;

  @override
  bool operator ==(Object other) {
    return other is RiverpodNode &&
        other.id == id &&
        other.containerId == containerId &&
        other.name == name &&
        other.state?.stateOrNull == state?.stateOrNull &&
        other.type == type &&
        other.mightBeOutdated == mightBeOutdated;
  }

  @override
  int get hashCode => Object.hash(
        id,
        containerId,
        name,
        state?.stateOrNull,
        type,
        mightBeOutdated,
      );
}

@immutable
class ContainerNode {
  const ContainerNode(this.id, this.riverpodNodes);

  final String id;
  final Map<String, RiverpodNode> riverpodNodes;

  @override
  bool operator ==(Object other) {
    return other is ContainerNode &&
        other.id == id &&
        const MapEquality<String, RiverpodNode>().equals(
          other.riverpodNodes,
          riverpodNodes,
        );
  }

  @override
  int get hashCode => Object.hash(id, riverpodNodes);
}

extension on ProviderContainer {
  ContainerNode asNode(String id) {
    final riverpodNodes = {
      for (final element in getAllProviderElements())
        element.debugId: RiverpodNode(
          id: element.debugId,
          containerId: element.container.debugId,
          name: element.origin.name,
          state: element.getState(),
          type: element.origin.runtimeType.toString(),
          mightBeOutdated: element._dependencyMayHaveChanged,
        ),
    };

    return ContainerNode(id, riverpodNodes);
  }
}

void Function(
  String eventKind,
  Map<Object?, Object?> event,
)? _debugPostEventOverride;

void debugPostEvent(
  String eventKind, [
  Map<Object?, Object?> event = const {},
]) {
  if (_debugPostEventOverride != null) {
    _debugPostEventOverride!(eventKind, event);
  } else {
    developer.postEvent(eventKind, event);
  }
}

PostEventSpy spyPostEvent() {
  assert(_debugPostEventOverride == null, 'postEvent is already spied');

  final spy = PostEventSpy._();
  _debugPostEventOverride = spy._postEvent;
  return spy;
}

void stopSpyPostEvent() {
  _debugPostEventOverride = null;
}

@protected
class PostEventCall {
  PostEventCall._(this.eventKind, this.event);
  final String eventKind;
  final Map<Object?, Object?> event;
}

@protected
class PostEventSpy {
  PostEventSpy._();
  final logs = <PostEventCall>[];

  void dispose() {
    assert(
      _debugPostEventOverride == _postEvent,
      'disposed a spy different from the current spy',
    );
    _debugPostEventOverride = null;
  }

  void _postEvent(
    String eventKind,
    Map<Object?, Object?> event,
  ) {
    logs.add(PostEventCall._(eventKind, event));
  }
}

@protected
class RiverpodBinding {
  RiverpodBinding._();

  static final _instance = RiverpodBinding._();

  static RiverpodBinding get debugInstance {
    RiverpodBinding? binding;
    assert(() {
      binding = _instance;
      return true;
    }(), '');

    return binding!;
  }

  /// Used in the devtools implementation to enable/disable certain features.
  /// Should be increased whenever a change is made to this api.
  final bindingVersion = 1;

  Map<String, ProviderContainer> _containers = {};
  Map<String, ProviderContainer> get containers => _containers;

  Map<String, ContainerNode> get containerNodes => {
        for (final entry in _containers.entries)
          entry.key: entry.value.asNode(entry.key),
      };

  set containers(Map<String, ProviderContainer> value) {
    debugPostEvent('riverpod:container_list_changed');
    _containers = value;
  }

  RiverpodNode? getProvider(String containerId, String providerId) {
    return containerNodes[containerId]?.riverpodNodes[providerId];
  }

  void providerListChangedFor({required String containerId}) {
    debugPostEvent(
      'riverpod:provider_list_changed',
      {'container_id': containerId},
    );
  }

  void providerChanged({
    required String containerId,
    required String providerId,
  }) {
    debugPostEvent(
      'riverpod:provider_changed',
      {
        'container_id': containerId,
        'provider_id': providerId,
      },
    );
  }
}
