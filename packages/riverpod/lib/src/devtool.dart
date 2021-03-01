// ignore_for_file: public_member_api_docs

part of 'provider.dart';

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

  Map<String, ProviderContainer> _containers = {};
  Map<String, ProviderContainer> get containers => _containers;
  set containers(Map<String, ProviderContainer> value) {
    debugPostEvent('riverpod:container_list_changed');
    _containers = value;
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
