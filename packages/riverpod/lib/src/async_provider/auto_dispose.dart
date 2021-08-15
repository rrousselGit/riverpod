import '../common.dart';
import '../framework.dart';

abstract class AutoDisposeAsyncProvider<T>
    extends AutoDisposeProviderBase<AsyncValue<T>> {
  AutoDisposeAsyncProvider(String? name) : super(name);

  @override
  AutoDisposeAsyncProviderElement<T> createElement();
}

class AutoDisposeAsyncProviderElement<T>
    extends AutoDisposeProviderElementBase<AsyncValue<T>> {
  AutoDisposeAsyncProviderElement(AutoDisposeAsyncProvider<T> provider)
      : super(provider);

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
