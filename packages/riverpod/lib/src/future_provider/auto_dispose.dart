part of '../future_provider.dart';

/// {@macro riverpod.futureprovider}
@sealed
class AutoDisposeFutureProvider<T>
    extends AutoDisposeProviderBase<Future<T>, AsyncValue<T>>
    with _FutureProviderMixin<T> {
  /// {@macro riverpod.futureprovider}
  AutoDisposeFutureProvider(
    Create<Future<T>, AsyncValue<T>,
            AutoDisposeProviderReferenceAdvanced<AsyncValue<T>>>
        create, {
    String? name,
  }) : super(create, name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeFutureProviderFamilyBuilder();

  RootProvider<Future<T>, Future<T>>? _future;

  /// {@macro riverpod.futureprovider.future}
  RootProvider<Future<T>, Future<T>> get future {
    return _future ??= AutoDisposeCreatedProvider(
      this,
      name: name == null ? null : '$name.future',
    );
  }

  @override
  _AutoDisposeFutureProviderState<T> createState() =>
      _AutoDisposeFutureProviderState();
}

@sealed
class _AutoDisposeFutureProviderState<T> = ProviderStateBase<Future<T>,
    AsyncValue<T>> with _FutureProviderStateMixin<T>;

/// {@macro riverpod.futureprovider.family}
@sealed
class AutoDisposeFutureProviderFamily<T, A> extends Family<
    Future<T>,
    AsyncValue<T>,
    A,
    AutoDisposeProviderReference<AsyncValue<T>>,
    AutoDisposeFutureProvider<T>> {
  /// {@macro riverpod.futureprovider.family}
  AutoDisposeFutureProviderFamily(
    Future<T> Function(
            AutoDisposeProviderReferenceAdvanced<AsyncValue<T>> ref, A a)
        create, {
    String? name,
  }) : super(
            (ref, a) => create(
                ref as AutoDisposeProviderReferenceAdvanced<AsyncValue<T>>, a),
            name);

  @override
  AutoDisposeFutureProvider<T> create(
    A value,
    Future<T> Function(AutoDisposeProviderReference<AsyncValue<T>> ref, A param)
        builder,
    String? name,
  ) {
    return AutoDisposeFutureProvider((ref) => builder(ref, value), name: name);
  }
}
