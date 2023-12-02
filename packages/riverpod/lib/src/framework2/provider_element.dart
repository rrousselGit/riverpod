part of 'framework.dart';

/// The element of a provider is a class responsible for managing the state
/// of a provider.
///
/// It is responsible for:
/// - Initializing the provider
/// - Recomputing the provider when requested (such as with [Ref.watch] or [Ref.invalidate])
/// - Disposing the state
abstract class ProviderElement<StateT> {
  ProviderElement(this.container);

  /// The provider associated with this [ProviderElement].
  Provider<StateT> get provider;

  /// The container where this [ProviderElement] is attached to.
  final ProviderContainer container;

  Result<StateT>? _result;

  /// The current state of this provider.
  ///
  /// This is `null` until the provider has been initialized.
  /// The state may be in error state, which can be checked using [Result].
  Result<StateT>? get result => _result;

  /// Set the current state of this provider.
  ///
  /// This will notify listeners if:
  /// - invoked after the provider has finished initializing
  /// - and if the new state is different from the previous one
  set result(Result<StateT>? value) => _result = value;

  @visibleForOverriding
  FutureOr<void> build(Ref<StateT> ref);

  void markNeedsReload() {
    throw UnimplementedError();
  }

  void markNeedsRefresh() {
    throw UnimplementedError();
  }
}
