import 'dart:async';

import 'package:meta/meta.dart';

import 'stack_trace.dart';

typedef Mutation<Result> = MutationState<Result, FutureOr<Result> Function()>;

typedef SetState<Result, Param> = void Function(
  MutationState<Result, Param> newState,
);

/// AsyncValue-like data class, but includes a setState and callback
/// strictly for use in providers
/// `_fn` is the handler for whatever parameter gets passed in (a call to a notifier function, for example)
/// Param is the type of the value that gets passed in by the front end
/// T is the type of the created data from the call (equivalent to AsyncValue's T)
/// (the type of the `value`)
@immutable
abstract class MutationState<Result, Param> {
  const MutationState(this._setState, this._fn);

  /// Use to initialize your own mutation provider
  ///
  /// [setState] is the provider reference
  ///
  /// [fn] is the function that will be called when the mutation is called
  /// with the parameter passed in by the front end
  ///
  /// Here's an example for a generic mutation:
  /// ```dart
  /// @riverpod
  /// MutationState<void, Future<void> Function()> genericMutation(GenericMutationRef setState, Object mutationKey) {
  ///   // simply calls the function provided by the user
  ///   return MutationState.create(setState, (fn) => fn());
  /// }
  /// ```
  const factory MutationState.create(
    SetState<Result, Param> setState,
    FutureOr<Result> Function(Param p) fn,
  ) = MutationState<Result, Param>.initial;

  const factory MutationState.initial(
    SetState<Result, Param> setState,
    FutureOr<Result> Function(Param p) fn,
  ) = MutationInitial<Result, Param>;

  const factory MutationState.error(
    SetState<Result, Param> setState,
    FutureOr<Result> Function(Param p) fn,
    Object error, {
    required StackTrace stackTrace,
  }) = MutationError<Result, Param>;

  const factory MutationState.data(
    SetState<Result, Param> setState,
    FutureOr<Result> Function(Param p) fn,
    Result value,
  ) = MutationData<Result, Param>;

  const factory MutationState.loading(
    SetState<Result, Param> setState,
    FutureOr<Result> Function(Param p) fn,
  ) = MutationLoading<Result, Param>;

  static Future<MutationState<Result, P>> guard<Result, P>(
    SetState<Result, P> setState,
    FutureOr<Result> Function(P p) fn,
    P parameter,
  ) async {
    try {
      return MutationState<Result, P>.data(setState, fn, await fn(parameter));
    } catch (e, s) {
      return MutationState<Result, P>.error(setState, fn, e, stackTrace: s);
    }
  }

  bool get isLoading;
  bool get hasValue;
  Result? get value;
  Object? get error;
  StackTrace? get stackTrace;
  final FutureOr<Result> Function(Param p) _fn;

  final SetState<Result, Param> _setState;
  // {
  //   _setState.state = state.copyWithPrevious(_setState.state);
  // }

  Future<MutationState<Result, Param>> call(Param parameter) async {
    _setState(MutationState<Result, Param>.loading(_setState, _fn));
    final result =
        await MutationState.guard<Result, Param>(_setState, _fn, parameter);
    _setState(result);
    return result;
  }

  R map<R>({
    required R Function(MutationInitial<Result, Param> initial) initial,
    required R Function(MutationData<Result, Param> data) data,
    required R Function(MutationError<Result, Param> error) error,
    required R Function(MutationLoading<Result, Param> loading) loading,
  });

  MutationState<Result, Param> copyWithPrevious(
    MutationState<Result, Param> previous,
  );

  MutationState<Result, Param> unwrapPrevious() {
    return map(
      initial: (i) => MutationInitial<Result, Param>(_setState, _fn),
      data: (d) {
        if (d.isLoading) {
          return MutationLoading<Result, Param>(_setState, _fn);
        }
        return MutationData(_setState, _fn, d.value!);
      },
      error: (e) {
        if (e.isLoading) return MutationLoading(_setState, _fn);
        return MutationError(
          _setState,
          _fn,
          e.error,
          stackTrace: e.stackTrace,
        );
      },
      loading: (l) => MutationLoading<Result, Param>(_setState, _fn),
    );
  }

  @override
  String toString() {
    final content = [
      if (isLoading && this is! MutationLoading) 'isLoading: $isLoading',
      if (hasValue) 'value: $value',
      if (hasError) ...[
        'error: $error',
        'stackTrace: $stackTrace',
      ],
      if (stackTrace != null) 'stackTrace: $stackTrace',
    ].join(', ');
    return '$runtimeType($content)';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType &&
        other is MutationState<Result, Param> &&
        other.isInitial == isInitial &&
        other.isLoading == isLoading &&
        other.hasValue == hasValue &&
        other.error == error &&
        other.stackTrace == stackTrace &&
        other.valueOrNull == valueOrNull;
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        isLoading,
        hasValue,
        // Fallback null values to 0, making sure Object.hash hashes all values
        valueOrNull ?? 0,
        error ?? 0,
        stackTrace ?? 0,
      );
}

class MutationInitial<Result, Param> extends MutationState<Result, Param> {
  const MutationInitial(super._setState, super._fn);

  @override
  Result? get value => null;

  @override
  bool get hasValue => false;

  @override
  bool get isLoading => false;

  @override
  StackTrace? get stackTrace => null;

  @override
  Object? get error => null;

  @override
  R map<R>({
    required R Function(MutationInitial<Result, Param> initial) initial,
    required R Function(MutationData<Result, Param> data) data,
    required R Function(MutationError<Result, Param> error) error,
    required R Function(MutationLoading<Result, Param> loading) loading,
  }) {
    return initial(this);
  }

  @override
  MutationState<Result, Param> copyWithPrevious(
    MutationState<Result, Param> previous,
  ) {
    // We shouldn't even have a previous value if we are initial
    return this;
  }
}

class MutationLoading<Result, Param> extends MutationState<Result, Param> {
  const MutationLoading(super._setState, super._fn)
      : hasValue = false,
        value = null,
        error = null,
        stackTrace = null;

  const MutationLoading._(
    super._setState,
    super._fn, {
    required this.hasValue,
    required this.value,
    required this.error,
    required this.stackTrace,
  });

  @override
  bool get isLoading => true;

  @override
  final bool hasValue;

  @override
  final Result? value;

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  @override
  R map<R>({
    required R Function(MutationInitial<Result, Param> initial) initial,
    required R Function(MutationData<Result, Param> data) data,
    required R Function(MutationError<Result, Param> error) error,
    required R Function(MutationLoading<Result, Param> loading) loading,
  }) {
    return loading(this);
  }

  @override
  MutationState<Result, Param> copyWithPrevious(
    MutationState<Result, Param> previous, {
    bool isRefresh = true,
  }) {
    if (isRefresh) {
      return previous.map(
        initial: (_) => this,
        data: (d) => MutationData._(
          _setState,
          _fn,
          d.value,
          isLoading: true,
          error: d.error,
          stackTrace: d.stackTrace,
        ),
        error: (e) => MutationError._(
          _setState,
          _fn,
          e.error,
          isLoading: true,
          value: e.valueOrNull,
          stackTrace: e.stackTrace,
          hasValue: e.hasValue,
        ),
        loading: (_) => this,
      );
    } else {
      return previous.map(
        initial: (_) => this,
        data: (e) => MutationLoading._(
          _setState,
          _fn,
          hasValue: true,
          value: e.valueOrNull,
          error: e.error,
          stackTrace: e.stackTrace,
        ),
        error: (e) => MutationLoading._(
          _setState,
          _fn,
          hasValue: e.hasValue,
          value: e.valueOrNull,
          error: e.error,
          stackTrace: e.stackTrace,
        ),
        loading: (e) => e,
      );
    }
  }
}

class MutationData<Result, Param> extends MutationState<Result, Param> {
  const MutationData(super._setState, super._fn, this.value)
      : isLoading = false,
        error = null,
        stackTrace = null;

  const MutationData._(
    super._setState,
    super._fn,
    this.value, {
    required this.isLoading,
    required this.error,
    required this.stackTrace,
  });

  @override
  final Result value;

  @override
  bool get hasValue => true;

  @override
  final bool isLoading;

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  @override
  R map<R>({
    required R Function(MutationInitial<Result, Param> initial) initial,
    required R Function(MutationData<Result, Param> data) data,
    required R Function(MutationError<Result, Param> error) error,
    required R Function(MutationLoading<Result, Param> loading) loading,
  }) {
    return data(this);
  }

  @override
  MutationState<Result, Param> copyWithPrevious(
    MutationState<Result, Param> previous,
  ) =>
      this;
}

class MutationError<Result, Param> extends MutationState<Result, Param> {
  const MutationError(
    super._setState,
    super._fn,
    this.error, {
    required this.stackTrace,
  })  : isLoading = false,
        hasValue = false,
        _value = null;

  const MutationError._(
    super._setState,
    super._fn,
    this.error, {
    required this.stackTrace,
    required this.isLoading,
    required Result? value,
    required this.hasValue,
  }) : _value = value;

  @override
  final bool isLoading;

  @override
  final bool hasValue;

  @override
  Result? get value {
    if (!hasValue) {
      throwErrorWithCombinedStackTrace(error, stackTrace);
    }
    return _value;
  }

  final Result? _value;

  @override
  final Object error;
  @override
  final StackTrace stackTrace;

  @override
  R map<R>({
    required R Function(MutationInitial<Result, Param> initial) initial,
    required R Function(MutationData<Result, Param> data) data,
    required R Function(MutationError<Result, Param> error) error,
    required R Function(MutationLoading<Result, Param> loading) loading,
  }) {
    return error(this);
  }

  @override
  MutationState<Result, Param> copyWithPrevious(
    MutationState<Result, Param> previous,
  ) {
    return MutationError._(
      _setState,
      _fn,
      error,
      stackTrace: stackTrace,
      isLoading: isLoading,
      value: previous.valueOrNull,
      hasValue: previous.hasValue,
    );
  }
}

extension MutationValueX<Result, Param> on MutationState<Result, Param> {
  bool get isInitial => this is MutationInitial;
  Result get requireValue {
    if (hasValue) return value as Result;
    if (hasError) throwErrorWithCombinedStackTrace(error!, stackTrace!);
    throw StateError(
      'Tried to call `requireValue` on a `MutationValue`'
      ' that has no value: $this',
    );
  }

  Result? get valueOrNull => hasValue ? value : null;

  bool get isRerunning =>
      isLoading && (hasValue || hasError) && this is! MutationLoading;

  bool get hasError => error != null;
  MutationData<Result, Param>? get asData =>
      maybeMap(data: (d) => d, orElse: () => null);

  MutationError<Result, Param>? get asError =>
      maybeMap(error: (e) => e, orElse: () => null);

  R maybeWhen<R>({
    bool skipLoadingOnRerun = false,
    bool skipError = false,
    R Function()? initial,
    R Function(Result value)? data,
    R Function(Object error, StackTrace stackTrace)? error,
    R Function()? loading,
    required R Function() orElse,
  }) {
    return when(
      skipError: skipError,
      skipLoadingOnRerun: skipLoadingOnRerun,
      initial: initial ?? orElse,
      loading: loading ?? orElse,
      data: (d) {
        if (data != null) return data(d);
        return orElse();
      },
      error: (e, s) {
        if (error != null) return error(e, s);
        return orElse();
      },
    );
  }

  R when<R>({
    bool skipLoadingOnRerun = false,
    bool skipError = false,
    required R Function() initial,
    required R Function(Result data) data,
    required R Function(Object error, StackTrace stackTrace) error,
    required R Function() loading,
  }) {
    if (isInitial) {
      return initial();
    }

    if (isLoading) {
      bool skip;
      if (isRerunning) {
        skip = skipLoadingOnRerun;
      } else {
        skip = false;
      }
      if (!skip) return loading();
    }

    if (hasError && (!hasValue || !skipError)) {
      return error(this.error!, stackTrace!);
    }

    return data(requireValue);
  }

  R? whenOrNull<R>({
    bool skipLoadingOnRerun = false,
    bool skipError = false,
    R? Function()? initial,
    R? Function(Result data)? data,
    R? Function(Object error, StackTrace stackTrace)? error,
    R? Function()? loading,
  }) {
    return when(
      skipError: skipError,
      skipLoadingOnRerun: skipLoadingOnRerun,
      initial: initial ?? () => null,
      data: data ?? (_) => null,
      error: error ?? (err, stack) => null,
      loading: loading ?? () => null,
    );
  }

  R maybeMap<R>({
    R Function(MutationInitial<Result, Param> initial)? initial,
    R Function(MutationData<Result, Param> data)? data,
    R Function(MutationError<Result, Param> error)? error,
    R Function(MutationLoading<Result, Param> loading)? loading,
    required R Function() orElse,
  }) {
    return map(
      initial: (i) {
        if (initial != null) return initial(i);
        return orElse();
      },
      data: (d) {
        if (data != null) return data(d);
        return orElse();
      },
      error: (e) {
        if (error != null) return error(e);
        return orElse();
      },
      loading: (l) {
        if (loading != null) return loading(l);
        return orElse();
      },
    );
  }
}
