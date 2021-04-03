part of '../stream_provider.dart';

/// {@macro riverpod.streamprovider}
@sealed
class AutoDisposeStreamProvider<T>
    extends AutoDisposeProviderBase<Stream<T>, AsyncValue<T>>
    with
        AutoDisposeProviderOverridesMixin<Stream<T>, AsyncValue<T>>,
        _StreamProviderMixin<T> {
  /// {@macro riverpod.streamprovider}
  AutoDisposeStreamProvider(this._create, {String? name}) : super(name);

  final Create<Stream<T>, AutoDisposeProviderReference> _create;

  @override
  Stream<T> create(covariant AutoDisposeProviderReference ref) => _create(ref);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStreamProviderFamilyBuilder();

  AutoDisposeProviderBase<Stream<T>, Stream<T>>? _stream;
  @override
  AutoDisposeProviderBase<Stream<T>, Stream<T>> get stream {
    return _stream ??= _AutoDisposeCreatedStreamProvider(
      this,
      name: name == null ? null : '$name.stream',
    );
  }

  AutoDisposeProviderBase<Object?, Future<T>>? _last;
  @override
  AutoDisposeProviderBase<Object?, Future<T>> get last {
    return _last ??= Provider.autoDispose(
      (ref) => _readLast(ref as ProviderElement, this),
      name: name == null ? null : '$name.last',
    );
  }

  @override
  _AutoDisposeStreamProviderState<T> createState() =>
      _AutoDisposeStreamProviderState();
}

@sealed
class _AutoDisposeStreamProviderState<T> = ProviderStateBase<Stream<T>,
    AsyncValue<T>> with _StreamProviderStateMixin<T>;

/// {@macro riverpod.streamprovider.family}
@sealed
class AutoDisposeStreamProviderFamily<T, A> extends Family<
    Stream<T>,
    AsyncValue<T>,
    A,
    AutoDisposeProviderReference,
    AutoDisposeStreamProvider<T>> {
  /// {@macro riverpod.streamprovider.family}
  AutoDisposeStreamProviderFamily(
    Stream<T> Function(AutoDisposeProviderReference ref, A a) create, {
    String? name,
  }) : super(create, name);

  @override
  AutoDisposeStreamProvider<T> create(
    A value,
    Stream<T> Function(AutoDisposeProviderReference ref, A param) builder,
    String? name,
  ) {
    return AutoDisposeStreamProvider((ref) => builder(ref, value), name: name);
  }
}
