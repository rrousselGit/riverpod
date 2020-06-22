part of 'provider.dart';

/// A provider that exposes a read-only value and automatically disposes it
/// when the value is no-longer listened.
///
/// See also:
///
/// - [Provider], a provider with the same behavior, but that doesn't automatically
///   disposes of the state when no-longer used.
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

/// Creates an [AutoDisposeProvider] from external parameters.
///
/// See also:
///
/// - [ProviderFamily], which contains an explanation of what a *Family is.
class AutoDisposeProviderFamily<Result, A>
    extends Family<AutoDisposeProvider<Result>, A> {
  /// Creates a value from an external parameter
  AutoDisposeProviderFamily(Result Function(ProviderReference ref, A a) create)
      : super((a) => AutoDisposeProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
    Result Function(ProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) {
        return AutoDisposeProvider<Result>((ref) => override(ref, value as A));
      },
    );
  }
}
