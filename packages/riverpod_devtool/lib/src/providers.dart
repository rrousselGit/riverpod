import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/src/internals.dart' as internals;

import 'event.dart';

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
        case ProviderElementUpdateEvent():
          break;
        case ProviderElementAddEvent(:final provider):
        case ProviderElementDisposeEvent(:final provider):
          changed = true;
          final originState = state[provider.originId] ??= OriginState(
            originDisplayString: provider.originDisplayString,
            isFamily: provider.isFamily,
            originId: provider.originId,
            associatedProviders: {},
          );

          originState.associatedProviders[provider.providerId] ??= ProviderState(
            provider: provider.providerId,
            providerDisplayString: provider.providerDisplayString,
          );
      }
    }

    if (changed) ref.notifyListeners();
  }
}

class OriginState {
  OriginState({
    required this.originDisplayString,
    required this.associatedProviders,
    required this.isFamily,
    required this.originId,
  });
  final String originDisplayString;
  final internals.OriginId originId;
  final bool isFamily;
  final Map<internals.ProviderId, ProviderState> associatedProviders;
}

class ProviderState {
  ProviderState({required this.provider, required this.providerDisplayString});

  final internals.ProviderId provider;
  final String providerDisplayString;
}
