part of 'future_provider.dart';

/// A provider that asynchronously creates an immutable value.
///
/// See also:
///
/// - [Provider], a provider that synchronously creates an immutable value
/// - [StreamProvider], a provider that asynchronously expose a value which can change over time.
class AutoDisposeFutureProvider<Res> extends AutoDisposeProviderBase<
    FutureProviderDependency<Res>, AsyncValue<Res>> {
  /// Creates a [FutureProvider] and allows specifying a [name].
  AutoDisposeFutureProvider(this._create, {String name}) : super(name);

  final Create<Future<Res>, ProviderReference> _create;

  @override
  _AutoDisposeFutureProviderState<Res> createState() {
    return _AutoDisposeFutureProviderState<Res>();
  }

// TODO overrideAs + support back to loading
}

class _AutoDisposeFutureProviderState<Res> extends AutoDisposeProviderStateBase<
        FutureProviderDependency<Res>,
        AsyncValue<Res>,
        AutoDisposeFutureProvider<Res>>
    with _FutureProviderStateMixin<Res, AutoDisposeFutureProvider<Res>> {
  @override
  Future<Res> create() {
    return provider._create(ProviderReference(this));
  }
}

/// Creates a [FutureProvider] from external parameters.
///
/// See also:
///
/// - [ProviderFamily], which contains an explanation of what a *Family is.
class AutoDisposeFutureProviderFamily<Result, A>
    extends Family<AutoDisposeFutureProvider<Result>, A> {
  /// Creates a [AutoDisposeFutureProvider] from external parameters.
  AutoDisposeFutureProviderFamily(
      Future<Result> Function(ProviderReference ref, A a) create)
      : super((a) => AutoDisposeFutureProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
    Future<Result> Function(ProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) =>
          AutoDisposeFutureProvider<Result>((ref) => override(ref, value as A)),
    );
  }
}
