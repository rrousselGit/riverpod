import 'dart:async';

import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

import 'common/internal_lints.dart';
import 'internals.dart';

// Mutation code. This should be in riverpod_annotation, but has to be here
// for the sake of ProviderObserver.
@internal
@publicInCodegen
const mutationZoneKey = #_mutation;

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
///   case IdleMutationState():
///     print('The mutation is idle');
///   case PendingMutationState():
///     print('The mutation is in progress');
///   case ErrorMutationState(:final error):
///     print('The mutation has failed with $error');
///   case SuccessMutationState(:final value):
///     print('The mutation has succeeded, and $value was returned');
/// }
/// ```
///
/// ### Example: Showing a loading indicator while the mutation is in progress
///
/// You can check for the [PendingMutationState] to show a loading indicator.
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
///           if (addTodo.state is PendingMutationState)
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
/// You can check for the [ErrorMutationState] and [SuccessMutationState] to show a snackbar.
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
///       if (addTodo.state is ErrorMutationState) {
///         message = 'Failed to add todo';
///       }
///       else if (addTodo.state is SuccessMutationState) {
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
/// You can check for the [PendingMutationState] to know if an operation is
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
///       onPressed: addTodo.state is PendingMutationState
///         ? null  // If the mutation is in progress, disable the button
///         : () => addTodo('Buy milk'), // Otherwise enable the button
///     );
///   }
/// }
/// ```
///
/// A similar logic can be used for showing the button in red/green when the
/// operation fails/completes, by instead checking for [ErrorMutationState] and
/// [SuccessMutationState].
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

/// The current state of a mutation.
///
/// {@template mutation_states}
/// A mutation can be in any of the following states:
/// - [IdleMutationState]: The mutation is not running. This is the default state.
/// - [PendingMutationState]: The mutation has been called and is in progress.
/// - [ErrorMutationState]: The mutation has failed with an error.
/// - [SuccessMutationState]: The mutation has completed successfully.
/// {@endtemplate}
sealed class MutationState<ResultT> {
  const MutationState._();
}

/// The mutation is not running.
///
/// This is the default state of a mutation.
/// A mutation can be reset to this state by calling [MutationBase.reset].
///
/// {@macro auto_reset}
///
/// {@macro mutation_states}
final class IdleMutationState<ResultT> extends MutationState<ResultT> {
  const IdleMutationState._() : super._();

  @override
  String toString() => 'IdleMutationState<$ResultT>()';
}

/// The mutation has been called and is in progress.
///
/// {@macro mutation_states}
final class PendingMutationState<ResultT> extends MutationState<ResultT> {
  const PendingMutationState._() : super._();

  @override
  String toString() => 'PendingMutationState<$ResultT>()';
}

/// The mutation has failed with an error.
///
/// {@macro mutation_states}
final class ErrorMutationState<ResultT> extends MutationState<ResultT> {
  ErrorMutationState._(this.error, this.stackTrace) : super._();

  /// The error thrown by the mutation.
  final Object error;

  /// The stack trace of the [error].
  final StackTrace stackTrace;

  @override
  String toString() => 'ErrorMutationState<$ResultT>($error, $stackTrace)';
}

/// The mutation has completed successfully.
///
/// {@macro mutation_states}
final class SuccessMutationState<ResultT> extends MutationState<ResultT> {
  SuccessMutationState._(this.value) : super._();

  /// The new state of the notifier after the mutation has completed.
  final ResultT value;

  @override
  String toString() => 'SuccessMutationState<$ResultT>($value)';
}

/// A base class that all mutations extends.
///
/// See also [Mutation] for information on how to define a mutation.
@immutable
abstract class MutationBase<ResultT> {
  /// The current state of the mutation.
  ///
  /// This defaults to [IdleMutationState].
  /// When the mutation starts, it will change to [PendingMutationState] and
  /// then to either [ErrorMutationState] or [SuccessMutationState].
  ///
  /// **Note**:
  /// This property is immutable. The state will not change unless you
  /// call `ref.watch(provider.myMutation)` again.
  MutationState<ResultT> get state;

  /// Sets [state] back to [IdleMutationState].
  ///
  /// Calling [reset] is useful when the mutation is actively listened to,
  /// and you want to forcibly go back to the [IdleMutationState].
  ///
  /// {@template auto_reset}
  /// ## Automatic resets
  ///
  /// By default, mutations are automatically reset when they are no longer
  /// being listened to.
  /// This is similar to Riverpod's "auto-dispose" feature, for mutations.
  /// If you remove all `watch`/`listen` calls to a mutation, the mutation
  /// will automatically go-back to its [IdleMutationState].
  ///
  /// If your mutation is always listened, you may want to call [MutationBase.reset] manually
  /// to restore the mutation to its [IdleMutationState].
  /// {@endtemplate}
  void reset();
}

@internal
@publicInCodegen
abstract class $SyncMutationBase<
        ResultT,
        MutationT extends $SyncMutationBase<ResultT, MutationT, ClassT>,
        ClassT extends NotifierBase<Object?>>
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
@publicInCodegen
abstract class $AsyncMutationBase<
        ResultT,
        MutationT extends $AsyncMutationBase<ResultT, MutationT, ClassT>,
        ClassT extends NotifierBase<Object?>>
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
            copyWith(PendingMutationState<ResultT>._(), key: key),
          );

          final result = await cb(notifier);
          if (key == _currentKey) {
            _setState(
              mutationContext,
              copyWith(SuccessMutationState<ResultT>._(result)),
            );
          }

          return result;
        } catch (err, stack) {
          if (key == _currentKey) {
            _setState(
              mutationContext,
              copyWith(ErrorMutationState<ResultT>._(err, stack)),
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
    ClassT extends NotifierBase<Object?>> implements MutationBase<ResultT> {
  _MutationBase({MutationState<ResultT>? state, this.key})
      : state = state ?? IdleMutationState<ResultT>._() {
    listenable.onCancel = _scheduleAutoReset;
  }

  @override
  final MutationState<ResultT> state;
  final Object? key;

  $ClassProviderElement<ClassT, Object?, Object?, Object?> get element;
  $ElementLense<MutationT> get listenable;

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
    if (state is IdleMutationState<ResultT>) return;

    listenable.result = $ResultData(copyWith(IdleMutationState<ResultT>._()));

    final context = ProviderObserverContext(element.origin, element.container);

    _notifyObserver((obs) => obs.mutationReset(context));
  }

  T _run<T>(
    Invocation invocation,
    T Function(MutationContext mutationContext, ClassT notifier) cb,
  ) {
    element.flush();
    final notifier = element.classListenable.value;
    final mutationContext = MutationContext(invocation, notifier);

    return runZoned(
      zoneValues: {mutationZoneKey: mutationContext},
      () => cb(mutationContext, notifier),
    );
  }

  void _notifyObserver(void Function(ProviderObserver obs) cb) {
    for (final observer in element.container.observers) {
      runUnaryGuarded(cb, observer);
    }
  }

  void _setState(MutationContext? mutationContext, MutationT mutation) {
    listenable.result = $Result.data(mutation);

    final obsContext = ProviderObserverContext(
      element.origin,
      element.container,
      mutation: mutationContext,
    );

    switch (mutation.state) {
      case ErrorMutationState(:final error, :final stackTrace):
        _notifyObserver(
          (obs) => obs.mutationError(
            obsContext,
            mutationContext!,
            error,
            stackTrace,
          ),
        );

      case SuccessMutationState(:final value):
        _notifyObserver(
          (obs) => obs.mutationSuccess(obsContext, mutationContext!, value),
        );

      case PendingMutationState():
        _notifyObserver(
          (obs) => obs.mutationStart(obsContext, mutationContext!),
        );

      default:
    }
  }

  @override
  String toString() => '$runtimeType#${shortHash(this)}($state)';
}
