import 'package:meta/meta.dart';

import 'framework.dart';
import 'result.dart';

/// A provider that is driven by a value instead of a function.
///
/// This is an implementation detail of `overrideWithValue`.
@sealed
@internal
class ValueProvider<State> extends ProviderBase<State>
    with AlwaysAliveProviderBase<State> {
  /// Creates a [ValueProvider].
  ValueProvider(this._value)
      : super(
          name: null,
          from: null,
          argument: null,
          debugGetCreateSourceHash: null,
        );

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
@internal
class ValueProviderElement<State> extends ProviderElementBase<State> {
  /// The [ProviderElementBase] of a [ValueProvider]
  ValueProviderElement(ValueProvider<State> super.provider);

  /// A custom listener called when `overrideWithValue` changes
  /// with a different value.
  void Function(State value)? onChange;

  @override
  void update(ProviderBase<State> newProvider) {
    super.update(newProvider);
    final newValue = (provider as ValueProvider<State>)._value;

    // `getState` will never be in error/loading state since there is no "create"
    final previousState = getState()! as ResultData<State>;

    if (newValue != previousState.state) {
      setState(newValue);
      onChange?.call(newValue);
    }
  }

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as ValueProvider<State>;
    setState(provider._value);
  }

  @override
  bool updateShouldNotify(State previous, State next) {
    return true;
  }
}
