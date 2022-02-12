import 'package:meta/meta.dart';

import 'future_provider.dart' show FutureProvider;
import 'stream_provider.dart' show StreamProvider;

/// Utility for `.name` of provider modifiers.
String? modifierName(String? from, String modifier) {
  return from == null ? null : '$from.$modifier';
}

enum AsyncValueStatus {
  data,
  loading,
  error,
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
///       data: (value) => Text('Hello ${user.name}'),
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

  /// Creates an [AsyncValue] in the error state.
  ///
  /// The parameter [error] cannot be `null`.
  // coverage:ignore-start
  const factory AsyncValue.error(Object error, {StackTrace? stackTrace}) =
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
      return AsyncValue.error(err, stackTrace: stack);
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
  T? get value;

  /// Whether [value] is set.
  ///
  /// Even if [hasError] is true, it is still possible for [hasValue]/[isLoading]
  /// to also be true.
  bool get hasError;

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
  /// This allow an [AsyncData] to also contain an [error], or similarly
  /// allows [AsyncError] to contain a [value].
  ///
  /// [AsyncLoading] will become an [AsyncData]/[AsyncError] with [isLoading]
  /// to true if [previous] is an [AsyncData] or [AsyncError].
  AsyncValue<T> copyWithPrevious(AsyncValue<T> previous);

  @override
  String toString() {
    final content = [
      if (isLoading) 'isLoading: $isLoading',
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
        other.hasError == hasError &&
        other.error == error &&
        other.stackTrace == stackTrace &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        value,
        isLoading,
        hasError,
        hasValue,
        error,
        stackTrace,
      );
}

/// Creates an [AsyncValue] with a data.
///
/// The data can be `null`.
class AsyncData<T> extends AsyncValue<T> {
  /// Creates an [AsyncValue] with a data.
  ///
  /// The data can be `null`.
  const AsyncData(T value) : this._(value, hasError: false, isLoading: false);

  const AsyncData._(
    this.value, {
    required this.hasError,
    required this.isLoading,
    this.error,
    this.stackTrace,
  }) : super._();

  @override
  final T value;

  @override
  bool get hasValue => true;

  @override
  final bool isLoading;

  @override
  final bool hasError;

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
  AsyncData<T> copyWithPrevious(AsyncValue<T> previous) {
    return AsyncData._(
      value,
      isLoading: isLoading,
      stackTrace: previous.stackTrace,
      error: previous.error,
      hasError: previous.hasError,
    );
  }
}

/// Creates an [AsyncValue] in loading state.
///
/// Prefer always using this constructor with the `const` keyword.
class AsyncLoading<T> extends AsyncValue<T> {
  /// Creates an [AsyncValue] in loading state.
  ///
  /// Prefer always using this constructor with the `const` keyword.
  const AsyncLoading() : super._();

  @override
  bool get isLoading => true;

  @override
  bool get hasValue => false;

  @override
  T? get value => null;

  @override
  bool get hasError => false;

  @override
  Object? get error => null;

  @override
  StackTrace? get stackTrace => null;

  @override
  R map<R>({
    required R Function(AsyncData<T> data) data,
    required R Function(AsyncError<T> error) error,
    required R Function(AsyncLoading<T> loading) loading,
  }) {
    return loading(this);
  }

  @override
  AsyncValue<T> copyWithPrevious(AsyncValue<T> previous) {
    return previous.map(
      data: (d) => AsyncData._(
        d.value,
        isLoading: true,
        error: d.error,
        stackTrace: d.stackTrace,
        hasError: d.hasError,
      ),
      error: (e) => AsyncError._(
        e.error,
        isLoading: true,
        value: e.value,
        stackTrace: e.stackTrace,
        hasValue: e.hasValue,
      ),
      loading: (_) => this,
    );
  }

  @override
  String toString() {
    return 'AsyncLoading<$T>()';
  }
}

/// Creates an [AsyncValue] in the error state.
///
/// The parameter [error] cannot be `null`.
class AsyncError<T> extends AsyncValue<T> {
  /// Creates an [AsyncValue] in the error state.
  ///
  /// The parameter [error] cannot be `null`.
  const AsyncError(
    Object error, {
    StackTrace? stackTrace,
  }) : this._(error, stackTrace: stackTrace, hasValue: false, isLoading: false);

  const AsyncError._(
    this.error, {
    this.stackTrace,
    this.value,
    required this.hasValue,
    required this.isLoading,
  }) : super._();

  @override
  final bool isLoading;

  @override
  final bool hasValue;

  @override
  final T? value;

  @override
  bool get hasError => true;

  @override
  final Object error;

  @override
  final StackTrace? stackTrace;

  @override
  R map<R>({
    required R Function(AsyncData<T> data) data,
    required R Function(AsyncError<T> error) error,
    required R Function(AsyncLoading<T> loading) loading,
  }) {
    return error(this);
  }

  @override
  AsyncError<T> copyWithPrevious(AsyncValue<T> previous) {
    return AsyncError._(
      error,
      stackTrace: stackTrace,
      isLoading: isLoading,
      value: previous.value,
      hasValue: previous.hasValue,
    );
  }
}

/// An extension that adds methods like [when] to an [AsyncValue].
extension AsyncValueX<T> on AsyncValue<T> {
  /// Whether an [AsyncData] or [AsyncError] was emitted but the state went
  /// back to loading state.
  bool get isRefreshing {
    return map(
      data: (d) => d.isLoading,
      error: (e) => e.isLoading,
      loading: (_) => false,
    );
  }

  /// Upcast [AsyncValue] into an [AsyncData], or return null if the [AsyncValue]
  /// is in loading/error state.
  AsyncData<T>? get asData {
    return map(
      data: (d) => d,
      error: (e) => null,
      loading: (l) => null,
    );
  }

  /// Attempts to synchronously read the data.
  ///
  /// On error, this will rethrow the error.
  /// If loading, will return `null`.
  /// Otherwise will return the data.
  T? get value {
    return map(
      data: (d) => d.value,
      // ignore: only_throw_errors
      error: (e) => throw e.error,
      loading: (l) => null,
    );
  }

  /// Whether this [AsyncValue] is an [AsyncLoading].
  bool get isLoading => map(
        data: (_) => false,
        error: (_) => false,
        loading: (_) => true,
      );

  /// Whether this [AsyncValue] is an [AsyncData].
  bool get isData => map(
        data: (_) => true,
        error: (_) => false,
        loading: (_) => false,
      );

  /// Whether this [AsyncValue] is an [AsyncError].
  bool get isError => map(
        data: (_) => false,
        error: (_) => true,
        loading: (_) => false,
      );

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
          return AsyncValue.data(cb(d.value));
        } catch (err, stack) {
          return AsyncValue.error(err, stackTrace: stack);
        }
      },
      error: (e) => AsyncError(e.error, stackTrace: e.stackTrace),
      loading: (l) => AsyncLoading<R>(),
    );
  }

  /// Switch-case over the state of the [AsyncValue] while purposefully not handling
  /// some cases.
  ///
  /// If [AsyncValue] was in a case that is not handled, will return [orElse].
  R maybeWhen<R>({
    R Function(T data)? data,
    R Function(Object error, StackTrace? stackTrace)? error,
    R Function()? loading,
    required R Function() orElse,
  }) {
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
  }

  /// Performs an action based on the state of the [AsyncValue].
  ///
  /// All cases are required, which allows returning a non-nullable value.
  R when<R>({
    required R Function(T data) data,
    required R Function(Object error, StackTrace? stackTrace) error,
    required R Function() loading,
  }) {
    return map(
      data: (d) => data(d.value),
      error: (e) => error(e.error, e.stackTrace),
      loading: (l) => loading(),
    );
  }

  /// Perform actions conditionally based on the state of the [AsyncValue].
  ///
  /// Returns null if [AsyncValue] was in a state that was not handled.
  ///
  /// This is similar to [maybeWhen] where `orElse` returns null.
  R? whenOrNull<R>({
    R Function(T data)? data,
    R Function(Object error, StackTrace? stackTrace)? error,
    R Function()? loading,
  }) {
    return map(
      data: (d) => data?.call(d.value),
      error: (e) => error?.call(e.error, e.stackTrace),
      loading: (l) => loading?.call(),
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
