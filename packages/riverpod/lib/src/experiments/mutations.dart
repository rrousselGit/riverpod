part of '../framework.dart';

extension ProviderContainerInvoke on ProviderContainer {
  T invoke<T>(Call<T> call) => throw UnimplementedError();
}

class Call<ResultT> {
  Mutation<ResultT>? get mutation => throw UnimplementedError();
}

class Mutation<ResultT> implements ProviderListenable<MutationState<ResultT>> {
  Mutation._(this._origin, this._symbol)
      : assert(
          _origin.args == null || _symbol != null,
          'Either override args, or specify a symbol',
        );

  final ProviderBase2<Object?> _origin;
  final Symbol? _symbol;

  Call<void> reset() => throw UnimplementedError();

  @override
  bool operator ==(Object other) {
    if (_symbol != null) {
      return other is Mutation<ResultT> &&
          other._origin == _origin &&
          other.runtimeType == runtimeType &&
          other._symbol == _symbol;
    }

    return super == other;
  }

  @override
  int get hashCode {
    if (_symbol == null) return _symbol.hashCode;

    return super.hashCode;
  }

  @override
  ProviderSubscription<MutationState<ResultT>> _addListener(
    Node node,
    void Function(
      MutationState<ResultT>? previous,
      MutationState<ResultT> next,
    ) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    // TODO: implement _addListener
    throw UnimplementedError();
  }

  @override
  ProviderSubscription<MutationState<ResultT>> addListener(
    Node node,
    void Function(
      MutationState<ResultT>? previous,
      MutationState<ResultT> next,
    ) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    // TODO: implement addListener
    throw UnimplementedError();
  }

  @override
  MutationState<ResultT> read(Node node) {
    // TODO: implement read
    throw UnimplementedError();
  }
}

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
/// A mutation can be reset to this state by calling [Mutation.reset].
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
