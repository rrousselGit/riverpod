import 'package:meta/meta.dart';

import '../../internals.dart';
import 'state_controller.dart';

ProviderElementProxy<T, StateController<T>> _notifier<T>(
  _StateProviderBase<T> that,
) {
  return ProviderElementProxy<T, StateController<T>>(
    that,
    (element) {
      return (element as StateProviderElement<T>)._controllerNotifier;
    },
  );
}

ProviderElementProxy<T, StateController<T>> _state<T>(
  _StateProviderBase<T> that,
) {
  return ProviderElementProxy<T, StateController<T>>(
    that,
    (element) {
      return (element as StateProviderElement<T>)._stateNotifier;
    },
  );
}

abstract class _StateProviderBase<T> extends ProviderBase<T> {
  const _StateProviderBase({
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required DebugGetCreateSourceHash? debugGetCreateSourceHash,
    required super.isAutoDispose,
  }) : _debugGetCreateSourceHash = debugGetCreateSourceHash;

  ProviderListenable<StateController<T>> get notifier;
  ProviderListenable<StateController<T>> get state;

  T _create(covariant StateProviderElement<T> ref);

  final DebugGetCreateSourceHash? _debugGetCreateSourceHash;
  @override
  String? debugGetCreateSourceHash() => _debugGetCreateSourceHash?.call();
}

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
          isAutoDispose: false,
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
    super.isAutoDispose = false,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  // ignore: deprecated_member_use_from_same_package
  final T Function(StateProviderRef<T> ref) _createFn;

  @override
  T _create(StateProviderElement<T> ref) => _createFn(ref);

  @internal
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
@internal
class StateProviderElement<T> extends ProviderElementBase<T>
    implements
        // ignore: deprecated_member_use_from_same_package
        StateProviderRef<T>,
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeStateProviderRef<T> {
  StateProviderElement._(_StateProviderBase<T> super._provider);

  @override
  StateController<T> get controller => _controllerNotifier.value;
  final _controllerNotifier = $ElementLense<StateController<T>>();

  final _stateNotifier = $ElementLense<StateController<T>>();

  void Function()? _removeListener;

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as _StateProviderBase<T>;
    final initialState = provider._create(this);

    final controller = StateController(initialState);
    _controllerNotifier.result = $Result.data(controller);

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
          isAutoDispose: false,
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

/// {@macro riverpod.provider_ref_base}
/// - [controller], the [StateController] currently exposed by this provider.
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class AutoDisposeStateProviderRef<State>
    extends StateProviderRef<State> implements AutoDisposeRef<State> {}

/// {@macro riverpod.stateprovider}
class AutoDisposeStateProvider<T> extends _StateProviderBase<T> {
  /// {@macro riverpod.stateprovider}
  AutoDisposeStateProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    @Deprecated('Will be removed in 3.0.0') super.from,
    @Deprecated('Will be removed in 3.0.0') super.argument,
    @Deprecated('Will be removed in 3.0.0') super.debugGetCreateSourceHash,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          isAutoDispose: true,
        );

  /// An implementation detail of Riverpod
  @internal
  AutoDisposeStateProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
    super.isAutoDispose = true,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateProviderFamily.new;

  // ignore: deprecated_member_use_from_same_package
  final T Function(AutoDisposeStateProviderRef<T> ref) _createFn;

  @override
  T _create(AutoDisposeStateProviderElement<T> ref) => _createFn(ref);

  @internal
  @override
  AutoDisposeStateProviderElement<T> createElement() {
    return AutoDisposeStateProviderElement._(this);
  }

  @override
  late final Refreshable<StateController<T>> notifier = _notifier(this);

  @Deprecated(
    'Will be removed in 3.0.0. '
    'Use either `ref.watch(provider)` or `ref.read(provider.notifier)` instead',
  )
  @override
  late final Refreshable<StateController<T>> state = _state(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Create<T, AutoDisposeStateProviderRef<T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeStateProvider<T>.internal(
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
@internal
typedef AutoDisposeStateProviderElement<T> = StateProviderElement<T>;

/// The [Family] of [StateProvider].
class AutoDisposeStateProviderFamily<R, Arg> extends FamilyBase<
    // ignore: deprecated_member_use_from_same_package
    AutoDisposeStateProviderRef<R>,
    R,
    Arg,
    R,
    AutoDisposeStateProvider<R>> {
  /// The [Family] of [StateProvider].
  AutoDisposeStateProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeStateProvider.internal,
          debugGetCreateSourceHash: null,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          isAutoDispose: true,
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    R Function(AutoDisposeStateProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<R, Arg, AutoDisposeStateProvider<R>>(
      this,
      (arg) => AutoDisposeStateProvider<R>.internal(
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
