part of '../stream_provider.dart';

/// {@macro riverpod.streamprovider}
class StreamProvider<T>
    extends AlwaysAliveProviderBase<Stream<T>, AsyncValue<T>>
    with _StreamProviderMixin<T> {
  /// {@macro riverpod.streamprovider}
  StreamProvider(
    Create<Stream<T>, ProviderReference> create, {
    String name,
  }) : super((ref) => create(ref).asBroadcastStream(), name);

  /// {@macro riverpod.family}
  static const family = StreamProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamProviderBuilder();

  AlwaysAliveProviderBase<Stream<T>, Stream<T>> _stream;
  AlwaysAliveProviderBase<Stream<T>, Stream<T>> get stream {
    return _stream ??= CreatedProvider(
      this,
      name: name == null ? null : '$name.stream',
    );
  }

  // AlwaysAliveProviderBase<Object, Future<T>> _last;
  // AlwaysAliveProviderBase<Object, Future<T>> get last {
  //   return _last ??= _LastValueProvider(
  //     this,
  //     name: name == null ? null : '$name.last',
  //   );
  // }

  @override
  _StreamProviderState<T> createState() => _StreamProviderState();
}

class _StreamProviderState<T> = ProviderStateBase<Stream<T>, AsyncValue<T>>
    with _StreamProviderStateMixin<T>;

class StreamProviderFamily<T, A> extends Family<Stream<T>, AsyncValue<T>, A,
    ProviderReference, StreamProvider<T>> {
  StreamProviderFamily(
    Stream<T> Function(ProviderReference ref, A a) create, {
    String name,
  }) : super(create, name);

  @override
  StreamProvider<T> create(
    A value,
    Stream<T> Function(ProviderReference ref, A param) builder,
  ) {
    return StreamProvider((ref) => builder(ref, value), name: name);
  }
}
