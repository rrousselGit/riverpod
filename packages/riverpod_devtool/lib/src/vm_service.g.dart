// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vm_service.dart';

// **************************************************************************
// _RiverpodDevtoolGeneratorGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
/// Devtool code for [internals.Event]
sealed class Event {
  Event();

  factory Event.from(Map<String, InstanceRef> events, {required String path}) {
    final type = events['$path._type']?.valueAsString;

    switch (type) {
      case 'ProviderContainerAddEvent':
        return ProviderContainerAddEvent.from(events, path: path);

      case 'ProviderContainerDisposeEvent':
        return ProviderContainerDisposeEvent.from(events, path: path);

      case 'ProviderElementAddEvent':
        return ProviderElementAddEvent.from(events, path: path);

      case 'ProviderElementDisposeEvent':
        return ProviderElementDisposeEvent.from(events, path: path);

      case 'ProviderElementUpdateEvent':
        return ProviderElementUpdateEvent.from(events, path: path);

      default:
        throw ArgumentError('Unknown event type: $type');
    }
  }
}

/// Devtool code for [internals.Frame]
class Frame {
  Frame({required this.timestamp, required this.index, required this.events});

  factory Frame.from(Map<String, InstanceRef> $events, {required String path}) {
    _validate($events, name: 'Frame', path: path);

    final timestamp = DateTime.fromMillisecondsSinceEpoch(
      int.parse($events['$path.timestamp']!.valueAsString!),
    );
    final index = int.parse($events['$path.index']!.valueAsString!);
    final events = List.generate(
      int.parse($events['$path.events.length']!.valueAsString!),
      (i) {
        return Event.from($events, path: '$path.events[$i]');
      },
    );

    return Frame(timestamp: timestamp, index: index, events: events);
  }

  final DateTime timestamp;
  final int index;
  final List<Event> events;
}

/// Devtool code for [internals.ProviderMeta]
class ProviderMeta {
  ProviderMeta({
    required this.origin,
    required this.id,
    required this.argToStringValue,
    required this.hashValue,
    required this.containerId,
    required this.containerHashValue,
    required this.elementId,
    required this.element,
    required this.creationStackTrace,
  });

  factory ProviderMeta.from(
    Map<String, InstanceRef> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderMeta', path: path);

    final origin = OriginMeta.from($events, path: '$path.origin');
    final id = internals.ProviderId($events['$path.id']!.valueAsString!);
    final argToStringValue = List.generate(
      int.parse($events['$path.argToStringValue.length']!.valueAsString!),
      (i) => $events['$path.argToStringValue.$i']!.valueAsString!,
    ).join();
    final hashValue = List.generate(
      int.parse($events['$path.hashValue.length']!.valueAsString!),
      (i) => $events['$path.hashValue.$i']!.valueAsString!,
    ).join();
    final containerId = internals.ContainerId(
      $events['$path.containerId']!.valueAsString!,
    );
    final containerHashValue = List.generate(
      int.parse($events['$path.containerHashValue.length']!.valueAsString!),
      (i) => $events['$path.containerHashValue.$i']!.valueAsString!,
    ).join();
    final elementId = internals.ElementId(
      $events['$path.elementId']!.valueAsString!,
    );
    final element = RootCachedObject(
      CacheId($events['$path.element']!.valueAsString!),
    );
    final creationStackTrace = List.generate(
      int.parse($events['$path.creationStackTrace.length']!.valueAsString!),
      (i) => $events['$path.creationStackTrace.$i']!.valueAsString!,
    ).join();

    return ProviderMeta(
      origin: origin,
      id: id,
      argToStringValue: argToStringValue,
      hashValue: hashValue,
      containerId: containerId,
      containerHashValue: containerHashValue,
      elementId: elementId,
      element: element,
      creationStackTrace: creationStackTrace,
    );
  }

  final OriginMeta origin;
  final internals.ProviderId id;
  final String argToStringValue;
  final String hashValue;
  final internals.ContainerId containerId;
  final String containerHashValue;
  final internals.ElementId elementId;
  final RootCachedObject element;
  final String? creationStackTrace;
}

/// Devtool code for [internals.OriginMeta]
class OriginMeta {
  OriginMeta({
    required this.id,
    required this.toStringValue,
    required this.hashValue,
    required this.isFamily,
    required this.creationStackTrace,
  });

  factory OriginMeta.from(
    Map<String, InstanceRef> $events, {
    required String path,
  }) {
    _validate($events, name: 'OriginMeta', path: path);

    final id = internals.OriginId($events['$path.id']!.valueAsString!);
    final toStringValue = List.generate(
      int.parse($events['$path.toStringValue.length']!.valueAsString!),
      (i) => $events['$path.toStringValue.$i']!.valueAsString!,
    ).join();
    final hashValue = List.generate(
      int.parse($events['$path.hashValue.length']!.valueAsString!),
      (i) => $events['$path.hashValue.$i']!.valueAsString!,
    ).join();
    final isFamily = ($events['$path.isFamily']!.valueAsString! == 'true');
    final creationStackTrace = List.generate(
      int.parse($events['$path.creationStackTrace.length']!.valueAsString!),
      (i) => $events['$path.creationStackTrace.$i']!.valueAsString!,
    ).join();

    return OriginMeta(
      id: id,
      toStringValue: toStringValue,
      hashValue: hashValue,
      isFamily: isFamily,
      creationStackTrace: creationStackTrace,
    );
  }

  final internals.OriginId id;
  final String toStringValue;
  final String hashValue;
  final bool isFamily;
  final String? creationStackTrace;
}

/// Devtool code for [internals.ProviderContainerAddEvent]
class ProviderContainerAddEvent extends Event {
  ProviderContainerAddEvent({
    required this.container,
    required this.containerId,
    required this.parentIds,
  });

  factory ProviderContainerAddEvent.from(
    Map<String, InstanceRef> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderContainerAddEvent', path: path);

    final container = RootCachedObject(
      CacheId($events['$path.container']!.valueAsString!),
    );
    final containerId = internals.ContainerId(
      $events['$path.containerId']!.valueAsString!,
    );
    final parentIds = List.generate(
      int.parse($events['$path.parentIds.length']!.valueAsString!),
      (i) {
        return internals.ContainerId(
          $events['$path.parentIds[$i]']!.valueAsString!,
        );
      },
    );

    return ProviderContainerAddEvent(
      container: container,
      containerId: containerId,
      parentIds: parentIds,
    );
  }

  final RootCachedObject container;
  final internals.ContainerId containerId;
  final List<internals.ContainerId> parentIds;
}

/// Devtool code for [internals.ProviderContainerDisposeEvent]
class ProviderContainerDisposeEvent extends Event {
  ProviderContainerDisposeEvent({required this.container});

  factory ProviderContainerDisposeEvent.from(
    Map<String, InstanceRef> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderContainerDisposeEvent', path: path);

    final container = RootCachedObject(
      CacheId($events['$path.container']!.valueAsString!),
    );

    return ProviderContainerDisposeEvent(container: container);
  }

  final RootCachedObject container;
}

/// Devtool code for [internals.ProviderElementAddEvent]
class ProviderElementAddEvent extends Event {
  ProviderElementAddEvent({required this.provider, required this.state});

  factory ProviderElementAddEvent.from(
    Map<String, InstanceRef> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderElementAddEvent', path: path);

    final provider = ProviderMeta.from($events, path: '$path.provider');
    final state = ProviderStateRef.from($events, path: '$path.state');

    return ProviderElementAddEvent(provider: provider, state: state);
  }

  final ProviderMeta provider;
  final ProviderStateRef state;
}

/// Devtool code for [internals.ProviderElementDisposeEvent]
class ProviderElementDisposeEvent extends Event {
  ProviderElementDisposeEvent({required this.provider});

  factory ProviderElementDisposeEvent.from(
    Map<String, InstanceRef> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderElementDisposeEvent', path: path);

    final provider = ProviderMeta.from($events, path: '$path.provider');

    return ProviderElementDisposeEvent(provider: provider);
  }

  final ProviderMeta provider;
}

/// Devtool code for [internals.ProviderStateRef]
class ProviderStateRef {
  ProviderStateRef({required this.state});

  factory ProviderStateRef.from(
    Map<String, InstanceRef> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderStateRef', path: path);

    final state = RootCachedObject(
      CacheId($events['$path.state']!.valueAsString!),
    );

    return ProviderStateRef(state: state);
  }

  final RootCachedObject state;
}

/// Devtool code for [internals.ProviderElementUpdateEvent]
class ProviderElementUpdateEvent extends Event {
  ProviderElementUpdateEvent({required this.provider, required this.next});

  factory ProviderElementUpdateEvent.from(
    Map<String, InstanceRef> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderElementUpdateEvent', path: path);

    final provider = ProviderMeta.from($events, path: '$path.provider');
    final next = ProviderStateRef.from($events, path: '$path.next');

    return ProviderElementUpdateEvent(provider: provider, next: next);
  }

  final ProviderMeta provider;
  final ProviderStateRef next;
}
