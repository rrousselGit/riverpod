part of '../../framework.dart';

/// Adds [listenable] to [ProviderListenable].
extension ProviderListenableListenable<StateT> on ProviderListenable<StateT> {
  /// Exposes a [ValueListenable] that tracks the state of this provider.
  ProviderListenable<ValueListenable<StateT>> get listenable {
    return _ListenableModifier<StateT>(this);
  }
}

@immutable
final class _ListenableModifier<StateT>
    with SyncProviderTransformerMixin<StateT, ValueListenable<StateT>> {
  _ListenableModifier(this.source);

  @override
  final ProviderListenable<StateT> source;

  @override
  ProviderTransformer<StateT, ValueListenable<StateT>> transform(
    ProviderTransformerContext<StateT, ValueListenable<StateT>> context,
  ) {
    // Start paused so that if no listener is added to the listenable,
    // the source provider is is paused.
    context.pause();

    late final _ProviderValueListenable<StateT> listenable;
    return ProviderTransformer(
      initState: (self) => listenable = _ProviderValueListenable(context),
      listener: (self, _, _) => listenable.notifyListeners(),
      onClose: () => listenable.dispose(),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is _ListenableModifier<StateT> && other.source == source;

  @override
  int get hashCode => source.hashCode;
}

class _ProviderValueListenable<StateT>
    with ChangeNotifier
    implements ValueListenable<StateT> {
  _ProviderValueListenable(this.context);

  final ProviderTransformerContext<StateT, ValueListenable<StateT>> context;

  @override
  void notifyListeners();

  @override
  void addListener(VoidCallback listener) {
    if (!hasListeners) context.resume();

    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    final hadListeners = hasListeners;
    super.removeListener(listener);

    if (!hasListeners && hadListeners) context.pause();
  }

  @override
  StateT get value => context.read();
}
