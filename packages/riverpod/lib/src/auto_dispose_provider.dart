import 'common.dart';
import 'framework/framework.dart';

/// The state to a [Provider].
abstract class AutoDisposeProviderDependency<T> extends ProviderDependencyBase {
  /// The value exposed by [Provider].
  ///
  /// It is guaranteed to never change.
  T get value;
}

// ignore: public_member_api_docs
class AutoDisposeProviderDependencyImpl<T>
    implements AutoDisposeProviderDependency<T> {
  // ignore: public_member_api_docs
  AutoDisposeProviderDependencyImpl(this.value);

  @override
  final T value;
}

/// A AutoDisposeprovider that exposes a read-only value.
// TODO doc
class AutoDisposeProvider<T>
    extends AlwaysAliveProviderBase<AutoDisposeProviderDependency<T>, T> {
  /// Creates an immutable value.
  AutoDisposeProvider(this._create, {String name}) : super(name);

  final Create<T, ProviderReference> _create;

  @override
  AutoDisposeProviderState<T> createState() => AutoDisposeProviderState();
}

/// The internal state of a [Provider].
class AutoDisposeProviderState<T> extends AutoDisposeProviderStateBase<
    AutoDisposeProviderDependency<T>, T, AutoDisposeProvider<T>> {
  @override
  T state;

  @override
  void initState() {
    state = provider._create(ProviderReference(this));
  }

  @override
  AutoDisposeProviderDependency<T> createProviderDependency() {
    return AutoDisposeProviderDependencyImpl(state);
  }
}
