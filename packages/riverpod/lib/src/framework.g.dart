// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'framework.dart';

// **************************************************************************
// _RiverpodDevtoolGeneratorGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
@internal
extension FrameToBytes on Frame {
  Map<String, Object?> toBytes({required String path}) {
    final res123 = <String, Object?>{'$path._type': 'Frame'};
    res123['$path.timestamp'] = timestamp.millisecondsSinceEpoch;
    res123['$path.index'] = index;
    {
      res123['$path.events.length'] = events.length;
      for (final (index, e) in events.indexed) {
        res123.addAll(EventToBytes(e).toBytes(path: '$path.events[$index]'));
      }
    }

    return res123;
  }
}

@internal
extension ProviderMetaToBytes on ProviderMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res124 = <String, Object?>{'$path._type': 'ProviderMeta'};
    res124.addAll(OriginMetaToBytes(origin).toBytes(path: '$path.origin'));
    res124['$path.id'] = id;
    res124['$path.toStringValue'] = toStringValue;
    res124['$path.hashValue'] = hashValue;
    res124['$path.containerId'] = containerId;
    res124['$path.containerHashValue'] = containerHashValue;
    res124['$path.elementId'] = elementId;
    return res124;
  }
}

@internal
extension OriginMetaToBytes on OriginMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res125 = <String, Object?>{'$path._type': 'OriginMeta'};
    res125['$path.id'] = id;
    res125['$path.toStringValue'] = toStringValue;
    res125['$path.hashValue'] = hashValue;
    res125['$path.isFamily'] = isFamily;
    return res125;
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
    final res126 = <String, Object?>{
      '$path._type': 'ProviderContainerAddEvent',
    };
    res126['$path.container'] = container;
    {
      res126['$path.parentIds.length'] = parentIds.length;
      for (final (index, e) in parentIds.indexed) {
        res126['$path.parentIds[$index]'] = e;
      }
    }

    res126['$path.containerId'] = containerId;
    return res126;
  }
}

@internal
extension ProviderContainerDisposeEventToBytes
    on ProviderContainerDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res127 = <String, Object?>{
      '$path._type': 'ProviderContainerDisposeEvent',
    };
    res127['$path.container'] = container;
    return res127;
  }
}

@internal
extension ProviderElementAddEventToBytes on ProviderElementAddEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res128 = <String, Object?>{'$path._type': 'ProviderElementAddEvent'};
    res128.addAll(
      ProviderMetaToBytes(provider).toBytes(path: '$path.provider'),
    );
    res128.addAll(ProviderStateRefToBytes(state).toBytes(path: '$path.state'));
    return res128;
  }
}

@internal
extension ProviderElementDisposeEventToBytes on ProviderElementDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res129 = <String, Object?>{
      '$path._type': 'ProviderElementDisposeEvent',
    };
    res129.addAll(
      ProviderMetaToBytes(provider).toBytes(path: '$path.provider'),
    );
    return res129;
  }
}

@internal
extension ProviderStateRefToBytes on ProviderStateRef {
  Map<String, Object?> toBytes({required String path}) {
    final res130 = <String, Object?>{'$path._type': 'ProviderStateRef'};
    res130['$path.state'] = state;
    return res130;
  }
}

@internal
extension ProviderElementUpdateEventToBytes on ProviderElementUpdateEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res131 = <String, Object?>{
      '$path._type': 'ProviderElementUpdateEvent',
    };
    res131.addAll(
      ProviderMetaToBytes(provider).toBytes(path: '$path.provider'),
    );
    res131.addAll(ProviderStateRefToBytes(next).toBytes(path: '$path.next'));
    return res131;
  }
}
