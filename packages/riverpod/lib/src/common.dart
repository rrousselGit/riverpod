import 'package:meta/meta.dart';

import 'framework.dart';
import 'future_provider.dart' show FutureProvider;
import 'stack_trace.dart';
import 'stream_provider.dart' show StreamProvider;

/// An extension for [asyncTransition].
@internal
extension AsyncTransition<T> on ProviderElementBase<AsyncValue<T>> {
  /// Internal utility for transitioning an [AsyncValue] after a provider refresh.
  void asyncTransition({required bool shouldClearPreviousState}) {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    final previous = getState()?.requireState;

    if (previous == null) {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      setState(AsyncLoading<T>());
    } else {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      setState(
        AsyncLoading<T>()
            .copyWithPrevious(previous, seamless: !shouldClearPreviousState),
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
/// state, consider using [value] to read the state:
///
/// ```dart
/// Widget build(BuildContext context, WidgetRef ref) {
///   // reads the data state directly – will be throw during loading/error states
///   final User user = ref.watch(userProvider).value;
///
///   return Text('Hello ${user.name}');
/// }
/// ```
///
/// See also:
///
/// - [FutureProvider] and [StreamProvider], which transforms a [Future] into
///   an [AsyncValue].
/// - [AsyncValue.guard], to simplify transforming a [Future] into an [AsyncValue].
@sealed
@immutable
abstract class AsyncValue<T> {
  const AsyncValue._();

  /// Creates an [AsyncValue] with a data.
  ///
  /// The data can be `null`.
  // coverage:ignore-start
  const factory AsyncValue.data(T value) = AsyncData<T>;
  // coverage:ignore-end

  /// Creates an [AsyncValue] in loading state.
  ///
  /// Prefer always using this constructor with the `const` keyword.
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
  /// This is useful to avoid having to do a tedious `try/catch`. Instead of:
  ///
  /// ```dart
  /// class MyNotifier extends StateNotifier<AsyncValue<MyData> {
  ///   MyNotifier(): super(const AsyncValue.loading()) {
  ///     _fetchData();
  ///   }
  ///
  ///   Future<void> _fetchData() async {
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
  /// which is redundant as the application grows and we need more and more of this
  /// pattern – we can use [guard] to simplify it:
  ///
  ///
  /// ```dart
  /// class MyNotifier extends StateNotifier<AsyncValue<MyData>> {
  ///   MyNotifier(): super(const AsyncValue.loading()) {
  ///     _fetchData();
  ///   }
  ///
  ///   Future<void> _fetchData() async {
  ///     state = const AsyncValue.loading();
  ///     // does the try/catch for us like previously
  ///     state = await AsyncValue.guard(() async {
  ///       final response = await dio.get('my_api/data');
  ///       return Data.fromJson(response);
  ///     });
  ///   }
  /// }
  /// ```
  static Future<AsyncValue<T>> guard<T>(Future<T> Function() future) async {
    try {
      return AsyncValue.data(await future());
    } catch (err, stack) {
      return AsyncValue.error(err, stack);
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
  ///
  /// [hasValue] correctly supports a null [value].
  bool get hasValue;

  /// The value currently exposed.
  ///
  /// When reading [value] during loading state, null will be returning.
  ///
  /// When trying to read [value] in error state, the error will be rethrown
  /// instead. The exception is if [isRefreshing] is true, in which case
  /// the previous value will be returned.
  ///
  /// See also [valueOrNull], which does not throw during error state.
  T? get value;

  /// The [error].
  Object? get error;

  /// The stacktrace of [error].
  StackTrace? get stackTrace;

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
  /// Specifying [seamless] (true by default) controls whether the clone should skip
  /// "loading" cases or not:
  ///
  /// ```dart
  /// print(
  ///   AsyncLoading<int>()
  ///     .copyWithPrevious(AsyncData(42))
  /// ); // AsyncData<int>(isLoading: true, value: 42)
  ///
  /// print(
  ///   AsyncLoading<int>()
  ///     .copyWithPrevious(AsyncData(42), seamless: false)
  /// ); // AsyncLoading<int>(isLoading: true, value: 42)
  /// ```
  ///
  /// Setting it to force is useful to force the UI to show a spinner.
  AsyncValue<T> copyWithPrevious(
    AsyncValue<T> previous, {
    bool seamless = true,
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
      ]
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
        // Fallback null values to 0, making sure Object.hash hashes all values
        valueOrNull ?? 0,
        error ?? 0,
        stackTrace ?? 0,
      );
}

/// Creates an [AsyncValue] with a data.
///
/// The data can be `null`.
class AsyncData<T> extends AsyncValue<T> {
  /// Creates an [AsyncValue] with a data.
  ///
  /// The data can be `null`.
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
    bool seamless = true,
  }) {
    return this;
  }
}

/// Creates an [AsyncValue] in loading state.
///
/// Prefer always using this constructor with the `const` keyword.
class AsyncLoading<T> extends AsyncValue<T> {
  /// Creates an [AsyncValue] in loading state.
  ///
  /// Prefer always using this constructor with the `const` keyword.
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
    bool seamless = true,
  }) {
    if (seamless) {
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
    bool seamless = true,
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
  /// If [hasValue] is true, returns the value. If in error, rethrows the error.
  /// Otherwise if in loading state, throws a [StateError].
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

  /// Return the value, or null if in error/loading state.
  ///
  /// This is different from [value], which will throw if trying to read the value
  /// in error state.
  T? get valueOrNull {
    if (hasValue) return value;
    return null;
  }

  /// Whether an [AsyncData] or [AsyncError] was emitted but the state went
  /// back to loading state.
  ///
  /// This is different from [isLoading] in that [isLoading] is for waiting
  /// the first value to be available, while [isRefreshing] is after a value
  /// was emitted but a provider refresh was triggered.
  bool get isRefreshing {
    return isLoading && (hasValue || hasError);
  }

  /// Whether [value] is set.
  ///
  /// Even if [hasError] is true, it is still possible for [hasValue]/[isLoading]
  /// to also be true.
  // It is safe to check it through `error != null` because `error` is non-nullable
  bool get hasError => error != null;

  /// Upcast [AsyncValue] into an [AsyncData], or return null if the [AsyncValue]
  /// is in loading/error state.
  AsyncData<T>? get asData {
    return map(
      data: (d) => d,
      error: (e) => null,
      loading: (l) => null,
    );
  }

  /// Upcast [AsyncValue] into an [AsyncError], or return null if the [AsyncValue]
  /// is in loading/data state.
  AsyncError? get asError => map(
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
  /// {@macro asyncvalue.optimistic}
  R maybeWhen<R>({
    bool? optimistic,
    R Function(T data)? data,
    R Function(Object error, StackTrace stackTrace)? error,
    R Function()? loading,
    required R Function() orElse,
  }) {
    if (optimistic == null) {
      return map(
        data: (d) {
          if (data != null) return data(d.value);
          return orElse();
        },
        error: (e) {
          if (error != null) return error(e.error, e.stackTrace);
          return orElse();
        },
        loading: (l) {
          if (loading != null) return loading();
          return orElse();
        },
      );
    } else if (optimistic) {
      if (hasError) return error?.call(this.error!, stackTrace!) ?? orElse();
      if (hasValue) return data?.call(requireValue) ?? orElse();
      return loading?.call() ?? orElse();
    } else {
      if (isLoading) return loading?.call() ?? orElse();
      if (hasError) return error?.call(this.error!, stackTrace!) ?? orElse();
      return data?.call(requireValue) ?? orElse();
    }
  }

  /// Performs an action based on the state of the [AsyncValue].
  ///
  /// All cases are required, which allows returning a non-nullable value.
  ///
  /// {@template asyncvalue.optimistic}
  /// The parameter [optimistic] can be optionally be specified to give control
  /// over whether to read [loading] or [data]/[error].
  ///
  /// If `null` (default), the default behavior is to let the provider decide,
  /// such that:
  /// - If a provider rebuilds due to [Ref.watch], [when] will invoke [loading].
  /// - If a provider rebuilds due to [Ref.refresh]/[Ref.invalidate],
  ///   the [loading] case is skipped and [when] will invoke [data] or [error]
  ///   with the previous value/error during the refresh.
  ///
  /// If `true`, forcibly skips [loading] cases. So even if a provider
  /// rebuilds because of [Ref.watch], [when] will still skip the [loading]
  /// case and instead invoke [data]/[error] with the previous value/error.
  ///
  /// If `false`, forcibly go into [loading] cases if [isLoading], even if a
  /// [value] or [error] is available. As such, rebuilding a provider
  /// with [Ref.refresh] will still cause [when] to invoke [loading], instead
  /// of invoking [data]/[error] with the previosu value.
  /// {@endtemplate}
  R when<R>({
    bool? optimistic,
    required R Function(T data) data,
    required R Function(Object error, StackTrace stackTrace) error,
    required R Function() loading,
  }) {
    if (optimistic == null) {
      return map(
        data: (d) => data(d.value),
        error: (e) => error(e.error, e.stackTrace),
        loading: (l) => loading(),
      );
    } else if (optimistic) {
      if (hasError) return error(this.error!, stackTrace!);
      if (hasValue) return data(requireValue);
      return loading();
    } else {
      if (isLoading) return loading();
      if (hasError) return error(this.error!, stackTrace!);
      return data(requireValue);
    }
  }

  /// Perform actions conditionally based on the state of the [AsyncValue].
  ///
  /// Returns null if [AsyncValue] was in a state that was not handled.
  /// This is similar to [maybeWhen] where `orElse` returns null.
  ///
  /// {@macro asyncvalue.optimistic}
  R? whenOrNull<R>({
    bool? optimistic,
    R Function(T data)? data,
    R Function(Object error, StackTrace stackTrace)? error,
    R Function()? loading,
  }) {
    if (optimistic == null) {
      return map(
        data: (d) => data?.call(d.value),
        error: (e) => error?.call(e.error, e.stackTrace),
        loading: (l) => loading?.call(),
      );
    } else if (optimistic) {
      if (hasError) return error?.call(this.error!, stackTrace!);
      if (hasValue) return data?.call(requireValue);
      return loading?.call();
    } else {
      if (isLoading) return loading?.call();
      if (hasError) return error?.call(this.error!, stackTrace!);
      return data?.call(requireValue);
    }
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
    R Function(AsyncData<T> data)? data,
    R Function(AsyncError<T> error)? error,
    R Function(AsyncLoading<T> loading)? loading,
  }) {
    return map(
      data: (d) => data?.call(d),
      error: (d) => error?.call(d),
      loading: (d) => loading?.call(d),
    );
  }
}
