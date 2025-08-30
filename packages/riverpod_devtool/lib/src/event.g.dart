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
    required this.originId,
    required this.originDisplayString,
    required this.isFamily,
    required this.providerId,
    required this.providerDisplayString,
  });

  factory ProviderMeta.from(Map<String, Byte> $events, {required String path}) {
    _validate($events, name: 'ProviderMeta', path: path);

    final originId = internals.OriginId(
      $events['$path.originId']!.ref.valueAsString!,
    );
    final originDisplayString =
        $events['$path.originDisplayString']!.ref.valueAsString!;
    final isFamily = ($events['$path.isFamily']!.ref.valueAsString! == 'true');
    final providerId = internals.ProviderId(
      $events['$path.providerId']!.ref.valueAsString!,
    );
    final providerDisplayString =
        $events['$path.providerDisplayString']!.ref.valueAsString!;

    return ProviderMeta(
      originId: originId,
      originDisplayString: originDisplayString,
      isFamily: isFamily,
      providerId: providerId,
      providerDisplayString: providerDisplayString,
    );
  }

  final internals.OriginId originId;
  final String originDisplayString;
  final bool isFamily;
  final internals.ProviderId providerId;
  final String providerDisplayString;
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

    final container = $events['$path.container']!.ref;
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

  final InstanceRef container;
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

    final container = $events['$path.container']!.ref;

    return ProviderContainerDisposeEvent(container: container);
  }

  final InstanceRef container;
}

/// Devtool code for [internals.ProviderElementAddEvent]
class ProviderElementAddEvent extends Event {
  ProviderElementAddEvent({required this.element, required this.provider});

  factory ProviderElementAddEvent.from(
    Map<String, Byte> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderElementAddEvent', path: path);

    final element = $events['$path.element']!.ref;
    final provider = ProviderMeta.from($events, path: '$path.provider');

    return ProviderElementAddEvent(element: element, provider: provider);
  }

  final InstanceRef element;
  final ProviderMeta provider;
}

/// Devtool code for [internals.ProviderElementDisposeEvent]
class ProviderElementDisposeEvent extends Event {
  ProviderElementDisposeEvent({required this.element, required this.provider});

  factory ProviderElementDisposeEvent.from(
    Map<String, Byte> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderElementDisposeEvent', path: path);

    final element = $events['$path.element']!.ref;
    final provider = ProviderMeta.from($events, path: '$path.provider');

    return ProviderElementDisposeEvent(element: element, provider: provider);
  }

  final InstanceRef element;
  final ProviderMeta provider;
}

/// Devtool code for [internals.ProviderElementUpdateEvent]
class ProviderElementUpdateEvent extends Event {
  ProviderElementUpdateEvent({
    required this.element,
    required this.previous,
    required this.next,
    required this.provider,
  });

  factory ProviderElementUpdateEvent.from(
    Map<String, Byte> $events, {
    required String path,
  }) {
    _validate($events, name: 'ProviderElementUpdateEvent', path: path);

    final element = $events['$path.element']!.ref;
    final previous = $events['$path.previous']!.ref;
    final next = $events['$path.next']!.ref;
    final provider = ProviderMeta.from($events, path: '$path.provider');

    return ProviderElementUpdateEvent(
      element: element,
      previous: previous,
      next: next,
      provider: provider,
    );
  }

  final InstanceRef element;
  final InstanceRef previous;
  final InstanceRef next;
  final ProviderMeta provider;
}
