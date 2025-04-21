part of '../stream_notifier.dart';

/// {@macro riverpod.async_notifier}
///
/// {@macro riverpod.async_notifier_provider_modifier}
abstract class FamilyStreamNotifier<StateT, ArgT>
    extends $StreamNotifier<StateT> {
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
  Stream<StateT> build(ArgT arg);

  @internal
  @override
  void runBuild() {
    final created = build(arg);
    element()!.handleValue(ref, created);
  }
}

final class FamilyStreamNotifierProvider< //
        NotifierT extends FamilyStreamNotifier<StateT, ArgT>,
        StateT,
        ArgT> //
    extends $StreamNotifierProvider<NotifierT, StateT>
    with LegacyProviderMixin<AsyncValue<StateT>> {
  /// An implementation detail of Riverpod
  const FamilyStreamNotifierProvider._(
    this._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.retry,
  });

  final NotifierT Function() _createNotifier;

  @internal
  @override
  NotifierT create() => _createNotifier();

  @internal
  @override
  $StreamNotifierProviderElement<NotifierT, StateT> $createElement(
    $ProviderPointer pointer,
  ) {
    return $StreamNotifierProviderElement(pointer);
  }
}

/// The [Family] of [StreamNotifierProvider].
class StreamNotifierProviderFamily< //
        NotifierT extends FamilyStreamNotifier<StateT, ArgT>,
        StateT,
        ArgT> //
    extends ClassFamily< //
        NotifierT,
        AsyncValue<StateT>,
        StateT,
        ArgT,
        Stream<StateT>,
        FamilyStreamNotifierProvider<NotifierT, StateT, ArgT>> {
  /// The [Family] of [StreamNotifierProvider].
  @internal
  StreamNotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: FamilyStreamNotifierProvider._,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );
}
