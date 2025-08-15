part of '../framework.dart';

/// Mutation code. This should be in riverpod_annotation, but has to be here
/// for the sake of ProviderObserver.
@internal
@publicInCodegenMutation
const mutationZoneKey = #_mutation;

/// A "ref" to be used within [Mutation.run].
///
/// By using this ref instead of the usual [Ref]/`WidgetRef`, this enables
/// [Mutation.run] to be do things such as:
/// - Keeping providers alive for the `run` duration.
/// - Closing any pending subscriptions specific to `run` after it completes.
///
///
/// See also:
/// - [get], the primary way to interact with providers within [Mutation.run].
@publicInMutations
final class MutationRef {
  MutationRef._(this._container);

  final ProviderContainer _container;
  var _closed = false;
  final List<ProviderSubscription<Object?>> _subscriptions = [];

  /// Reads the current state of a listenable and maintains a subscription
  /// to it until the transaction completes.
  ///
  /// **Note**: Updates to the listenable during the transaction are ignored.
  StateT get<StateT>(ProviderListenable<StateT> listenable) {
    assert(
      !_closed,
      'Cannot get a listenable after the transaction has been closed',
    );

    final sub = _container.listen(
      listenable,
      (previous, next) {},
      onError: (error, stackTrace) {},
    );

    _subscriptions.add(sub);

    return sub.readSafe().valueOrProviderException;
  }

  void _close() {
    assert(!_closed, 'MutationRef is already closed');
    _closed = true;
    _closeSubscriptions(_subscriptions);
  }
}

final class _MutationProvider<ValueT> extends $FunctionalProvider<
    _MutationNotifier<ValueT>,
    _MutationNotifier<ValueT>,
    _MutationNotifier<ValueT>> {
  const _MutationProvider(this.mutation)
      : super(
          from: null,
          argument: null,
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
          retry: null,
          name: null,
        );

  @override
  bool get _isSynthetic => true;

  final Mutation<ValueT> mutation;

  @override
  _MutationElement<ValueT> $createElement($ProviderPointer pointer) =>
      _MutationElement<ValueT>(pointer);

  @override
  _MutationNotifier<ValueT> create(Ref ref) => throw UnimplementedError();

  @override
  String? debugGetCreateSourceHash() => null;

  @override
  bool operator ==(Object other) {
    return other is _MutationProvider<ValueT> && mutation == other.mutation;
  }

  @override
  int get hashCode => mutation.hashCode;
}

class _MutationNotifier<ValueT> {
  _MutationNotifier(this.state, this.setState, this.setRef, this.getRef);

  final MutationState<ValueT> state;
  final void Function(MutationState<ValueT> state, MutationRef ref) setState;
  final void Function(MutationRef ref) setRef;
  final MutationRef? Function() getRef;

  @override
  String toString() {
    return 'MutationNotifier<$ValueT>($state)';
  }
}

class _MutationElement<StateT> extends $FunctionalProviderElement<
        _MutationNotifier<StateT>,
        _MutationNotifier<StateT>,
        _MutationNotifier<StateT>>
    with SyncProviderElement<_MutationNotifier<StateT>> {
  _MutationElement(super.pointer);

  @override
  WhenComplete? create(Ref ref) {
    final provider = this.provider as _MutationProvider<StateT>;
    final mutation = provider.mutation;

    MutationRef? activeRef;

    void setState(MutationState<StateT> state, MutationRef? mutRef) {
      if (mutRef != activeRef) return;

      final prevState = value;
      if (prevState.value?.state == state) return;

      value = AsyncData(
        _MutationNotifier(
          state,
          setState,
          (ref) => activeRef = ref,
          () => activeRef,
        ),
      );
      switch (state) {
        case MutationIdle() when activeRef == null:
          // Initial state, do nothing.
          break;
        case MutationIdle():
          // Reset call
          for (final obs in ref.container.observers) {
            container.runBinaryGuarded(
              obs.mutationReset,
              _currentObserverContext(),
              mutation,
            );
          }
        case MutationPending():
          for (final obs in ref.container.observers) {
            container.runBinaryGuarded(
              obs.mutationStart,
              _currentObserverContext(),
              mutation,
            );
          }
        case MutationError():
          for (final obs in ref.container.observers) {
            container.runQuaternaryGuarded(
              obs.mutationError,
              _currentObserverContext(),
              mutation,
              state.error,
              state.stackTrace,
            );
          }
        case MutationSuccess():
          for (final obs in ref.container.observers) {
            container.runTernaryGuarded(
              obs.mutationSuccess,
              _currentObserverContext(),
              mutation,
              state.value,
            );
          }
      }
    }

    setState(MutationIdle<StateT>._(), null);

    return null;
  }
}

/// An interface for objects that can be passed to [Mutation.run].
///
/// This is typically either [Ref], [ProviderContainer] or `WidgetRef`.
@publicInMutations
abstract class MutationTarget {
  /// The [ProviderContainer] that is used to run the mutation.
  ProviderContainer get container;
}

/// Mutations are a form of UI state that represents "side-effects" (such as
/// "submitting a form" or "saving a file", etc).
///
/// Mutations are a mean to enable the UI to both:
/// - Preserve the state of providers while the operation is running.
/// - Allow the UI to react to the state of the operation.
///
/// In particular, mutations are useful to show a loading indicator
/// for a form submission, or a snackbar when the form submission
/// has completed (either successfully or with an error).
///
/// ## Usage
///
/// Mutations are used like providers. They are defined as a top-level
/// global final variable:
///
/// ```dart
/// final addTodoMutation = Mutation<void>();
/// ```
///
/// The generic type corresponds to the state of the mutation.
/// This corresponds to data that the UI will be able to react to, to
/// display special UI elements on success.
///
/// Once defined, you can use mutations using [Ref.watch] to listen to their state:
///
/// ```dart
/// Widget build(BuildContext context, WidgetRef ref) {
///   final addTodo = ref.watch(addTodoMutation);
///
///   switch (addTodo) {
///     case MutationIdle():
///       return ElevatedButton(
///         onPressed: () {
///           /* Add a todo. See further down */
///         },
///         child: const Text('Add Todo'),
///       );
///     case MutationPending():
///       return const CircularProgressIndicator();
///     case MutationError():
///       return Text('An error occurred: ${addTodo.error}');
///     case MutationSuccess():
///       return const Text('Todo added successfully!');
///   }
/// }
/// ```
///
/// This is for the UI logic. But on its own, the state of the mutation
/// will never change.
///
/// To change the mutation state, you need to call [Mutation.run].
/// This is typically done inside a callback, such as the `onPressed`
/// of a button:
///
/// ```dart
/// ElevatedButton(
///   onPressed: () {
///     addTodoMutation.run(ref, (ref) async {
///       // This is where you perform the side-effect. Here, you can
///       // read your providers to modify them.
///       await ref.get(todoListProvider.notifier).addTodo(
///         Todo(title: 'New Todo'),
///       );
///     });
///   },
/// );
/// ```
///
/// Tapping the button will:
/// - Set the mutation state to [MutationPending].
/// - Wait for `todoListProvider.notifier.addTodo` to complete.
///   - If successful, set the mutation state to [MutationSuccess].
///   - If an exception is thrown, set the mutation state to [MutationError].
///
/// ## Resetting to [MutationIdle]
///
/// By default, mutations are automatically reset to [MutationIdle] when they
/// are no longer being listened to.
/// This is similar to Riverpod's "auto-dispose" feature, for mutations.
///
/// If you do not wish for a mutation to be automatically reset, you can
/// listen to its state in a provider/consumer using [Ref.listen].
///
/// If your mutation is always listened, you may call [Mutation.reset] manually
/// to restore the mutation to its [MutationIdle] state.
///
/// ## Concurrency
///
/// Currently, mutations do not restrict concurrent calls in any capacity.
///
/// This means that if you call [Mutation.run] while a previous call is still
/// pending, the mutation state will be set to [MutationPending] again,
/// and the previous call's return value will be ignored.
///
/// ## Passing keys to mutations to obtain a unique state
///
/// By default, the state of a mutation is shared across all places that
/// listen to it.
///
/// But you may want to distinguish between different calls to the same
/// mutation, based on some unique parameter. For example, given a
/// `deleteTodoMutation`, you may want to distinguish between
/// two different todos being deleted.
///
/// To do so, mutations optionally can take a key, by using [call]:
///
/// ```dart
/// final deleteTodoMutation = Mutation<void>();
/// ...
///
/// // You can pass a unique object to the mutation upon watching it.
/// final deleteTodo = ref.watch(deleteMutation(todo.id));
/// ...
///
/// onPressed: () {
///   // Upon calling `run`, you will have to pass the same key as when
///   // watching the mutation.
///   deleteTodo(todo.id).run(ref, (ref) async { /* ... */ });
/// }
/// ```
///
/// See also:
/// - [Mutation.reset], to manually reset a mutation to its initial state.
/// - [ProviderObserver], to react to mutation state changes.
/// - [MutationState], the current state of a mutation.
@immutable
@publicInMutations
sealed class Mutation<ResultT>
    implements ProviderListenable<MutationState<ResultT>> {
  factory Mutation({Object? label}) = MutationImpl<ResultT>;

  /// The label of the mutation, used for debugging purposes.
  Object? get label;

  /// A key to differentiate calls to the same mutation.
  ///
  /// This are passed using [call].
  Object? get key;

  /// Passes a key to the mutation, which will be used to
  /// distinguish between different calls to the same mutation.
  ///
  /// This works by checking `==` on the key. As such, if passing custom objects,
  /// consider overriding `==`.
  ///
  /// Alternatively, you can use a [Record]:
  ///
  /// ```dart
  /// // Use two different values as key
  /// ref.watch(mutation((todo.id, user.id)));
  /// ```
  Mutation<ResultT> call(Object? key);

  /// Starts a mutation and set its state based on the result of the callback.
  ///
  /// This sets the mutation state to [MutationPending],
  /// call the callback, then set the mutation state to either
  /// [MutationSuccess] or [MutationError] depending on whether the callback
  /// completes successfully or throws an error.
  ///
  /// While within the callback, use [MutationRef] to interact with providers.
  /// When doing so, [run] will naturally keep the providers alive for the duration
  /// of the callback, and close any pending subscriptions after it completes.
  Future<ResultT> run(
    MutationTarget target,
    Future<ResultT> Function(MutationRef ref) cb,
  );

  /// Resets the mutation to its initial state ([MutationIdle]).
  void reset(MutationTarget container);
}

extension<StateT> on Mutation<StateT> {
  MutationImpl<StateT> get impl {
    final that = this;
    switch (that) {
      case MutationImpl():
        return that;
    }
  }
}

@internal
final class MutationImpl<ResultT>
    with
        SyncProviderTransformerMixin<_MutationNotifier<ResultT>,
            MutationState<ResultT>>
    implements
        Mutation<ResultT> {
  MutationImpl({this.label}) : _key = null;

  MutationImpl._keyed(this._key, {this.label});

  @internal
  @override
  // ignore: library_private_types_in_public_api, not public
  ProviderListenable<_MutationNotifier<ResultT>> get source =>
      _MutationProvider<ResultT>(this);

  @override
  Object? get key => _key?.$1;

  @override
  final Object? label;
  final (Object? value, Mutation<ResultT> parent)? _key;

  @override
  MutationImpl<ResultT> call(Object? key) {
    return MutationImpl<ResultT>._keyed((key, this), label: label);
  }

  @override
  Future<ResultT> run(
    MutationTarget target,
    Future<ResultT> Function(MutationRef ref) cb,
  ) {
    return runZoned(zoneValues: {mutationZoneKey: this}, () async {
      final container = target.container;

      final mut = impl;
      final sub = container.listen<_MutationNotifier<ResultT>>(
        _MutationProvider(this),
        (_, __) {},
      );
      final ref = MutationRef._(container);

      try {
        mut._mutationStart(sub, ref);

        final result = await cb(ref);

        mut._mutationSuccess(sub, ref, result);

        return result;
      } catch (error, stackTrace) {
        mut._mutationErrored(sub, ref, error, stackTrace);

        rethrow;
      } finally {
        sub.close();
        ref._close();
      }
    });
  }

  @override
  void reset(MutationTarget target) {
    final container = target.container;
    final _MutationNotifier(:state, :setState, :getRef) =
        container.read<_MutationNotifier<ResultT>>(
      _MutationProvider(this),
    );

    final ref = getRef();
    if (ref == null) return;

    setState(MutationIdle<ResultT>._(), ref);
  }

  void _mutationStart(
    ProviderSubscription<_MutationNotifier<ResultT>> sub,
    MutationRef ref,
  ) {
    final _MutationNotifier(:state, :setState, :setRef) =
        sub.readSafe().valueOrRawException;

    setRef(ref);

    setState(MutationPending<ResultT>._(), ref);
  }

  void _mutationSuccess(
    ProviderSubscription<_MutationNotifier<ResultT>> sub,
    MutationRef ref,
    ResultT result,
  ) {
    final _MutationNotifier(:state, :setState) =
        sub.readSafe().valueOrRawException;

    setState(MutationSuccess<ResultT>._(result), ref);
  }

  void _mutationErrored(
    ProviderSubscription<_MutationNotifier<ResultT>> sub,
    MutationRef ref,
    Object error,
    StackTrace stackTrace,
  ) {
    final _MutationNotifier(:state, :setState) =
        sub.readSafe().valueOrRawException;

    setState(MutationError<ResultT>._(error, stackTrace), ref);
  }

  @internal
  @override
  // ignore: library_private_types_in_public_api, not public
  ProviderTransformer<_MutationNotifier<ResultT>, MutationState<ResultT>>
      transform(
    // ignore: library_private_types_in_public_api, not public
    ProviderTransformerContext<_MutationNotifier<ResultT>,
            MutationState<ResultT>>
        context,
  ) {
    return ProviderTransformer(
      initState: (self) => context.sourceState.requireValue.state,
      listener: (self, prev, next) {
        self.state = AsyncResult.guard(() => next.requireValue.state);
      },
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! MutationImpl<ResultT>) return false;
    if (_key != null) return _key == other._key;

    return super == other;
  }

  @override
  int get hashCode {
    if (_key != null) return _key.hashCode;

    return super.hashCode;
  }

  @override
  String toString() {
    final buffer = StringBuffer('Mutation<$ResultT>#${shortHash(this)}(');
    buffer.writeAll(
      [
        if (_key != null) '${_key.$1}',
        if (label != null) 'label: $label',
      ],
      ', ',
    );
    buffer.write(')');
    return buffer.toString();
  }
}

/// The current state of a mutation.
///
/// {@template mutation_states}
/// A mutation can be in any of the following states:
/// - [MutationIdle]: The mutation is not running. This is the default state.
/// - [MutationPending]: The mutation has been called and is in progress.
/// - [MutationError]: The mutation has failed with an error.
/// - [MutationSuccess]: The mutation has completed successfully.
/// {@endtemplate}
@publicInMutations
@immutable
sealed class MutationState<ResultT> {
  const MutationState._();

  /// Whether the mutation is currently idle.
  ///
  /// This is equivalent to checking if the mutation state is [MutationIdle].
  bool get isIdle => this is MutationIdle<ResultT>;

  /// Whether the mutation is currently pending.
  ///
  /// This is equivalent to checking if the mutation state is [MutationPending].
  bool get isPending => this is MutationPending<ResultT>;

  /// Whether the mutation has completed with an error.
  ///
  /// This is equivalent to checking if the mutation state is [MutationError].
  bool get hasError => this is MutationError<ResultT>;

  /// Whether the mutation has completed successfully.
  ///
  /// This is equivalent to checking if the mutation state is [MutationSuccess].
  bool get isSuccess => this is MutationSuccess<ResultT>;

  @override
  @mustBeOverridden
  bool operator ==(Object other);

  @override
  @mustBeOverridden
  int get hashCode;
}

/// The mutation is not running.
///
/// This is the default state of a mutation.
///
/// {@template auto_reset}
/// ## Auto reset
/// By default, mutations are automatically reset to [MutationIdle] when they
/// are no longer being listened to. This is similar to Riverpod's "auto-dispose"
/// feature, for mutations.
///
/// You cam also manually reset a mutation to its initial state using
/// [Mutation.reset].
/// {@endtemplate}
///
/// {@macro mutation_states}
@publicInMutations
final class MutationIdle<ResultT> extends MutationState<ResultT> {
  const MutationIdle._() : super._();

  @override
  String toString() => 'MutationIdle<$ResultT>()';

  @override
  bool operator ==(Object other) => other is MutationIdle<ResultT>;

  @override
  int get hashCode => 0;
}

/// The mutation has been called and is in progress.
///
/// {@macro mutation_states}
@publicInMutations
final class MutationPending<ResultT> extends MutationState<ResultT> {
  const MutationPending._() : super._();

  @override
  String toString() => 'MutationPending<$ResultT>()';

  @override
  bool operator ==(Object other) => other is MutationPending<ResultT>;

  @override
  int get hashCode => 1;
}

/// The mutation has failed with an error.
///
/// {@macro mutation_states}
@publicInMutations
final class MutationError<ResultT> extends MutationState<ResultT> {
  const MutationError._(this.error, this.stackTrace) : super._();

  /// The error thrown by the mutation.
  final Object error;

  /// The stack trace of the [error].
  final StackTrace stackTrace;

  @override
  String toString() => 'MutationError<$ResultT>($error, $stackTrace)';

  @override
  bool operator ==(Object other) {
    if (other is! MutationError<ResultT>) return false;
    return error == other.error && stackTrace == other.stackTrace;
  }

  @override
  int get hashCode => Object.hash(error, stackTrace);
}

/// The mutation has completed successfully.
///
/// {@macro mutation_states}
@publicInMutations
final class MutationSuccess<ResultT> extends MutationState<ResultT> {
  const MutationSuccess._(this.value) : super._();

  /// The new state of the notifier after the mutation has completed.
  final ResultT value;

  @override
  String toString() => 'MutationSuccess<$ResultT>($value)';

  @override
  bool operator ==(Object other) {
    if (other is! MutationSuccess<ResultT>) return false;
    return value == other.value;
  }

  @override
  int get hashCode => value.hashCode;
}
