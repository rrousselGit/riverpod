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

    if (creationStackTrace case final value2?) {
      {
        final $value = value2;
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
    }

    return res1;
  }
}

@internal
extension OriginMetaToBytes on OriginMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res3 = <String, Object?>{path: 'OriginMeta'};
    res3['$path.id'] = id;
    {
      final $value = toStringValue;
      final length = ($value.length / 128).ceil();
      res3['$path.toStringValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res3['$path.toStringValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    {
      final $value = hashValue;
      final length = ($value.length / 128).ceil();
      res3['$path.hashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res3['$path.hashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    res3['$path.isFamily'] = isFamily;
    if (creationStackTrace case final value4?) {
      {
        final $value = value4;
        final length = ($value.length / 128).ceil();
        res3['$path.creationStackTrace.length'] = length;
        for (var i = 0; i < length; i++) {
          final end = (i + 1) * 128;
          res3['$path.creationStackTrace.$i'] = $value.substring(
            i * 128,
            end > $value.length ? $value.length : end,
          );
        }
      }
    }

    return res3;
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
    final res5 = <String, Object?>{path: 'ProviderContainerAddEvent'};
    res5['$path.container'] = RiverpodDevtool.instance.cache(container);

    res5['$path.containerId'] = containerId;
    {
      res5['$path.parentIds.length'] = parentIds.length;
      for (final (index, e) in parentIds.indexed) {
        res5['$path.parentIds[$index]'] = e;
      }
    }

    return res5;
  }
}

@internal
extension ProviderContainerDisposeEventToBytes
    on ProviderContainerDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res6 = <String, Object?>{path: 'ProviderContainerDisposeEvent'};
    res6['$path.container'] = RiverpodDevtool.instance.cache(container);

    return res6;
  }
}

@internal
extension ProviderElementAddEventToBytes on ProviderElementAddEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res7 = <String, Object?>{path: 'ProviderElementAddEvent'};
    res7.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    res7.addAll(ProviderStateRefToBytes(state).toBytes(path: '$path.state'));
    if (notifier case final value8?) {
      res7.addAll(
        ProviderStateRefToBytes(value8).toBytes(path: '$path.notifier'),
      );
    }

    return res7;
  }
}

@internal
extension ProviderElementDisposeEventToBytes on ProviderElementDisposeEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res9 = <String, Object?>{path: 'ProviderElementDisposeEvent'};
    res9.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    return res9;
  }
}

@internal
extension ProviderStateRefToBytes on ProviderStateRef {
  Map<String, Object?> toBytes({required String path}) {
    final res10 = <String, Object?>{path: 'ProviderStateRef'};
    res10['$path.state'] = RiverpodDevtool.instance.cache(state);

    return res10;
  }
}

@internal
extension ProviderElementUpdateEventToBytes on ProviderElementUpdateEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res11 = <String, Object?>{path: 'ProviderElementUpdateEvent'};
    res11.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    res11.addAll(ProviderStateRefToBytes(next).toBytes(path: '$path.next'));
    if (notifier case final value12?) {
      res11.addAll(
        ProviderStateRefToBytes(value12).toBytes(path: '$path.notifier'),
      );
    }

    return res11;
  }
}

@internal
extension RefUsageEventToBytes on RefUsageEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res13 = <String, Object?>{path: 'RefUsageEvent'};
    res13.addAll(ProviderMetaToBytes(provider).toBytes(path: '$path.provider'));
    {
      final $value = methodName;
      final length = ($value.length / 128).ceil();
      res13['$path.methodName.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res13['$path.methodName.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    if (stackTrace case final value14?) {
      {
        final $value = value14;
        final length = ($value.length / 128).ceil();
        res13['$path.stackTrace.length'] = length;
        for (var i = 0; i < length; i++) {
          final end = (i + 1) * 128;
          res13['$path.stackTrace.$i'] = $value.substring(
            i * 128,
            end > $value.length ? $value.length : end,
          );
        }
      }
    }

    {
      res13['$path.positionalArguments.length'] = positionalArguments.length;
      for (final (index, e) in positionalArguments.indexed) {
        res13['$path.positionalArguments[$index]'] = RiverpodDevtool.instance
            .cache(e);
      }
    }

    {
      res13['$path.typeArguments.length'] = typeArguments.length;
      for (final (index, e) in typeArguments.indexed) {
        res13['$path.typeArguments[$index]'] = RiverpodDevtool.instance.cache(
          e,
        );
      }
    }

    res13['$path.namedArguments'] = RiverpodDevtool.instance.cache(
      namedArguments,
    );

    {
      res13['$path.listenedProviders.length'] = listenedProviders.length;
      for (final (index, e) in listenedProviders.indexed) {
        res13['$path.listenedProviders[$index]'] = RiverpodDevtool.instance
            .cache(e);
      }
    }

    return res13;
  }
}

@internal
extension WidgetRefUsageEventToBytes on WidgetRefUsageEvent {
  Map<String, Object?> toBytes({required String path}) {
    final res15 = <String, Object?>{path: 'WidgetRefUsageEvent'};
    res15['$path.consumer'] = RiverpodDevtool.instance.cache(consumer);

    {
      final $value = methodName;
      final length = ($value.length / 128).ceil();
      res15['$path.methodName.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res15['$path.methodName.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    if (stackTrace case final value16?) {
      {
        final $value = value16;
        final length = ($value.length / 128).ceil();
        res15['$path.stackTrace.length'] = length;
        for (var i = 0; i < length; i++) {
          final end = (i + 1) * 128;
          res15['$path.stackTrace.$i'] = $value.substring(
            i * 128,
            end > $value.length ? $value.length : end,
          );
        }
      }
    }

    {
      res15['$path.positionalArguments.length'] = positionalArguments.length;
      for (final (index, e) in positionalArguments.indexed) {
        res15['$path.positionalArguments[$index]'] = RiverpodDevtool.instance
            .cache(e);
      }
    }

    {
      res15['$path.typeArguments.length'] = typeArguments.length;
      for (final (index, e) in typeArguments.indexed) {
        res15['$path.typeArguments[$index]'] = RiverpodDevtool.instance.cache(
          e,
        );
      }
    }

    res15['$path.namedArguments'] = RiverpodDevtool.instance.cache(
      namedArguments,
    );

    {
      res15['$path.listenedProviders.length'] = listenedProviders.length;
      for (final (index, e) in listenedProviders.indexed) {
        res15['$path.listenedProviders[$index]'] = RiverpodDevtool.instance
            .cache(e);
      }
    }

    return res15;
  }
}

@internal
extension ConsumerMetaToBytes on ConsumerMeta {
  Map<String, Object?> toBytes({required String path}) {
    final res17 = <String, Object?>{path: 'ConsumerMeta'};
    res17['$path.id'] = RiverpodDevtool.instance.cache(id);

    {
      final $value = hashValue;
      final length = ($value.length / 128).ceil();
      res17['$path.hashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res17['$path.hashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    res17['$path.containerId'] = containerId;
    {
      final $value = containerHashValue;
      final length = ($value.length / 128).ceil();
      res17['$path.containerHashValue.length'] = length;
      for (var i = 0; i < length; i++) {
        final end = (i + 1) * 128;
        res17['$path.containerHashValue.$i'] = $value.substring(
          i * 128,
          end > $value.length ? $value.length : end,
        );
      }
    }

    if (creationStackTrace case final value18?) {
      {
        final $value = value18;
        final length = ($value.length / 128).ceil();
        res17['$path.creationStackTrace.length'] = length;
        for (var i = 0; i < length; i++) {
          final end = (i + 1) * 128;
          res17['$path.creationStackTrace.$i'] = $value.substring(
            i * 128,
            end > $value.length ? $value.length : end,
          );
        }
      }
    }

    return res17;
  }
}
