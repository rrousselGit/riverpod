import 'package:meta/meta.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../internals.dart';

ProviderElementProxy<T, NotifierT>
    _notifier<NotifierT extends StateNotifier<T>, T>(
  _StateNotifierProviderBase<NotifierT, T> that,
) {
  return ProviderElementProxy<T, NotifierT>(
    that,
    (element) {
      return (element as StateNotifierProviderElement<NotifierT, T>)
          ._notifierNotifier;
    },
  );
}

abstract class _StateNotifierProviderBase<NotifierT extends StateNotifier<T>, T>
    extends ProviderBase<T> {
  const _StateNotifierProviderBase({
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
  });

  /// Obtains the [StateNotifier] associated with this provider, without listening
  /// to state changes.
  ///
  /// This is typically used to invoke methods on a [StateNotifier]. For example:
  ///
  /// ```dart
  /// Button(
  ///   onTap: () => ref.read(stateNotifierProvider.notifier).increment(),
  /// )
  /// ```
  ///
  /// This listenable will notify its notifiers if the [StateNotifier] instance
  /// changes.
  /// This may happen if the provider is refreshed or one of its dependencies
  /// has changes.
  ProviderListenable<NotifierT> get notifier;

  NotifierT _create(covariant StateNotifierProviderElement<NotifierT, T> ref);
}

/// {@macro riverpod.provider_ref_base}
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class StateNotifierProviderRef<NotifierT extends StateNotifier<T>, T>
    implements Ref<T> {
  /// The [StateNotifier] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  NotifierT get notifier;
}

/// {@template riverpod.statenotifierprovider}
/// Creates a [StateNotifier] and exposes its current state.
///
/// This provider is used in combination with `package:state_notifier`.
///
/// Combined with [StateNotifier], [StateNotifierProvider] can be used to manipulate
/// advanced states, that would otherwise be difficult to represent with simpler
/// providers such as [Provider] or [FutureProvider].
///
/// For example, you may have a todo-list, where you can add and remove
/// and complete a todo.
/// Using [StateNotifier], you could represent such state as:
///
/// ```dart
/// class TodosNotifier extends StateNotifier<List<Todo>> {
///   TodosNotifier(): super([]);
///
///   void add(Todo todo) {
///     state = [...state, todo];
///   }
///
///   void remove(String todoId) {
///     state = [
///       for (final todo in state)
///         if (todo.id != todoId) todo,
///     ];
///   }
///
///   void toggle(String todoId) {
///     state = [
///       for (final todo in state)
///         if (todo.id == todoId) todo.copyWith(completed: !todo.completed),
///     ];
///   }
/// }
/// ```
///
/// Which you can then pass to a [StateNotifierProvider] like so:
///
/// ```dart
/// final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) => TodosNotifier());
/// ```
///
/// And finally, you can interact with it inside your UI:
///
/// ```dart
/// Widget build(BuildContext context, WidgetRef ref) {
///   // rebuild the widget when the todo list changes
///   List<Todo> todos = ref.watch(todosProvider);
///
///   return ListView(
///     children: [
///       for (final todo in todos)
///         CheckboxListTile(
///            value: todo.completed,
///            // When tapping on the todo, change its completed status
///            onChanged: (value) => ref.read(todosProvider.notifier).toggle(todo.id),
///            title: Text(todo.description),
///         ),
///     ],
///   );
/// }
/// ```
/// {@endtemplate}
class StateNotifierProvider<NotifierT extends StateNotifier<T>, T>
    extends _StateNotifierProviderBase<NotifierT, T>
    with
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderBase<T> {
  /// {@macro riverpod.statenotifierprovider}
  StateNotifierProvider(
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
  StateNotifierProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StateNotifierProviderFamilyBuilder();

  // ignore: deprecated_member_use_from_same_package
  final NotifierT Function(StateNotifierProviderRef<NotifierT, T> ref)
      _createFn;

  @override
  NotifierT _create(StateNotifierProviderElement<NotifierT, T> ref) {
    return _createFn(ref);
  }

  @internal
  @override
  StateNotifierProviderElement<NotifierT, T> createElement() {
    return StateNotifierProviderElement._(this);
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<NotifierT> notifier = _notifier(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Create<NotifierT, StateNotifierProviderRef<NotifierT, T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StateNotifierProvider<NotifierT, T>.internal(
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

/// The element of [StateNotifierProvider].
@internal
class StateNotifierProviderElement<NotifierT extends StateNotifier<T>, T>
    extends ProviderElementBase<T>
    implements
        // ignore: deprecated_member_use_from_same_package
        StateNotifierProviderRef<NotifierT, T> {
  StateNotifierProviderElement._(
    _StateNotifierProviderBase<NotifierT, T> super._provider,
  );

  @override
  NotifierT get notifier => _notifierNotifier.value;
  final _notifierNotifier = $ElementLense<NotifierT>();

  void Function()? _removeListener;

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as _StateNotifierProviderBase<NotifierT, T>;

    final notifier =
        _notifierNotifier.result = $Result.guard(() => provider._create(this));

    _removeListener = notifier
        // TODO test requireState, as ref.read(p) is expected to throw if notifier creation failed
        .requireState
        .addListener(setState, fireImmediately: true);
  }

  @override
  bool updateShouldNotify(T previous, T next) {
    // TODO test that updateShouldNotify is applied
    return _notifierNotifier.result!.requireState
        // ignore: invalid_use_of_protected_member
        .updateShouldNotify(previous, next);
  }

  @override
  void runOnDispose() {
    super.runOnDispose();

    _removeListener?.call();
    _removeListener = null;

    final notifier = _notifierNotifier.result?.value;
    if (notifier != null) {
      // TODO test STateNotifier.dispose is guarded
      runGuarded(notifier.dispose);
    }
    _notifierNotifier.result = null;
  }

  @override
  void visitChildren({
    required void Function(ProviderElementBase element) elementVisitor,
    required void Function($ElementLense element) notifierVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      notifierVisitor: notifierVisitor,
    );
    notifierVisitor(_notifierNotifier);
  }
}

/// The [Family] of [StateNotifierProvider].
class StateNotifierProviderFamily<NotifierT extends StateNotifier<T>, T, Arg>
    // ignore: deprecated_member_use_from_same_package
    extends FamilyBase<StateNotifierProviderRef<NotifierT, T>, T, Arg,
        NotifierT, StateNotifierProvider<NotifierT, T>> {
  /// The [Family] of [StateNotifierProvider].
  StateNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: StateNotifierProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          debugGetCreateSourceHash: null,
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    NotifierT Function(StateNotifierProviderRef<NotifierT, T> ref, Arg arg)
        create,
  ) {
    return FamilyOverrideImpl<T, Arg, StateNotifierProvider<NotifierT, T>>(
      this,
      (arg) => StateNotifierProvider<NotifierT, T>.internal(
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
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class AutoDisposeStateNotifierProviderRef<
        NotifierT extends StateNotifier<T>,
        T> extends StateNotifierProviderRef<NotifierT, T>
    implements AutoDisposeRef<T> {}

/// {@macro riverpod.statenotifierprovider}
class AutoDisposeStateNotifierProvider<NotifierT extends StateNotifier<T>, T>
    extends _StateNotifierProviderBase<NotifierT, T> {
  /// {@macro riverpod.statenotifierprovider}
  AutoDisposeStateNotifierProvider(
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
  AutoDisposeStateNotifierProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateNotifierProviderFamily.new;

  final NotifierT Function(
    // ignore: deprecated_member_use_from_same_package
    AutoDisposeStateNotifierProviderRef<NotifierT, T> ref,
  ) _createFn;

  @override
  NotifierT _create(AutoDisposeStateNotifierProviderElement<NotifierT, T> ref) {
    return _createFn(ref);
  }

  @internal
  @override
  AutoDisposeStateNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeStateNotifierProviderElement._(this);
  }

  @override
  late final Refreshable<NotifierT> notifier = _notifier(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Create<NotifierT, AutoDisposeStateNotifierProviderRef<NotifierT, T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeStateNotifierProvider<NotifierT, T>.internal(
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

/// The element of [AutoDisposeStateNotifierProvider].
@internal
class AutoDisposeStateNotifierProviderElement<
        NotifierT extends StateNotifier<T>,
        T> extends StateNotifierProviderElement<NotifierT, T>
    with
        AutoDisposeProviderElementMixin<T>
    implements
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeStateNotifierProviderRef<NotifierT, T> {
  /// The [ProviderElementBase] for [StateNotifierProvider]
  AutoDisposeStateNotifierProviderElement._(
    AutoDisposeStateNotifierProvider<NotifierT, T> super._provider,
  ) : super._();
}

/// The [Family] of [AutoDisposeStateNotifierProvider].
class AutoDisposeStateNotifierProviderFamily<NotifierT extends StateNotifier<T>, T, Arg>
    extends AutoDisposeFamilyBase<
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeStateNotifierProviderRef<NotifierT, T>,
        T,
        Arg,
        NotifierT,
        AutoDisposeStateNotifierProvider<NotifierT, T>> {
  /// The [Family] of [AutoDisposeStateNotifierProvider].
  AutoDisposeStateNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeStateNotifierProvider.internal,
          debugGetCreateSourceHash: null,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    NotifierT Function(
      // ignore: deprecated_member_use_from_same_package
      AutoDisposeStateNotifierProviderRef<NotifierT, T> ref,
      Arg arg,
    ) create,
  ) {
    return FamilyOverrideImpl<T, Arg,
        AutoDisposeStateNotifierProvider<NotifierT, T>>(
      this,
      (arg) => AutoDisposeStateNotifierProvider<NotifierT, T>.internal(
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
