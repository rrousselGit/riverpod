part of '../framework.dart';

/// A provider that is driven by a value instead of a function.
///
/// This is an implementation detail of [RootProvider.overrideWithValue].
class ValueProvider<Created, Listened>
    extends AlwaysAliveProviderBase<Created, Listened> {
  /// Creates a [ValueProvider].
  ValueProvider(
    Created Function(ValueProviderElement<Created, Listened> ref) create,
    this._value,
  ) : super((ref) => create(ref as ValueProviderElement<Created, Listened>),
            null);

  final Listened _value;

  @override
  _ValueProviderState<Created, Listened> createState() {
    return _ValueProviderState();
  }

  @override
  ValueProviderElement<Created, Listened> createElement() {
    return ValueProviderElement(this);
  }

  @override
  Override overrideWithValue(Listened value) {
    throw UnimplementedError();
  }
}

/// The [ProviderElement] of a [ValueProvider]
class ValueProviderElement<Created, Listened>
    extends ProviderElement<Created, Listened> {
  /// The [ProviderElement] of a [ValueProvider]
  ValueProviderElement(
    ValueProvider<Created, Listened> provider,
  ) : super(provider);

  /// A custom listener called when [RootProvider.overrideWithValue] changes
  /// with a different value.
  void Function(Listened value) onChange;

  @override
  void mount() {
    super.mount();
  }

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

class _ValueProviderState<Created, Listened>
    extends ProviderStateBase<Created, Listened> {
  @override
  void valueChanged({Object previous}) {
    exposedValue =
        ((ref as ProviderElement).provider as ValueProvider<Created, Listened>)
            ._value;
  }
}
