import 'common.dart';
import 'framework/framework.dart';

/// The subscription to a [Provider].
class ProviderSubscription<T> extends ProviderSubscriptionBase {
  ProviderSubscription._(this.value);

  /// The value exposed by [Provider].
  /// It is guaranteed to never change.
  final T value;
}

/// A provider that exposes a read-only value.

// TODO What is a provider (testable, overridable, listenable)
// TODO how to read a provider (Flutter)
// TODO how to test a provider 
class Provider<T> extends AlwaysAliveProvider<ProviderSubscription<T>, T> {
  Provider(this._create, {String name}) : super(name);

  final Create<T, ProviderReference> _create;

  @override
  _ProviderState<T> createState() => _ProviderState();
}

class _ProviderState<T>
    extends ProviderStateBase<ProviderSubscription<T>, T, Provider<T>> {
  @override
  T state;

  @override
  void initState() {
    state = provider._create(ProviderReference(this));
  }

  @override
  ProviderSubscription<T> createProviderSubscription() {
    return ProviderSubscription._(state);
  }
}
