import '../common.dart';
import '../framework.dart';
import '../provider.dart';

abstract class AsyncProvider<T> extends AlwaysAliveProviderBase<AsyncValue<T>> {
  AsyncProvider(String? name) : super(name);

  @override
  AsyncProviderElement<T> createElement();
}

class AsyncProviderElement<T> extends ProviderElementBase<AsyncValue<T>> {
  AsyncProviderElement(AsyncProvider<T> provider) : super(provider);

  @override
  void setState(AsyncValue<T> newState) {
    newState.maybeWhen(
      loading: (_) {
        final previous = getState();

        if (previous == null) {
          super.setState(AsyncLoading<T>());
          return;
        }

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
      orElse: () {
        super.setState(newState);
      },
    );
  }
}
