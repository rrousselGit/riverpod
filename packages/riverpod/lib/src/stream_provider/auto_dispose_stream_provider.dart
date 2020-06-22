part of 'stream_provider.dart';

/// Creates a stream and expose its latest event.
///
/// Consumers of [AutoDisposeStreamProvider] will receive an [AsyncValue] instead of the
/// raw value emitted.
/// This is so that dependents can handle loading/error states.
class AutoDisposeStreamProvider<T> extends AutoDisposeProviderBase<
    StreamProviderDependency<T>, AsyncValue<T>> {
  /// Creates a [AutoDisposeStreamProvider] and allows specifying a [name].
  AutoDisposeStreamProvider(this._create, {String name}) : super(name);

  final Create<Stream<T>, AutoDisposeProviderReference> _create;

  @override
  _AutoDisposeStreamProviderState<T> createState() {
    return _AutoDisposeStreamProviderState<T>();
  }

// TODO overrideAs + support back to loading
}

class _AutoDisposeStreamProviderState<T> extends AutoDisposeProviderStateBase<
        StreamProviderDependency<T>,
        AsyncValue<T>,
        AutoDisposeStreamProvider<T>>
    with
        _State<T, AutoDisposeStreamProvider<T>>,
        _StreamProviderStateMixin<T, AutoDisposeStreamProvider<T>> {
  @override
  Stream<T> create() {
    // ignore: invalid_use_of_visible_for_testing_member
    return provider._create(AutoDisposeProviderReference(this));
  }
}

/// Creates a [AutoDisposeStreamProvider] from external parameters.
///
/// See also:
/// - [ProviderFamily], which contains an explanation of what a *Family is.
class AutoDisposeStreamProviderFamily<Result, A>
    extends Family<AutoDisposeStreamProvider<Result>, A> {
  /// Creates a [AutoDisposeStreamProvider] from external parameters.
  AutoDisposeStreamProviderFamily(
      Stream<Result> Function(AutoDisposeProviderReference ref, A a) create)
      : super((a) => AutoDisposeStreamProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
    Stream<Result> Function(AutoDisposeProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) =>
          AutoDisposeStreamProvider<Result>((ref) => override(ref, value as A)),
    );
  }
}
