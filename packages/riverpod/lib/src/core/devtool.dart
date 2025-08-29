part of '../framework.dart';

@internal
class RiverpodDevtool {
  RiverpodDevtool._();
  static final instance = RiverpodDevtool._();

  Frame? _pendingFrame;
  Timer? _pendingFrameTimer;

  Map<ProviderOrFamily, OriginId> _uniqueOrigins = {};
  Map<ProviderOrFamily, ProviderId> _uniqueProviders = {};

  final frames = <Frame>[];
  void addEvent(Event event) {
    if (_pendingFrame == null) {
      final newFrame = _pendingFrame = Frame();
      _pendingFrameTimer = Timer(Duration.zero, () {
        frames.add(newFrame);
        newFrame.index = frames.length - 1;
        _pendingFrame = null;
        _pendingFrameTimer = null;

        final notification = NewEventNotification(frames.length - 1);
        debugPostEvent(notification);
      });
    }

    _pendingFrame!.events.add(event);
  }

  OriginId _originId(ProviderOrFamily origin) {
    return _uniqueOrigins.putIfAbsent(
      origin.from ?? origin,
      () => OriginId(const Uuid().v4()),
    );
  }

  ProviderId _providerId(ProviderOrFamily origin) {
    return _uniqueProviders.putIfAbsent(
      origin,
      () => ProviderId(const Uuid().v4()),
    );
  }
}

extension type OriginId(String _id) {}
extension type ProviderId(String _id) {}

@internal
sealed class Notification {
  static Notification? fromJson(String code, Map<Object?, Object?> json) {
    switch (code) {
      case NewEventNotification.code:
        return NewEventNotification.fromJson(json);
      default:
        return null;
    }
  }

  String get name;

  Map<Object?, Object?> toJson();
}

@internal
const devtool = Object();

@internal
final class NewEventNotification extends Notification {
  NewEventNotification(this.offset);

  factory NewEventNotification.fromJson(Map<Object?, Object?> json) {
    return NewEventNotification(json['offset']! as int);
  }

  static const code = 'riverpod:new_event';

  @override
  String get name => code;

  final int offset;

  @override
  Map<Object?, Object?> toJson() => {'offset': offset};
}

@devtool
@internal
class Frame {
  final DateTime timestamp = DateTime.now();
  late final int index;
  final List<Event> events = [];
}

@devtool
@internal
sealed class Event {
  String get name => '$runtimeType';
}

@devtool
@internal
class ProviderContainerAddEvent extends Event {
  ProviderContainerAddEvent(this.container);
  final ProviderContainer container;

  ContainerId get containerId => container.id;
  late final List<ContainerId> parentIds = container.parents
      .map((e) => e.id)
      .toList();
}

@devtool
@internal
final class ProviderContainerDisposeEvent extends Event {
  ProviderContainerDisposeEvent(this.container);
  final ProviderContainer container;
}

@devtool
@internal
final class ProviderElementAddEvent extends Event {
  ProviderElementAddEvent(this.element);

  OriginId get originId => RiverpodDevtool.instance._originId(element.origin);
  ProviderId get providerId =>
      RiverpodDevtool.instance._providerId(element.origin);

  final ProviderElement element;
}

@devtool
@internal
final class ProviderElementDisposeEvent extends Event {
  ProviderElementDisposeEvent(this.element);

  OriginId get originId => RiverpodDevtool.instance._originId(element.origin);
  ProviderId get providerId =>
      RiverpodDevtool.instance._providerId(element.origin);

  final ProviderElement element;
}

@devtool
@internal
final class ProviderElementUpdateEvent extends Event {
  ProviderElementUpdateEvent(
    this.element, {
    required this.previous,
    required this.next,
  });

  OriginId get originId => RiverpodDevtool.instance._originId(element.origin);
  ProviderId get providerId =>
      RiverpodDevtool.instance._providerId(element.origin);

  final ProviderElement element;
  final Object? previous;
  final Object? next;
}

final class _DevtoolObserver extends ProviderObserver {
  const _DevtoolObserver();

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    RiverpodDevtool.instance.addEvent(
      ProviderElementAddEvent(context._element),
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    RiverpodDevtool.instance.addEvent(
      ProviderElementDisposeEvent(context._element),
    );
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    RiverpodDevtool.instance.addEvent(
      ProviderElementUpdateEvent(
        context._element,
        previous: previousValue,
        next: newValue,
      ),
    );
  }
}

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

  ContainerId get id => _debugId;
}

/* ====  */

void Function(String eventKind, Map<Object?, Object?> event)?
_debugPostEventOverride;

@internal
void debugPostEvent(Notification notification) {
  if (_debugPostEventOverride != null) {
    _debugPostEventOverride!(notification.name, notification.toJson());
  } else {
    developer.postEvent(notification.name, notification.toJson());
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
