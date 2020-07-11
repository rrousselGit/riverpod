import 'package:state_notifier/state_notifier.dart';

import '../builders.dart';
import '../common.dart';
import '../framework/framework.dart';
import '../internals.dart';

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
/// final todosProvider = StateNotifierProvider((ref) => TodosNotifier());
/// ```
///
/// And finally, you can interact with it inside your UI:
///
/// ```dart
/// Widget build(BuildContext context) {
///   // rebuild the widget when the todo list changes
///   List<Todo> todos = useProvider(todosProvider.state);
///
///   return ListView(
///     children: [
///       for (final todo in todos)
///         CheckboxListTile(
///            value: todo.completed,
///            // When tapping on the todo, change its completed status
///            onChanged: (value) => todosProvider.read(context).toggle(todo.id),
///            title: Text(todo.description),
///         ),
///     ],
///   );
/// }
/// ```
/// {@endtemplate}
class StateNotifierProvider<Notifier extends StateNotifier<Object>>
    extends Provider<Notifier> {
  /// {@macro riverpod.statenotifierprovider}
  StateNotifierProvider(
    Create<Notifier, ProviderReference> create, {
    String name,
  }) : super(
          (ref) {
            final notifier = create(ref);
            ref.onDispose(notifier.dispose);
            return notifier;
          },
          name: name,
        );

  /// {@macro riverpod.family}
  static const family = StateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  SetStateProvider<Object> _state;
}

/// Adds [state] to [StateNotifierProvider].
///
/// This is done as an extension as a workaround to language limitations around
/// generic parameters.
extension StateNotifierStateProviderX<Value>
    on StateNotifierProvider<StateNotifier<Value>> {
  /// A provider that expose the state of a [StateNotifier].
  StateNotifierStateProvider<Value> get state {
    _state ??= StateNotifierStateProvider<Value>._(this);
    return _state as StateNotifierStateProvider<Value>;
  }
}

/// Implementation detail of [StateNotifierProvider].
class StateNotifierStateProvider<T> extends SetStateProvider<T> {
  StateNotifierStateProvider._(this.notifierProvider)
      : super((ref) {
          final notifier = ref.dependOn(notifierProvider).value;

          ref.onDispose(
            notifier.addListener((newValue) => ref.state = newValue),
          );

          return ref.state;
        },
            name: notifierProvider.name == null
                ? null
                : '${notifierProvider.name}.state');

  /// The [StateNotifierProvider] associated with this [StateNotifierStateProvider].
  final StateNotifierProvider<StateNotifier<T>> notifierProvider;
}

/// Creates a [StateNotifierProvider] from external parameters.
///
/// See also:
///
/// - [ProviderFamily], which contains an explanation of what a *Family is.
class StateNotifierProviderFamily<Result extends StateNotifier<dynamic>, A>
    extends Family<StateNotifierProvider<Result>, A> {
  /// Creates a [StateNotifierProvider] from external parameters.
  StateNotifierProviderFamily(
      Result Function(ProviderReference ref, A a) create)
      : super((a) => StateNotifierProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
    Result Function(ProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) =>
          StateNotifierProvider<Result>((ref) => override(ref, value as A)),
    );
  }
}
