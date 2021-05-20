part of '../stream_provider.dart';

/// {@macro riverpod.streamprovider}
@sealed
class StreamProvider<T>
    extends AlwaysAliveProviderBase<Stream<T>, AsyncValue<T>>
    with
        ProviderOverridesMixin<Stream<T>, AsyncValue<T>>,
        _StreamProviderMixin<T> {
  /// {@macro riverpod.streamprovider}
  StreamProvider(this._create, {String? name}) : super(name);

  final Create<Stream<T>, ProviderReference> _create;

  @override
  Stream<T> create(ProviderReference ref) => ref.watch(stream);

  /// {@macro riverpod.family}
  static const family = StreamProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamProviderBuilder();

  @override
  late final AlwaysAliveProviderBase<Object?, Stream<T>> stream =
      Provider((ref) {
    // TODO(rrousselGit) test that refresh works
    return _createStream(ref, () => _create(ref));
  });

  @override
  late final RootProvider<Object?, Future<T>> last =
      _LastStreamValueProvider(this);

  @override
  _StreamProviderState<T> createState() => _StreamProviderState();
}

@sealed
class _StreamProviderState<T> = ProviderStateBase<Stream<T>, AsyncValue<T>>
    with _StreamProviderStateMixin<T>;

/// {@template riverpod.streamprovider.family}
/// A class that allows building a [StreamProvider] from an external parameter.
/// {@endtemplate}
@sealed
class StreamProviderFamily<T, A> extends Family<Stream<T>, AsyncValue<T>, A,
    ProviderReference, StreamProvider<T>> {
  /// {@macro riverpod.streamprovider.family}
  StreamProviderFamily(
    Stream<T> Function(ProviderReference ref, A a) create, {
    String? name,
  }) : super(create, name);

  @override
  StreamProvider<T> create(
    A value,
    Stream<T> Function(ProviderReference ref, A param) builder,
    String? name,
  ) {
    return StreamProvider((ref) => builder(ref, value), name: name);
  }
}
