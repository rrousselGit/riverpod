part of '../framework.dart';

/// A provider that is driven by a value instead of a function.
///
/// This is an implementation detail of `overrideWithValue`.
@publicInCodegen
final class $ValueProvider<StateT, ValueT>
    extends $ProviderBaseImpl<StateT, ValueT>
    with LegacyProviderMixin<StateT, ValueT> {
  /// Creates a [$ValueProvider].
  const $ValueProvider(this._value)
      : super(
          name: null,
          from: null,
          argument: null,
          $allTransitiveDependencies: null,
          dependencies: null,
          isAutoDispose: false,
          retry: null,
        );

  final StateT _value;

  @override
  Iterable<ProviderOrFamily>? get dependencies => null;

  @override
  Set<ProviderOrFamily>? get $allTransitiveDependencies => null;

  /// @nodoc
  @internal
  @override
  // ignore: library_private_types_in_public_api, not public API
  _ValueProviderElement<StateT, ValueT> $createElement(
    $ProviderPointer pointer,
  ) {
    return _ValueProviderElement(this, pointer);
  }
}

/// The [ProviderElement] of a [$ValueProvider]
class _ValueProviderElement<StateT, ValueT>
    extends ProviderElement<StateT, ValueT> {
  /// The [ProviderElement] of a [$ValueProvider]
  _ValueProviderElement(this.provider, super.pointer);

  /// A custom listener called when `overrideWithValue` changes
  /// with a different value.
  void Function(StateT value)? onChange;

  @override
  $ValueProvider<StateT, ValueT> provider;

  @override
  void update(covariant $ValueProvider<StateT, ValueT> newProvider) {
    super.update(newProvider);
    provider = newProvider;
    final newValue = provider._value;

    // `getState` will never be in error/loading state since there is no "create"
    final previousState = stateResult! as $ResultData<StateT>;

    if (newValue != previousState.value) {
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

  void _setValue(StateT value) => setStateResult($ResultData(value));

  @override
  WhenComplete create(Ref ref) {
    _setValue(provider._value);

    return null;
  }
}

@internal
final class $AsyncValueProvider<ValueT>
    extends $ValueProvider<AsyncValue<ValueT>, ValueT> {
  const $AsyncValueProvider(super._value);

  /// @nodoc
  @internal
  @override
  // ignore: library_private_types_in_public_api, not public API
  _AsyncValueProviderElement<ValueT> $createElement(
    $ProviderPointer pointer,
  ) {
    return _AsyncValueProviderElement(this, pointer);
  }
}

class _AsyncValueProviderElement<ValueT>
    extends _ValueProviderElement<AsyncValue<ValueT>, ValueT>
    with FutureModifierElement<ValueT> {
  _AsyncValueProviderElement(super.provider, super.pointer);

  @override
  void _setValue(AsyncValue<ValueT> value) {
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
