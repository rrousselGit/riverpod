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
    newState.maybeWhen(
      loading: (_) {
        getState().when(
          loading: (_) {
            super.setState(AsyncLoading<T>());
          },
          error: (_, __) {
            // TODO
          },
          data: (previous) {
            previous.maybeMap(
              loading: (_) {
                // TODO test does not notify listeners
                // preserve the previous value, nothing to do
              },
              orElse: () {
                super.setState(AsyncLoading(previous: previous));
              },
            );
          },
        );
      },
      orElse: () {
        super.setState(newState);
      },
    );
  }
}
