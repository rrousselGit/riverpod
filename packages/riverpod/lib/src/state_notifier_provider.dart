import 'package:meta/meta.dart';
import 'package:state_notifier/state_notifier.dart';

import 'builders.dart';
import 'framework.dart';
import 'future_provider.dart';
import 'provider.dart';

part 'state_notifier_provider/auto_dispose.dart';
part 'state_notifier_provider/base.dart';

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
/// Widget build(BuildContext context, ScopedReader watch) {
///   // rebuild the widget when the todo list changes
///   List<Todo> todos = watch(todosProvider);
///
///   return ListView(
///     children: [
///       for (final todo in todos)
///         CheckboxListTile(
///            value: todo.completed,
///            // When tapping on the todo, change its completed status
///            onChanged: (value) => context.read(todosProvider).toggle(todo.id),
///            title: Text(todo.description),
///         ),
///     ],
///   );
/// }
/// ```
/// {@endtemplate}

class _StateNotifierProviderState<Notifier extends StateNotifier<Value>, Value>
    extends ProviderStateBase<Notifier, Value> {
  void Function()? removeListener;

  @override
  void valueChanged({Notifier? previous}) {
    if (createdValue == previous) {
      return;
    }
    removeListener?.call();
    removeListener = createdValue.addListener(_listener);
  }

  // ignore: use_setters_to_change_properties
  void _listener(Value value) {
    exposedValue = value;
  }

  @override
  void dispose() {
    removeListener?.call();
    super.dispose();
  }
}

mixin _StateNotifierProviderMixin<Notifier extends StateNotifier<Value>, Value>
    on RootProvider<Notifier, Value> {
  ProviderBase<Notifier, Notifier> get notifier;

  /// Overrides the behavior of a provider with a value.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithValue(Notifier value) {
    return ProviderOverride(
      ValueProvider<Object?, Notifier>((ref) => value, value),
      notifier,
    );
  }
}
