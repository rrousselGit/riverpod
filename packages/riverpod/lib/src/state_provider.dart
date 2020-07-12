import 'package:state_notifier/state_notifier.dart';

import 'builders.dart';
import 'common.dart';
import 'framework/framework.dart';
import 'provider/provider.dart';

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
}

/// A provider that expose a value which can be modified from outside.
///
/// It can be useful for very simple states, like a filter or the currently
/// selected item – which can then be combined with [Computed] or accessed
/// in multiple screens.
///
/// The following code shows a list of products, and allows selecting
/// a product by tapping on it.
///
/// ```dart
/// final selectedProductIdProvider = StateProvider<String>((ref) => null);
/// final productsProvider = StateNotifierProvider<ProductsNotifier>((ref) => ProductsNotifier());
///
/// Widget build(BuildContext context) {
///   final List<Product> products = useProvider(productsProvider.state);
///   final selectedProductId = useProvider(selectedProductIdProvider);
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
class StateProvider<T> extends AlwaysAliveProviderBase<
    ProviderDependency<StateController<T>>, StateController<T>> {
  /// Creates the initial value
  StateProvider(this._create, {String name}) : super(name);

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  final Create<T, ProviderReference> _create;

  @override
  _ProviderState<T> createState() => _ProviderState();
}

class _ProviderState<T> extends ProviderStateBase<
    ProviderDependency<StateController<T>>,
    StateController<T>,
    StateProvider<T>> {
  @override
  StateController<T> state;
  VoidCallback _removeListener;

  @override
  void initState() {
    // ignore: invalid_use_of_visible_for_testing_member
    state = StateController(provider._create(ProviderReference(this)));
    _removeListener = state.addListener((_) => markMayHaveChanged());
  }

  @override
  ProviderDependency<StateController<T>> createProviderDependency() {
    return ProviderDependencyImpl(state);
  }

  @override
  void dispose() {
    _removeListener();
    state.dispose();
    super.dispose();
  }
}

/// Creates a [StateProvider] from external parameters.
///
/// See also:
///
/// - [ProviderFamily], which contains an explanation of what a *Family is.
class StateProviderFamily<Result, A> extends Family<StateProvider<Result>, A> {
  /// Creates a [StateProvider] from external parameters.
  StateProviderFamily(Result Function(ProviderReference ref, A a) create)
      : super((a) => StateProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
    Result Function(ProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) => StateProvider<Result>((ref) => override(ref, value as A)),
    );
  }
}
