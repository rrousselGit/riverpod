import 'package:meta/meta.dart';

import '../../builder.dart';
import '../../internals.dart';
import 'state_controller.dart';

ProviderElementProxy<StateController<StateT>, StateT> _notifier<StateT>(
  StateProvider<StateT> that,
) {
  return ProviderElementProxy<StateController<StateT>, StateT>(
    that,
    (element) {
      return (element as StateProviderElement<StateT>)._controllerNotifier;
    },
  );
}

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

  Refreshable<StateController<StateT>> get notifier => _notifier(this);

  @internal
  @override
  StateProviderElement<StateT> $createElement(
    $ProviderPointer pointer,
  ) {
    return StateProviderElement._(this, pointer);
  }

  @mustBeOverridden
  @visibleForOverriding
  @override
  StateProvider<StateT> $copyWithCreate(Create<StateT> create) {
    return StateProvider<StateT>.internal(
      create,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      from: from,
      argument: argument,
      isAutoDispose: isAutoDispose,
      retry: retry,
    );
  }
}

/// The element of [StateProvider].
class StateProviderElement<T> extends ProviderElement<T> {
  StateProviderElement._(this.provider, super.pointer);

  @override
  final StateProvider<T> provider;

  final _controllerNotifier = $ElementLense<StateController<T>>();

  final _stateNotifier = $ElementLense<StateController<T>>();

  void Function()? _removeListener;

  @override
  WhenComplete create(
    Ref ref, {
    required bool isFirstBuild,
    required bool didChangeDependency,
  }) {
    final initialState = provider._createFn(ref);

    final controller = StateController(initialState);
    _controllerNotifier.result = $Result.data(controller);

    _removeListener = controller.addListener(
      fireImmediately: true,
      (state) {
        _stateNotifier.result = _controllerNotifier.result;
        setStateResult(ResultData(state));
      },
    );

    return null;
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
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);
    listenableVisitor(_stateNotifier);
    listenableVisitor(_controllerNotifier);
  }
}

/// The [Family] of [StateProvider].
class StateProviderFamily<StateT, Arg> extends FunctionalFamily< //
    StateT,
    Arg,
    StateT,
    StateProvider<StateT>> {
  /// The [Family] of [AsyncNotifierProvider].
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
