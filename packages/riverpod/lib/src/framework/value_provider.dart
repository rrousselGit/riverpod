part of '../framework.dart';

/// A provider that is driven by a value instead of a function.
///
/// This is an implementation detail of `overrideWithValue`.
@sealed
class ValueProvider<Created, Listened>
    extends AlwaysAliveProviderBase<Created, Listened> {
  /// Creates a [ValueProvider].
  ValueProvider(this._create, this._value) : super(null);

  final Created Function(ValueProviderElement<Created, Listened> ref) _create;

  @override
  Created create(covariant ValueProviderElement<Created, Listened> ref) =>
      _create(ref);

  final Listened _value;

  @override
  _ValueProviderState<Created, Listened> createState() {
    return _ValueProviderState();
  }

  @override
  ValueProviderElement<Created, Listened> createElement() {
    return ValueProviderElement(this);
  }
}

/// The [ProviderElement] of a [ValueProvider]
@sealed
class ValueProviderElement<Created, Listened>
    extends ProviderElement<Created, Listened> {
  /// The [ProviderElement] of a [ValueProvider]
  ValueProviderElement(
    ValueProvider<Created, Listened> provider,
  ) : super(provider);

  /// A custom listener called when `overrideWithValue` changes
  /// with a different value.
  void Function(Listened value)? onChange;

  @override
  void update(ProviderBase<Created, Listened> newProvider) {
    super.update(newProvider);
    final newValue = (provider as ValueProvider<Created, Listened>)._value;
    if (newValue != state._exposedValue) {
      state.exposedValue = newValue;
      onChange?.call(newValue);
    }
  }
}

@sealed
class _ValueProviderState<Created, Listened>
    extends ProviderStateBase<Created, Listened> {
  @override
  void valueChanged({Object? previous}) {
    exposedValue =
        ((ref as ProviderElement).provider as ValueProvider<Created, Listened>)
            ._value;
  }
}
