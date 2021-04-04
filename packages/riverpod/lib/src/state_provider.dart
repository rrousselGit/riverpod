import 'package:meta/meta.dart';
import 'package:state_notifier/state_notifier.dart';

import '../riverpod.dart';
import 'builders.dart';
import 'framework.dart';

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
/// Widget build(BuildContext context, ScopedReader watch) {
///   final List<Product> products = watch(productsProvider);
///   final selectedProductId = watch(selectedProductIdProvider);
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
mixin _StateProviderStateMixin<T>
    on ProviderStateBase<StateController<T>, StateController<T>> {
  void Function()? removeListener;

  @override
  void valueChanged({StateController? previous}) {
    if (createdValue == previous) {
      return;
    }

    removeListener?.call();
    exposedValue?.dispose();
    removeListener = createdValue.addListener((state) {
      exposedValue = createdValue;
    });
  }

  @override
  void dispose() {
    removeListener?.call();
    exposedValue!.dispose();
    super.dispose();
  }
}
