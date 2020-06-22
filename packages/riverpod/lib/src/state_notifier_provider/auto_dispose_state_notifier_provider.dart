import 'package:state_notifier/state_notifier.dart';

import '../common.dart';
import '../framework/framework.dart';
import '../internals.dart';

/// Creates a [StateNotifier] and expose its current state.
///
/// Listening to this provider will not cause widget to rebuild when [StateNotifier.state]
/// changes.
///
/// Instead, listen to `AutoDisposeStateNotifierProvider.state`:
///
/// ```dart
/// class Counter extends StateNotifier<int> {
///   Counter(): super(0);
/// }
///
/// final counterProvider = AutoDisposeStateNotifierProvider((_) => Counter());
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
class AutoDisposeStateNotifierProvider<Notifier extends StateNotifier<Object>>
    extends AutoDisposeProvider<Notifier> {
  /// Creates a [StateNotifier] and expose it + its state.
  AutoDisposeStateNotifierProvider(
    Create<Notifier, AutoDisposeProviderReference> create, {
    String name,
  }) : super(
          (ref) {
            final notifier = create(ref);
            ref.onDispose(notifier.dispose);
            return notifier;
          },
          name: name,
        );

  AutoDisposeSetStateProvider<Object> _state;
}

/// Adds [state] to [AutoDisposeStateNotifierProvider].
///
/// This is done as an extension as a workaround to language limitations around
/// generic parameters.
extension AutoDisposeStateNotifierStateProviderX<Value>
    on AutoDisposeStateNotifierProvider<StateNotifier<Value>> {
  /// A provider that expose the state of a [StateNotifier].
  AutoDisposeStateNotifierStateProvider<Value> get state {
    _state ??= AutoDisposeStateNotifierStateProvider<Value>._(this);
    return _state as AutoDisposeStateNotifierStateProvider<Value>;
  }
}

/// Implementation detail of [AutoDisposeStateNotifierProvider].
class AutoDisposeStateNotifierStateProvider<T>
    extends AutoDisposeSetStateProvider<T> {
  AutoDisposeStateNotifierStateProvider._(this.notifierProvider)
      : super((ref) {
          final notifier = ref.read(notifierProvider).value;

          ref.onDispose(
            notifier.addListener((newValue) => ref.state = newValue),
          );

          return ref.state;
        },
            name: notifierProvider.name == null
                ? null
                : '${notifierProvider.name}.state');

  /// The [AutoDisposeStateNotifierProvider] associated with this [AutoDisposeStateNotifierStateProvider].
  final AutoDisposeStateNotifierProvider<StateNotifier<T>> notifierProvider;
}

/// Creates a [AutoDisposeStateNotifierProvider] from external parameters.
///
/// See also:
///
/// - [ProviderFamily], which contains an explanation of what a *Family is.
class AutoDisposeStateNotifierProviderFamily<
    Result extends StateNotifier<dynamic>,
    A> extends Family<AutoDisposeStateNotifierProvider<Result>, A> {
  /// Creates a [AutoDisposeStateNotifierProvider] from external parameters.
  AutoDisposeStateNotifierProviderFamily(
      Result Function(AutoDisposeProviderReference ref, A a) create)
      : super((a) => AutoDisposeStateNotifierProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
    Result Function(AutoDisposeProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) {
        return AutoDisposeStateNotifierProvider<Result>(
          (ref) => override(ref, value as A),
        );
      },
    );
  }
}
