part of '../framework.dart';

@internal
class RiverpodDevtool {
  RiverpodDevtool._();
  static final instance = RiverpodDevtool._();

  final _containers = <ProviderContainer>[];
  Iterable<ProviderContainer> get containers => _containers;
  void addContainer(ProviderContainer container) => _containers.add(container);
  void removeContainer(ProviderContainer container) =>
      _containers.remove(container);

  final _elements = <ProviderElement>[];
  Iterable<ProviderElement> get elements => _elements;
  void addElement(ProviderElement element) => _elements.add(element);
  void removeElement(ProviderElement element) => _elements.remove(element);
}

/* ====  */

void Function(
  String eventKind,
  Map<Object?, Object?> event,
)? _debugPostEventOverride;

@internal
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

@internal
PostEventSpy spyPostEvent() {
  assert(_debugPostEventOverride == null, 'postEvent is already spied');

  final spy = PostEventSpy._();
  _debugPostEventOverride = spy._postEvent;
  return spy;
}

@internal
class PostEventCall {
  PostEventCall._(this.eventKind, this.event);
  final String eventKind;
  final Map<Object?, Object?> event;
}

@internal
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
