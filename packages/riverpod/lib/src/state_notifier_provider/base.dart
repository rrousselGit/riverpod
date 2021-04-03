part of '../state_notifier_provider.dart';

class _NotifierProvider<Notifier extends StateNotifier<Object?>>
    extends Provider<Notifier> {
  _NotifierProvider(
    Create<Notifier, ProviderReference> create, {
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
class StateNotifierProvider<Notifier extends StateNotifier<Value>, Value>
    extends AlwaysAliveProviderBase<Notifier, Value>
    with _StateNotifierProviderMixin<Notifier, Value> {
  /// {@macro riverpod.statenotifierprovider}
  StateNotifierProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = StateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  final Create<Notifier, ProviderReference> _create;

  @override
  StateNotifierProviderFamily<Notifier, Value, Object?>? get from =>
      super.from as StateNotifierProviderFamily<Notifier, Value, Object?>?;

  /// {@template riverpod.statenotifierprovider.notifier}
  /// Obtains the [StateNotifier] associated with this [StateNotifierProvider],
  /// without listening to it.
  ///
  /// Listening to this provider may cause providers/widgets to rebuild in the
  /// event that the [StateNotifier] it recreated.
  /// {@endtemplate}
  @override
  late final AlwaysAliveProviderBase<Notifier, Notifier> notifier = from != null
      ? from!._notifierFamily(argument)
      : _NotifierProvider(_create, name: name);

  /// Overrides the behavior of a provider with a another provider.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    StateNotifierProvider<Notifier, Value> provider,
  ) {
    return ProviderOverride(provider.notifier, notifier);
  }

  @override
  Notifier create(ProviderReference ref) => ref.watch(notifier);

  @override
  _StateNotifierProviderState<Notifier, Value> createState() {
    return _StateNotifierProviderState<Notifier, Value>();
  }
}

/// {@template riverpod.statenotifierprovider.family}
/// A class that allows building a [StateNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class StateNotifierProviderFamily<Notifier extends StateNotifier<Value>, Value,
        Param>
    extends Family<Notifier, Value, Param, ProviderReference,
        StateNotifierProvider<Notifier, Value>> {
  /// {@macro riverpod.statenotifierprovider.family}
  StateNotifierProviderFamily(
    Notifier Function(ProviderReference ref, Param a) create, {
    String? name,
  }) : super(create, name);

  @override
  StateNotifierProvider<Notifier, Value> create(
    Param value,
    Notifier Function(ProviderReference ref, Param param) builder,
    String? name,
  ) {
    return StateNotifierProvider((ref) => builder(ref, value), name: name);
  }

  late final _notifierFamily = _NotifierFamily<Notifier, Param>(builder, name);

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
class _NotifierFamily<Notifier extends StateNotifier<Object?>, Param>
    extends Family<Notifier, Notifier, Param, ProviderReference,
        _NotifierProvider<Notifier>> {
  _NotifierFamily(
    Notifier Function(ProviderReference ref, Param param) builder,
    String? name,
  ) : super(builder, name);

  @override
  _NotifierProvider<Notifier> create(
    Param value,
    Notifier Function(ProviderReference ref, Param param) builder,
    String? name,
  ) {
    return _NotifierProvider((ref) => builder(ref, value), name: name);
  }
}
