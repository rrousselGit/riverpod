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

/// The [ProviderElement] of a [$ValueProvider]
class _ValueProviderElement<StateT> extends ProviderElement<StateT> {
  /// The [ProviderElement] of a [$ValueProvider]
  _ValueProviderElement(this.provider, super.container);

  /// A custom listener called when `overrideWithValue` changes
  /// with a different value.
  void Function(StateT value)? onChange;

  @override
  $ValueProvider<StateT> provider;

  @override
  void update(covariant $ValueProvider<StateT> newProvider) {
    super.update(newProvider);
    provider = newProvider;
    final newValue = provider._value;

    // `getState` will never be in error/loading state since there is no "create"
    final previousState = stateResult! as ResultData<StateT>;

    if (newValue != previousState.state) {
      // Asserts would otherwise prevent a provider rebuild from updating
      // other providers
      if (kDebugMode) _debugSkipNotifyListenersAsserts = true;

      _setValue(newValue);

      // Asserts would otherwise prevent a provider rebuild from updating
      // other providers
      if (kDebugMode) _debugSkipNotifyListenersAsserts = false;

      onChange?.call(newValue);
    }
  }

  void _setValue(StateT value) => setStateResult(ResultData(value));

  @override
  void create(Ref<StateT> ref, {required bool didChangeDependency}) {
    _setValue(provider._value);
  }

  @override
  bool updateShouldNotify(StateT previous, StateT next) {
    return true;
  }
}

@internal
final class $AsyncValueProvider<StateT>
    extends $ValueProvider<AsyncValue<StateT>> {
  const $AsyncValueProvider(super._value);

  @override
  // ignore: library_private_types_in_public_api, not public API
  _AsyncValueProviderElement<StateT> $createElement(
    ProviderContainer container,
  ) {
    return _AsyncValueProviderElement(this, container);
  }
}

class _AsyncValueProviderElement<StateT>
    extends _ValueProviderElement<AsyncValue<StateT>>
    with FutureModifierElement<StateT> {
  _AsyncValueProviderElement(super.provider, super.container);

  @override
  void _setValue(AsyncValue<StateT> value) {
    switch (value) {
      case AsyncData():
        onData(value, seamless: true);
      case AsyncError():
        onError(value, seamless: true);
      case AsyncLoading():
        onLoading(value, seamless: true);
    }
  }
}
