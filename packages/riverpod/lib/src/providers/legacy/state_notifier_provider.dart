import 'package:meta/meta.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../builder.dart';
import '../../internals.dart';

ProviderElementProxy<StateT, NotifierT>
    _notifier<NotifierT extends StateNotifier<StateT>, StateT>(
  StateNotifierProvider<NotifierT, StateT> that,
) {
  return ProviderElementProxy<StateT, NotifierT>(
    that,
    (element) {
      return (element as StateNotifierProviderElement<NotifierT, StateT>)
          ._notifierNotifier;
    },
  );
}

/// {@macro riverpod.provider_ref_base}
abstract class StateNotifierProviderRef<NotifierT extends StateNotifier<T>, T>
    implements Ref<T> {
  /// The [StateNotifier] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  NotifierT get notifier;
}

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
final class StateNotifierProvider< //
        NotifierT extends StateNotifier<StateT>,
        StateT> //
    extends $FunctionalProvider< //
        StateT,
        NotifierT,
        StateNotifierProviderRef<NotifierT, StateT>>
    with LegacyProviderMixin<StateT> {
  /// {@macro riverpod.statenotifierprovider}
  StateNotifierProvider(
    this._create, {
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
  StateNotifierProvider.internal(
    this._create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StateNotifierProviderFamilyBuilder();

  final NotifierT Function(StateNotifierProviderRef<NotifierT, StateT> ref)
      _create;

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
  Refreshable<NotifierT> get notifier => _notifier(this);

  @override
  StateNotifierProviderElement<NotifierT, StateT> createElement(
    ProviderContainer container,
  ) {
    return StateNotifierProviderElement._(this, container);
  }

  @mustBeOverridden
  @visibleForOverriding
  @override
  StateNotifierProvider<NotifierT, StateT> $copyWithCreate(
    Create<NotifierT, StateNotifierProviderRef<NotifierT, StateT>> create,
  ) {
    return StateNotifierProvider<NotifierT, StateT>.internal(
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

/// The element of [StateNotifierProvider].
class StateNotifierProviderElement<NotifierT extends StateNotifier<T>, T>
    extends ProviderElementBase<T>
    implements StateNotifierProviderRef<NotifierT, T> {
  StateNotifierProviderElement._(this.provider, super.container);

  @override
  final StateNotifierProvider<NotifierT, T> provider;

  @override
  NotifierT get notifier => _notifierNotifier.value;
  final _notifierNotifier = ProxyElementValueListenable<NotifierT>();

  void Function()? _removeListener;

  @override
  void create({required bool didChangeDependency}) {
    final notifier =
        _notifierNotifier.result = Result.guard(() => provider._create(this));

    _removeListener = notifier
        // TODO test requireState, as ref.read(p) is expected to throw if notifier creation failed
        .requireState
        .addListener(
      (newState) => setStateResult(ResultData(newState)),
      fireImmediately: true,
    );
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

    final notifier = _notifierNotifier.result?.stateOrNull;
    if (notifier != null) {
      // TODO test STateNotifier.dispose is guarded
      runGuarded(notifier.dispose);
    }
    _notifierNotifier.result = null;
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
    listenableVisitor(_notifierNotifier);
  }
}

/// The [Family] of [StateNotifierProvider].
class StateNotifierProviderFamily<NotifierT extends StateNotifier<T>, T, Arg>
    extends FunctionalFamily<StateNotifierProviderRef<NotifierT, T>, T, Arg,
        NotifierT, StateNotifierProvider<NotifierT, T>> {
  /// The [Family] of [StateNotifierProvider].
  StateNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
  }) : super(
          providerFactory: StateNotifierProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}