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
