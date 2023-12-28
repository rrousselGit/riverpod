part of '../framework.dart';

/// A mixin to add [overrideWithValue] capability to a provider.
// TODO merge with Provider directy
mixin OverrideWithValueMixin<State> on ProviderBase<State> {
  /// {@template riverpod.overrridewithvalue}
  /// Overrides a provider with a value, ejecting the default behavior.
  ///
  /// This will also disable the auto-scoping mechanism, meaning that if the
  /// overridden provider specified [dependencies], it will have no effect.
  ///
  /// Some common use-cases are:
  /// - testing, by replacing a service with a fake implementation, or to reach
  ///   a very specific state easily.
  /// - multiple environments, by changing the implementation of a class
  ///   based on the platform or other parameters.
  ///
  /// This function should be used in combination with `ProviderScope.overrides`
  /// or `ProviderContainer.overrides`:
  ///
  /// ```dart
  /// final myService = Provider((ref) => MyService());
  ///
  /// runApp(
  ///   ProviderScope(
  ///     overrides: [
  ///       myService.overrideWithValue(
  ///         // Replace the implementation of MyService with a fake implementation
  ///         MyFakeService(),
  ///       ),
  ///     ],
  ///     child: MyApp(),
  ///   ),
  /// );
  /// ```
  /// {@endtemplate}
  Override overrideWithValue(State value) {
    return ProviderOverride(
      origin: this,
      providerOverride: ValueProvider<State>(value),
    );
  }

  @override
  String toString();
}

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

  @override
  String toString() => 'ValueProvider<$State>($_value)';
}

/// The [ProviderElementBase] of a [ValueProvider]
@sealed
@internal
class ValueProviderElement<State> extends ProviderElementBase<State> {
  /// The [ProviderElementBase] of a [ValueProvider]
  ValueProviderElement(ValueProvider<State> super._provider, super.container);

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
    final provider = this.provider as ValueProvider<State>;
    setState(provider._value);
  }

  @override
  bool updateShouldNotify(State previous, State next) {
    return true;
  }
}
