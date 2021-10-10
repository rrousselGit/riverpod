part of '../state_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
typedef AutoDisposeStateNotifierProviderRef<
        Notifier extends StateNotifier<State>, State>
    = AutoDisposeProviderRefBase;

class _AutoDisposeNotifierProvider<Notifier extends StateNotifier<Object?>>
    extends AutoDisposeProviderBase<Notifier> {
  _AutoDisposeNotifierProvider(
    this._create, {
    required String? name,
    required this.dependencies,
  }) : super(name: name == null ? null : '$name.notifier');

  final Create<Notifier, AutoDisposeProviderRefBase> _create;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  Notifier create(AutoDisposeProviderRefBase ref) {
    final notifier = _create(ref);
    ref.onDispose(notifier.dispose);
    return notifier;
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) {
    return true;
  }

  @override
  AutoDisposeProviderElement<Notifier> createElement() {
    return AutoDisposeProviderElement(this);
  }
}

/// {@template riverpod.statenotifierprovider}
/// Creates a [StateNotifier] and expose its current state.
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
///            onChanged: (value) => context.read(todosProvider.notifier).toggle(todo.id),
///            title: Text(todo.description),
///         ),
///     ],
///   );
/// }
/// ```
/// {@endtemplate}
@sealed
class AutoDisposeStateNotifierProvider<Notifier extends StateNotifier<State>,
        State> extends AutoDisposeProviderBase<State>
    with StateNotifierProviderOverrideMixin<Notifier, State> {
  /// {@macro riverpod.statenotifierprovider}
  AutoDisposeStateNotifierProvider(
    Create<Notifier, AutoDisposeStateNotifierProviderRef<Notifier, State>>
        create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  })  : notifier = _AutoDisposeNotifierProvider(
          create,
          name: name,
          dependencies: dependencies,
        ),
        super(name: name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateNotifierProviderFamilyBuilder();

  /// {@template riverpod.statenotifierprovider.notifier}
  /// Obtains the [StateNotifier] associated with this [AutoDisposeStateNotifierProvider],
  /// without listening to it.
  ///
  /// Listening to this provider may cause providers/widgets to rebuild in the
  /// event that the [StateNotifier] it recreated.
  /// {@endtemplate}
  @override
  final AutoDisposeProviderBase<Notifier> notifier;

  @override
  State create(AutoDisposeProviderElementBase<State> ref) {
    final notifier = ref.watch(this.notifier);

    void listener(State newState) {
      ref.setState(newState);
    }

    final removeListener = notifier.addListener(listener);
    ref.onDispose(removeListener);

    return ref.getState() as State;
  }

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return true;
  }

  @override
  AutoDisposeProviderElementBase<State> createElement() {
    return AutoDisposeProviderElement(this);
  }
}

/// {@template riverpod.statenotifierprovider.family}
/// A class that allows building a [AutoDisposeStateNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class AutoDisposeStateNotifierProviderFamily<
        Notifier extends StateNotifier<State>, State, Arg>
    extends Family<State, Arg,
        AutoDisposeStateNotifierProvider<Notifier, State>> {
  /// {@macro riverpod.statenotifierprovider.family}
  AutoDisposeStateNotifierProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<Notifier,
      AutoDisposeStateNotifierProviderRef<Notifier, State>, Arg> _create;

  @override
  AutoDisposeStateNotifierProvider<Notifier, State> create(Arg argument) {
    final provider = AutoDisposeStateNotifierProvider<Notifier, State>(
      (ref) => _create(ref, argument),
      name: name,
    );

    registerProvider(provider.notifier, argument);

    return provider;
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);
    setup(origin: provider, override: provider);
    setup(origin: provider.notifier, override: provider.notifier);
  }
}
