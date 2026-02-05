// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'framework.dart';

// **************************************************************************
// _RiverpodDevtoolGeneratorGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
@internal
extension FrameToBytes on Frame {
  Map<String, Object?> toBytes({required String path}) {
    final res0 = <String, Object?>{path: 'Frame'};
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
    final res1 = <String, Object?>{path: 'ProviderMeta'};
    res1.addAll(OriginMetaToBytes(origin).toBytes(path: '$path.origin'));
    res1['$path.id'] = id;
    {
      final $value = argToStringValue;
      final length = ($value.length / 128).ceil();
      res1['$path.argToStringValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res1['$path.argToStringValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    {
      final $value = hashValue;
      final length = ($value.length / 128).ceil();
      res1['$path.hashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res1['$path.hashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    res1['$path.containerId'] = containerId;
    {
      final $value = containerHashValue;
      final length = ($value.length / 128).ceil();
      res1['$path.containerHashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res1['$path.containerHashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    res1['$path.elementId'] = elementId;
    res1['$path.element'] = RiverpodDevtool.instance.cache(element);

    {
      final $value = creationStackTrace ?? '';
      final length = ($value.length / 128).ceil();
      res1['$path.creationStackTrace.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res1['$path.creationStackTrace.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    return res1;
  }
}

@internal
extension OriginMetaToBytes on OriginMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res2 = <String, Object?>{path: 'OriginMeta'};
    res2['$path.id'] = id;
    {
      final $value = toStringValue;
      final length = ($value.length / 128).ceil();
      res2['$path.toStringValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res2['$path.toStringValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    {
      final $value = hashValue;
      final length = ($value.length / 128).ceil();
      res2['$path.hashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res2['$path.hashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    res2['$path.isFamily'] = isFamily;
    {
      final $value = creationStackTrace ?? '';
      final length = ($value.length / 128).ceil();
      res2['$path.creationStackTrace.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res2['$path.creationStackTrace.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    return res2;
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
      case RefUsageEvent():
        return that.toBytes(path: path);
      case WidgetRefUsageEvent():
        return that.toBytes(path: path);
    }
  }
}

@internal
extension ProviderContainerAddEventToBytes on ProviderContainerAddEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res3 = <String, Object?>{path: 'ProviderContainerAddEvent'};
    res3['$path.container'] = RiverpodDevtool.instance.cache(container);

    res3['$path.containerId'] = containerId;
    {
      res3['$path.parentIds.length'] = parentIds.length;
      for (final (index, e) in parentIds.indexed) {
        res3['$path.parentIds[$index]'] = e;
      }
    }

    return res3;
  }
}

@internal
extension ProviderContainerDisposeEventToBytes
    on ProviderContainerDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res4 = <String, Object?>{path: 'ProviderContainerDisposeEvent'};
    res4['$path.container'] = RiverpodDevtool.instance.cache(container);

    return res4;
  }
}

@internal
extension ProviderElementAddEventToBytes on ProviderElementAddEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res5 = <String, Object?>{path: 'ProviderElementAddEvent'};
    res5.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    res5.addAll(ProviderStateRefToBytes(state).toBytes(path: '$path.state'));
    final result6 = notifier;
    if (result6 != null) {
      res5.addAll(
        ProviderStateRefToBytes(result6).toBytes(path: '$path.notifier'),
      );
    }

    return res5;
  }
}

@internal
extension ProviderElementDisposeEventToBytes on ProviderElementDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res7 = <String, Object?>{path: 'ProviderElementDisposeEvent'};
    res7.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    return res7;
  }
}

@internal
extension ProviderStateRefToBytes on ProviderStateRef {
  Map<String, Object?> toBytes({required String path}) {
    final res8 = <String, Object?>{path: 'ProviderStateRef'};
    res8['$path.state'] = RiverpodDevtool.instance.cache(state);

    return res8;
  }
}

@internal
extension ProviderElementUpdateEventToBytes on ProviderElementUpdateEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res9 = <String, Object?>{path: 'ProviderElementUpdateEvent'};
    res9.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    res9.addAll(ProviderStateRefToBytes(next).toBytes(path: '$path.next'));
    final result10 = notifier;
    if (result10 != null) {
      res9.addAll(
        ProviderStateRefToBytes(result10).toBytes(path: '$path.notifier'),
      );
    }

    return res9;
  }
}

@internal
extension RefUsageEventToBytes on RefUsageEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res11 = <String, Object?>{path: 'RefUsageEvent'};
    res11.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    {
      final $value = methodName;
      final length = ($value.length / 128).ceil();
      res11['$path.methodName.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res11['$path.methodName.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    {
      final $value = stackTrace ?? '';
      final length = ($value.length / 128).ceil();
      res11['$path.stackTrace.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res11['$path.stackTrace.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    {
      res11['$path.positionalArguments.length'] = positionalArguments.length;
      for (final (index, e) in positionalArguments.indexed) {
        res11['$path.positionalArguments[$index]'] = RiverpodDevtool.instance
            .cache(e);
      }
    }

    {
      res11['$path.typeArguments.length'] = typeArguments.length;
      for (final (index, e) in typeArguments.indexed) {
        res11['$path.typeArguments[$index]'] = RiverpodDevtool.instance.cache(
          e,
        );
      }
    }

    res11['$path.namedArguments'] = RiverpodDevtool.instance.cache(
      namedArguments,
    );

    return res11;
  }
}

@internal
extension WidgetRefUsageEventToBytes on WidgetRefUsageEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res12 = <String, Object?>{path: 'WidgetRefUsageEvent'};
    res12['$path.consumer'] = RiverpodDevtool.instance.cache(consumer);

    {
      final $value = methodName;
      final length = ($value.length / 128).ceil();
      res12['$path.methodName.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res12['$path.methodName.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    {
      final $value = stackTrace ?? '';
      final length = ($value.length / 128).ceil();
      res12['$path.stackTrace.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res12['$path.stackTrace.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    {
      res12['$path.positionalArguments.length'] = positionalArguments.length;
      for (final (index, e) in positionalArguments.indexed) {
        res12['$path.positionalArguments[$index]'] = RiverpodDevtool.instance
            .cache(e);
      }
    }

    {
      res12['$path.typeArguments.length'] = typeArguments.length;
      for (final (index, e) in typeArguments.indexed) {
        res12['$path.typeArguments[$index]'] = RiverpodDevtool.instance.cache(
          e,
        );
      }
    }

    res12['$path.namedArguments'] = RiverpodDevtool.instance.cache(
      namedArguments,
    );

    return res12;
  }
}

@internal
extension ConsumerMetaToBytes on ConsumerMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res13 = <String, Object?>{path: 'ConsumerMeta'};
    res13['$path.id'] = RiverpodDevtool.instance.cache(id);

    {
      final $value = hashValue;
      final length = ($value.length / 128).ceil();
      res13['$path.hashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res13['$path.hashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    res13['$path.containerId'] = containerId;
    {
      final $value = containerHashValue;
      final length = ($value.length / 128).ceil();
      res13['$path.containerHashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res13['$path.containerHashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    {
      final $value = creationStackTrace ?? '';
      final length = ($value.length / 128).ceil();
      res13['$path.creationStackTrace.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res13['$path.creationStackTrace.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    return res13;
  }
}
