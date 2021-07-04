import 'package:meta/meta.dart';

import '../riverpod.dart';

/// A provider that is driven by a value instead of a function.
///
/// This is an implementation detail of `overrideWithValue`.
@sealed
class ValueProvider<State> extends AlwaysAliveProviderBase<State> {
  /// Creates a [ValueProvider].
  ValueProvider(this._value, [this._create]) : super(null);

  final State Function(ValueProviderElement<State> ref)? _create;

  final State _value;

  @override
  State create(ValueProviderElement<State> ref) {
    if (_create == null) return _value;
    return _create!(ref);
  }

  @override
  bool recreateShouldNotify(State previousState, State newState) {
    return true;
  }

  @override
  ValueProviderElement<State> createElement() {
    return ValueProviderElement(this);
  }

  @override
  void setupOverride(SetupOverride setup) {}
}

/// The [ProviderElementBase] of a [ValueProvider]
@sealed
class ValueProviderElement<State> extends ProviderElementBase<State> {
  /// The [ProviderElementBase] of a [ValueProvider]
  ValueProviderElement(
    ValueProvider<State> provider,
  ) : super(provider);

  /// A custom listener called when `overrideWithValue` changes
  /// with a different value.
  void Function(State value)? onChange;

  @override
  void update(ProviderBase<State> newProvider) {
    super.update(newProvider);
    final newValue = (provider as ValueProvider<State>)._value;
    if (newValue != state) {
      state = newValue;
      onChange?.call(newValue);
    }
  }
}
