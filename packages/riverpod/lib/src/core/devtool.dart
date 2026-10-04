part of '../framework.dart';

/// A flag to control whether Riverpod should track the [StackTrace] of providers
/// when they are created.
///
/// This is used by the devtool to enable navigating to the source of a provider.
///
/// No-op in release mode.
/// Defaults to `false` as this can slow down provider creation.
///
/// To use, set to `true` before using any provider:
///
/// ```dart
/// void main() {
///   debugTrackProviderCreation = true;
///   // Use Riverpod as normal
/// }
/// ```
///
/// Make sure to hot-restart your application after changing this flag.
/// The devtool should then automatically pick up the stack trace of providers.
bool debugTrackProviderCreation = false;

/// Whether Riverpod retains previous frames for time-travel debugging.
///
/// Defaults to `false`: only a snapshot of currently mounted providers is kept.
/// Set this to `true` before creating providers to record their entire history,
/// or enable it later to record from the current snapshot onwards.
/// Recording history retains provider states in memory. Set this back to `false`
/// to release that history. This flag has no effect in release mode.
bool get debugTrackProviderHistory => _debugTrackProviderHistory;
bool _debugTrackProviderHistory = false;
set debugTrackProviderHistory(bool value) {
  if (_debugTrackProviderHistory == value) return;
  _debugTrackProviderHistory = value;
  if (kDebugMode && !value) {
    RiverpodDevtool.instance._compactFrames();
    RiverpodDevtool.instance.clearFrameCache();
  }
  if (kDebugMode) debugPostEvent(NewEventNotification(0));
}

@internal
void inspectInIDE(Object? obj) {
  dev.inspect(obj);
}

@internal
void openInIDE({required String uri, required int line, required int column}) {
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
  final firstNonRiverpodFrame = trace.frames
      .where(
        (frame) =>
            !_riverpodPackages.contains(frame.package) &&
            !frame.uri.path.endsWith('.g.dart'),
      )
      .firstOrNull;
  if (firstNonRiverpodFrame == null) return null;

  final newTrace = Trace([firstNonRiverpodFrame]);

  return newTrace.vmTrace.toString();
}

@internal
class RiverpodDevtool {
  RiverpodDevtool._();
  static final instance = RiverpodDevtool._();

  Frame? _pendingFrame;
  final _pendingFrameSchedulers = <ProviderScheduler>{};

  final _uniqueOrigins = Expando<String>();
  final _origins = <OriginId, WeakReference<ProviderOrFamily>>{};
  final _uniqueProviders = Expando<String>();
  final frames = <Frame>[];

  /// How long exported values remain available without a DevTools heartbeat.
  static const sessionLeaseDuration = Duration(seconds: 30);

  final _sessions = <String, _DevtoolSession>{};
  _DevtoolSession? _encodingSession;

  String openSession() {
    final id = const Uuid().v4();
    _sessions[id] = _DevtoolSession(id, () => closeSession(id));
    return id;
  }

  bool renewSession(String id) {
    final session = _sessions[id];
    if (session == null) return false;
    session.renew();
    return true;
  }

  void closeSession(String id) => _sessions.remove(id)?.dispose();

  _DevtoolSession _session(String id) {
    return _sessions[id] ??
        (throw StateError('Riverpod devtool session expired'));
  }

  void validateSession(String id) => _session(id);

  String _sessionIdForKey(String key) => key.split(':').first;

  void deleteCache(String key) {
    // Deletion is harmless after a session has expired or already been closed.
    _sessions[_sessionIdForKey(key)]?.cache.remove(key);
  }

  Object? getCache(String key) {
    final session = _session(_sessionIdForKey(key));
    if (session.cache.containsKey(key)) return session.cache[key];
    if (session.frameCache.containsKey(key)) return session.frameCache[key];
    throw StateError('The inspected value is no longer retained: $key');
  }

  String cache(Object? obj, {required String sessionId}) {
    final session = _session(sessionId);
    final key = '$sessionId:${const Uuid().v4()}';
    session.cache[key] = obj;
    return key;
  }

  // Generated serializers run synchronously within their client's session.
  String cacheFrame(Object? obj) {
    final session = _encodingSession;
    if (session == null) {
      throw StateError('Frame serialization needs a session');
    }
    return session.cacheFrame(obj);
  }

  T withFrameCache<T>(String sessionId, T Function() encode) {
    if (_encodingSession != null) {
      throw StateError('Nested frame serialization');
    }
    final session = _encodingSession = _session(sessionId);
    try {
      return session.withFrameCache(encode);
    } finally {
      _encodingSession = null;
    }
  }

  void clearFrameCache() {
    for (final session in _sessions.values) {
      session.clearFrameCache();
    }
  }

  void addEvent(ProviderContainer container, Event event) {
    if (_pendingFrame == null) {
      final newFrame = _pendingFrame = Frame();

      void onFrame() {
        frames.add(newFrame);
        if (debugTrackProviderHistory) {
          newFrame.index = frames.length - 1;
        } else {
          _compactFrames();
        }
        _pendingFrame = null;

        final notification = NewEventNotification(frames.length - 1);
        debugPostEvent(notification);
      }

      // Dependent providers rebuild through the scheduler, which may wait for
      // Flutter's next frame. Publish after those updates have joined this frame.
      // Scheduler disposal completes pending futures, so final disposal events
      // are still delivered even if their container is gone.
      Future.microtask(() async {
        while (true) {
          final pending = [
            for (final scheduler in _pendingFrameSchedulers)
              ?scheduler.pendingFuture,
          ];
          if (pending.isEmpty) break;
          await Future.wait(pending);
        }
        _pendingFrameSchedulers.clear();
        onFrame();
      });
    }

    _pendingFrameSchedulers.add(container.scheduler);
    _pendingFrame!.events.add(event);
  }

  // Fold incremental events into a snapshot without retaining disposed elements
  // or obsolete states. The snapshot forms frame zero when recording is enabled.
  void _compactFrames() {
    if (frames.isEmpty) return;
    final containers = <ContainerId, ProviderContainerAddEvent>{};
    final providers = <ElementId, Event>{};
    final dependencies = <ElementId, ProviderDependencyChangeEvent>{};
    for (final frame in frames) {
      for (final event in frame.events) {
        switch (event) {
          case ProviderContainerAddEvent():
            containers[event.containerId] = event;
          case ProviderContainerDisposeEvent():
            containers.remove(event.container.id);
          case ProviderElementAddEvent(:final provider):
          case ProviderElementUpdateEvent(:final provider):
            providers[provider.elementId] = event;
          case ProviderElementDisposeEvent(:final provider):
            providers.remove(provider.elementId);
            dependencies.remove(provider.elementId);
          case ProviderDependencyChangeEvent(:final elementId):
            dependencies[elementId] = event;
        }
      }
    }
    final snapshot = Frame(timestamp: frames.last.timestamp)..index = 0;
    snapshot.events.addAll([
      ...containers.values,
      ...providers.values,
      ...dependencies.entries
          .where((entry) => providers.containsKey(entry.key))
          .map((entry) => entry.value),
    ]);
    frames
      ..clear()
      ..add(snapshot);
    _origins.removeWhere((key, value) => value.target == null);
  }

  OriginId _originId(ProviderOrFamily origin) {
    final familyOrProvider = origin.from ?? origin;
    final existing = _uniqueOrigins[familyOrProvider];
    if (existing != null) return OriginId(existing);
    final id = OriginId(_uniqueOrigins[familyOrProvider] = const Uuid().v4());
    _origins[id] = WeakReference(familyOrProvider);
    return id;
  }

  ProviderId _providerId(ProviderOrFamily origin) {
    return ProviderId(_uniqueProviders[origin] ??= const Uuid().v4());
  }

  ProviderOrFamily? originFromId(OriginId id) => _origins[id]?.target;
}

// Both kinds of exported values have a session lifetime. Frame values also
// follow snapshot replacement; terminal results are explicitly deleted by the UI.
class _DevtoolSession {
  _DevtoolSession(this.id, this.onExpire) {
    renew();
  }

  final String id;
  final void Function() onExpire;
  Timer? _expiration;
  final cache = <String, Object?>{};
  final frameCache = <String, Object?>{};
  final _frameCacheKeys = Map<Object?, String>.identity();
  Set<String>? _usedKeys;
  Set<String>? _createdKeys;

  void renew() {
    _expiration?.cancel();
    _expiration = Timer(RiverpodDevtool.sessionLeaseDuration, onExpire);
  }

  String cacheFrame(Object? obj) {
    final key = _frameCacheKeys.putIfAbsent(obj, () {
      final key = '$id:${const Uuid().v4()}';
      _createdKeys?.add(key);
      return key;
    });
    frameCache[key] = obj;
    _usedKeys?.add(key);
    return key;
  }

  T withFrameCache<T>(T Function() encode) {
    final used = _usedKeys = <String>{};
    final created = _createdKeys = <String>{};
    try {
      final result = encode();
      if (!debugTrackProviderHistory) _removeUnused(used);
      return result;
    } catch (_) {
      // A failed export must neither destroy the displayed snapshot nor retain
      // partially serialized objects across retries.
      frameCache.removeWhere((key, _) => created.contains(key));
      _frameCacheKeys.removeWhere((_, key) => created.contains(key));
      rethrow;
    } finally {
      _usedKeys = null;
      _createdKeys = null;
    }
  }

  void _removeUnused(Set<String> used) {
    frameCache.removeWhere((key, _) => !used.contains(key));
    _frameCacheKeys.removeWhere((_, key) => !used.contains(key));
  }

  void clearFrameCache() {
    frameCache.clear();
    _frameCacheKeys.clear();
  }

  void dispose() {
    _expiration?.cancel();
    cache.clear();
    clearFrameCache();
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

/// ID for specific [Provider] within a [ProviderOrFamily]
@publicInDevtools
extension type ConsumerId(String _id) {}

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
  Frame({DateTime? timestamp}) : timestamp = timestamp ?? DateTime.now();

  final DateTime timestamp;
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

@devtool
@internal
sealed class NodeMeta {}

@devtool
@internal
final class ProviderNodeMeta extends NodeMeta {
  ProviderNodeMeta(this.provider);
  final ProviderMeta provider;
}

@devtool
@internal
final class ContainerNodeMeta extends NodeMeta {
  ContainerNodeMeta(this.containerId);
  final ContainerId containerId;
}

@devtool
@internal
final class ConsumerNodeMeta extends NodeMeta {
  ConsumerNodeMeta(this.consumerId);
  final ConsumerId consumerId;
}

extension on Node {
  NodeMeta get meta {
    final that = this;
    return switch (that) {
      ProviderNode(:final element) => ProviderNodeMeta(
        ProviderMeta.from(element),
      ),
      ContainerNode(:final container) => ContainerNodeMeta(container.id),
      ConsumerNode(:final id) => ConsumerNodeMeta(id),
    };
  }
}

@devtool
@internal
class ProviderDependencyChangeEvent extends Event {
  ProviderDependencyChangeEvent(ProviderElement element)
    : elementId = element._debugId,
      dependents = ((element.dependents ?? const [])
          .map((sub) => sub.source.meta)
          .toSet()),
      weakDependents = (element.weakDependents
          .map((sub) => sub.source.meta)
          .toSet()),
      dependencies = ((element.subscriptions ?? const [])
          .map((sub) => sub.impl.source.meta)
          .cast<ProviderNodeMeta>()
          .map((e) => e.provider.elementId)
          .toSet());

  final ElementId elementId;
  final Set<NodeMeta> dependents;
  final Set<NodeMeta> weakDependents;
  final Set<ElementId> dependencies;
}

@devtool
@internal
final class ConsumerMeta {
  ConsumerMeta({
    required this.id,
    required this.hashValue,
    required this.containerId,
    required this.containerHashValue,
  });

  factory ConsumerMeta.from({
    required ConsumerId id,
    required Object buildContext,
    required ProviderContainer container,
  }) {
    return ConsumerMeta(
      id: id,
      containerId: container.id,
      hashValue: shortHash(buildContext),
      containerHashValue: shortHash(container),
    );
  }

  final ConsumerId id;
  final String hashValue;
  final ContainerId containerId;
  final String containerHashValue;
}

/// An observer who's responsible for communicating with the Riverpod devtool
@visibleForTesting
final class DevtoolObserver extends ProviderObserver {
  /// An observer who's responsible for communicating with the Riverpod devtool
  const DevtoolObserver();

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
