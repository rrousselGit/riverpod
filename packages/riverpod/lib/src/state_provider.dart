import 'package:meta/meta.dart';

import '../riverpod.dart';
import 'internals.dart';

part 'state_provider/auto_dispose.dart';
part 'state_provider/base.dart';

/// A [StateNotifier] that allows modifying its [state] from outside.
///
/// This avoids having to make a [StateNotifier] subclass for simple scenarios.
class StateController<T> extends StateNotifier<T> {
  /// Initialize the state of [StateController].
  StateController(T state) : super(state);

  // Remove the protected status
  @override
  T get state => super.state;

  @override
  set state(T value) => super.state = value;

  /// Calls a function with the current [state] and assign the result as new state
  ///
  /// This allows simplifying the syntax for updating the state when the update
  /// depends on the previous state, such that rather than:
  ///
  /// ```dart
  /// ref.read(provider).state = ref.read(provider).state + 1;
  /// ```
  ///
  /// we can do:
  ///
  /// ```dart
  /// ref.read(provider).update((state) => state + 1);
  /// ```
  T update(T Function(T state) cb) => state = cb(state);
}

/// {@template riverpod.stateprovider}
/// A provider that expose a value which can be modified from outside.
///
/// It can be useful for very simple states, like a filter or the currently
/// selected item – which can then be combined with other providers or accessed
/// in multiple screens.
///
/// The following code shows a list of products, and allows selecting
/// a product by tapping on it.
///
/// ```dart
/// final selectedProductIdProvider = StateProvider<String?>((ref) => null);
/// final productsProvider = StateNotifierProvider<ProductsNotifier>((ref) => ProductsNotifier());
///
/// Widget build(BuildContext context, WidgetRef ref) {
///   final List<Product> products = ref.watch(productsProvider);
///   final selectedProductId = ref.watch(selectedProductIdProvider);
///
///   return ListView(
///     children: [
///       for (final product in products)
///         GestureDetector(
///           onTap: () => selectedProductId.state = product.id,
///           child: ProductItem(
///             product: product,
///             isSelected: selectedProductId.state == product.id,
///           ),
///         ),
///     ],
///   );
/// }
/// ```
/// {@endtemplate}
StateController<State> _listenStateProvider<State>(
  ProviderElementBase<StateController<State>> ref,
  StateController<State> controller,
) {
  void listener(State newState) {
    ref.setState(controller);
  }

  // No need to remove the listener on dispose, since we are disposing the controller
  controller.addListener(listener, fireImmediately: false);

  return controller;
}

/// Add [overrideWithValue] to [StateProvider]
mixin StateProviderOverrideMixin<State>
    on ProviderBase<StateController<State>> {
  ///
  ProviderBase<StateController<State>> get notifier;

  @override
  late final List<ProviderOrFamily>? dependencies = [notifier];

  @override
  ProviderBase<StateController<State>> get originProvider => notifier;

  /// {@macro riverpod.overrridewithvalue}
  Override overrideWithValue(StateController<State> value) {
    return ProviderOverride(
      origin: notifier,
      override: ValueProvider<StateController<State>>(value),
    );
  }
}
