// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// _RiverpodDevtoolGeneratorGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
/// Devtool code for [internals.Event]
sealed class Event {
  Event();

  factory Event.from(Map<String, Byte> events, {required String path}) {
    final type = events['$path._type']!.ref.valueAsString;

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

  factory Frame.from(Map<String, Byte> $events, {required String path}) {
    _validate($events, name: 'Frame', path: path);

    final timestamp = DateTime.fromMillisecondsSinceEpoch(
      int.parse($events['$path.timestamp']!.ref.valueAsString!),
    );
    final index = int.parse($events['$path.index']!.ref.valueAsString!);
    final events = List.generate(
      int.parse($events['$path.events.length']!.ref.valueAsString!),
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
    required this.toStringValue,
    required this.hashValue,
    required this.containerId,
    required this.containerHashValue,
    required this.elementId,
  });

  factory ProviderMeta.from(Map<String, Byte> $events, {required String path}) {
    _validate($events, name: 'ProviderMeta', path: path);

    final origin = OriginMeta.from($events, path: '$path.origin');
    final id = internals.ProviderId($events['$path.id']!.ref.valueAsString!);
    final toStringValue = $events['$path.toStringValue']!.ref.valueAsString!;
    final hashValue = $events['$path.hashValue']!.ref.valueAsString!;
    final containerId = internals.ContainerId(
      $events['$path.containerId']!.ref.valueAsString!,
    );
    final containerHashValue =
        $events['$path.containerHashValue']!.ref.valueAsString!;
    final elementId = internals.ElementId(
      $events['$path.elementId']!.ref.valueAsString!,
    );

    return ProviderMeta(
      origin: origin,
      id: id,
      toStringValue: toStringValue,
      hashValue: hashValue,
      containerId: containerId,
      containerHashValue: containerHashValue,
      elementId: elementId,
    );
  }

  final OriginMeta origin;
  final internals.ProviderId id;
  final String toStringValue;
  final String hashValue;
  final internals.ContainerId containerId;
  final String containerHashValue;
  final internals.ElementId elementId;
}

/// Devtool code for [internals.OriginMeta]
class OriginMeta {
  OriginMeta({
    required this.id,
    required this.toStringValue,
    required this.hashValue,
    required this.isFamily,
  });

  factory OriginMeta.from(Map<String, Byte> $events, {required String path}) {
    _validate($events, name: 'OriginMeta', path: path);

    final id = internals.OriginId($events['$path.id']!.ref.valueAsString!);
    final toStringValue = $events['$path.toStringValue']!.ref.valueAsString!;
    final hashValue = $events['$path.hashValue']!.ref.valueAsString!;
    final isFamily = ($events['$path.isFamily']!.ref.valueAsString! == 'true');

    return OriginMeta(
      id: id,
      toStringValue: toStringValue,
      hashValue: hashValue,
      isFamily: isFamily,
    );
  }

  final internals.OriginId id;
  final String toStringValue;
  final String hashValue;
  final bool isFamily;
}

/// Devtool code for [internals.ProviderContainerAddEvent]
class ProviderContainerAddEvent extends Event {
  ProviderContainerAddEvent({
    required this.container,
    required this.parentIds,
    required this.containerId,
  });

  factory ProviderContainerAddEvent.from(
    Map<String, Byte> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderContainerAddEvent', path: path);

    final container = Byte.of($events['$path.container']!.ref);
    final parentIds = List.generate(
      int.parse($events['$path.parentIds.length']!.ref.valueAsString!),
      (i) {
        return internals.ContainerId(
          $events['$path.parentIds[$i]']!.ref.valueAsString!,
        );
      },
    );
    final containerId = internals.ContainerId(
      $events['$path.containerId']!.ref.valueAsString!,
    );

    return ProviderContainerAddEvent(
      container: container,
      parentIds: parentIds,
      containerId: containerId,
    );
  }

  final Byte container;
  final List<internals.ContainerId> parentIds;
  final internals.ContainerId containerId;
}

/// Devtool code for [internals.ProviderContainerDisposeEvent]
class ProviderContainerDisposeEvent extends Event {
  ProviderContainerDisposeEvent({required this.container});

  factory ProviderContainerDisposeEvent.from(
    Map<String, Byte> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderContainerDisposeEvent', path: path);

    final container = Byte.of($events['$path.container']!.ref);

    return ProviderContainerDisposeEvent(container: container);
  }

  final Byte container;
}

/// Devtool code for [internals.ProviderElementAddEvent]
class ProviderElementAddEvent extends Event {
  ProviderElementAddEvent({required this.provider, required this.state});

  factory ProviderElementAddEvent.from(
    Map<String, Byte> $events, {
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
    Map<String, Byte> $events, {
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
    Map<String, Byte> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderStateRef', path: path);

    final state = Byte.of($events['$path.state']!.ref);

    return ProviderStateRef(state: state);
  }

  final Byte state;
}

/// Devtool code for [internals.ProviderElementUpdateEvent]
class ProviderElementUpdateEvent extends Event {
  ProviderElementUpdateEvent({required this.provider, required this.next});

  factory ProviderElementUpdateEvent.from(
    Map<String, Byte> $events, {
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
