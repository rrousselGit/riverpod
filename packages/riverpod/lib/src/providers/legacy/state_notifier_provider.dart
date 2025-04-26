import 'package:meta/meta.dart';

import '../../internals.dart';

/// {@template riverpod.state_notifier_provider}
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
@publicInLegacy
final class StateNotifierProvider< //
        NotifierT extends StateNotifier<StateT>,
        StateT> //
    extends $FunctionalProvider< //
        StateT,
        NotifierT> with LegacyProviderMixin<StateT> {
  /// {@macro riverpod.state_notifier_provider}
  StateNotifierProvider(
    this._create, {
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
  StateNotifierProvider.internal(
    this._create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.retry,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StateNotifierProviderFamilyBuilder();

  final NotifierT Function(Ref ref) _create;
  @override
  NotifierT create(Ref ref) => _create(ref);

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
  Refreshable<NotifierT> get notifier =>
      ProviderElementProxy<NotifierT, StateT>(
        this,
        (element) {
          return (element as _StateNotifierProviderElement<NotifierT, StateT>)
              ._notifierNotifier;
        },
      );

  /// @nodoc
  @internal
  @override
  // ignore: library_private_types_in_public_api, not public API
  _StateNotifierProviderElement<NotifierT, StateT> $createElement(
    $ProviderPointer pointer,
  ) {
    return _StateNotifierProviderElement._(pointer);
  }
}

/// The element of [StateNotifierProvider].
class _StateNotifierProviderElement<NotifierT extends StateNotifier<StateT>,
    StateT> extends $FunctionalProviderElement<StateT, NotifierT> {
  _StateNotifierProviderElement._(super.pointer);

  final _notifierNotifier = $ElementLense<NotifierT>();

  void Function()? _removeListener;

  @override
  WhenComplete create($Ref<StateT> ref) {
    final notifier = _notifierNotifier.result = $Result.guard(
      () => provider.create(ref),
    );

    _removeListener = notifier.requireState.addListener(
      (newState) => setStateResult($ResultData(newState)),
      fireImmediately: true,
    );

    return null;
  }

  @override
  bool updateShouldNotify(StateT previous, StateT next) {
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
      runGuarded(notifier.dispose);
    }
    _notifierNotifier.result = null;
  }

  @override
  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {
    super.visitListenables(listenableVisitor);
    listenableVisitor(_notifierNotifier);
  }
}

/// The [Family] of [StateNotifierProvider].
@publicInMisc
final class StateNotifierProviderFamily<NotifierT extends StateNotifier<T>, T,
        Arg>
    extends FunctionalFamily<T, Arg, NotifierT,
        StateNotifierProvider<NotifierT, T>> {
  /// The [Family] of [StateNotifierProvider].
  /// @nodoc
  @internal
  StateNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: StateNotifierProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}
