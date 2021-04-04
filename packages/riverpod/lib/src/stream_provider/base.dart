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
  Stream<T> create(ProviderReference ref) => _create(ref);

  /// {@macro riverpod.family}
  static const family = StreamProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamProviderBuilder();

  AlwaysAliveProviderBase<Stream<T>, Stream<T>>? _stream;
  @override
  AlwaysAliveProviderBase<Stream<T>, Stream<T>> get stream {
    return _stream ??= _CreatedStreamProvider(
      this,
      name: name == null ? null : '$name.stream',
    );
  }

  AlwaysAliveProviderBase<Object?, Future<T>>? _last;
  @override
  AlwaysAliveProviderBase<Object?, Future<T>> get last {
    return _last ??= Provider(
      (ref) => _readLast(ref as ProviderElement, this),
      name: name == null ? null : '$name.last',
    );
  }

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
