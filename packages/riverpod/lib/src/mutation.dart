@publicInCodegenMutation
library;

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

import 'internals.dart';

/// {@template mutation}
/// Declares a method of a notifier as a "mutation".
///
/// ## What is a mutation?
///
/// A mutation is a method that modifies the state of a [Notifier].
/// For example, an `addTodo` mutation would add a new todo to a todo-list.
///
/// The primary purpose of mutations is to enable Flutter's Widgets to listen
/// to the progress of an operation.
/// Specifically, by using mutations, a widget may:
/// - Disabling a button while the operation is in progress
/// - Show a button to start an operation
/// - Show a loading indicator when the mutation is in progress.
/// - Show a snackbar when the operation completes/fails
///
/// Mutations also make it easier to separate the logic for "starting an operation"
/// from the logic for "handling the result of an operation".
/// Two widgets can rely on the same mutation, and the progress of the operation
/// will be shared between them.
/// This way, one widget can be responsible for showing a button, while another
/// widget can be responsible for showing a loading indicator.
///
/// Although there are ways to handle such cases without mutations, using
/// mutations makes it simpler to deal with.
/// For example, there is no need to catch possible exceptions to allow the UI
/// to show an error message. By using mutations, Riverpod will automatically
/// take care of that.
///
/// ## How to define a mutation
///
/// To define a mutation, we must first define a [Notifier].
/// For that, we need to define a class annotation by `@riverpod`, and that defines
/// a `build` method:
///
/// ```dart
/// @riverpod
/// class TodoListNotifier extends $ExampleNotifier {
///   @override
///   Future<List<Todo>> build() {
///     /* fetch the list of todos from your server here */
///   }
/// }
/// ```
///
/// Once we have defined a notifier, we can add a mutation to it.
/// To do so, we define a method in the notifier class and annotate it with [Mutation]:
///
/// ```dart
/// @riverpod
/// class TodoListNotifier extends $ExampleNotifier {
///   /* ... */
///
///   @mutation
///   Future<Todo> addTodo(String task) async {
///     final todo = Todo(task);
///     /* to-do: Make an HTTP post request to notify the server about the added todo */
///
///     // Mutations are expected to return the new state for our notifier.
///     // Riverpod will then assign this value to `this.state`
///     state = AsyncData([...await future, todo]);
///
///     // We return the new todo, so that the UI can display it.
///     return todo;
///   }
/// }
/// ```
///
/// ## How to use mutations
///
/// Now that we've defined a mutation, we need a way to invoke it from our UI.
///
/// The way this is typically done is by using `ref.watch`/`ref.listen` to obtain
/// an object that enables us to interact with the mutation:
///
/// ```dart
/// class AddTodoButton extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     // We use `ref.watch` to obtain the mutation object.
///     // For every `@mutation` defined in our notifier, a corresponding
///     // `myProvider.myMutation` will be available ; which can be as followed:
///     final addTodo = ref.watch(todoListProvider.addTodo);
///   }
/// }
/// ```
///
/// Once we have obtained the mutation object, we have two main ways to use it:
///
/// ### 1. Start the operation inside a button press
///
/// Mutation objects are "callable". This means that we can call them like a function.
/// When we call a mutation, it will start the operation.
/// Of course, we will have to pass the required arguments that are expected by our mutation.
///
/// The following code shows a button that, when pressed, will start the `addTodo` mutation:
///
/// ```dart
/// final addTodo = ref.watch(todoListProvider.addTodo);
///
/// return ElevatedButton(
///   // Pressing the button will call `TodoListNotifier.addTodo`
///   onPressed: () => addTodo('Buy milk'),
/// );
/// ```
///
/// ### 2. Listen to the progress of the operation
///
/// Alternatively, we can use the mutation object to track the progress of the operation.
/// This is useful for many reasons, including:
/// - Disabling a button while the operation is in progress
/// - Showing a loading indicator while the operation is pending
/// - Showing a snackbar or the button in red/green when the operation fails/completes
///
/// {@macro mutation_states}
///
/// You can switch over the different types using pattern matching:
///
/// ```dart
/// final addTodo = ref.watch(todoListProvider.addTodo);
///
/// switch (addTodo.state) {
///   case MutationIdle():
///     print('The mutation is idle');
///   case MutationPending():
///     print('The mutation is in progress');
///   case MutationError(:final error):
///     print('The mutation has failed with $error');
///   case MutationSuccess(:final value):
///     print('The mutation has succeeded, and $value was returned');
/// }
/// ```
///
/// ### Example: Showing a loading indicator while the mutation is in progress
///
/// You can check for the [MutationPending] to show a loading indicator.
/// The following code shows a loading indicator while the mutation is in progress.
/// The indicator will disappear when the mutation completes or fails.
///
/// ```dart
/// class TodoListView extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final addTodo = ref.watch(todoListProvider.addTodo);
///
///     return Scaffold(
///       body: Column(
///         children: [
///           // If the mutation is in progress, show a loading indicator
///           if (addTodo.state is MutationPending)
///             const LinearProgressIndicator(),
///           // See above for how AddTodoButton is defined
///           AddTodoButton(),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
/// Notice how the code that handles the loading state of our mutation
/// is separated from the code that starts the mutation.
/// In this example, even though `AddTodoButton` and `TodoListView` are separate,
/// both share the progress of the operation. This allows to easily separate
/// split the responsibilities of our widgets.
///
/// ### Example: Showing a snackbar when the mutation completes/fails
///
/// You can check for the [MutationError] and [MutationSuccess] to show a snackbar.
///
/// Since showing snackbar is done using `showSnackBar`, which is not a widget,
/// we cannot rely on `ref.watch` here.
/// Instead, we should use `ref.listen` to listen to the mutation state.
/// This will give us a callback where we can safely show a snackbar.
///
/// ```dart
/// class TodoListView extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     ref.listen(todoListProvider.addTodo, (_, addTodo) {
///       // We determine if the mutation succeeded or failed, and change
///       // the message accordingly.
///       String message;
///       if (addTodo.state is MutationError) {
///         message = 'Failed to add todo';
///       }
///       else if (addTodo.state is MutationSuccess) {
///         message = 'Todo added successfully';
///       }
///       // We are neither in a success nor in an error state, so we do not show a snackbar.
///       else return;
///
///       // We show a snackbar with the message.
///       ScaffoldMessenger.of(context).showSnackBar(
///         SnackBar(content: Text(message)),
///       );
///     });
///   }
/// }
/// ```
///
/// ## Example: Disabling a button while the operation is pending
///
/// You can check for the [MutationPending] to know if an operation is
/// in progress. We can use this information to disable a button, by setting its
/// `onPressed` to `null`:
///
/// ```dart
/// class AddTodoButton extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final addTodo = ref.watch(todoListProvider.addTodo);
///
///     return ElevatedButton(
///       onPressed: addTodo.state is MutationPending
///         ? null  // If the mutation is in progress, disable the button
///         : () => addTodo('Buy milk'), // Otherwise enable the button
///     );
///   }
/// }
/// ```
///
/// A similar logic can be used for showing the button in red/green when the
/// operation fails/completes, by instead checking for [MutationError] and
/// [MutationSuccess].
///
/// {@macro auto_reset}
/// {@endtemplate}
@Target({TargetKind.method})
final class Mutation {
  /// {@macro mutation}
  const Mutation();
}

/// {@macro mutation}
const mutation = Mutation();

@internal
@publicInCodegenMutation
abstract class $SyncMutationBase<
        ResultT,
        MutationT extends $SyncMutationBase<ResultT, MutationT, ClassT>,
        ClassT extends AnyNotifier<Object?, Object?>>
    extends _MutationBase<ResultT, MutationT, ClassT> {
  $SyncMutationBase({super.state, super.key});

  @protected
  ResultT mutate(
    Invocation invocation,
    ResultT Function(ClassT clazz) cb,
  ) {
    return _run(invocation, (_, notifier) => cb(notifier));
  }
}

@internal
@publicInCodegenMutation
abstract class $AsyncMutationBase<
        ResultT,
        MutationT extends $AsyncMutationBase<ResultT, MutationT, ClassT>,
        ClassT extends AnyNotifier<Object?, Object?>>
    extends _MutationBase<ResultT, MutationT, ClassT> {
  $AsyncMutationBase({super.state, super.key});

  @protected
  Future<ResultT> mutate(
    Invocation invocation,
    FutureOr<ResultT> Function(ClassT clazz) cb,
  ) {
    return _run(
      invocation,
      (mutationContext, notifier) async {
        // ! is safe because of the flush() above
        final key = Object();
        try {
          _setState(
            mutationContext,
            copyWith(MutationPending<ResultT>._(), key: key),
          );

          final result = await cb(notifier);
          if (key == _currentKey) {
            _setState(
              mutationContext,
              copyWith(MutationSuccess<ResultT>._(result)),
            );
          }

          return result;
        } catch (err, stack) {
          if (key == _currentKey) {
            _setState(
              mutationContext,
              copyWith(MutationError<ResultT>._(err, stack)),
            );
          }

          rethrow;
        }
      },
    );
  }
}

abstract class _MutationBase<
        ResultT,
        MutationT extends _MutationBase<ResultT, MutationT, ClassT>,
        ClassT extends AnyNotifier<Object?, Object?>>
    implements MutationBase<ResultT> {
  _MutationBase({MutationState<ResultT>? state, this.key})
      : state = state ?? MutationIdle<ResultT>._() {
    listenable.onCancel = _scheduleAutoReset;
  }

  @override
  final MutationState<ResultT> state;
  final Object? key;

  $ClassProviderElement<ClassT, Object?, Object?, Object?> get element;
  $Observable<MutationT> get listenable;

  Object? get _currentKey => listenable.result?.value?.key;

  MutationT copyWith(MutationState<ResultT> state, {Object? key});

  void _scheduleAutoReset() {
    Future.microtask(() {
      if (listenable.hasListeners) return;

      reset();
    });
  }

  @override
  void reset() {
    if (state is MutationIdle<ResultT>) return;

    listenable.result = $ResultData(copyWith(MutationIdle<ResultT>._()));

    final context = ProviderObserverContext(
      element.origin,
      element.container,
      mutation: null,
      notifier: element.classListenable.value,
    );

    _notifyObserver((obs) => obs.mutationReset(context));
  }

  T _run<T>(
    Invocation invocation,
    T Function(MutationContext mutationContext, ClassT notifier) cb,
  ) {
    element.flush();
    final notifier = element.classListenable.value;
    final mutationContext = MutationContext(invocation);

    return runZoned(
      zoneValues: {mutationZoneKey: mutationContext},
      () => cb(mutationContext, notifier),
    );
  }

  void _notifyObserver(void Function(ProviderObserver obs) cb) {
    for (final observer in element.container.observers) {
      element.container.runUnaryGuarded(cb, observer);
    }
  }

  void _setState(MutationContext? mutationContext, MutationT mutation) {
    listenable.result = $Result.data(mutation);

    final obsContext = ProviderObserverContext(
      element.origin,
      element.container,
      mutation: mutationContext,
      notifier: element.classListenable.value,
    );

    switch (mutation.state) {
      case MutationError(:final error, :final stackTrace):
        _notifyObserver(
          (obs) => obs.mutationError(
            obsContext,
            mutationContext!,
            error,
            stackTrace,
          ),
        );

      case MutationSuccess(:final value):
        _notifyObserver(
          (obs) => obs.mutationSuccess(obsContext, mutationContext!, value),
        );

      case MutationPending():
        _notifyObserver(
          (obs) => obs.mutationStart(obsContext, mutationContext!),
        );

      default:
    }
  }

  @override
  String toString() => '$runtimeType#${shortHash(this)}($state)';
}
