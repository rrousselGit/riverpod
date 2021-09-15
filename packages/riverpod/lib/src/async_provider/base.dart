import '../common.dart';
import '../framework.dart';

/// An internal provider extended by both StreamProvider and FutureProvider
abstract class AsyncProvider<T> extends AlwaysAliveProviderBase<AsyncValue<T>> {
  /// An internal provider extended by both StreamProvider and FutureProvider
  AsyncProvider(String? name) : super(name);

  @override
  AsyncProviderElement<T> createElement();
}

/// The Element of [AsyncProvider]
class AsyncProviderElement<T> extends ProviderElementBase<AsyncValue<T>> {
  /// The Element of [AsyncProvider]
  AsyncProviderElement(AsyncProvider<T> provider) : super(provider);

  @override
  void setState(AsyncValue<T> newState) {
    getState().map(
      error: (error) {
        // the provider threw during state creation
        // never reached since the error is caught and sent as "data" with AsyncError
      },
      loading: (loading) {
        // the very first time a provider is initialized – no previous state
        super.setState(newState);
      },
      data: (data) {
        // a provider rebuilt
        super.setState(data.value.next(newState));
      },
    );

    // newState.map(
    //   loading: (_) {
    //     getState().when(
    //       loading: (_) {
    //         super.setState(AsyncLoading<T>());
    //       },
    //       error: (_, __, ___) {
    //         // TODO
    //       },
    //       data: (previous) {
    //         previous.maybeMap(
    //           loading: (_) {
    //             // TODO test does not notify listeners
    //             // preserve the previous value, nothing to do
    //           },
    //           orElse: () {
    //             super.setState(AsyncLoading(previous: previous));
    //           },
    //         );
    //       },
    //     );
    //   },
    //   error: (e) {
    //     final previous = getState();

    //     if (previous == null) {
    //       // Reached when FutureOr<T> throws, bypassing AsyncLoading
    //       super.setState(AsyncError<T>(e.error, stackTrace: e.stackTrace));
    //       return;
    //     }

    //     previous.map(
    //       data: (data) {
    //         // Reached when FutureOr<T> returns T, bypassing AsyncLoading
    //         super.setState(
    //           AsyncError(
    //             e.error,
    //             stackTrace: e.stackTrace,
    //             previous: data,
    //           ),
    //         );
    //       },
    //       error: (previousErr) {
    //         // Reached when FutureOr<T> throws, bypassing AsyncLoading
    //         super.setState(
    //           AsyncError(
    //             e.error,
    //             stackTrace: e.stackTrace,
    //             previous: previousErr.previous,
    //           ),
    //         );
    //       },
    //       loading: (l) {
    //         if (l.previous == null) {
    //           super.setState(AsyncError<T>(e.error, stackTrace: e.stackTrace));
    //           return;
    //         }

    //         l.previous!.map(
    //           data: (l) {
    //             super.setState(
    //               AsyncError<T>(
    //                 e.error,
    //                 stackTrace: e.stackTrace,
    //                 previous: l,
    //               ),
    //             );
    //           },
    //           error: (l) {
    //             super.setState(
    //               AsyncError<T>(
    //                 e.error,
    //                 stackTrace: e.stackTrace,
    //                 previous: l.previous,
    //               ),
    //             );
    //           },
    //           // coverage:ignore-start
    //           loading: (l) {
    //             assert(
    //               false,
    //               'AyncLoading cannot have an AsyncLoading as previous value',
    //             );
    //           },
    //           // coverage:ignore-end
    //         );
    //       },
    //     );
    //   },
    //   data: super.setState,
    // );
  }
}

extension<T> on AsyncValue<T> {
  AsyncValue<T> next(AsyncValue<T> nextState) {
    return nextState.map(
      data: (data) => data,
      error: (error) {
        assert(
          error.previous == null,
          'Bad state, expected AsyncError to have no previous state',
        );

        return AsyncError(
          error.error,
          stackTrace: error.stackTrace,
          previous: previousAsyncData,
        );
      },
      loading: (loading) {
        assert(
          loading.previous == null,
          'Bad state, expected AsyncLoading to have no previous state',
        );

        return AsyncLoading(previous: lastNonLoadingState);
      },
    );
  }

  AsyncValue<T>? get lastNonLoadingState {
    return map(
      data: (data) => data,
      error: (error) => error,
      loading: (loading) => loading.previous,
    );
  }

  AsyncData<T>? get previousAsyncData {
    return map(
      data: (data) => data,
      error: (error) => error.previous,
      loading: (loading) {
        return loading.previous?.previousAsyncData;
      },
    );
  }
}
