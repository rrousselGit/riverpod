part of '../notifier.dart';

/// {@template riverpod.notifier}
abstract class AutoDisposeFamilyNotifier<State, Arg>
    extends BuildlessAutoDisposeNotifier<State> {
  /// {@template riverpod.notifier.family_arg}
  late final Arg arg;

  @override
  void _setElement(ProviderElementBase<State> element) {
    super._setElement(element);
    arg = element.origin.argument as Arg;
  }

  /// {@macro riverpod.asyncnotifier.build}
  @visibleForOverriding
  State build(Arg arg);
}

/// {@macro riverpod.notifier}
typedef AutoDisposeFamilyNotifierProvider<
        NotifierT extends AutoDisposeFamilyNotifier<T, Arg>, T, Arg>
    = AutoDisposeFamilyNotifierProviderImpl<NotifierT, T, Arg>;

/// The implementation of [AutoDisposeNotifierProvider] but with loosened type constraints
/// that can be shared with [NotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeNotifierProvider] and
/// [NotifierProvider] at the same time.
@internal
class AutoDisposeFamilyNotifierProviderImpl<NotifierT extends NotifierBase<T>,
    T, Arg> extends NotifierProviderBase<NotifierT, T> {
  /// {@macro riverpod.notifier}
  AutoDisposeFamilyNotifierProviderImpl(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
  });

  @override
  late final Refreshable<NotifierT> notifier = _notifier<NotifierT, T>(this);

  @override
  AutoDisposeNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeNotifierProviderElement._(this);
  }

  @override
  T runNotifierBuild(
    covariant AutoDisposeFamilyNotifier<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}

/// The [Family] of [NotifierProvider].
class AutoDisposeNotifierProviderFamily<
        NotifierT extends AutoDisposeFamilyNotifier<T, Arg>, T, Arg>
    extends AutoDisposeNotifierFamilyBase<AutoDisposeNotifierProviderRef<T>, T,
        Arg, NotifierT, AutoDisposeFamilyNotifierProvider<NotifierT, T, Arg>> {
  /// The [Family] of [AutoDisposeNotifierProvider].
  AutoDisposeNotifierProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: AutoDisposeFamilyNotifierProvider.new);

  /// {@macro riverpod.overridewith}
  Override overrideWith(NotifierT Function() create) {
    return FamilyOverrideImpl<T, Arg,
        AutoDisposeFamilyNotifierProvider<NotifierT, T, Arg>>(
      this,
      (arg) => AutoDisposeFamilyNotifierProvider<NotifierT, T, Arg>(
        create,
        from: from,
        argument: arg,
      ),
    );
  }
}
