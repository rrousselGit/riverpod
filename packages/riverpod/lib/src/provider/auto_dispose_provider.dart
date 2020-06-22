part of 'provider.dart';

/// A AutoDisposeprovider that exposes a read-only value.
// TODO doc
class AutoDisposeProvider<T>
    extends OverridableAutoDisposeProviderBase<ProviderDependency<T>, T> {
  /// Creates an immutable value.
  AutoDisposeProvider(this._create, {String name}) : super(name);

  final Create<T, ProviderReference> _create;

  @override
  AutoDisposeProviderState<T> createState() => AutoDisposeProviderState();
}

/// The internal state of a [Provider].
class AutoDisposeProviderState<T> extends AutoDisposeProviderStateBase<
    ProviderDependency<T>, T, AutoDisposeProvider<T>> {
  @override
  T state;

  @override
  void initState() {
    state = provider._create(ProviderReference(this));
  }

  @override
  ProviderDependency<T> createProviderDependency() {
    return ProviderDependencyImpl(state);
  }
}
