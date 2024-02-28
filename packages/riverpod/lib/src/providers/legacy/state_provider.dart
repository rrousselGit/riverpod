import 'package:meta/meta.dart';

import '../../builder.dart';
import '../../internals.dart';
import 'state_controller.dart';

ProviderElementProxy<StateT, StateController<StateT>> _notifier<StateT>(
  StateProvider<StateT> that,
) {
  return ProviderElementProxy<StateT, StateController<StateT>>(
    that,
    (element) {
      return (element as StateProviderElement<StateT>)._controllerNotifier;
    },
  );
}

/// {@macro riverpod.provider_ref_base}
/// - [controller], the [StateController] currently exposed by this provider.
abstract class StateProviderRef<StateT> implements Ref<StateT> {
  /// The [StateController] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  StateController<StateT> get controller;
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
final class StateProvider<StateT>
    extends $FunctionalProvider<StateT, StateT, StateProviderRef<StateT>>
    with LegacyProviderMixin<StateT> {
  /// {@macro riverpod.state_provider}
  StateProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
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
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  final StateT Function(StateProviderRef<StateT> ref) _createFn;

  Refreshable<StateController<StateT>> get notifier => _notifier(this);

  @internal
  @override
  StateProviderElement<StateT> $createElement(
    ProviderContainer container,
  ) {
    return StateProviderElement._(this, container);
  }

  @mustBeOverridden
  @visibleForOverriding
  @override
  StateProvider<StateT> $copyWithCreate(
    Create<StateT, StateProviderRef<StateT>> create,
  ) {
    return StateProvider<StateT>.internal(
      create,
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      from: from,
      argument: argument,
      isAutoDispose: isAutoDispose,
    );
  }
}

/// The element of [StateProvider].
class StateProviderElement<T> extends ProviderElementBase<T>
    implements StateProviderRef<T> {
  StateProviderElement._(this.provider, super.container);

  @override
  final StateProvider<T> provider;

  @override
  StateController<T> get controller => _controllerNotifier.value;
  final _controllerNotifier = ProxyElementValueListenable<StateController<T>>();

  final _stateNotifier = ProxyElementValueListenable<StateController<T>>();

  void Function()? _removeListener;

  @override
  void create({required bool didChangeDependency}) {
    final initialState = provider._createFn(this);

    final controller = StateController(initialState);
    _controllerNotifier.result = Result.data(controller);

    _removeListener = controller.addListener(
      fireImmediately: true,
      (state) {
        _stateNotifier.result = _controllerNotifier.result;
        setStateResult(ResultData(state));
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
    required void Function(ProviderElementBase<Object?> element) elementVisitor,
    required void Function(ProxyElementValueListenable<Object?> element)
        listenableVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      listenableVisitor: listenableVisitor,
    );
    listenableVisitor(_stateNotifier);
    listenableVisitor(_controllerNotifier);
  }
}

/// The [Family] of [StateProvider].
class StateProviderFamily<StateT, Arg> extends FunctionalFamily< //
    StateProviderRef<StateT>,
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
  }) : super(providerFactory: StateProvider.internal);
}
