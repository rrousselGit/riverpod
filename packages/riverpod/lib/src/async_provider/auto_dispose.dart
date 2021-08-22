import '../common.dart';
import '../framework.dart';

/// An internal provider extended by both StreamProvider and FutureProvider
abstract class AutoDisposeAsyncProvider<T>
    extends AutoDisposeProviderBase<AsyncValue<T>> {
  /// An internal provider extended by both StreamProvider and FutureProvider
  AutoDisposeAsyncProvider(String? name) : super(name);

  @override
  AutoDisposeAsyncProviderElement<T> createElement();
}

/// The Element of [AutoDisposeAsyncProvider]
class AutoDisposeAsyncProviderElement<T>
    extends AutoDisposeProviderElementBase<AsyncValue<T>> {
  /// The Element of [AutoDisposeAsyncProvider]
  AutoDisposeAsyncProviderElement(AutoDisposeAsyncProvider<T> provider)
      : super(provider);

  @override
  void setState(AsyncValue<T> newState) {
    newState.map(
      loading: (_) {
        final previous = getState();

        if (previous == null) {
          super.setState(AsyncLoading<T>());
          return;
        }

        previous.maybeMap(
          orElse: () {
            super.setState(AsyncLoading<T>(previous: previous));
          },
          loading: (_) {
            // TODO test does not notify listeners
            // preserve the previous value, nothing to do
          },
        );
      },
      error: (e) {
        final previous = getState();

        if (previous == null) {
          // Reached when FutureOr<T> throws, bypassing AsyncLoading
          super.setState(AsyncError<T>(e.error, stackTrace: e.stackTrace));
          return;
        }

        previous.map(
          data: (data) {
            // Reached when FutureOr<T> returns T, bypassing AsyncLoading
            super.setState(
              AsyncError(
                e.error,
                stackTrace: e.stackTrace,
                previous: data,
              ),
            );
          },
          error: (previousErr) {
            // Reached when FutureOr<T> throws, bypassing AsyncLoading
            super.setState(
              AsyncError(
                e.error,
                stackTrace: e.stackTrace,
                previous: previousErr.previous,
              ),
            );
          },
          loading: (l) {
            if (l.previous == null) {
              super.setState(AsyncError<T>(e.error, stackTrace: e.stackTrace));
              return;
            }

            l.previous!.map(
              data: (l) {
                super.setState(
                  AsyncError<T>(
                    e.error,
                    stackTrace: e.stackTrace,
                    previous: l,
                  ),
                );
              },
              error: (l) {
                super.setState(
                  AsyncError<T>(
                    e.error,
                    stackTrace: e.stackTrace,
                    previous: l.previous,
                  ),
                );
              },
              // coverage:ignore-start
              loading: (l) {
                assert(
                  false,
                  'AyncLoading cannot have an AsyncLoading as previous value',
                );
              },
              // coverage:ignore-end
            );
          },
        );
      },
      data: super.setState,
    );
  }
}
