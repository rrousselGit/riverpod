// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'framework.dart';

// **************************************************************************
// _RiverpodDevtoolGeneratorGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
@internal
extension FrameToBytes on Frame {
  Map<String, Object?> toBytes({required String path}) {
    final res114 = <String, Object?>{'$path._type': 'Frame'};
    res114['$path.timestamp'] = timestamp.millisecondsSinceEpoch;
    res114['$path.index'] = index;
    {
      res114['$path.events.length'] = events.length;
      for (final (index, e) in events.indexed) {
        res114.addAll(EventToBytes(e).toBytes(path: '$path.events[$index]'));
      }
    }

    return res114;
  }
}

@internal
extension ProviderMetaToBytes on ProviderMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res115 = <String, Object?>{'$path._type': 'ProviderMeta'};
    res115.addAll(OriginMetaToBytes(origin).toBytes(path: '$path.origin'));
    res115['$path.id'] = id;
    res115['$path.toStringValue'] = toStringValue;
    res115['$path.hashValue'] = hashValue;
    res115['$path.containerId'] = containerId;
    res115['$path.elementId'] = elementId;
    return res115;
  }
}

@internal
extension OriginMetaToBytes on OriginMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res116 = <String, Object?>{'$path._type': 'OriginMeta'};
    res116['$path.id'] = id;
    res116['$path.toStringValue'] = toStringValue;
    res116['$path.hashValue'] = hashValue;
    res116['$path.isFamily'] = isFamily;
    return res116;
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
    final res117 = <String, Object?>{
      '$path._type': 'ProviderContainerAddEvent',
    };
    res117['$path.container'] = container;
    {
      res117['$path.parentIds.length'] = parentIds.length;
      for (final (index, e) in parentIds.indexed) {
        res117['$path.parentIds[$index]'] = e;
      }
    }

    res117['$path.containerId'] = containerId;
    return res117;
  }
}

@internal
extension ProviderContainerDisposeEventToBytes
    on ProviderContainerDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res118 = <String, Object?>{
      '$path._type': 'ProviderContainerDisposeEvent',
    };
    res118['$path.container'] = container;
    return res118;
  }
}

@internal
extension ProviderElementAddEventToBytes on ProviderElementAddEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res119 = <String, Object?>{'$path._type': 'ProviderElementAddEvent'};
    res119.addAll(
      ProviderMetaToBytes(provider).toBytes(path: '$path.provider'),
    );
    res119.addAll(ProviderStateRefToBytes(state).toBytes(path: '$path.state'));
    return res119;
  }
}

@internal
extension ProviderElementDisposeEventToBytes on ProviderElementDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res120 = <String, Object?>{
      '$path._type': 'ProviderElementDisposeEvent',
    };
    res120.addAll(
      ProviderMetaToBytes(provider).toBytes(path: '$path.provider'),
    );
    return res120;
  }
}

@internal
extension ProviderStateRefToBytes on ProviderStateRef {
  Map<String, Object?> toBytes({required String path}) {
    final res121 = <String, Object?>{'$path._type': 'ProviderStateRef'};
    res121['$path.state'] = state;
    return res121;
  }
}

@internal
extension ProviderElementUpdateEventToBytes on ProviderElementUpdateEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res122 = <String, Object?>{
      '$path._type': 'ProviderElementUpdateEvent',
    };
    res122.addAll(
      ProviderMetaToBytes(provider).toBytes(path: '$path.provider'),
    );
    res122.addAll(ProviderStateRefToBytes(next).toBytes(path: '$path.next'));
    return res122;
  }
}
