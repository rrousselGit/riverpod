import 'package:meta/meta.dart';

import '../common/internal_lints.dart';
import '../common/stack_trace.dart';
import '../framework.dart';
import '../providers/future_provider.dart' show FutureProvider;
import '../providers/stream_provider.dart' show StreamProvider;

@internal
extension AsyncTransition<StateT> on AsyncValue<StateT> {
  AsyncValue<T> cast<T>() => _cast<T>();
}

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
sealed class AsyncValue<StateT> {
  const AsyncValue._();

  /// {@template async_value.data}
  /// Creates an [AsyncValue] with a data.
  /// {@endtemplate}
  // coverage:ignore-start
  const factory AsyncValue.data(StateT value) = AsyncData<StateT>;
  // coverage:ignore-end

  /// {@template async_value.loading}
  /// Creates an [AsyncValue] in loading state.
  ///
  /// Prefer always using this constructor with the `const` keyword.
  /// {@endtemplate}
  // coverage:ignore-start
  const factory AsyncValue.loading({num progress}) = AsyncLoading<StateT>;
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
      AsyncError<StateT>;
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
  static Future<AsyncValue<T>> guard<T>(
    Future<T> Function() future, [
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

  /// Whether the value was obtained using Riverpod's offline-persistence feature.
  ///
  /// When [isFromCache] is true, [isLoading] should also be true.
  bool get isFromCache;

  /// Whether some new value is currently asynchronously loading.
  ///
  /// Even if [isLoading] is true, it is still possible for [hasValue]/[hasError]
  /// to also be true.
  bool get isLoading;

  /// Whether [value] is set.
  ///
  /// Even if [hasValue] is true, it is still possible for [isLoading]/[hasError]
  /// to also be true.
  bool get hasValue;

  /// The current progress of the asynchronous operation.
  ///
  /// This value must be between 0 and 1.
  ///
  /// By default, the progress will always be `null`.
  /// Providers can set this manually as such:
  ///
  /// ```dart
  /// @riverpod
  /// Future<Model> example(Ref ref) async {
  ///   ref.state = AsyncLoading(progress: 0);
  ///
  ///   await something();
  ///
  ///   ref.state = AsyncLoading(progress: 1);
  /// }
  /// ```
  num? get progress;

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
  StateT? get value;

  /// The [error].
  Object? get error;

  /// The stacktrace of [error].
  StackTrace? get stackTrace;

  String get _displayString;

  /// If [hasValue] is true, returns the value.
  /// Otherwise if [hasError], rethrows the error.
  /// Finally if in loading state, throws a [StateError].
  ///
  /// This is typically used for when the UI assumes that [value] is always present.
  StateT get requireValue {
    if (hasValue) return value as StateT;
    if (hasError) {
      throwErrorWithCombinedStackTrace(error!, stackTrace!);
    }

    throw StateError(
      'Tried to call `requireValue` on an `AsyncValue` that has no value: $this',
    );
  }

  /// Whether the associated provider was forced to recompute even though
  /// none of its dependencies has changed, after at least one [value]/[error] was emitted.
  ///
  /// This is usually the case when rebuilding a provider with either
  /// [Ref.invalidate]/[Ref.refresh].
  ///
  /// If a provider rebuilds because one of its dependencies changes (using [Ref.watch]),
  /// then [isRefreshing] will be false, and instead [isReloading] will be true.
  bool get isRefreshing =>
      isLoading && (hasValue || hasError) && this is! AsyncLoading;

  /// Whether the associated provider was recomputed because of a dependency change
  /// (using [Ref.watch]), after at least one [value]/[error] was emitted.
  ///
  /// If a provider rebuilds because one of its dependencies changed (using [Ref.watch]),
  /// then [isReloading] will be true.
  /// If a provider rebuilds only due to [Ref.invalidate]/[Ref.refresh], then
  /// [isReloading] will be false (and [isRefreshing] will be true).
  ///
  /// See also [isRefreshing] for manual provider rebuild.
  bool get isReloading => (hasValue || hasError) && this is AsyncLoading;

  /// Whether [error] is not null.
  ///
  /// Even if [hasError] is true, it is still possible for [hasValue]/[isLoading]
  /// to also be true.
  // It is safe to check it through `error != null` because `error` is non-nullable
  // on the AsyncError constructor.
  bool get hasError => error != null;

  /// Upcast [AsyncValue] into an [AsyncData], or return null if the [AsyncValue]
  /// is an [AsyncLoading]/[AsyncError].
  ///
  /// Note that an [AsyncData] may still be in loading/error state, such
  /// as during a pull-to-refresh.
  AsyncData<StateT>? get asData {
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
  AsyncError<StateT>? get asError => map(
        data: (_) => null,
        error: (e) => e,
        loading: (_) => null,
      );

  /// Perform some action based on the current state of the [AsyncValue].
  ///
  /// This allows reading the content of an [AsyncValue] in a type-safe way,
  /// without potentially ignoring to handle a case.
  R map<R>({
    required R Function(AsyncData<StateT> data) data,
    required R Function(AsyncError<StateT> error) error,
    required R Function(AsyncLoading<StateT> loading) loading,
  });

  /// Casts the [AsyncValue] to a different type.
  AsyncValue<R> _cast<R>();

  /// Shorthand for [when] to handle only the `data` case.
  ///
  /// For loading/error cases, creates a new [AsyncValue] with the corresponding
  /// generic type while preserving the error/stacktrace.
  AsyncValue<R> whenData<R>(R Function(StateT value) cb) {
    return map(
      data: (d) {
        try {
          return AsyncData._(
            cb(d.value),
            isLoading: d.isLoading,
            error: d.error,
            stackTrace: d.stackTrace,
            progress: d.progress,
            isFromCache: d.isFromCache,
          );
        } catch (err, stack) {
          return AsyncError._(
            err,
            stackTrace: stack,
            isLoading: d.isLoading,
            value: null,
            hasValue: false,
            progress: d.progress,
          );
        }
      },
      error: (e) => AsyncError._(
        e.error,
        stackTrace: e.stackTrace,
        isLoading: e.isLoading,
        value: null,
        hasValue: false,
        progress: e.progress,
      ),
      loading: (l) => AsyncLoading<R>(progress: progress),
    );
  }

  /// Switch-case over the state of the [AsyncValue] while purposefully not handling
  /// some cases.
  ///
  /// If [AsyncValue] was in a case that is not handled, will return [orElse].
  ///
  /// {@macro async_value.skip_flags}
  R maybeWhen<R>({
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    R Function(StateT data)? data,
    R Function(Object error, StackTrace stackTrace)? error,
    R Function()? loading,
    required R Function() orElse,
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
  R when<R>({
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    required R Function(StateT data) data,
    required R Function(Object error, StackTrace stackTrace) error,
    required R Function() loading,
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
  R? whenOrNull<R>({
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    R? Function(StateT data)? data,
    R? Function(Object error, StackTrace stackTrace)? error,
    R? Function()? loading,
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
  R maybeMap<R>({
    R Function(AsyncData<StateT> data)? data,
    R Function(AsyncError<StateT> error)? error,
    R Function(AsyncLoading<StateT> loading)? loading,
    required R Function() orElse,
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
  R? mapOrNull<R>({
    R? Function(AsyncData<StateT> data)? data,
    R? Function(AsyncError<StateT> error)? error,
    R? Function(AsyncLoading<StateT> loading)? loading,
  }) {
    return map(
      data: (d) => data?.call(d),
      error: (d) => error?.call(d),
      loading: (d) => loading?.call(d),
    );
  }

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
  AsyncValue<StateT> copyWithPrevious(
    AsyncValue<StateT> previous, {
    bool isRefresh = true,
  });

  /// The opposite of [copyWithPrevious], reverting to the raw [AsyncValue]
  /// with no information on the previous state.
  AsyncValue<StateT> unwrapPrevious() {
    return map(
      data: (d) {
        if (d.isLoading) return AsyncLoading<StateT>(progress: progress);
        return AsyncData(d.value);
      },
      error: (e) {
        if (e.isLoading) return AsyncLoading<StateT>(progress: progress);
        return AsyncError(e.error, e.stackTrace);
      },
      loading: (l) => AsyncLoading<StateT>(progress: progress),
    );
  }

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
      if (isFromCache) 'isFromCache: $isFromCache',
    ].join(', ');

    return '$_displayString<$StateT>($content)';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType &&
        other is AsyncValue<StateT> &&
        other.isLoading == isLoading &&
        other.hasValue == hasValue &&
        other.error == error &&
        other.stackTrace == stackTrace &&
        other.progress == progress &&
        other.isFromCache == isFromCache &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        isLoading,
        hasValue,
        value,
        error,
        stackTrace,
        progress,
        isFromCache,
      );
}

/// {@macro async_value.data}
/// {@category Core}
@publicInRiverpodAndCodegen
final class AsyncData<StateT> extends AsyncValue<StateT> {
  /// {@macro async_value.data}
  const AsyncData(
    StateT value, {
    /// @nodoc
    bool isFromCache = false,
  }) : this._(
          value,
          isLoading: false,
          isFromCache: isFromCache,
          error: null,
          stackTrace: null,
          progress: null,
        );

  const AsyncData._(
    this.value, {
    required this.isLoading,
    required this.error,
    required this.stackTrace,
    required this.progress,
    required this.isFromCache,
  }) : super._();

  @override
  String get _displayString => 'AsyncData';

  @override
  bool get hasValue => true;

  @override
  final bool isFromCache;

  @override
  final num? progress;

  @override
  final StateT value;

  @override
  @override
  final bool isLoading;

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  @override
  R map<R>({
    required R Function(AsyncData<StateT> data) data,
    required R Function(AsyncError<StateT> error) error,
    required R Function(AsyncLoading<StateT> loading) loading,
  }) {
    return data(this);
  }

  @override
  AsyncData<StateT> copyWithPrevious(
    AsyncValue<StateT> previous, {
    bool isRefresh = true,
  }) {
    return this;
  }

  @override
  AsyncValue<R> _cast<R>() {
    if (StateT == R) return this as AsyncValue<R>;
    return AsyncData<R>._(
      value as R,
      isLoading: isLoading,
      error: error,
      stackTrace: stackTrace,
      progress: progress,
      isFromCache: isFromCache,
    );
  }
}

/// {@macro async_value.loading}
/// {@category Core}
@publicInRiverpodAndCodegen
final class AsyncLoading<StateT> extends AsyncValue<StateT> {
  /// {@macro async_value.loading}
  const AsyncLoading({this.progress})
      : hasValue = false,
        value = null,
        error = null,
        stackTrace = null,
        isFromCache = false,
        assert(
          progress == null || (progress >= 0 && progress <= 1),
          'progress must be between 0 and 1',
        ),
        super._();

  const AsyncLoading._({
    required this.hasValue,
    required this.value,
    required this.error,
    required this.stackTrace,
    required this.progress,
    required this.isFromCache,
  }) : super._();

  @override
  bool get isLoading => true;

  @override
  final bool isFromCache;

  @override
  String get _displayString => 'AsyncLoading';

  @override
  final bool hasValue;

  @override
  final num? progress;

  @override
  final StateT? value;

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  @override
  AsyncValue<R> _cast<R>() {
    if (StateT == R) return this as AsyncValue<R>;
    return AsyncLoading<R>._(
      hasValue: hasValue,
      value: value as R?,
      error: error,
      stackTrace: stackTrace,
      progress: progress,
      isFromCache: isFromCache,
    );
  }

  @override
  R map<R>({
    required R Function(AsyncData<StateT> data) data,
    required R Function(AsyncError<StateT> error) error,
    required R Function(AsyncLoading<StateT> loading) loading,
  }) {
    return loading(this);
  }

  @override
  AsyncValue<StateT> copyWithPrevious(
    AsyncValue<StateT> previous, {
    bool isRefresh = true,
  }) {
    if (isRefresh) {
      return previous.map(
        data: (d) => AsyncData._(
          d.value,
          isLoading: true,
          error: d.error,
          stackTrace: d.stackTrace,
          progress: progress,
          isFromCache: d.isFromCache,
        ),
        error: (e) => AsyncError._(
          e.error,
          isLoading: true,
          value: e.value,
          stackTrace: e.stackTrace,
          hasValue: e.hasValue,
          progress: progress,
        ),
        loading: (_) => this,
      );
    } else {
      return previous.map(
        data: (d) => AsyncLoading._(
          hasValue: true,
          value: d.value,
          isFromCache: d.isFromCache,
          error: d.error,
          stackTrace: d.stackTrace,
          progress: progress,
        ),
        error: (e) => AsyncLoading._(
          hasValue: e.hasValue,
          value: e.value,
          isFromCache: e.isFromCache,
          error: e.error,
          stackTrace: e.stackTrace,
          progress: progress,
        ),
        loading: (e) => AsyncLoading._(
          hasValue: e.hasValue,
          value: e.value,
          isFromCache: e.isFromCache,
          error: e.error,
          stackTrace: e.stackTrace,
          progress: progress,
        ),
      );
    }
  }
}

/// {@macro async_value.error_ctor}
/// {@category Core}
@publicInRiverpodAndCodegen
final class AsyncError<StateT> extends AsyncValue<StateT> {
  /// {@macro async_value.error_ctor}
  const AsyncError(Object error, StackTrace stackTrace)
      : this._(
          error,
          stackTrace: stackTrace,
          isLoading: false,
          hasValue: false,
          value: null,
          progress: null,
        );

  const AsyncError._(
    this.error, {
    required this.stackTrace,
    required this.value,
    required this.hasValue,
    required this.isLoading,
    required this.progress,
  }) : super._();

  @override
  String get _displayString => 'AsyncError';

  @override
  bool get isFromCache => false;

  @override
  final num? progress;

  @override
  final bool isLoading;

  @override
  final bool hasValue;

  @override
  final StateT? value;

  @override
  final Object error;

  @override
  final StackTrace stackTrace;

  @override
  AsyncValue<R> _cast<R>() {
    if (StateT == R) return this as AsyncValue<R>;
    return AsyncError<R>._(
      error,
      stackTrace: stackTrace,
      isLoading: isLoading,
      value: value as R?,
      hasValue: hasValue,
      progress: progress,
    );
  }

  @override
  R map<R>({
    required R Function(AsyncData<StateT> data) data,
    required R Function(AsyncError<StateT> error) error,
    required R Function(AsyncLoading<StateT> loading) loading,
  }) {
    return error(this);
  }

  @override
  AsyncError<StateT> copyWithPrevious(
    AsyncValue<StateT> previous, {
    bool isRefresh = true,
  }) {
    return AsyncError._(
      error,
      stackTrace: stackTrace,
      isLoading: isLoading,
      value: previous.value,
      hasValue: previous.hasValue,
      progress: progress,
    );
  }
}
