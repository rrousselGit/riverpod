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
final class StateProvider<ValueT>
    extends $FunctionalProvider<ValueT, ValueT, ValueT>
    with LegacyProviderMixin<ValueT> {
  /// {@macro riverpod.state_provider}
  StateProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
         $allTransitiveDependencies: computeAllTransitiveDependencies(
           dependencies,
         ),
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
    required super.$allTransitiveDependencies,
    required super.isAutoDispose,
    required super.from,
    required super.argument,
    required super.retry,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  final ValueT Function(Ref ref) _createFn;
  @override
  ValueT create(Ref ref) => _createFn(ref);

  /// Obtains the [StateController] of this provider.
  ///
  /// The value obtained may change if the provider is refreshed (such as using
  /// [Ref.watch] or [Ref.refresh]).
  Refreshable<StateController<ValueT>> get notifier =>
      ProviderElementProxy<StateController<ValueT>, ValueT>(
        this,
        (element) {
          return (element as _StateProviderElement<ValueT>)._controllerNotifier;
        },
      );

  /// @nodoc
  @internal
  @override
  // ignore: library_private_types_in_public_api, not public
  _StateProviderElement<ValueT> $createElement(
    $ProviderPointer pointer,
  ) {
    return _StateProviderElement._(pointer);
  }
}

/// The element of [StateProvider].
class _StateProviderElement<ValueT>
    extends $FunctionalProviderElement<ValueT, ValueT, ValueT>
    with SyncProviderElement<ValueT> {
  _StateProviderElement._(super.pointer);

  final _controllerNotifier = $Observable<StateController<ValueT>>();

  final _stateNotifier = $Observable<StateController<ValueT>>();

  void Function()? _removeListener;

  @override
  WhenComplete create(Ref ref) {
    final initialState = provider.create(ref);

    final controller = StateController(initialState);
    _controllerNotifier.result = $Result.data(controller);

    _removeListener = controller.addListener(
      fireImmediately: true,
      (state) {
        _stateNotifier.result = _controllerNotifier.result;
        value = AsyncData(state);
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
    void Function($Observable element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);
    listenableVisitor(_stateNotifier);
    listenableVisitor(_controllerNotifier);
  }
}

/// The [Family] of [StateProvider].
@publicInLegacy
final class StateProviderFamily<ValueT, ArgT>
    extends
        FunctionalFamily<
          //
          ValueT,
          ValueT,
          ArgT,
          ValueT,
          StateProvider<ValueT>
        > {
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
         $allTransitiveDependencies: computeAllTransitiveDependencies(
           dependencies,
         ),
       );

  /// The [Family] of [AsyncNotifierProvider].
  /// @nodoc
  @internal
  StateProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    required super.$allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  }) : super(providerFactory: StateProvider.internal);
}
