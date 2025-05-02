part of '../async_notifier.dart';

/// {@macro riverpod.async_notifier}
///
/// {@macro riverpod.async_notifier_provider_modifier}
abstract class FamilyAsyncNotifier<StateT, ArgT>
    extends $AsyncNotifier<StateT> {
  /// {@template riverpod.notifier.family_arg}
  /// The argument that was passed to this family.
  ///
  /// For example, when doing:
  ///
  /// ```dart
  /// ref.watch(provider(0));
  /// ```
  ///
  /// then [arg] will be `0`.
  /// {@endtemplate}
  late final ArgT arg = ref.$arg as ArgT;

  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  FutureOr<StateT> build(ArgT arg);

  @mustCallSuper
  @override
  void runBuild() {
    final created = build(arg);
    requireElement().handleValue(ref, created);
  }
}

/// The [Family] of [AsyncNotifierProvider].
/// @nodoc
@publicInMisc
final class AsyncNotifierProviderFamily< //
        NotifierT extends FamilyAsyncNotifier<StateT, ArgT>,
        StateT,
        ArgT> //
    extends ClassFamily< //
        NotifierT,
        AsyncValue<StateT>,
        StateT,
        ArgT,
        FutureOr<StateT>,
        FamilyAsyncNotifierProvider<NotifierT, StateT, ArgT>> {
  /// The [Family] of [AsyncNotifierProvider].
  /// @nodoc
  @internal
  AsyncNotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: FamilyAsyncNotifierProvider._,
          $allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}

/// The provider returned by [AsyncNotifierProviderFamily].
@publicInMisc
final class FamilyAsyncNotifierProvider< //
        NotifierT extends FamilyAsyncNotifier<StateT, ArgT>,
        StateT,
        ArgT> //
    extends $AsyncNotifierProvider<NotifierT, StateT>
    with LegacyProviderMixin<AsyncValue<StateT>> {
  /// An implementation detail of Riverpod
  const FamilyAsyncNotifierProvider._(
    this._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.$allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.retry,
  });

  final NotifierT Function() _createNotifier;

  /// @nodoc
  @internal
  @override
  NotifierT create() => _createNotifier();
}
