// ignore_for_file: invalid_use_of_internal_member

part of '../change_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeChangeNotifierProviderRef<
        NotifierT extends ChangeNotifier?>
    extends ChangeNotifierProviderRef<NotifierT>
    implements AutoDisposeRef<NotifierT> {}

// ignore: subtype_of_sealed_class
/// {@macro riverpod.ChangeNotifierprovider}
class AutoDisposeChangeNotifierProvider<NotifierT extends ChangeNotifier?>
    extends _ChangeNotifierProviderBase<NotifierT> {
  /// {@macro riverpod.ChangeNotifierprovider}
  AutoDisposeChangeNotifierProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeChangeNotifierProviderFamily.new;

  final NotifierT Function(AutoDisposeChangeNotifierProviderRef<NotifierT> ref)
      _createFn;

  @override
  NotifierT _create(AutoDisposeChangeNotifierProviderElement<NotifierT> ref) {
    return _createFn(ref);
  }

  @override
  AutoDisposeChangeNotifierProviderElement<NotifierT> createElement() {
    return AutoDisposeChangeNotifierProviderElement<NotifierT>._(this);
  }

  @override
  late final Refreshable<NotifierT> notifier = _notifier<NotifierT>(this);

  /// {@macro riverpod.overridewith}
  Override overrideWith(
    Create<NotifierT, AutoDisposeChangeNotifierProviderRef<NotifierT>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeChangeNotifierProvider<NotifierT>(
        create,
        from: from,
        argument: argument,
      ),
    );
  }
}

/// The element of [AutoDisposeChangeNotifierProvider].
class AutoDisposeChangeNotifierProviderElement<
        NotifierT extends ChangeNotifier?>
    extends ChangeNotifierProviderElement<NotifierT>
    with AutoDisposeProviderElementMixin<NotifierT>
    implements AutoDisposeChangeNotifierProviderRef<NotifierT> {
  /// The [ProviderElementBase] for [ChangeNotifier]
  AutoDisposeChangeNotifierProviderElement._(
    AutoDisposeChangeNotifierProvider<NotifierT> super.provider,
  ) : super._();
}

// ignore: subtype_of_sealed_class
/// The [Family] of [AutoDisposeChangeNotifierProvider].
class AutoDisposeChangeNotifierProviderFamily<NotifierT extends ChangeNotifier?,
        Arg>
    extends AutoDisposeFamilyBase<
        AutoDisposeChangeNotifierProviderRef<NotifierT>,
        NotifierT,
        Arg,
        NotifierT,
        AutoDisposeChangeNotifierProvider<NotifierT>> {
  /// The [Family] of [AutoDisposeChangeNotifierProvider].
  AutoDisposeChangeNotifierProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: AutoDisposeChangeNotifierProvider.new);

  /// {@macro riverpod.overridewith}
  Override overrideWith(
    NotifierT Function(
      AutoDisposeChangeNotifierProviderRef<NotifierT> ref,
      Arg arg,
    )
        create,
  ) {
    return FamilyOverrideImpl<NotifierT, Arg,
        AutoDisposeChangeNotifierProvider<NotifierT>>(
      this,
      (arg) => AutoDisposeChangeNotifierProvider<NotifierT>(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
      ),
    );
  }
}
