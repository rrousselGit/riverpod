part of '../notifier.dart';

/// {@template riverpod.notifier}
abstract class FamilyNotifier<State, Arg> extends NotifierBase<State> {
  /// {@template riverpod.notifier.family_arg}
  late final Arg arg;

  @override
  late final NotifierProviderElement<FamilyNotifier<State, Arg>, State>
      _element;

  @override
  void _setElement(ProviderElementBase<State> element) {
    _element =
        element as NotifierProviderElement<FamilyNotifier<State, Arg>, State>;
    arg = element.origin.argument as Arg;
  }

  @override
  NotifierProviderRef<State> get ref => _element;

  /// {@macro riverpod.asyncnotifier.build}
  @visibleForOverriding
  State build(Arg arg);
}

/// The provider for [NotifierProviderFamily].
typedef NotifierFamilyProvider<NotifierT extends FamilyNotifier<T, Arg>, T, Arg>
    = TestFamilyNotifierProvider<NotifierT, T, Arg>;

/// The implementation of [NotifierFamilyProvider] but with loosened type constraints
/// that can be shared with [AutoDisposeNotifierProvider].
///
/// This enables tests to execute on both [NotifierProvider] and
/// [AutoDisposeNotifierProvider] at the same time.
@visibleForTesting
class TestFamilyNotifierProvider<NotifierT extends NotifierBase<T>, T, Arg>
    extends NotifierProviderBase<NotifierT, T> with AlwaysAliveProviderBase<T> {
  /// {@macro riverpod.notifier}
  TestFamilyNotifierProvider(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  /// {@macro riverpod.autoDispose}
  // ignore: prefer_const_declarations
  static final autoDispose = AutoDisposeNotifierProviderFamily.new;

  // /// {@macro riverpod.family}
  // static const family = NotifierProviderFamilyBuilder();

  @override
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _notifier<NotifierT, T>(this);

  @override
  NotifierProviderElement<NotifierT, T> createElement() {
    return NotifierProviderElement._(this);
  }

  @override
  T _runNotifierBuild(
    covariant FamilyNotifier<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}

/// The [Family] of [NotifierProvider].
class NotifierProviderFamily<NotifierT extends FamilyNotifier<T, Arg>, T, Arg>
    extends NotifierFamilyBase<NotifierProviderRef<T>, T, Arg, NotifierT,
        NotifierFamilyProvider<NotifierT, T, Arg>> {
  /// The [Family] of [NotifierProvider].
  NotifierProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: NotifierFamilyProvider.new);
}
