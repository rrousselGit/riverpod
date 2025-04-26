import 'package:meta/meta.dart';

import '../../internals.dart';

/// {@template riverpod.state_provider}
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
@publicInLegacy
final class StateProvider<StateT> extends $FunctionalProvider<StateT, StateT>
    with LegacyProviderMixin<StateT> {
  /// {@macro riverpod.state_provider}
  StateProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
        );

  /// An implementation detail of Riverpod
  /// @nodoc
  @internal
  StateProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required super.from,
    required super.argument,
    required super.retry,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  final StateT Function(Ref ref) _createFn;
  @override
  StateT create(Ref ref) => _createFn(ref);

  /// Obtains the [StateController] of this provider.
  ///
  /// The value obtained may change if the provider is refreshed (such as using
  /// [Ref.watch] or [Ref.refresh]).
  Refreshable<StateController<StateT>> get notifier =>
      ProviderElementProxy<StateController<StateT>, StateT>(
        this,
        (element) {
          return (element as _StateProviderElement<StateT>)._controllerNotifier;
        },
      );

  /// @nodoc
  @internal
  @override
  // ignore: library_private_types_in_public_api, not public
  _StateProviderElement<StateT> $createElement(
    $ProviderPointer pointer,
  ) {
    return _StateProviderElement._(pointer);
  }
}

/// The element of [StateProvider].
class _StateProviderElement<T> extends $FunctionalProviderElement<T, T> {
  _StateProviderElement._(super.pointer);

  final _controllerNotifier = $ElementLense<StateController<T>>();

  final _stateNotifier = $ElementLense<StateController<T>>();

  void Function()? _removeListener;

  @override
  WhenComplete create($Ref<T> ref) {
    final initialState = provider.create(ref);

    final controller = StateController(initialState);
    _controllerNotifier.result = $Result.data(controller);

    _removeListener = controller.addListener(
      fireImmediately: true,
      (state) {
        _stateNotifier.result = _controllerNotifier.result;
        setStateResult($ResultData(state));
      },
    );

    return null;
  }

  @override
  void runOnDispose() {
    super.runOnDispose();

    _removeListener?.call();
    _removeListener = null;

    _controllerNotifier.result?.value?.dispose();
    _controllerNotifier.result = null;
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);
    listenableVisitor(_stateNotifier);
    listenableVisitor(_controllerNotifier);
  }
}

/// The [Family] of [StateProvider].
@publicInMisc
final class StateProviderFamily<StateT, Arg> extends FunctionalFamily< //
    StateT,
    Arg,
    StateT,
    StateProvider<StateT>> {
  /// The [Family] of [StateProvider].
  /// @nodoc
  @internal
  StateProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: StateProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// The [Family] of [AsyncNotifierProvider].
  /// @nodoc
  @internal
  StateProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  }) : super(providerFactory: StateProvider.internal);
}
