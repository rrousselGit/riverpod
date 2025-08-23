part of '../framework.dart';

@internal
class RiverpodDevtool {
  RiverpodDevtool._();
  static final instance = RiverpodDevtool._();

  final events = <Event>[];
  void addEvent(String name, [List<Object?> items = const []]) {
    events.add(Event(name, _deflated(items), DateTime.now()));
    debugPostEvent(name, <Object?, Object?>{'offset': events.length - 1});
  }
}

@internal
class Event {
  Event(this.name, this.items, this.timestamp);
  final String name;
  final List<Object?> items;
  final DateTime timestamp;
}

List<Object?> _deflated(List<Object?> items) => items..insert(0, items.length);

@internal
extension ProviderContainerParents on ProviderContainer {
  // All the parents of this container, in order from the closest to the furthest.
  Iterable<ProviderContainer> get parents {
    final parents = <ProviderContainer>[];
    for (var node = parent; node != null; node = node.parent) {
      parents.add(node);
    }

    return parents;
  }

  String get id => _debugId;
}

/* ====  */

void Function(String eventKind, Map<Object?, Object?> event)?
_debugPostEventOverride;

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

  void _postEvent(String eventKind, Map<Object?, Object?> event) {
    logs.add(PostEventCall._(eventKind, event));
  }
}
