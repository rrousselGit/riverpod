part of '../stream_provider.dart';

/// {@macro riverpod.streamprovider}
class AutoDisposeStreamProvider<T>
    extends AutoDisposeProviderBase<Stream<T>, AsyncValue<T>> {
  /// {@macro riverpod.streamprovider}
  AutoDisposeStreamProvider(
    Create<Stream<T>, AutoDisposeProviderReference> create, {
    String name,
  }) : super(create, name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStreamProviderFamilyBuilder();

  ProviderBase<Stream<T>, Stream<T>> _stream;
  ProviderBase<Stream<T>, Stream<T>> get stream {
    return _stream ??= AutoDisposeCreatedProvider(
      this,
      name: name == null ? null : '$name.stream',
    );
  }

  @override
  _AutoDisposeStreamProviderState<T> createState() =>
      _AutoDisposeStreamProviderState();
}

class _AutoDisposeStreamProviderState<T> = ProviderStateBase<Stream<T>,
    AsyncValue<T>> with _StreamProviderStateMixin<T>;

class AutoDisposeStreamProviderFamily<T, A> extends Family<
    Stream<T>,
    AsyncValue<T>,
    A,
    AutoDisposeProviderReference,
    AutoDisposeStreamProvider<T>> {
  AutoDisposeStreamProviderFamily(
    Stream<T> Function(AutoDisposeProviderReference ref, A a) create, {
    String name,
  }) : super(create, name);

  @override
  AutoDisposeStreamProvider<T> create(
    A value,
    Stream<T> Function(AutoDisposeProviderReference ref, A param) builder,
  ) {
    return AutoDisposeStreamProvider((ref) => builder(ref, value), name: name);
  }
}
