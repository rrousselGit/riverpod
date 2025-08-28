// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'framework.dart';

// **************************************************************************
// _RiverpodDevtoolGeneratorGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
@internal
extension FrameToBytes on Frame {
  Map<String, Object?> toBytes({required String path}) {
    final res0 = <String, Object?>{'$path._type': 'Frame'};
    res0['$path.timestamp'] = timestamp.millisecondsSinceEpoch;
    res0['$path.index'] = index;
    {
      res0['$path.events.length'] = events.length;
      for (final (index, e) in events.indexed) {
        res0.addAll(EventToBytes(e).toBytes(path: '$path.events[$index]'));
      }
    }

    return res0;
  }
}

@internal
extension EventToBytes on Event {
  Map<String, Object?> toBytes({required String path}) {
    final that = this;
    switch (that) {
      case ProviderContainerAddEvent():
        return that.toBytes(path: path);
      case ProviderContainerDisposeEvent():
        return that.toBytes(path: path);
      case ProviderElementAddEvent():
        return that.toBytes(path: path);
      case ProviderElementDisposeEvent():
        return that.toBytes(path: path);
      case ProviderElementUpdateEvent():
        return that.toBytes(path: path);
    }
  }
}

@internal
extension ProviderContainerAddEventToBytes on ProviderContainerAddEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res1 = <String, Object?>{'$path._type': 'ProviderContainerAddEvent'};
    res1['$path.container'] = container;
    {
      res1['$path.parentIds.length'] = parentIds.length;
      for (final (index, e) in parentIds.indexed) {
        res1['$path.parentIds[$index]'] = e;
      }
    }

    res1['$path.containerId'] = containerId;
    return res1;
  }
}

@internal
extension ProviderContainerDisposeEventToBytes
    on ProviderContainerDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res2 = <String, Object?>{
      '$path._type': 'ProviderContainerDisposeEvent',
    };
    res2['$path.container'] = container;
    return res2;
  }
}

@internal
extension ProviderElementAddEventToBytes on ProviderElementAddEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res3 = <String, Object?>{'$path._type': 'ProviderElementAddEvent'};
    res3['$path.element'] = element;
    return res3;
  }
}

@internal
extension ProviderElementDisposeEventToBytes on ProviderElementDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res4 = <String, Object?>{
      '$path._type': 'ProviderElementDisposeEvent',
    };
    res4['$path.element'] = element;
    return res4;
  }
}

@internal
extension ProviderElementUpdateEventToBytes on ProviderElementUpdateEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res5 = <String, Object?>{'$path._type': 'ProviderElementUpdateEvent'};
    res5['$path.element'] = element;
    res5['$path.previous'] = previous;
    res5['$path.next'] = next;
    return res5;
  }
}
