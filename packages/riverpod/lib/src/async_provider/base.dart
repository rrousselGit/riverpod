import '../async_value_converters.dart';
import '../common.dart';
import '../framework.dart';

/// An internal provider extended by both StreamProvider and FutureProvider
abstract class AsyncProvider<T> extends AlwaysAliveProviderBase<AsyncValue<T>> {
  /// An internal provider extended by both StreamProvider and FutureProvider
  AsyncProvider({required String? name}) : super(name: name);

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
  }
}
