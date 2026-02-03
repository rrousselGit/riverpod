part of '../framework.dart';

@internal
void inspectInIDE(Object? obj) {
  dev.inspect(obj);
}

@internal
void openInIDE({required String uri, required int line, required int column}) {
  print('Opening in IDE: $uri:$line:$column');
  developer.postEvent('navigate', stream: 'ToolEvent', {
    'fileUri': uri,
    'line': line,
    'column': column,
    'source': 'riverpod.devtools',
  });
}

String? _stringForStackTrace(StackTrace? stackTrace) {
  if (stackTrace == null) return null;

  const _riverpodPackages = {
    'riverpod',
    'hooks_riverpod',
    'flutter_riverpod',
    'riverpod_generator',
  };

  final trace = Trace.from(stackTrace);
  final firstNonRiverpodFrame =
      trace.frames
          .where(
            (frame) =>
                !_riverpodPackages.contains(frame.package) &&
                !frame.uri.path.endsWith('.g.dart'),
          )
          .firstOrNull;

  return firstNonRiverpodFrame?.toString();
}

@internal
class RiverpodDevtool {
  RiverpodDevtool._();
  static final instance = RiverpodDevtool._();

  Frame? _pendingFrame;

  final _uniqueOrigins = <ProviderOrFamily, OriginId>{};
  final _uniqueProviders = <ProviderOrFamily, ProviderId>{};
  final frames = <Frame>[];

  final _cache = <String, Object?>{};

  void deleteCache(String key) => _cache.remove(key);
  Object? getCache(String key) => _cache[key];
  String cache(Object? obj) {
    final key = const Uuid().v4();
    _cache[key] = obj;

    return key;
  }

  void addEvent(ProviderContainer container, Event event) {
    if (_pendingFrame == null) {
      final newFrame = _pendingFrame = Frame();

      void onFrame() {
        frames.add(newFrame);
        newFrame.index = frames.length - 1;
        _pendingFrame = null;

        final notification = NewEventNotification(frames.length - 1);
        debugPostEvent(notification);
      }

      container.scheduler.debugScheduleFrame(onFrame);
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

  ProviderOrFamily? originFromId(OriginId id) {
    return _uniqueOrigins.entries
        .firstWhereOrNull((entry) => entry.value == id)
        ?.key;
  }
}

/// ID for [ProviderContainer]
@publicInDevtools
extension type ContainerId(String value) {}

/// ID for [ProviderElement]
@publicInDevtools
extension type ElementId(String value) {}

/// ID for [ProviderOrFamily] origin
@publicInDevtools
extension type OriginId(String _id) {}

/// ID for specific [Provider] within a [ProviderOrFamily]
@publicInDevtools
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
final class ProviderMeta {
  ProviderMeta({
    required this.origin,
    required this.id,
    required this.argToStringValue,
    required this.hashValue,
    required this.containerId,
    required this.elementId,
    required this.containerHashValue,
    required this.creationStackTrace,
    required this.element,
  });

  factory ProviderMeta.from(ProviderElement element) {
    final provider = element.origin;
    final providerId = RiverpodDevtool.instance._providerId(provider);

    return ProviderMeta(
      origin: OriginMeta.from(element),
      argToStringValue: provider.argument.toString(),
      hashValue: shortHash(provider),
      containerId: element.container.id,
      id: providerId,
      element: element,
      elementId: element._debugId,
      containerHashValue: shortHash(element.container),
      creationStackTrace: _stringForStackTrace(
        provider._debugCreationStackTrace,
      ),
    );
  }

  final OriginMeta origin;
  final ProviderId id;
  final String argToStringValue;
  final String hashValue;
  final ContainerId containerId;
  final String containerHashValue;
  final ElementId elementId;
  final ProviderElement element;
  final String? creationStackTrace;
}

@devtool
@internal
final class OriginMeta {
  OriginMeta({
    required this.id,
    required this.toStringValue,
    required this.isFamily,
    required this.hashValue,
    required this.creationStackTrace,
  });

  factory OriginMeta.from(ProviderElement element) {
    final provider = element.origin;
    final originId = RiverpodDevtool.instance._originId(provider);

    return OriginMeta(
      id: originId,
      toStringValue: provider.name ?? provider.runtimeType.toString(),
      hashValue: shortHash(provider.from ?? provider),
      isFamily: provider.from != null,
      creationStackTrace: _stringForStackTrace(
        (element.origin.from ?? element.origin)._debugCreationStackTrace,
      ),
    );
  }

  final OriginId id;
  final String toStringValue;
  final String hashValue;
  final bool isFamily;
  final String? creationStackTrace;
}

@devtool
@internal
sealed class Event {
  // ignore: no_runtimetype_tostring, not in production code
  String get name => '$runtimeType';
}

@devtool
@internal
class ProviderContainerAddEvent extends Event {
  ProviderContainerAddEvent(this.container);
  final ProviderContainer container;

  ContainerId get containerId => container.id;
  late final List<ContainerId> parentIds =
      container.parents.map((e) => e.id).toList();
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
  ProviderElementAddEvent(ProviderElement element)
    : provider = ProviderMeta.from(element),
      state = ProviderStateRef(state: element.stateResult()?.value),
      notifier = ProviderStateRef.notifier(element);

  final ProviderMeta provider;
  final ProviderStateRef state;
  final ProviderStateRef? notifier;
}

@devtool
@internal
final class ProviderElementDisposeEvent extends Event {
  ProviderElementDisposeEvent(ProviderElement element)
    : provider = ProviderMeta.from(element);

  final ProviderMeta provider;
}

@devtool
@internal
final class ProviderStateRef {
  ProviderStateRef({required this.state});
  static ProviderStateRef? notifier(ProviderElement element) {
    return switch (element) {
      $ClassProviderElement() => ProviderStateRef(
        state: element.classListenable.result?.value,
      ),
      _ => null,
    };
  }

  final Object? state;
}

@devtool
@internal
final class ProviderElementUpdateEvent extends Event {
  ProviderElementUpdateEvent(ProviderElement element)
    : provider = ProviderMeta.from(element),
      next = ProviderStateRef(state: element.stateResult()?.value),
      notifier = ProviderStateRef.notifier(element);

  final ProviderMeta provider;
  final ProviderStateRef next;
  final ProviderStateRef? notifier;
}

final class _DevtoolObserver extends ProviderObserver {
  const _DevtoolObserver();

  @override
  void didCreateProviderContainer(ProviderContainer container) {
    RiverpodDevtool.instance.addEvent(
      container,
      ProviderContainerAddEvent(container),
    );
  }

  @override
  void didDisposeProviderContainer(ProviderContainer container) {
    RiverpodDevtool.instance.addEvent(
      container,
      ProviderContainerDisposeEvent(container),
    );
  }

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    RiverpodDevtool.instance.addEvent(
      context.container,
      ProviderElementAddEvent(context._element),
    );
  }

  @override
  void didUnmountProvider(ProviderObserverContext context) {
    RiverpodDevtool.instance.addEvent(
      context.container,
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
      context.container,
      ProviderElementUpdateEvent(context._element),
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
