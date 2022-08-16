part of '../notifier.dart';

/// {@template riverpod.notifier}
abstract class AutoDisposeFamilyNotifier<State, Arg>
    extends NotifierBase<State> {
  /// {@template riverpod.notifier.family_arg}
  late final Arg arg;

  @override
  late final AutoDisposeNotifierProviderElement<
      AutoDisposeFamilyNotifier<State, Arg>, State> _element;

  @override
  void _setElement(ProviderElementBase<State> element) {
    _element = element as AutoDisposeNotifierProviderElement<
        AutoDisposeFamilyNotifier<State, Arg>, State>;
    arg = element.origin.argument as Arg;
  }

  @override
  AutoDisposeNotifierProviderRef<State> get ref => _element;

  /// {@macro riverpod.asyncnotifier.build}
  @visibleForOverriding
  State build(Arg arg);
}

/// {@macro riverpod.notifier}
typedef AutoDisposeFamilyNotifierProvider<
        NotifierT extends AutoDisposeFamilyNotifier<T, Arg>, T, Arg>
    = TestAutoDisposeFamilyNotifierProvider<NotifierT, T, Arg>;

/// The implementation of [AutoDisposeNotifierProvider] but with loosened type constraints
/// that can be shared with [NotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeNotifierProvider] and
/// [NotifierProvider] at the same time.
class TestAutoDisposeFamilyNotifierProvider<NotifierT extends NotifierBase<T>,
    T, Arg> extends NotifierProviderBase<NotifierT, T> {
  /// {@macro riverpod.notifier}
  TestAutoDisposeFamilyNotifierProvider(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  });

  @override
  late final Refreshable<NotifierT> notifier = _notifier<NotifierT, T>(this);

  @override
  AutoDisposeNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeNotifierProviderElement._(this);
  }

  @override
  T _runNotifierBuild(
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
    super.cacheTime,
    super.disposeDelay,
  }) : super(providerFactory: AutoDisposeFamilyNotifierProvider.new);
}
