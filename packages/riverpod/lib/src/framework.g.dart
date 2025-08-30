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
extension ProviderMetaToBytes on ProviderMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res1 = <String, Object?>{'$path._type': 'ProviderMeta'};
    res1['$path.originId'] = originId;
    res1['$path.originDisplayString'] = originDisplayString;
    res1['$path.isFamily'] = isFamily;
    res1['$path.providerId'] = providerId;
    res1['$path.providerDisplayString'] = providerDisplayString;
    return res1;
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
    final res2 = <String, Object?>{'$path._type': 'ProviderContainerAddEvent'};
    res2['$path.container'] = container;
    {
      res2['$path.parentIds.length'] = parentIds.length;
      for (final (index, e) in parentIds.indexed) {
        res2['$path.parentIds[$index]'] = e;
      }
    }

    res2['$path.containerId'] = containerId;
    return res2;
  }
}

@internal
extension ProviderContainerDisposeEventToBytes
    on ProviderContainerDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res3 = <String, Object?>{
      '$path._type': 'ProviderContainerDisposeEvent',
    };
    res3['$path.container'] = container;
    return res3;
  }
}

@internal
extension ProviderElementAddEventToBytes on ProviderElementAddEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res4 = <String, Object?>{'$path._type': 'ProviderElementAddEvent'};
    res4['$path.element'] = element;
    res4.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    return res4;
  }
}

@internal
extension ProviderElementDisposeEventToBytes on ProviderElementDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res5 = <String, Object?>{
      '$path._type': 'ProviderElementDisposeEvent',
    };
    res5['$path.element'] = element;
    res5.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    return res5;
  }
}

@internal
extension ProviderElementUpdateEventToBytes on ProviderElementUpdateEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res6 = <String, Object?>{'$path._type': 'ProviderElementUpdateEvent'};
    res6['$path.element'] = element;
    res6['$path.previous'] = previous;
    res6['$path.next'] = next;
    res6.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    return res6;
  }
}
