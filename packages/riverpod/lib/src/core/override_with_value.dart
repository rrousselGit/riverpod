part of '../framework.dart';

@reopen
abstract base class _ValueProvider<StateT, ValueT>
    extends $ProviderBaseImpl<StateT>
    with LegacyProviderMixin<StateT> {
  /// Creates a [_ValueProvider].
  const _ValueProvider(this._value)
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
  );
}

/// A provider that is driven by a value instead of a function.
///
/// This is an implementation detail of `overrideWithValue`.
@publicInCodegen
@internal
final class $SyncValueProvider<ValueT> extends _ValueProvider<ValueT, ValueT> {
  /// Creates a [$SyncValueProvider].
  const $SyncValueProvider(super._value);

  @override
  Iterable<ProviderOrFamily>? get dependencies => null;

  @override
  Set<ProviderOrFamily>? get $allTransitiveDependencies => null;

  /// @nodoc
  @internal
  @override
  // ignore: library_private_types_in_public_api, not public API
  _SyncValueProviderElement<ValueT> $createElement($ProviderPointer pointer) {
    return _SyncValueProviderElement(this, pointer);
  }
}

/// The [ProviderElement] of a [_ValueProvider]
abstract class _ValueProviderElement<StateT, ValueT>
    extends ProviderElement<StateT, ValueT>
    with ElementWithFuture {
  /// The [ProviderElement] of a [_ValueProvider]
  _ValueProviderElement(this.provider, super.pointer);

  /// A custom listener called when `overrideWithValue` changes
  /// with a different value.
  void Function(StateT value)? onChange;

  @override
  _ValueProvider<StateT, ValueT> provider;

  @override
  void update(covariant _ValueProvider<StateT, ValueT> newProvider) {
    super.update(newProvider);
    provider = newProvider;
    final newValue = provider._value;

    // `getState` will never be in error/loading state since there is no "create"
    final previousState = stateResult()! as $ResultData<StateT>;

    if (newValue != previousState.value) {
      final debugPreviouslyBuildingElement =
          ProviderElement._debugCurrentlyBuildingElement;
      // Asserts would otherwise prevent a provider rebuild from updating
      // other providers
      if (kDebugMode) {
        _debugSkipNotifyListenersAsserts = true;
        ProviderElement._debugCurrentlyBuildingElement = null;
      }

      _setValue(newValue);

      // Asserts would otherwise prevent a provider rebuild from updating
      // other providers
      if (kDebugMode) {
        _debugSkipNotifyListenersAsserts = false;
        ProviderElement._debugCurrentlyBuildingElement =
            debugPreviouslyBuildingElement;
      }

      onChange?.call(newValue);
    }
  }

  void _setValue(StateT value);

  @override
  WhenComplete create(Ref ref) {
    _setValue(provider._value);

    return null;
  }
}

class _SyncValueProviderElement<ValueT>
    extends _ValueProviderElement<ValueT, ValueT>
    with SyncProviderElement<ValueT> {
  _SyncValueProviderElement(super.provider, super.pointer);

  @override
  void _setValue(ValueT value) {
    this.value = AsyncData(value);
  }
}

/// A provider that is driven by a value instead of a function.
///
/// This is an implementation detail of `overrideWithValue`.
@internal
final class $AsyncValueProvider<ValueT>
    extends _ValueProvider<AsyncValue<ValueT>, ValueT> {
  /// Creates a [$AsyncValueProvider].
  const $AsyncValueProvider(super._value);

  /// @nodoc
  @internal
  @override
  // ignore: library_private_types_in_public_api, not public API
  _AsyncValueProviderElement<ValueT> $createElement($ProviderPointer pointer) {
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
