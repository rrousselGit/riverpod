import 'common.dart';
import 'framework/framework.dart';

/// The state to a [Provider].
abstract class ProviderDependency<T> extends ProviderDependencyBase {
  /// The value exposed by [Provider].
  ///
  /// It is guaranteed to never change.
  T get value;
}

class ProviderDependencyImpl<T> implements ProviderDependency<T> {
  ProviderDependencyImpl(this.value);

  @override
  final T value;
}

/// A provider that exposes a read-only value.

// TODO What is a provider (testable, overridable, listenable)
// TODO how to read a provider (Flutter)
// TODO how to test a provider
class Provider<T> extends AlwaysAliveProvider<ProviderDependency<T>, T> {
  Provider(this._create, {String name}) : super(name);

  final Create<T, ProviderReference> _create;

  @override
  ProviderState<T> createState() => ProviderState();
}

class ProviderState<T>
    extends ProviderStateBase<ProviderDependency<T>, T, Provider<T>> {
  @override
  T state;

  @override
  void initState() {
    state = provider._create(ProviderReference(this));
  }

  @override
  ProviderDependency<T> createProviderDependency() {
    return ProviderDependencyImpl(state);
  }
}

class ProviderFamily<Result, A> extends Family<Provider<Result>, A> {
  ProviderFamily(Result Function(ProviderReference ref, A a) create)
      : super((a) => Provider((ref) => create(ref, a)));

  FamilyOverride overrideAs(
    Result Function(ProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) => Provider<Result>((ref) => override(ref, value as A)),
    );
  }
}
