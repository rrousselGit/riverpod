// ignore_for_file: public_member_api_docs

part of '../framework.dart';

class _MutationState<T> {
  late final listenable = ProxyElementValueNotifier<MutationState<T>>()
    ..result = $Result.data(IdleMutation<T>._())
    ..onCancel = _scheduleAutoReset;

  Object? pendingKey;

  void _scheduleAutoReset() {
    Future.microtask(() {
      if (listenable.hasListeners) return;

      reset();
    });
  }

  void reset() {
    pendingKey = null;
    listenable.result = $Result.data(IdleMutation<T>._());
  }
}

mixin _MutationElement<T> on ProviderElementBase<T> {
  static Call<Future<T>> _mutate<T, RefT>(
    Mutation<T> mutation,
    FutureOr<T> Function(RefT) mutator,
  ) {
    return _run<Future<T>, RefT>(mutation._origin as ProviderBase2<Object?>,
        (element, ref) async {
      final state = element.mutations.putIfAbsent(mutation, () {
        return _MutationState<T>();
      }) as _MutationState<T>;

      final key = state.pendingKey = Object();
      try {
        state.listenable.result = $Result.data(PendingMutation<T>._());
        final result = await mutator(ref);

        if (state.pendingKey == key) {
          state.listenable.result = $Result.data(SuccessMutation<T>._(result));
        }

        return result;
      } catch (error, stackTrace) {
        if (state.pendingKey == key) {
          state.listenable.result = $Result<MutationState<T>>.data(
            ErrorMutation<T>._(error, stackTrace),
          );
        }

        rethrow;
      }
    });
  }

  static Call<T> _run<T, RefT>(
    ProviderBase2<Object?> origin,
    T Function(_MutationElement<Object?> element, RefT ref) mutator,
  ) {
    return Call<T>._((container) {
      final element = container.readProviderElement(origin);

      return mutator(element as _MutationElement, element as RefT);
    });
  }

  final mutations = <Mutation<Object?>, _MutationState<Object?>>{};

  @override
  void visitChildren({
    required void Function(ProviderElementBase element) elementVisitor,
    required void Function(ProxyElementValueNotifier element) notifierVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      notifierVisitor: notifierVisitor,
    );
    for (final mutation in mutations.values) {
      notifierVisitor(mutation.listenable);
    }
  }
}

extension ProviderContainerInvoke on ProviderContainer {
  T invoke<T>(Call<T> call) => call._run(this);
}

final class Call<ResultT> {
  Call._(this._run);

  final ResultT Function(ProviderContainer container) _run;
}

final class Mutation<ResultT>
    extends ProviderElementProxy<Object?, MutationState<ResultT>> {
  Mutation.__(
    ProviderBase2<Object?> super._origin,
    super._lense, {
    required Symbol? symbol,
  })  : _symbol = symbol,
        assert(
          _origin.args == null || symbol != null,
          'When args is overridden, you must specify a symbol',
        );

  factory Mutation._(ProviderBase2<Object?> origin, Symbol? symbol) {
    late Mutation<ResultT> mut;
    return mut = Mutation.__(
      origin,
      symbol: symbol,
      (e) {
        final element = e as _MutationElement<Object?>;

        final state =
            element.mutations.putIfAbsent(mut, _MutationState<ResultT>.new)
                as _MutationState<ResultT>;

        return state.listenable;
      },
    );
  }

  final Symbol? _symbol;

  Call<void> reset() => Call._((container) {
        final element =
            container.readProviderElement(_origin) as _MutationElement;

        element.mutations[this]?.reset();
      });

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
    if (_symbol != null) return _symbol.hashCode;

    return super.hashCode;
  }
}

/// The current state of a mutation.
///
/// {@template mutation_states}
/// A mutation can be in any of the following states:
/// - [IdleMutation]: The mutation is not running. This is the default state.
/// - [PendingMutation]: The mutation has been called and is in progress.
/// - [ErrorMutation]: The mutation has failed with an error.
/// - [SuccessMutation]: The mutation has completed successfully.
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
final class IdleMutation<ResultT> extends MutationState<ResultT> {
  const IdleMutation._() : super._();

  @override
  String toString() => 'IdleMutation<$ResultT>()';
}

/// The mutation has been called and is in progress.
///
/// {@macro mutation_states}
final class PendingMutation<ResultT> extends MutationState<ResultT> {
  const PendingMutation._() : super._();

  @override
  String toString() => 'PendingMutation<$ResultT>()';
}

/// The mutation has failed with an error.
///
/// {@macro mutation_states}
final class ErrorMutation<ResultT> extends MutationState<ResultT> {
  ErrorMutation._(this.error, this.stackTrace) : super._();

  /// The error thrown by the mutation.
  final Object error;

  /// The stack trace of the [error].
  final StackTrace stackTrace;

  @override
  String toString() => 'ErrorMutation<$ResultT>($error, $stackTrace)';
}

/// The mutation has completed successfully.
///
/// {@macro mutation_states}
final class SuccessMutation<ResultT> extends MutationState<ResultT> {
  SuccessMutation._(this.value) : super._();

  /// The new state of the notifier after the mutation has completed.
  final ResultT value;

  @override
  String toString() => 'SuccessMutation<$ResultT>($value)';
}
