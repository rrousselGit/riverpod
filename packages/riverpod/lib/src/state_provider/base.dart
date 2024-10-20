part of '../state_provider.dart';

/// {@macro riverpod.provider_ref_base}
/// - [controller], the [StateController] currently exposed by this provider.
@Deprecated('will be removed in 3.0.0. Use Ref instead')
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
    with
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderBase<T> {
  /// {@macro riverpod.stateprovider}
  StateProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    @Deprecated('Will be removed in 3.0.0') super.from,
    @Deprecated('Will be removed in 3.0.0') super.argument,
    @Deprecated('Will be removed in 3.0.0') super.debugGetCreateSourceHash,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// An implementation detail of Riverpod
  @internal
  StateProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  // ignore: deprecated_member_use_from_same_package
  final T Function(StateProviderRef<T> ref) _createFn;

  @override
  T _create(StateProviderElement<T> ref) => _createFn(ref);

  @override
  StateProviderElement<T> createElement() => StateProviderElement._(this);

  @override
  // ignore: deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<StateController<T>> notifier =
      _notifier(this);

  @Deprecated(
    'Will be removed in 3.0.0. '
    'Use either `ref.watch(provider)` or `ref.read(provider.notifier)` instead',
  )
  @override
  late final AlwaysAliveRefreshable<StateController<T>> state = _state(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Create<T, StateProviderRef<T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StateProvider<T>.internal(
        create,
        from: from,
        argument: argument,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: null,
      ),
    );
  }
}

/// The element of [StateProvider].
class StateProviderElement<T> extends ProviderElementBase<T>
    implements
        // ignore: deprecated_member_use_from_same_package
        StateProviderRef<T> {
  StateProviderElement._(_StateProviderBase<T> super._provider);

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
    // ignore: deprecated_member_use_from_same_package
    extends FamilyBase<StateProviderRef<R>, R, Arg, R, StateProvider<R>> {
  /// The [Family] of [StateProvider].
  StateProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: StateProvider.internal,
          debugGetCreateSourceHash: null,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    R Function(StateProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<R, Arg, StateProvider<R>>(
      this,
      (arg) => StateProvider<R>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: null,
      ),
    );
  }
}
