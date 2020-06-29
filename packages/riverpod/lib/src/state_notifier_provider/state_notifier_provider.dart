import 'package:state_notifier/state_notifier.dart';

import '../common.dart';
import '../framework/framework.dart';
import '../internals.dart';

/// Creates a [StateNotifier] and expose its current state.
///
/// Listening to this provider will not cause widget to rebuild when [StateNotifier.state]
/// changes.
///
/// Instead, listen to `StateNotifierProvider.state`:
///
/// ```dart
/// class Counter extends StateNotifier<int> {
///   Counter(): super(0);
/// }
///
/// final counterProvider = StateNotifierProvider((_) => Counter());
///
/// // ...
///
/// @override
/// Widget build(BuildContext) {
///   // read the StateNotifier without rebuilding when state changes
///   final Counter counter = useProvider(counterProvider);
///
///   // listen to the state of the StateNotifier
///   final int count = useProvider(counterProvider.state);
/// }
/// ```
// ignore: must_be_immutable, false positive, _state is immutable but lazy loaded.
class StateNotifierProvider<Notifier extends StateNotifier<Object>>
    extends Provider<Notifier> {
  /// Creates a [StateNotifier] and expose it + its state.
  StateNotifierProvider(
    Create<Notifier, ProviderReference> create, {
    String name,
  }) : super(
          (ref) {
            final notifier = create(ref);
            ref.onDispose(notifier.dispose);
            return notifier;
          },
          name: name,
        );

  SetStateProvider<Object> _state;
}

/// Adds [state] to [StateNotifierProvider].
///
/// This is done as an extension as a workaround to language limitations around
/// generic parameters.
extension StateNotifierStateProviderX<Value>
    on StateNotifierProvider<StateNotifier<Value>> {
  /// A provider that expose the state of a [StateNotifier].
  StateNotifierStateProvider<Value> get state {
    _state ??= StateNotifierStateProvider<Value>._(this);
    return _state as StateNotifierStateProvider<Value>;
  }
}

/// Implementation detail of [StateNotifierProvider].
class StateNotifierStateProvider<T> extends SetStateProvider<T> {
  StateNotifierStateProvider._(this.notifierProvider)
      : super((ref) {
          final notifier = ref.dependOn(notifierProvider).value;

          ref.onDispose(
            notifier.addListener((newValue) => ref.state = newValue),
          );

          return ref.state;
        },
            name: notifierProvider.name == null
                ? null
                : '${notifierProvider.name}.state');

  /// The [StateNotifierProvider] associated with this [StateNotifierStateProvider].
  final StateNotifierProvider<StateNotifier<T>> notifierProvider;
}

/// Creates a [StateNotifierProvider] from external parameters.
///
/// See also:
///
/// - [ProviderFamily], which contains an explanation of what a *Family is.
class StateNotifierProviderFamily<Result extends StateNotifier<dynamic>, A>
    extends Family<StateNotifierProvider<Result>, A> {
  /// Creates a [StateNotifierProvider] from external parameters.
  StateNotifierProviderFamily(
      Result Function(ProviderReference ref, A a) create)
      : super((a) => StateNotifierProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
    Result Function(ProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) =>
          StateNotifierProvider<Result>((ref) => override(ref, value as A)),
    );
  }
}
