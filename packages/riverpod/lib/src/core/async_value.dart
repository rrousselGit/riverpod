import 'package:meta/meta.dart';

import '../common/internal_lints.dart';
import '../common/stack_trace.dart';
import '../framework.dart';
import '../providers/future_provider.dart' show FutureProvider;
import '../providers/stream_provider.dart' show StreamProvider;

@internal
extension AsyncTransition<ValueT> on AsyncValue<ValueT> {
  AsyncValue<NewT> cast<NewT>() => _cast<NewT>();
}

extension<BoxedT> on (BoxedT,)? {
  BoxedT unwrapSentinel(BoxedT current) {
    final that = this;
    if (that == null) return current;

    return that.$1;
  }
}

extension on _LoadingRecord {
  _LoadingRecord copyWith({
    (num?,)? progress,
    (_LoadingKind?,)? kind,
  }) {
    return (
      progress: progress.unwrapSentinel(this.progress),
      kind: kind.unwrapSentinel(this.kind),
    );
  }
}

/// Adds non-state related methods/getters to [AsyncValue].
@publicInRiverpodAndCodegen
extension AsyncValueExtensions<ValueT> on AsyncValue<ValueT> {
  SourceKind get _valueSource => _value?.source ?? SourceKind.live;

  /// Whether the value was obtained using Riverpod's offline-persistence feature.
  ///
  /// When [isFromCache] is true, [isLoading] should also be true.
  bool get isFromCache => _valueSource == SourceKind.cache;

  /// Whether some new value is currently asynchronously loading.
  ///
  /// Even if [isLoading] is true, it is still possible for [hasValue]/[hasError]
  /// to also be true.
  bool get isLoading => _loading != null;

  bool get _hasState => hasValue || hasError;

  /// Whether the associated provider was forced to recompute even though
  /// none of its dependencies has changed, after at least one [value]/[error] was emitted.
  ///
  /// This is usually the case when rebuilding a provider with either
  /// [Ref.invalidate]/[Ref.refresh].
  ///
  /// If a provider rebuilds because one of its dependencies changes (using [Ref.watch]),
  /// then [isRefreshing] will be false, and instead [isReloading] will be true.
  bool get isRefreshing => _hasState && _loading?.kind == _LoadingKind.refresh;

  /// Whether the associated provider was recomputed because of a dependency change
  /// (using [Ref.watch]), after at least one [value]/[error] was emitted.
  ///
  /// If a provider rebuilds because one of its dependencies changed (using [Ref.watch]),
  /// then [isReloading] will be true.
  /// If a provider rebuilds only due to [Ref.invalidate]/[Ref.refresh], then
  /// [isReloading] will be false (and [isRefreshing] will be true).
  ///
  /// See also [isRefreshing] for manual provider rebuild.
  bool get isReloading => _hasState && _loading?.kind == _LoadingKind.reload;

  /// The current progress of the asynchronous operation.
  ///
  /// This value must be between 0 and 1.
  ///
  /// By default, the progress will always be `null`.
  /// Notifiers can set this manually as such:
  ///
  /// ```dart
  /// state = AsyncLoading(progress: 0);
  /// await something();
  /// ref.state = AsyncLoading(progress: 1);
  /// ```
  num? get progress => _loading?.progress;

  /// Whether [value] is set.
  ///
  /// Even if [hasValue] is true, it is still possible for [isLoading]/[hasError]
  /// to also be true.
  bool get hasValue => _value != null;

  /// Whether [error] is not null.
  ///
  /// Even if [hasError] is true, it is still possible for [hasValue]/[isLoading]
  /// to also be true.
  // It is safe to check it through `error != null` because `error` is non-nullable
  // on the AsyncError constructor.
  bool get hasError => _error != null;

  /// Upcast [AsyncValue] into an [AsyncData], or return null if the [AsyncValue]
  /// is an [AsyncLoading]/[AsyncError].
  ///
  /// Note that an [AsyncData] may still be in loading/error state, such
  /// as during a pull-to-refresh.
  AsyncData<ValueT>? get asData {
    return map(
      data: (d) => d,
      error: (e) => null,
      loading: (l) => null,
    );
  }

  /// Upcast [AsyncValue] into an [AsyncError], or return null if the [AsyncValue]
  /// is an [AsyncLoading]/[AsyncData].
  ///
  /// Note that an [AsyncError] may still be in loading state, such
  /// as during a pull-to-refresh.
  AsyncError<ValueT>? get asError => map(
        data: (_) => null,
        error: (e) => e,
        loading: (_) => null,
      );

  /// Perform some action based on the current state of the [AsyncValue].
  ///
  /// This allows reading the content of an [AsyncValue] in a type-safe way,
  /// without potentially ignoring to handle a case.
  NewT map<NewT>({
    required NewT Function(AsyncData<ValueT> data) data,
    required NewT Function(AsyncError<ValueT> error) error,
    required NewT Function(AsyncLoading<ValueT> loading) loading,
  }) {
    final that = this;
    switch (that) {
      case AsyncLoading():
        return loading(that);
      case AsyncData():
        return data(that);
      case AsyncError():
        return error(that);
    }
  }

  /// Shorthand for [when] to handle only the `data` case.
  ///
  /// For loading/error cases, creates a new [AsyncValue] with the corresponding
  /// generic type while preserving the error/stacktrace.
  AsyncValue<NewT> whenData<NewT>(NewT Function(ValueT value) cb) {
    return map(
      data: (d) {
        try {
          return AsyncData._(
            (cb(d.value), source: null),
            loading: d._loading,
            error: d._error,
          );
        } catch (err, stack) {
          return AsyncError._(
            (err: err, stack: stack),
            loading: d._loading,
            value: null,
          );
        }
      },
      error: (e) => AsyncError._(
        e._error,
        loading: e._loading,
        value: null,
      ),
      loading: (l) => AsyncLoading<NewT>(progress: progress),
    );
  }

  /// Switch-case over the state of the [AsyncValue] while purposefully not handling
  /// some cases.
  ///
  /// If [AsyncValue] was in a case that is not handled, will return [orElse].
  ///
  /// {@macro async_value.skip_flags}
  NewT maybeWhen<NewT>({
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    NewT Function(ValueT data)? data,
    NewT Function(Object error, StackTrace stackTrace)? error,
    NewT Function()? loading,
    required NewT Function() orElse,
  }) {
    return when(
      skipError: skipError,
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipLoadingOnReload: skipLoadingOnReload,
      data: data ?? (_) => orElse(),
      error: error ?? (err, stack) => orElse(),
      loading: loading ?? () => orElse(),
    );
  }

  /// Performs an action based on the state of the [AsyncValue].
  ///
  /// All cases are required, which allows returning a non-nullable value.
  ///
  /// {@template async_value.skip_flags}
  /// By default, [when] skips "loading" states if triggered by a [Ref.refresh]
  /// or [Ref.invalidate] (but does not skip loading states if triggered by [Ref.watch]).
  ///
  /// In the event that an [AsyncValue] is in multiple states at once (such as
  /// when reloading a provider or emitting an error after a valid data),
  /// [when] offers various flags to customize whether it should call
  /// [loading]/[error]/[data] :
  ///
  /// - [skipLoadingOnReload] (false by default) customizes whether [loading]
  ///   should be invoked if a provider rebuilds because of [Ref.watch].
  ///   In that situation, [when] will try to invoke either [error]/[data]
  ///   with the previous state.
  ///
  /// - [skipLoadingOnRefresh] (true by default) controls whether [loading]
  ///   should be invoked if a provider rebuilds because of [Ref.refresh]
  ///   or [Ref.invalidate].
  ///   In that situation, [when] will try to invoke either [error]/[data]
  ///   with the previous state.
  ///
  /// - [skipError] (false by default) decides whether to invoke [data] instead
  ///   of [error] if a previous [value] is available.
  /// {@endtemplate}
  NewT when<NewT>({
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    required NewT Function(ValueT data) data,
    required NewT Function(Object error, StackTrace stackTrace) error,
    required NewT Function() loading,
  }) {
    if (isLoading) {
      bool skip;
      if (isRefreshing) {
        skip = skipLoadingOnRefresh;
      } else if (isReloading) {
        skip = skipLoadingOnReload;
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

  /// Perform actions conditionally based on the state of the [AsyncValue].
  ///
  /// Returns null if [AsyncValue] was in a state that was not handled.
  /// This is similar to [maybeWhen] where `orElse` returns null.
  ///
  /// {@macro async_value.skip_flags}
  NewT? whenOrNull<NewT>({
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    NewT? Function(ValueT data)? data,
    NewT? Function(Object error, StackTrace stackTrace)? error,
    NewT? Function()? loading,
  }) {
    return when(
      skipError: skipError,
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipLoadingOnReload: skipLoadingOnReload,
      data: data ?? (_) => null,
      error: error ?? (err, stack) => null,
      loading: loading ?? () => null,
    );
  }

  /// Perform some actions based on the state of the [AsyncValue], or call orElse
  /// if the current state was not tested.
  NewT maybeMap<NewT>({
    NewT Function(AsyncData<ValueT> data)? data,
    NewT Function(AsyncError<ValueT> error)? error,
    NewT Function(AsyncLoading<ValueT> loading)? loading,
    required NewT Function() orElse,
  }) {
    return map(
      data: (d) {
        if (data != null) return data(d);
        return orElse();
      },
      error: (d) {
        if (error != null) return error(d);
        return orElse();
      },
      loading: (d) {
        if (loading != null) return loading(d);
        return orElse();
      },
    );
  }

  /// Perform some actions based on the state of the [AsyncValue], or return null
  /// if the current state wasn't tested.
  NewT? mapOrNull<NewT>({
    NewT? Function(AsyncData<ValueT> data)? data,
    NewT? Function(AsyncError<ValueT> error)? error,
    NewT? Function(AsyncLoading<ValueT> loading)? loading,
  }) {
    return map(
      data: (d) => data?.call(d),
      error: (d) => error?.call(d),
      loading: (d) => loading?.call(d),
    );
  }

  /// The opposite of [copyWithPrevious], reverting to the raw [AsyncValue]
  /// with no information on the previous state.
  AsyncValue<ValueT> unwrapPrevious() {
    final that = this;
    return switch (that) {
      AsyncValue(isLoading: true) ||
      AsyncLoading() =>
        AsyncLoading<ValueT>(progress: that.progress),
      AsyncData() => AsyncData<ValueT>(that.value),
      AsyncError() => AsyncError<ValueT>(that.error, that.stackTrace),
    };
  }
}

enum _LoadingKind {
  reload,
  refresh,
}

@internal
enum SourceKind {
  cache,
  live,
  reload,
  refresh,
}

typedef _DataRecord<ValueT> = (ValueT, {SourceKind? source});
typedef _ErrorRecord = ({Object err, StackTrace stack});
typedef _LoadingRecord = ({num? progress, _LoadingKind? kind});

/// A utility for safely manipulating asynchronous data.
///
/// By using [AsyncValue], you are guaranteed that you cannot forget to
/// handle the loading/error state of an asynchronous operation.
///
/// [AsyncValue] is a sealed class, and is designed to be used with
/// pattern matching to handle the different states:
///
/// ```dart
/// /// A provider that asynchronously exposes the current user
/// final userProvider = StreamProvider<User>((_) async* {
///   // fetch the user
/// });
///
/// class Example extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final AsyncValue<User> user = ref.watch(userProvider);
///
///     return switch (user) {
///       AsyncValue(hasError: true) => Text('Oops, something unexpected happened'),
///       AsyncValue(:final value, hasValue: true) => Text('Hello ${value.name}'),
///       _ => CircularProgressIndicator(),
///     );
///   }
/// }
/// ```
///
/// If a consumer of an [AsyncValue] does not care about the loading/error
/// state, consider using [requireValue] to read the state:
///
/// ```dart
/// Widget build(BuildContext context, WidgetRef ref) {
///   // Reading .requiredValue will be throw both on loading and error states.
///   final User user = ref.watch(userProvider).requiredValue;
///
///   ...
/// }
/// ```
///
/// By using [requireValue], we get an immediate access to the value. At the same
/// time, if we made a mistake and the value is not available, we will get an
/// exception. This is a good thing because it will help us to spot problem.
///
/// See also:
///
/// - [FutureProvider], [StreamProvider] which transforms a [Future] into
///   an [AsyncValue].
/// - [AsyncValue.guard], to simplify transforming a [Future] into an [AsyncValue].
/// {@category Core}
@sealed
@immutable
@publicInRiverpodAndCodegen
sealed class AsyncValue<ValueT> {
  const AsyncValue._();

  /// {@template async_value.data}
  /// Creates an [AsyncValue] with a data.
  /// {@endtemplate}
  // coverage:ignore-start
  const factory AsyncValue.data(ValueT value) = AsyncData<ValueT>;
  // coverage:ignore-end

  /// {@template async_value.loading}
  /// Creates an [AsyncValue] in loading state.
  ///
  /// Prefer always using this constructor with the `const` keyword.
  /// {@endtemplate}
  // coverage:ignore-start
  const factory AsyncValue.loading({num progress}) = AsyncLoading<ValueT>;
  // coverage:ignore-end

  /// {@template async_value.error_ctor}
  /// Creates an [AsyncValue] in the error state.
  ///
  /// _I don't have a [StackTrace], what can I do?_
  /// You can still construct an [AsyncError] by passing [StackTrace.current]:
  ///
  /// ```dart
  /// AsyncValue.error(error, StackTrace.current);
  /// ```
  /// {@endtemplate}
  // coverage:ignore-start
  const factory AsyncValue.error(Object error, StackTrace stackTrace) =
      AsyncError<ValueT>;
  // coverage:ignore-end

  /// Transforms a [Future] that may fail into something that is safe to read.
  ///
  /// This is useful to avoid having to do a tedious `try/catch`. Instead of
  /// writing:
  ///
  /// ```dart
  /// class MyNotifier extends AsyncNotifier<MyData> {
  ///   @override
  ///   Future<MyData> build() => Future.value(MyData());
  ///
  ///   Future<void> sideEffect() async {
  ///     state = const AsyncValue.loading();
  ///     try {
  ///       final response = await dio.get('my_api/data');
  ///       final data = MyData.fromJson(response);
  ///       state = AsyncValue.data(data);
  ///     } catch (err, stack) {
  ///       state = AsyncValue.error(err, stack);
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// We can use [guard] to simplify it:
  ///
  /// ```dart
  /// class MyNotifier extends AsyncNotifier<MyData> {
  ///   @override
  ///   Future<MyData> build() => Future.value(MyData());
  ///
  ///   Future<void> sideEffect() async {
  ///     state = const AsyncValue.loading();
  ///     // does the try/catch for us like previously
  ///     state = await AsyncValue.guard(() async {
  ///       final response = await dio.get('my_api/data');
  ///       return Data.fromJson(response);
  ///     });
  ///   }
  /// }
  /// ```
  ///
  /// An optional callback can be specified to catch errors only under a certain condition.
  /// In the following example, we catch all exceptions beside FormatExceptions.
  ///
  /// ```dart
  ///   AsyncValue.guard(
  ///    () async { /* ... */ },
  ///     // Catch all errors beside [FormatException]s.
  ///    (err) => err is! FormatException,
  ///   );
  /// }
  /// ```
  static Future<AsyncValue<ValueT>> guard<ValueT>(
    Future<ValueT> Function() future, [
    bool Function(Object)? test,
  ]) async {
    try {
      return AsyncValue.data(await future());
    } catch (err, stack) {
      if (test == null) {
        return AsyncValue.error(err, stack);
      }
      if (test(err)) {
        return AsyncValue.error(err, stack);
      }

      Error.throwWithStackTrace(err, stack);
    }
  }

  _LoadingRecord? get _loading;
  _DataRecord<ValueT>? get _value;
  _ErrorRecord? get _error;

  /// The value currently exposed.
  ///
  /// If currently in error/loading state, will return the previous value.
  /// If there is no previous value available, `null` will be returned.
  ///
  /// If you do not want to return previous value during loading/error states,
  /// consider using [unwrapPrevious]:
  ///
  /// ```dart
  /// ref.watch(provider).unwrapPrevious().value;
  /// ```
  ValueT? get value => _value?.$1;

  /// If [hasValue] is true, returns the value.
  /// Otherwise if [hasError], rethrows the error.
  /// Finally if in loading state, throws a [StateError].
  ///
  /// This is typically used for when the UI assumes that [value] is always present.
  ValueT get requireValue {
    if (hasValue) return value as ValueT;
    if (hasError) {
      assert(this is! AsyncData, 'Bad state');
      throwProviderException(error!, stackTrace!);
    }

    assert(this is! AsyncData, 'Bad state');
    throw StateError(
      'Tried to call `requireValue` on an `AsyncValue` that has no value: $this',
    );
  }

  /// The [error].
  Object? get error => _error?.err;

  /// The stacktrace of [error].
  StackTrace? get stackTrace => _error?.stack;

  String get _displayString;

  /// Casts the [AsyncValue] to a different type.
  AsyncValue<NewT> _cast<NewT>();

  /// Clone an [AsyncValue], merging it with [previous].
  ///
  /// When doing so, the resulting [AsyncValue] can contain the information
  /// about multiple state at once.
  /// For example, this allows an [AsyncError] to contain a [value], or even
  /// [AsyncLoading] to contain both a [value] and an [error].
  ///
  /// The optional [isRefresh] flag (true by default) represents whether the
  /// provider rebuilt by [Ref.refresh]/[Ref.invalidate] (if true)
  /// or instead by [Ref.watch] (if false).
  /// This changes the default behavior of [when] and sets the [isReloading]/
  /// [isRefreshing] flags accordingly.
  AsyncValue<ValueT> copyWithPrevious(
    AsyncValue<ValueT> previous, {
    bool isRefresh = true,
  });

  @override
  String toString() {
    final content = [
      if (isLoading && this is! AsyncLoading) 'isLoading: $isLoading',
      if (progress case final progress?) 'progress: $progress',
      if (hasValue) 'value: $value',
      if (hasError) ...[
        'error: $error',
        'stackTrace: $stackTrace',
      ],
      if (_value?.source case final valueSource?)
        'valueSource: ${valueSource.name}',
    ].join(', ');

    return '$_displayString<$ValueT>($content)';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType &&
        other is AsyncValue<ValueT> &&
        other.isLoading == isLoading &&
        other.progress == progress &&
        other._value == _value &&
        other._error == _error;
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        isLoading,
        progress,
        _value,
        _error,
      );
}

/// A variant of [AsyncValue] that excludes [AsyncLoading].
///
/// This is useful when you want to represent only data|error states.
@publicInRiverpodAndCodegen
sealed class AsyncResult<ValueT> extends AsyncValue<ValueT> {
  const AsyncResult._() : super._();

  /// A variant of [AsyncValue.guard] that returns an [AsyncResult],
  /// but does not support returning a [Future].
  static AsyncResult<ValueT> guard<ValueT>(ValueT Function() fn) {
    try {
      return AsyncData(fn());
    } catch (err, stack) {
      return AsyncError(err, stack);
    }
  }
}

/// {@macro async_value.data}
/// {@category Core}
@publicInRiverpodAndCodegen
final class AsyncData<ValueT> extends AsyncResult<ValueT> {
  /// {@macro async_value.data}
  const AsyncData(
    ValueT value, {
    /// @nodoc
    @internal SourceKind? source,
  }) : this._(
          (value, source: source),
          loading: null,
          error: null,
        );

  const AsyncData._(
    this._value, {
    required _ErrorRecord? error,
    required _LoadingRecord? loading,
  })  : _loading = loading,
        _error = error,
        super._();

  @override
  final _LoadingRecord? _loading;

  @override
  String get _displayString => 'AsyncData';

  @override
  final _DataRecord<ValueT> _value;
  @override
  ValueT get value => _value.$1;

  @override
  final _ErrorRecord? _error;

  @override
  AsyncData<ValueT> copyWithPrevious(
    AsyncValue<ValueT> previous, {
    bool isRefresh = true,
  }) {
    return this;
  }

  @override
  AsyncValue<NewT> _cast<NewT>() {
    if (ValueT == NewT) return this as AsyncValue<NewT>;
    return AsyncData<NewT>._(
      _value as _DataRecord<NewT>,
      error: _error,
      loading: _loading,
    );
  }
}

/// {@macro async_value.loading}
/// {@category Core}
@publicInRiverpodAndCodegen
final class AsyncLoading<ValueT> extends AsyncValue<ValueT> {
  /// {@macro async_value.loading}
  const AsyncLoading({num? progress})
      : _value = null,
        _loading = (progress: progress, kind: null),
        _error = null,
        assert(
          progress == null || (progress >= 0 && progress <= 1),
          'progress must be between 0 and 1',
        ),
        super._();

  const AsyncLoading._(
    this._loading, {
    required _DataRecord<ValueT>? value,
    required _ErrorRecord? error,
  })  : _value = value,
        _error = error,
        super._();

  @override
  final _LoadingRecord _loading;

  @override
  String get _displayString => 'AsyncLoading';

  @override
  final _DataRecord<ValueT>? _value;

  @override
  final _ErrorRecord? _error;

  @override
  AsyncValue<NewT> _cast<NewT>() {
    if (ValueT == NewT) return this as AsyncValue<NewT>;
    return AsyncLoading<NewT>._(
      _loading,
      value: value as _DataRecord<NewT>?,
      error: _error,
    );
  }

  @override
  AsyncValue<ValueT> copyWithPrevious(
    AsyncValue<ValueT> previous, {
    bool isRefresh = true,
  }) {
    final newLoading = _loading.copyWith(
      kind: (isRefresh ? _LoadingKind.refresh : _LoadingKind.reload,),
    );

    if (isRefresh) {
      return previous.map(
        data: (d) => AsyncData._(
          d._value,
          error: d._error,
          loading: newLoading,
        ),
        error: (e) => AsyncError._(
          e._error,
          loading: newLoading,
          value: e._value,
        ),
        loading: (_) => this,
      );
    } else {
      return AsyncLoading._(
        newLoading,
        value: previous._value,
        error: previous._error,
      );
    }
  }
}

/// {@macro async_value.error_ctor}
/// {@category Core}
@publicInRiverpodAndCodegen
final class AsyncError<ValueT> extends AsyncResult<ValueT> {
  /// {@macro async_value.error_ctor}
  const AsyncError(Object error, StackTrace stackTrace)
      : this._(
          (err: error, stack: stackTrace),
          loading: null,
          value: null,
        );

  const AsyncError._(
    this._error, {
    required _DataRecord<ValueT>? value,
    required _LoadingRecord? loading,
  })  : _value = value,
        _loading = loading,
        super._();

  @override
  final _LoadingRecord? _loading;

  @override
  String get _displayString => 'AsyncError';

  @override
  final _DataRecord<ValueT>? _value;

  @override
  final _ErrorRecord _error;

  @override
  Object get error => _error.err;
  @override
  StackTrace get stackTrace => _error.stack;

  @override
  AsyncValue<NewT> _cast<NewT>() {
    if (ValueT == NewT) return this as AsyncValue<NewT>;
    return AsyncError<NewT>._(
      _error,
      loading: _loading,
      value: _value as _DataRecord<NewT>?,
    );
  }

  @override
  AsyncError<ValueT> copyWithPrevious(
    AsyncValue<ValueT> previous, {
    bool isRefresh = true,
  }) {
    return AsyncError._(
      _error,
      loading: _loading,
      value: previous._value,
    );
  }
}
