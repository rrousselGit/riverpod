import 'package:meta/meta.dart';

import 'framework.dart';

/// A provider that is driven by a value instead of a function.
///
/// This is an implementation detail of `overrideWithValue`.
@sealed
class ValueProvider<State> extends AlwaysAliveProviderBase<State> {
  /// Creates a [ValueProvider].
  ValueProvider(this._value) : super(name: null, from: null, argument: null);

  final State _value;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  ValueProviderElement<State> createElement() {
    return ValueProviderElement(this);
  }
}

/// The [ProviderElementBase] of a [ValueProvider]
@sealed
class ValueProviderElement<State> extends ProviderElementBase<State> {
  /// The [ProviderElementBase] of a [ValueProvider]
  ValueProviderElement(this.provider);

  @override
  ValueProvider<State> provider;

  /// A custom listener called when `overrideWithValue` changes
  /// with a different value.
  void Function(State value)? onChange;

  @override
  void update(ProviderBase<State> newProvider) {
    provider = newProvider as ValueProvider<State>;
    final newValue = provider._value;

    // `getState` will never be in error/loading state since there is no "create"
    final previousState = getState()! as ResultData<State>;

    if (newValue != previousState.state) {
      setState(newValue);
      onChange?.call(newValue);
    }
  }

  @override
  State create() => provider._value;

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return true;
  }
}
