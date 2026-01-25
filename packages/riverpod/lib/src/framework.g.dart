// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'framework.dart';

// **************************************************************************
// _RiverpodDevtoolGeneratorGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
@internal
extension FrameToBytes on Frame {
  Map<String, Object?> toBytes({required String path}) {
    final res90 = <String, Object?>{'$path._type': 'Frame'};
    res90['$path.timestamp'] = timestamp.millisecondsSinceEpoch;
    res90['$path.index'] = index;
    {
      res90['$path.events.length'] = events.length;
      for (final (index, e) in events.indexed) {
        res90.addAll(EventToBytes(e).toBytes(path: '$path.events[$index]'));
      }
    }

    return res90;
  }
}

@internal
extension ProviderMetaToBytes on ProviderMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res91 = <String, Object?>{'$path._type': 'ProviderMeta'};
    res91.addAll(OriginMetaToBytes(origin).toBytes(path: '$path.origin'));
    res91['$path.id'] = id;
    {
      final $value = argToStringValue;
      final length = ($value.length / 128).ceil();
      res91['$path.argToStringValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res91['$path.argToStringValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    {
      final $value = hashValue;
      final length = ($value.length / 128).ceil();
      res91['$path.hashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res91['$path.hashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    res91['$path.containerId'] = containerId;
    {
      final $value = containerHashValue;
      final length = ($value.length / 128).ceil();
      res91['$path.containerHashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res91['$path.containerHashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    res91['$path.elementId'] = elementId;
    res91['$path.element'] = element;
    {
      final $value = creationStackTrace ?? '';
      final length = ($value.length / 128).ceil();
      res91['$path.creationStackTrace.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res91['$path.creationStackTrace.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    return res91;
  }
}

@internal
extension OriginMetaToBytes on OriginMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res92 = <String, Object?>{'$path._type': 'OriginMeta'};
    res92['$path.id'] = id;
    {
      final $value = toStringValue;
      final length = ($value.length / 128).ceil();
      res92['$path.toStringValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res92['$path.toStringValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    {
      final $value = hashValue;
      final length = ($value.length / 128).ceil();
      res92['$path.hashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res92['$path.hashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    res92['$path.isFamily'] = isFamily;
    {
      final $value = creationStackTrace ?? '';
      final length = ($value.length / 128).ceil();
      res92['$path.creationStackTrace.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res92['$path.creationStackTrace.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    return res92;
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
    final res93 = <String, Object?>{'$path._type': 'ProviderContainerAddEvent'};
    res93['$path.container'] = container;
    res93['$path.containerId'] = containerId;
    {
      res93['$path.parentIds.length'] = parentIds.length;
      for (final (index, e) in parentIds.indexed) {
        res93['$path.parentIds[$index]'] = e;
      }
    }

    return res93;
  }
}

@internal
extension ProviderContainerDisposeEventToBytes
    on ProviderContainerDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res94 = <String, Object?>{
      '$path._type': 'ProviderContainerDisposeEvent',
    };
    res94['$path.container'] = container;
    return res94;
  }
}

@internal
extension ProviderElementAddEventToBytes on ProviderElementAddEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res95 = <String, Object?>{'$path._type': 'ProviderElementAddEvent'};
    res95.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    res95.addAll(ProviderStateRefToBytes(state).toBytes(path: '$path.state'));
    return res95;
  }
}

@internal
extension ProviderElementDisposeEventToBytes on ProviderElementDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res96 = <String, Object?>{
      '$path._type': 'ProviderElementDisposeEvent',
    };
    res96.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    return res96;
  }
}

@internal
extension ProviderStateRefToBytes on ProviderStateRef {
  Map<String, Object?> toBytes({required String path}) {
    final res97 = <String, Object?>{'$path._type': 'ProviderStateRef'};
    res97['$path.state'] = state;
    return res97;
  }
}

@internal
extension ProviderElementUpdateEventToBytes on ProviderElementUpdateEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res98 = <String, Object?>{
      '$path._type': 'ProviderElementUpdateEvent',
    };
    res98.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    res98.addAll(ProviderStateRefToBytes(next).toBytes(path: '$path.next'));
    return res98;
  }
}
