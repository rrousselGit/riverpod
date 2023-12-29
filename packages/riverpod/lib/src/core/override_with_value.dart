part of '../framework.dart';

/// A provider that is driven by a value instead of a function.
///
/// This is an implementation detail of `overrideWithValue`.
@sealed
@internal
class ValueProvider<State> extends ProviderBase<State> {
  /// Creates a [ValueProvider].
  const ValueProvider(this._value)
      : super(
          name: null,
          from: null,
          argument: null,
          debugGetCreateSourceHash: null,
          allTransitiveDependencies: null,
          dependencies: null,
        );

  final State _value;

  @override
  Iterable<ProviderOrFamily>? get dependencies => null;

  @override
  Set<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  ValueProviderElement<State> createElement(ProviderContainer container) {
    return ValueProviderElement(this, container);
  }
}

/// The [ProviderElementBase] of a [ValueProvider]
@sealed
@internal
class ValueProviderElement<State> extends ProviderElementBase<State> {
  /// The [ProviderElementBase] of a [ValueProvider]
  ValueProviderElement(this.provider, super.container);

  /// A custom listener called when `overrideWithValue` changes
  /// with a different value.
  void Function(State value)? onChange;

  @override
  ValueProvider<State> provider;

  @override
  void update(covariant ValueProvider<State> newProvider) {
    super.update(newProvider);
    provider = newProvider;
    final newValue = provider._value;

    // `getState` will never be in error/loading state since there is no "create"
    final previousState = getState()! as ResultData<State>;

    if (newValue != previousState.state) {
      assert(
        () {
          // Asserts would otherwise prevent a provider rebuild from updating
          // other providers
          _debugSkipNotifyListenersAsserts = true;
          return true;
        }(),
        '',
      );
      setState(newValue);
      assert(
        () {
          // Asserts would otherwise prevent a provider rebuild from updating
          // other providers
          _debugSkipNotifyListenersAsserts = false;
          return true;
        }(),
        '',
      );
      onChange?.call(newValue);
    }
  }

  @override
  void create({required bool didChangeDependency}) {
    setState(provider._value);
  }

  @override
  bool updateShouldNotify(State previous, State next) {
    return true;
  }
}
