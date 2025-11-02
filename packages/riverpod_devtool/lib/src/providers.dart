import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/src/internals.dart' as internals;

import 'frames.dart';
import 'vm_service.dart';
import 'search.dart';

final allDiscoveredOriginsProvider =
    NotifierProvider<
      AllDiscoveredOriginsNotifier,
      Map<internals.OriginId, OriginState>
    >(AllDiscoveredOriginsNotifier.new);

class AllDiscoveredOriginsNotifier
    extends Notifier<Map<internals.OriginId, OriginState>> {
  @override
  Map<internals.OriginId, OriginState> build() {
    ref.watch(hotRestartEventProvider);

    state = {};

    ref.listen(framesProvider, fireImmediately: true, (previous, next) {
      if (next.isLoading) return;

      final frames = next.value ?? const [];

      frames.forEach(_handleFrame);
    });

    return state;
  }

  void _handleFrame(FoldedFrame frame) {
    var changed = false;

    for (final event in frame.frame.events) {
      // Accumulate unique origin IDs
      switch (event) {
        case ProviderContainerAddEvent():
        case ProviderContainerDisposeEvent():
          break;
        case ProviderElementDisposeEvent(:final provider):
          changed = true;
          state[provider.origin.id]?.associatedProviders.remove(
            provider.elementId,
          );

        case ProviderElementAddEvent(:final provider):
        case ProviderElementUpdateEvent(:final provider):
          changed = true;
          final originState = state[provider.origin.id] ??= OriginState(
            value: provider.origin,
            associatedProviders: {},
          );

          originState.associatedProviders[provider.elementId] ??= provider;
      }
    }

    if (changed) ref.notifyListeners();
  }
}

class OriginState {
  OriginState({
    required this.associatedProviders,
    required this.value,
    required FrameId start,
  }) : lifespan = (start: start, end: null);

  final OriginMeta value;
  final Map<internals.ElementId, ProviderMeta> associatedProviders;
  final ({FrameId start, FrameId? end}) lifespan;
}

extension ProviderMetaX on ProviderMeta {
  bool isSelected(internals.ElementId? id) => id == elementId;
}

final filteredProvidersProvider = Provider.autoDispose
    .family<List<ProviderPickerItem>, String>((ref, search) {
      final allOrigins = ref.watch(allDiscoveredOriginsProvider);
    });

sealed class ProviderPickerItem {}

final class ProviderHeading extends ProviderPickerItem {
  ProviderHeading({required this.originMeta, required this.match});

  final OriginMeta originMeta;
  final FuzzyMatch match;
}

final class ProviderEntry extends ProviderPickerItem {
  ProviderEntry(this.providerMeta, this.match);
  final ProviderMeta providerMeta;
  final FuzzyMatch match;
}
