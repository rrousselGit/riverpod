part of '../state_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [controller], the [StateController] currently exposed by this provider.
abstract class StateProviderRef<State> implements Ref<State> {
  /// The [StateController] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  StateController<State> get controller;
}

/// {@template riverpod.stateprovider}
/// A provider that exposes a value that can be modified from outside.
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
/// final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) => ProductsNotifier());
///
/// Widget build(BuildContext context, WidgetRef ref) {
///   final List<Product> products = ref.watch(productsProvider);
///   final selectedProductId = ref.watch(selectedProductIdProvider);
///
///   return ListView(
///     children: [
///       for (final product in products)
///         GestureDetector(
///           onTap: () => ref.read(selectedProductIdProvider.notifier).state = product.id,
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
class StateProvider<T> extends _StateProviderBase<T>
    with AlwaysAliveProviderBase<T> {
  /// {@macro riverpod.stateprovider}
  StateProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  final T Function(StateProviderRef<T> ref) _createFn;

  @override
  T _create(StateProviderElement<T> ref) => _createFn(ref);

  @override
  StateProviderElement<T> createElement() => StateProviderElement._(this);

  @override
  late final AlwaysAliveRefreshable<StateController<T>> notifier =
      _notifier(this);

  @override
  late final AlwaysAliveRefreshable<StateController<T>> state = _state(this);
}

/// The element of [StateProvider].
class StateProviderElement<T> extends ProviderElementBase<T>
    implements StateProviderRef<T> {
  StateProviderElement._(_StateProviderBase<T> super.provider);

  @override
  StateController<T> get controller => _controllerNotifier.value;
  final _controllerNotifier = ProxyElementValueNotifier<StateController<T>>();

  final _stateNotifier = ProxyElementValueNotifier<StateController<T>>();

  void Function()? _removeListener;

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as _StateProviderBase<T>;
    final initialState = provider._create(this);

    final controller = StateController(initialState);
    _controllerNotifier.result = Result.data(controller);

    _removeListener = controller.addListener(
      fireImmediately: true,
      (state) {
        _stateNotifier.result = _controllerNotifier.result;
        setState(state);
      },
    );
  }

  @override
  bool updateShouldNotify(T previous, T next) {
    return !identical(previous, next);
  }

  @override
  void runOnDispose() {
    super.runOnDispose();

    _removeListener?.call();
    _removeListener = null;

    _controllerNotifier.result?.stateOrNull?.dispose();
    _controllerNotifier.result = null;
  }

  @override
  void visitChildren({
    required void Function(ProviderElementBase element) elementVisitor,
    required void Function(ProxyElementValueNotifier element) notifierVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      notifierVisitor: notifierVisitor,
    );
    notifierVisitor(_stateNotifier);
    notifierVisitor(_controllerNotifier);
  }
}

/// The [Family] of [StateProvider].
class StateProviderFamily<R, Arg>
    extends FamilyBase<StateProviderRef<R>, R, Arg, R, StateProvider<R>> {
  /// The [Family] of [StateProvider].
  StateProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: StateProvider.new);
}
