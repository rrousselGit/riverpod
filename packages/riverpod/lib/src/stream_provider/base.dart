part of '../stream_provider.dart';

/// {@macro riverpod.streamprovider}
class StreamProvider<T>
    extends AlwaysAliveProviderBase<Stream<T>, AsyncValue<T>> {
  /// {@macro riverpod.streamprovider}
  StreamProvider(
    Create<Stream<T>, ProviderReference> create, {
    String name,
  }) : super(create, name);

  /// {@macro riverpod.family}
  static const family = StreamProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamProviderBuilder();

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
