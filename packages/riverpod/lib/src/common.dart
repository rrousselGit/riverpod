import 'package:meta/meta.dart';

import 'framework.dart';
import 'future_provider.dart' show FutureProvider;
import 'stack_trace.dart';
import 'stream_provider.dart' show StreamProvider;

/// An extension for [asyncTransition].
@internal
extension AsyncTransition<T> on ProviderElementBase<AsyncValue<T>> {
  /// Internal utility for transitioning an [AsyncValue] after a provider refresh.
  ///
  /// [seamless] controls how the previous state is preserved:
  /// - seamless:true => import previous state and skip loading
  /// - seamless:false => import previous state and prefer loading
  void asyncTransition(
    AsyncValue<T> newState, {
    required bool seamless,
  }) {
// ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    final previous = getState()?.requireState;

    if (previous == null) {
// ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      setState(newState);
    } else {
// ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      setState(
        newState._cast<T>().copyWithPrevious(previous, isRefresh: seamless),
      );
    }
  }
}

/// A utility for safely manipulating asynchronous data.
///
/// By using [AsyncValue], you are guaranteed that you cannot forget to
/// handle the loading/error state of an asynchronous operation.
///
/// It also exposes some utilities to nicely convert an [AsyncValue] to
/// a different object.
/// For example, a Flutter Widget may use [when] to convert an [AsyncValue]
/// into either a progress indicator, an error screen, or to show the data:
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
///     return user.when(
///       loading: () => CircularProgressIndicator(),
///       error: (error, stack) => Text('Oops, something unexpected happened'),
///       data: (user) => Text('Hello ${user.name}'),
///     );
///   }
/// }
/// ```
///
/// If a consumer of an [AsyncValue] does not care about the loading/error
/// state, consider using [value]/[valueOrNull] to read the state:
///
/// ```dart
/// Widget build(BuildContext context, WidgetRef ref) {
///   // Reading .value will be throw during error and return null on "loading" states.
///   final User user = ref.watch(userProvider).value;
///
///   // Reading .value will be throw both on loading and error states.
///   final User user2 = ref.watch(userProvider).requiredValue;
///
///   ...
/// }
/// ```
///
/// See also:
///
/// - [FutureProvider], [StreamProvider] which transforms a [Future] into
///   an [AsyncValue].
/// - [AsyncValue.guard], to simplify transforming a [Future] into an [AsyncValue].
@sealed
@immutable
abstract class AsyncValue<T> {
  const AsyncValue._();

  /// {@template asyncvalue.data}
  /// Creates an [AsyncValue] with a data.
  /// {@endtemplate}
  // coverage:ignore-start
  const factory AsyncValue.data(T value) = AsyncData<T>;
  // coverage:ignore-end

  /// {@template asyncvalue.loading}
  /// Creates an [AsyncValue] in loading state.
  ///
  /// Prefer always using this constructor with the `const` keyword.
  /// {@endtemplate}
  // coverage:ignore-start
  const factory AsyncValue.loading() = AsyncLoading<T>;
  // coverage:ignore-end

  /// {@template asyncvalue.error_ctor}
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
      AsyncError<T>;
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

  /// The value currently exposed.
  ///
  /// It will return the previous value during loading/error state.
  /// If there is no previous value, reading [value] during loading state will
  /// return null. While during error state, the error will be rethrown instead.
  ///
  /// If you do not want to return previous value during loading/error states,
  /// consider using [unwrapPrevious] with [valueOrNull]:
  ///
  /// ```dart
  /// ref.watch(provider).unwrapPrevious().valueOrNull;
  /// ```
  ///
  /// This will return null during loading/error states.
  T? get value;

  /// The [error].
  Object? get error;

  /// The stacktrace of [error].
  StackTrace? get stackTrace;

  /// Casts the [AsyncValue] to a different type.
  AsyncValue<R> _cast<R>();

  /// Perform some action based on the current state of the [AsyncValue].
  ///
  /// This allows reading the content of an [AsyncValue] in a type-safe way,
  /// without potentially ignoring to handle a case.
  R map<R>({
    required R Function(AsyncData<T> data) data,
    required R Function(AsyncError<T> error) error,
    required R Function(AsyncLoading<T> loading) loading,
  });

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
  AsyncValue<T> copyWithPrevious(
    AsyncValue<T> previous, {
    bool isRefresh = true,
  });

  /// The opposite of [copyWithPrevious], reverting to the raw [AsyncValue]
  /// with no information on the previous state.
  AsyncValue<T> unwrapPrevious() {
    return map(
      data: (d) {
        if (d.isLoading) return AsyncLoading<T>();
        return AsyncData(d.value);
      },
      error: (e) {
        if (e.isLoading) return AsyncLoading<T>();
        return AsyncError(e.error, e.stackTrace);
      },
      loading: (l) => AsyncLoading<T>(),
    );
  }

  @override
  String toString() {
    final content = [
      if (isLoading && this is! AsyncLoading) 'isLoading: $isLoading',
      if (hasValue) 'value: $value',
      if (hasError) ...[
        'error: $error',
        'stackTrace: $stackTrace',
      ],
    ].join(', ');

    return '$runtimeType($content)';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType &&
        other is AsyncValue<T> &&
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
        valueOrNull,
        error,
        stackTrace,
      );
}

/// {@macro asyncvalue.data}
class AsyncData<T> extends AsyncValue<T> {
  /// {@macro asyncvalue.data}
  const AsyncData(T value)
      : this._(
          value,
          isLoading: false,
          error: null,
          stackTrace: null,
        );

  const AsyncData._(
    this.value, {
    required this.isLoading,
    required this.error,
    required this.stackTrace,
  }) : super._();

  @override
  final T value;

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
    required R Function(AsyncData<T> data) data,
    required R Function(AsyncError<T> error) error,
    required R Function(AsyncLoading<T> loading) loading,
  }) {
    return data(this);
  }

  @override
  AsyncData<T> copyWithPrevious(
    AsyncValue<T> previous, {
    bool isRefresh = true,
  }) {
    return this;
  }

  @override
  AsyncValue<R> _cast<R>() {
    if (T == R) return this as AsyncValue<R>;
    return AsyncData<R>._(
      value as R,
      isLoading: isLoading,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// {@macro asyncvalue.loading}
class AsyncLoading<T> extends AsyncValue<T> {
  /// {@macro asyncvalue.loading}
  const AsyncLoading()
      : hasValue = false,
        value = null,
        error = null,
        stackTrace = null,
        super._();

  const AsyncLoading._({
    required this.hasValue,
    required this.value,
    required this.error,
    required this.stackTrace,
  }) : super._();

  @override
  bool get isLoading => true;

  @override
  final bool hasValue;

  @override
  final T? value;

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  @override
  AsyncValue<R> _cast<R>() {
    if (T == R) return this as AsyncValue<R>;
    return AsyncLoading<R>._(
      hasValue: hasValue,
      value: value as R?,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  R map<R>({
    required R Function(AsyncData<T> data) data,
    required R Function(AsyncError<T> error) error,
    required R Function(AsyncLoading<T> loading) loading,
  }) {
    return loading(this);
  }

  @override
  AsyncValue<T> copyWithPrevious(
    AsyncValue<T> previous, {
    bool isRefresh = true,
  }) {
    if (isRefresh) {
      return previous.map(
        data: (d) => AsyncData._(
          d.value,
          isLoading: true,
          error: d.error,
          stackTrace: d.stackTrace,
        ),
        error: (e) => AsyncError._(
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
        data: (d) => AsyncLoading._(
          hasValue: true,
          value: d.valueOrNull,
          error: d.error,
          stackTrace: d.stackTrace,
        ),
        error: (e) => AsyncLoading._(
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

/// {@macro asyncvalue.error_ctor}
class AsyncError<T> extends AsyncValue<T> {
  /// {@macro asyncvalue.error_ctor}
  const AsyncError(Object error, StackTrace stackTrace)
      : this._(
          error,
          stackTrace: stackTrace,
          isLoading: false,
          hasValue: false,
          value: null,
        );

  const AsyncError._(
    this.error, {
    required this.stackTrace,
    required T? value,
    required this.hasValue,
    required this.isLoading,
  })  : _value = value,
        super._();

  @override
  final bool isLoading;

  @override
  final bool hasValue;

  final T? _value;

  @override
  T? get value {
    if (!hasValue) {
      throwErrorWithCombinedStackTrace(error, stackTrace);
    }
    return _value;
  }

  @override
  final Object error;

  @override
  final StackTrace stackTrace;

  @override
  AsyncValue<R> _cast<R>() {
    if (T == R) return this as AsyncValue<R>;
    return AsyncError<R>._(
      error,
      stackTrace: stackTrace,
      isLoading: isLoading,
      value: _value as R?,
      hasValue: hasValue,
    );
  }

  @override
  R map<R>({
    required R Function(AsyncData<T> data) data,
    required R Function(AsyncError<T> error) error,
    required R Function(AsyncLoading<T> loading) loading,
  }) {
    return error(this);
  }

  @override
  AsyncError<T> copyWithPrevious(
    AsyncValue<T> previous, {
    bool isRefresh = true,
  }) {
    return AsyncError._(
      error,
      stackTrace: stackTrace,
      isLoading: isLoading,
      value: previous.valueOrNull,
      hasValue: previous.hasValue,
    );
  }
}

/// An extension that adds methods like [when] to an [AsyncValue].
extension AsyncValueX<T> on AsyncValue<T> {
  /// If [hasValue] is true, returns the value.
  /// Otherwise if [hasError], rethrows the error.
  /// Finally if in loading state, throws a [StateError].
  ///
  /// This is typically used for when the UI assumes that [value] is always present.
  T get requireValue {
    if (hasValue) return value as T;
    if (hasError) {
      throwErrorWithCombinedStackTrace(error!, stackTrace!);
    }

    throw StateError(
      'Tried to call `requireValue` on an `AsyncValue` that has no value: $this',
    );
  }

  /// Return the value or previous value if in loading/error state.
  ///
  /// If there is no previous value, null will be returned during loading/error state.
  ///
  /// This is different from [value], which will rethrow the error instead of returning null.
  ///
  /// If you do not want to return previous value during loading/error states,
  /// consider using [unwrapPrevious] :
  ///
  /// ```dart
  /// ref.watch(provider).unwrapPrevious()?.valueOrNull;
  /// ```
  T? get valueOrNull {
    if (hasValue) return value;
    return null;
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
  AsyncData<T>? get asData {
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
  AsyncError<T>? get asError => map(
        data: (_) => null,
        error: (e) => e,
        loading: (_) => null,
      );

  /// Shorthand for [when] to handle only the `data` case.
  ///
  /// For loading/error cases, creates a new [AsyncValue] with the corresponding
  /// generic type while preserving the error/stacktrace.
  AsyncValue<R> whenData<R>(R Function(T value) cb) {
    return map(
      data: (d) {
        try {
          return AsyncData._(
            cb(d.value),
            isLoading: d.isLoading,
            error: d.error,
            stackTrace: d.stackTrace,
          );
        } catch (err, stack) {
          return AsyncError._(
            err,
            stackTrace: stack,
            isLoading: d.isLoading,
            value: null,
            hasValue: false,
          );
        }
      },
      error: (e) => AsyncError._(
        e.error,
        stackTrace: e.stackTrace,
        isLoading: e.isLoading,
        value: null,
        hasValue: false,
      ),
      loading: (l) => AsyncLoading<R>(),
    );
  }

  /// Switch-case over the state of the [AsyncValue] while purposefully not handling
  /// some cases.
  ///
  /// If [AsyncValue] was in a case that is not handled, will return [orElse].
  ///
  /// {@macro asyncvalue.skip_flags}
  R maybeWhen<R>({
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    R Function(T data)? data,
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
  /// {@template asyncvalue.skip_flags}
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
    required R Function(T data) data,
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
  /// {@macro asyncvalue.skip_flags}
  R? whenOrNull<R>({
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
    bool skipError = false,
    R? Function(T data)? data,
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
    R Function(AsyncData<T> data)? data,
    R Function(AsyncError<T> error)? error,
    R Function(AsyncLoading<T> loading)? loading,
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
    R? Function(AsyncData<T> data)? data,
    R? Function(AsyncError<T> error)? error,
    R? Function(AsyncLoading<T> loading)? loading,
  }) {
    return map(
      data: (d) => data?.call(d),
      error: (d) => error?.call(d),
      loading: (d) => loading?.call(d),
    );
  }
}
