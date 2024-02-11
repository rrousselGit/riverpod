part of '../framework.dart';

/// A provider that is driven by a value instead of a function.
///
/// This is an implementation detail of `overrideWithValue`.
final class $ValueProvider<StateT> extends ProviderBase<StateT>
    with LegacyProviderMixin<StateT> {
  /// Creates a [$ValueProvider].
  const $ValueProvider(this._value)
      : super(
          name: null,
          from: null,
          argument: null,
          allTransitiveDependencies: null,
          dependencies: null,
          isAutoDispose: false,
        );

  final StateT _value;

  @override
  Iterable<ProviderOrFamily>? get dependencies => null;

  @override
  Set<ProviderOrFamily>? get allTransitiveDependencies => null;

  @internal
  @override
  // ignore: library_private_types_in_public_api, not public API
  _ValueProviderElement<StateT> $createElement(ProviderContainer container) {
    return _ValueProviderElement(this, container);
  }
}

/// The [ProviderElementBase] of a [$ValueProvider]
class _ValueProviderElement<State> extends ProviderElementBase<State> {
  /// The [ProviderElementBase] of a [$ValueProvider]
  _ValueProviderElement(this.provider, super.container);

  /// A custom listener called when `overrideWithValue` changes
  /// with a different value.
  void Function(State value)? onChange;

  @override
  $ValueProvider<State> provider;

  @override
  void update(covariant $ValueProvider<State> newProvider) {
    super.update(newProvider);
    provider = newProvider;
    final newValue = provider._value;

    // `getState` will never be in error/loading state since there is no "create"
    final previousState = stateResult! as ResultData<State>;

    if (newValue != previousState.state) {
      // Asserts would otherwise prevent a provider rebuild from updating
      // other providers
      if (kDebugMode) _debugSkipNotifyListenersAsserts = true;

      setStateResult(ResultData(newValue));

      // Asserts would otherwise prevent a provider rebuild from updating
      // other providers
      if (kDebugMode) _debugSkipNotifyListenersAsserts = false;

      onChange?.call(newValue);
    }
  }

  @override
  void create({required bool didChangeDependency}) {
    setStateResult(ResultData(provider._value));
  }

  @override
  bool updateShouldNotify(State previous, State next) {
    return true;
  }
}
