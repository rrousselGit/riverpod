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
    newState.map(
      loading: (_) {
        final previous = getState();

        if (previous == null) {
          super.setState(AsyncLoading<T>());
          return;
        }

        previous.when(
          data: (value) {
            super.setState(AsyncLoading(previous: AsyncValue<T>.data(value)));
          },
          error: (err, stack) {
            super.setState(
              AsyncLoading(previous: AsyncError<T>(err, stackTrace: stack)),
            );
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
          super.setState(AsyncError<T>(e.error, stackTrace: e.stackTrace));
          return;
        }

        previous.map(
          data: (data) {
            super.setState(
              AsyncError(
                e.error,
                stackTrace: e.stackTrace,
                previous: data,
              ),
            );
          },
          error: (previousErr) {
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
              loading: (l) {
                assert(
                  false,
                  'AyncLoading cannot have an AsyncLoading as previous value',
                );
              },
            );
          },
        );
      },
      data: super.setState,
    );
  }
}
