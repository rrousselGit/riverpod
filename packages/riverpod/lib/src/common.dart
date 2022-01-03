import 'package:meta/meta.dart';

import 'future_provider.dart' show FutureProvider;
import 'stream_provider.dart' show StreamProvider;

/// Utility for `.name` of provider modifiers.
String? modifierName(String? from, String modifier) {
  return from == null ? null : '$from.$modifier';
}

/// An utility for safely manipulating asynchronous data.
///
/// By using [AsyncValue], you are guaranteed that you cannot forget to
/// handle the loading/error state of an asynchronous operation.
///
/// It also expose some utilities to nicely convert an [AsyncValue] to
/// a different object.
/// For example, a Flutter Widget may use [when] to convert an [AsyncValue]
/// into either a progress indicator, an error screen, or to show the data:
///
/// ```dart
/// /// A provider that asynchronously expose the current user
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
  const factory AsyncValue.data(T value, {bool isRefreshing}) = AsyncData<T>;
  // coverage:ignore-end

  /// Creates an [AsyncValue] in loading state.
  ///
  /// Prefer always using this constructor with the `const` keyword.
  // coverage:ignore-start
  const factory AsyncValue.loading() = AsyncLoading<T>;
  // coverage:ignore-end

  /// Creates an [AsyncValue] in error state.
  ///
  /// The parameter [error] cannot be `null`.
  // coverage:ignore-start
  const factory AsyncValue.error(
    Object error, {
    StackTrace? stackTrace,
    bool isRefreshing,
  }) = AsyncError<T>;
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

  // private mapper, so thast classes inheriting AsyncValue can specify their own
  // `map` method with different parameters.
  R _map<R>({
    required R Function(AsyncData<T> data) data,
    required R Function(AsyncError<T> error) error,
    required R Function(AsyncLoading<T> loading) loading,
  });

  /// Whether the provider assiciated with this [AsyncValue] is currently rebuilding.
  ///
  /// This is different from [isLoading] in that [isLoading] is for waiting
  /// the first value to be available, while [isRefreshing] is after a value
  /// was emitted but a provider refresh was triggered.
  bool get isRefreshing;

  AsyncValue<T> _asRefreshing() {
    return map(
      data: (data) => AsyncData(data.value, isRefreshing: true),
      error: (err) =>
          AsyncError(err.error, stackTrace: err.stackTrace, isRefreshing: true),
      loading: (l) => l,
    );
  }
}

/// Creates an [AsyncValue] with a data.
///
/// The data can be `null`.
class AsyncData<T> extends AsyncValue<T> {
  /// Creates an [AsyncValue] with a data.
  ///
  /// The data can be `null`.
  const AsyncData(this.value, {this.isRefreshing = false}) : super._();

  /// The value currently exposed.
  final T value;

  @override
  final bool isRefreshing;

  @override
  R _map<R>({
    required R Function(AsyncData<T> data) data,
    required R Function(AsyncError<T> error) error,
    required R Function(AsyncLoading<T> loading) loading,
  }) {
    return data(this);
  }

  @override
  String toString() {
    final content = [
      'value: $value',
      if (isRefreshing) 'isRefreshing: true',
    ].join(', ');

    return 'AsyncData<$T>($content)';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType &&
        other is AsyncData<T> &&
        other.isRefreshing == isRefreshing &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, value, isRefreshing);
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
  bool get isRefreshing => false;

  @override
  R _map<R>({
    required R Function(AsyncData<T> data) data,
    required R Function(AsyncError<T> error) error,
    required R Function(AsyncLoading<T> loading) loading,
  }) {
    return loading(this);
  }

  @override
  String toString() {
    return 'AsyncLoading<$T>()';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Creates an [AsyncValue] in error state.
///
/// The parameter [error] cannot be `null`.
class AsyncError<T> extends AsyncValue<T> {
  /// Creates an [AsyncValue] in error state.
  ///
  /// The parameter [error] cannot be `null`.
  const AsyncError(this.error, {this.stackTrace, this.isRefreshing = false})
      : super._();

  /// The error.
  final Object error;

  /// The stacktrace of [error].
  final StackTrace? stackTrace;

  @override
  final bool isRefreshing;

  @override
  R _map<R>({
    required R Function(AsyncData<T> data) data,
    required R Function(AsyncError<T> error) error,
    required R Function(AsyncLoading<T> loading) loading,
  }) {
    return error(this);
  }

  @override
  String toString() {
    final content = [
      'error: $error',
      'stackTrace: $stackTrace',
      if (isRefreshing) 'isRefreshing: true',
    ].join(', ');

    return 'AsyncError<$T>($content)';
  }

  @override
  bool operator ==(Object other) {
    return runtimeType == other.runtimeType &&
        other is AsyncError<T> &&
        other.error == error &&
        other.isRefreshing == isRefreshing &&
        other.stackTrace == stackTrace;
  }

  @override
  int get hashCode => Object.hash(runtimeType, error, stackTrace, isRefreshing);
}

/// An extension that adds methods like [when] to an [AsyncValue].
extension AsyncValueX<T> on AsyncValue<T> {
  /// Upcast [AsyncValue] into an [AsyncData], or return null if the [AsyncValue]
  /// is in loading/error state.
  @Deprecated('use `asData` instead')
  AsyncData<T>? get data => asData;

  /// Upcast [AsyncValue] into an [AsyncData], or return null if the [AsyncValue]
  /// is in loading/error state.
  AsyncData<T>? get asData {
    return _map(
      data: (d) => d,
      error: (e) => null,
      loading: (l) => null,
    );
  }

  /// Attempts to synchronously.
  ///
  /// On error, this will rethrow the error.
  /// If loading, will return `null`.
  /// Otherwise will return the data.
  T? get value {
    return _map(
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
    return _map(
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
    return _map(
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
    return _map(
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
    return _map(
      data: (d) => data?.call(d.value),
      error: (e) => error?.call(e.error, e.stackTrace),
      loading: (l) => loading?.call(),
    );
  }

  /// Perform some action based on the current state of the [AsyncValue].
  ///
  /// This allows reading the content of an [AsyncValue] in a type-safe way,
  /// without potentially ignoring to handle a case.
  R map<R>({
    required R Function(AsyncData<T> data) data,
    required R Function(AsyncError<T> error) error,
    required R Function(AsyncLoading<T> loading) loading,
  }) {
    return _map(data: data, error: error, loading: loading);
  }

  /// Perform some actions based on the state of the [AsyncValue], or call orElse
  /// if the current state was not tested.
  R maybeMap<R>({
    R Function(AsyncData<T> data)? data,
    R Function(AsyncError<T> error)? error,
    R Function(AsyncLoading<T> loading)? loading,
    required R Function() orElse,
  }) {
    return _map(
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
    return _map(
      data: (d) => data?.call(d),
      error: (d) => error?.call(d),
      loading: (d) => loading?.call(d),
    );
  }
}

// ignore: public_member_api_docs
extension InternalAsyncValueX on AsyncValue {
  // ignore: public_member_api_docs
  AsyncValue<Object?> asRefreshing() => _asRefreshing();
}
