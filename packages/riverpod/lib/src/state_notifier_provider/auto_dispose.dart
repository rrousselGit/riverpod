part of '../state_notifier_provider.dart';

class _AutoDisposeNotifierProvider<Notifier extends StateNotifier<Object?>>
    extends AutoDisposeProvider<Notifier> {
  _AutoDisposeNotifierProvider(
    Create<Notifier, AutoDisposeProviderReference> create, {
    required String? name,
  }) : super(
          (ref) {
            final notifier = create(ref);
            ref.onDispose(notifier.dispose);
            return notifier;
          },
          name: name == null ? null : '$name.notifier',
        );
}

/// {@macro riverpod.statenotifierprovider}
@sealed
class AutoDisposeStateNotifierProvider<Notifier extends StateNotifier<Value>,
        Value> extends AutoDisposeProviderBase<Notifier, Value>
    with _StateNotifierProviderMixin<Notifier, Value> {
  /// {@macro riverpod.statenotifierprovider}
  AutoDisposeStateNotifierProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  final Create<Notifier, AutoDisposeProviderReference> _create;

  @override
  AutoDisposeStateNotifierProviderFamily<Notifier, Value, Object?>? get from =>
      super.from
          as AutoDisposeStateNotifierProviderFamily<Notifier, Value, Object?>?;

  /// {@macro riverpod.statenotifierprovider.notifier}
  @override
  late final AutoDisposeProviderBase<Notifier, Notifier> notifier = from != null
      ? from!._notifierFamily(argument)
      : _AutoDisposeNotifierProvider(_create, name: name);

  /// Overrides the behavior of a provider with a another provider.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    AutoDisposeStateNotifierProvider<Notifier, Value> provider,
  ) {
    return ProviderOverride(provider.notifier, notifier);
  }

  @override
  Notifier create(covariant AutoDisposeProviderReference ref) {
    return ref.watch(notifier);
  }

  @override
  _StateNotifierProviderState<Notifier, Value> createState() {
    return _StateNotifierProviderState<Notifier, Value>();
  }
}

/// {@template riverpod.statenotifierprovider.family}
/// A class that allows building a [StateNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class AutoDisposeStateNotifierProviderFamily<
        Notifier extends StateNotifier<Value>, Value, Param>
    extends Family<Notifier, Value, Param, AutoDisposeProviderReference,
        AutoDisposeStateNotifierProvider<Notifier, Value>> {
  /// {@macro riverpod.statenotifierprovider.family}
  AutoDisposeStateNotifierProviderFamily(
    Notifier Function(AutoDisposeProviderReference ref, Param a) create, {
    String? name,
  }) : super(create, name);

  @override
  AutoDisposeStateNotifierProvider<Notifier, Value> create(
    Param value,
    Notifier Function(AutoDisposeProviderReference ref, Param param) builder,
    String? name,
  ) {
    return AutoDisposeStateNotifierProvider(
      (ref) => builder(ref, value),
      name: name,
    );
  }

  late final _notifierFamily =
      _AutoDisposeNotifierFamily<Notifier, Param>(builder, name);

  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    Notifier Function(ProviderReference ref, Param param) builderOverride,
  ) {
    return FamilyOverride(
      _notifierFamily,
      (param) {
        return _notifierFamily.create(param as Param, builderOverride, null);
      },
    );
  }
}

@sealed
class _AutoDisposeNotifierFamily<Notifier extends StateNotifier<Object?>, Param>
    extends Family<Notifier, Notifier, Param, AutoDisposeProviderReference,
        _AutoDisposeNotifierProvider<Notifier>> {
  _AutoDisposeNotifierFamily(
    Notifier Function(AutoDisposeProviderReference ref, Param param) builder,
    String? name,
  ) : super(builder, name);

  @override
  _AutoDisposeNotifierProvider<Notifier> create(
    Param value,
    Notifier Function(AutoDisposeProviderReference ref, Param param) builder,
    String? name,
  ) {
    return _AutoDisposeNotifierProvider(
      (ref) => builder(ref, value),
      name: name,
    );
  }
}
