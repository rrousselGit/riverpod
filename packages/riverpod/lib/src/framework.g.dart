// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'framework.dart';

// **************************************************************************
// _RiverpodDevtoolGeneratorGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
@internal
extension FrameToBytes on Frame {
  Map<String, Object?> toBytes({required String path}) {
    final res9 = <String, Object?>{'$path._type': 'Frame'};
    res9['$path.timestamp'] = timestamp.millisecondsSinceEpoch;
    res9['$path.index'] = index;
    {
      res9['$path.events.length'] = events.length;
      for (final (index, e) in events.indexed) {
        res9.addAll(EventToBytes(e).toBytes(path: '$path.events[$index]'));
      }
    }

    return res9;
  }
}

@internal
extension ProviderMetaToBytes on ProviderMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res10 = <String, Object?>{'$path._type': 'ProviderMeta'};
    res10.addAll(OriginMetaToBytes(origin).toBytes(path: '$path.origin'));
    res10['$path.id'] = id;
    {
      final $value = toStringValue;
      final length = ($value.length / 128).ceil();
      res10['$path.toStringValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res10['$path.toStringValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    {
      final $value = hashValue;
      final length = ($value.length / 128).ceil();
      res10['$path.hashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res10['$path.hashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    res10['$path.containerId'] = containerId;
    {
      final $value = containerHashValue;
      final length = ($value.length / 128).ceil();
      res10['$path.containerHashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res10['$path.containerHashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    res10['$path.elementId'] = elementId;
    res10['$path.element'] = element;
    {
      final $value = creationStackTrace ?? '';
      final length = ($value.length / 128).ceil();
      res10['$path.creationStackTrace.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res10['$path.creationStackTrace.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    return res10;
  }
}

@internal
extension OriginMetaToBytes on OriginMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res11 = <String, Object?>{'$path._type': 'OriginMeta'};
    res11['$path.id'] = id;
    {
      final $value = toStringValue;
      final length = ($value.length / 128).ceil();
      res11['$path.toStringValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res11['$path.toStringValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    {
      final $value = hashValue;
      final length = ($value.length / 128).ceil();
      res11['$path.hashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res11['$path.hashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    res11['$path.isFamily'] = isFamily;
    {
      final $value = creationStackTrace ?? '';
      final length = ($value.length / 128).ceil();
      res11['$path.creationStackTrace.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res11['$path.creationStackTrace.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    return res11;
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
    final res12 = <String, Object?>{'$path._type': 'ProviderContainerAddEvent'};
    res12['$path.container'] = container;
    {
      res12['$path.parentIds.length'] = parentIds.length;
      for (final (index, e) in parentIds.indexed) {
        res12['$path.parentIds[$index]'] = e;
      }
    }

    res12['$path.containerId'] = containerId;
    return res12;
  }
}

@internal
extension ProviderContainerDisposeEventToBytes
    on ProviderContainerDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res13 = <String, Object?>{
      '$path._type': 'ProviderContainerDisposeEvent',
    };
    res13['$path.container'] = container;
    return res13;
  }
}

@internal
extension ProviderElementAddEventToBytes on ProviderElementAddEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res14 = <String, Object?>{'$path._type': 'ProviderElementAddEvent'};
    res14.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    res14.addAll(ProviderStateRefToBytes(state).toBytes(path: '$path.state'));
    return res14;
  }
}

@internal
extension ProviderElementDisposeEventToBytes on ProviderElementDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res15 = <String, Object?>{
      '$path._type': 'ProviderElementDisposeEvent',
    };
    res15.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    return res15;
  }
}

@internal
extension ProviderStateRefToBytes on ProviderStateRef {
  Map<String, Object?> toBytes({required String path}) {
    final res16 = <String, Object?>{'$path._type': 'ProviderStateRef'};
    res16['$path.state'] = state;
    return res16;
  }
}

@internal
extension ProviderElementUpdateEventToBytes on ProviderElementUpdateEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res17 = <String, Object?>{
      '$path._type': 'ProviderElementUpdateEvent',
    };
    res17.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    res17.addAll(ProviderStateRefToBytes(next).toBytes(path: '$path.next'));
    return res17;
  }
}
