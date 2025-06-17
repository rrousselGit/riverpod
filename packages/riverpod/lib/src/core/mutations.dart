part of '../framework.dart';

/// Mutation code. This should be in riverpod_annotation, but has to be here
/// for the sake of ProviderObserver.
@internal
@publicInCodegenMutation
const mutationZoneKey = #_mutation;

@publicInMutations
final class MutationRef {
  MutationRef._();
}

final class _MutationProvider<T> extends $FunctionalProvider<
    _MutationNotifier<T>, _MutationNotifier<T>, _MutationNotifier<T>> {
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

  final Mutation<T> mutation;

  @override
  _MutationElement<T> $createElement($ProviderPointer pointer) =>
      _MutationElement<T>(pointer);

  @override
  _MutationNotifier<T> create(Ref ref) => throw UnimplementedError();

  @override
  String? debugGetCreateSourceHash() => null;

  @override
  bool operator ==(Object other) {
    return other is _MutationProvider<T> && mutation == other.mutation;
  }

  @override
  int get hashCode => mutation.hashCode;
}

class _MutationNotifier<T> {
  _MutationNotifier(this.state, this.setState);

  final MutationState<T> state;
  final void Function(MutationState<T> state) setState;

  @override
  String toString() {
    return 'MutationNotifier<$T>($state)';
  }
}

class _MutationElement<T> extends $FunctionalProviderElement<
    _MutationNotifier<T>,
    _MutationNotifier<T>,
    _MutationNotifier<T>> with SyncProviderElement<_MutationNotifier<T>> {
  _MutationElement(super.pointer);

  @override
  WhenComplete? create(Ref ref) {
    print('create: $ref');
    void setState(MutationState<T> state) {
      print('setState: $state');
      value = AsyncData(_MutationNotifier(state, setState));
    }

    void reset() => setState(MutationIdle<T>._(reset));

    setState(MutationIdle<T>._(reset));

    return null;
  }
}

@immutable
@publicInMutations
sealed class Mutation<ResultT>
    implements ProviderListenable<MutationState<ResultT>> {
  factory Mutation({Object? label}) = MutationImpl<ResultT>;

  ProviderListenable<MutationState<ResultT>> call(Object? key);
}

extension<T> on Mutation<T> {
  MutationImpl<T> get impl {
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
  ProviderListenable<_MutationNotifier<ResultT>> get source =>
      _MutationProvider<ResultT>(this);

  final Object? label;
  final (Object? value, Mutation<ResultT> parent)? _key;

  @override
  ProviderListenable<MutationState<ResultT>> call(Object? key) {
    return MutationImpl<ResultT>._keyed((key, this), label: label);
  }

  Future<ResultT> _mutate(
    ProviderContainer container,
    Future<ResultT> Function(MutationRef ref) cb,
  ) async {
    print('oy');
    final sub = container.listen(_MutationProvider<ResultT>(this), (_, __) {});
    try {
      final ref = MutationRef._();

      _mutationStart(sub);

      final result = await cb(ref);

      _mutationSuccess(sub, result);

      return result;
    } catch (error, stackTrace) {
      _mutationErrored(sub, error, stackTrace);

      rethrow;
    } finally {
      sub.close();
    }
  }

  void _mutationStart(ProviderSubscription<_MutationNotifier<ResultT>> sub) {
    print('foo');
    final _MutationNotifier(:state, :setState) =
        sub.readSafe().valueOrRawException;

    setState(MutationPending<ResultT>._(state._reset));
  }

  void _mutationSuccess(
    ProviderSubscription<_MutationNotifier<ResultT>> sub,
    ResultT result,
  ) {
    final _MutationNotifier(:state, :setState) =
        sub.readSafe().valueOrRawException;

    setState(MutationSuccess<ResultT>._(result, state._reset));
  }

  void _mutationErrored(
    ProviderSubscription<_MutationNotifier<ResultT>> sub,
    Object error,
    StackTrace stackTrace,
  ) {
    final _MutationNotifier(:state, :setState) =
        sub.readSafe().valueOrRawException;

    setState(MutationError<ResultT>._(error, stackTrace, state._reset));
  }

  @override
  ProviderTransformer<_MutationNotifier<ResultT>, MutationState<ResultT>>
      transform(context) {
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
sealed class MutationState<ResultT> {
  const MutationState._(this._reset);

  /// Sets the mutation's state back to [MutationIdle].
  ///
  /// Calling [reset] is useful when the mutation is actively listened to,
  /// and you want to forcibly go back to the [MutationIdle].
  ///
  /// {@template auto_reset}
  /// ## Automatic resets
  ///
  /// By default, mutations are automatically reset when they are no longer
  /// being listened to.
  /// This is similar to Riverpod's "auto-dispose" feature, for mutations.
  /// If you remove all `watch`/`listen` calls to a mutation, the mutation
  /// will automatically go-back to its [MutationIdle].
  ///
  /// If your mutation is always listened, you may want to call [MutationState.reset] manually
  /// to restore the mutation to its [MutationIdle].
  /// {@endtemplate}
  void reset() => _reset();
  final void Function() _reset;
}

/// The mutation is not running.
///
/// This is the default state of a mutation.
/// A mutation can be reset to this state by calling [MutationState.reset].
///
/// {@macro auto_reset}
///
/// {@macro mutation_states}
@publicInMutations
final class MutationIdle<ResultT> extends MutationState<ResultT> {
  const MutationIdle._(super._reset) : super._();

  @override
  String toString() => 'MutationIdle<$ResultT>()';
}

/// The mutation has been called and is in progress.
///
/// {@macro mutation_states}
@publicInMutations
final class MutationPending<ResultT> extends MutationState<ResultT> {
  const MutationPending._(super._reset) : super._();

  @override
  String toString() => 'MutationPending<$ResultT>()';
}

/// The mutation has failed with an error.
///
/// {@macro mutation_states}
@publicInMutations
final class MutationError<ResultT> extends MutationState<ResultT> {
  MutationError._(this.error, this.stackTrace, super._reset) : super._();

  /// The error thrown by the mutation.
  final Object error;

  /// The stack trace of the [error].
  final StackTrace stackTrace;

  @override
  String toString() => 'MutationError<$ResultT>($error, $stackTrace)';
}

/// The mutation has completed successfully.
///
/// {@macro mutation_states}
@publicInMutations
final class MutationSuccess<ResultT> extends MutationState<ResultT> {
  MutationSuccess._(this.value, super._reset) : super._();

  /// The new state of the notifier after the mutation has completed.
  final ResultT value;

  @override
  String toString() => 'MutationSuccess<$ResultT>($value)';
}
