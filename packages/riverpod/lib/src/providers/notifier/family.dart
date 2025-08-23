part of '../notifier.dart';

/// The [Family] of [NotifierProvider].
@publicInMisc
final class NotifierProviderFamily<
  NotifierT extends Notifier<StateT>,
  StateT,
  ArgT
>
    extends
        ClassFamily<
          //
          NotifierT,
          StateT,
          StateT,
          ArgT,
          StateT,
          NotifierProvider<NotifierT, StateT>
        > {
  /// The [Family] of [NotifierProvider].
  /// @nodoc
  @internal
  NotifierProviderFamily.internal(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
         providerFactory: NotifierProvider.internal,
         $allTransitiveDependencies: computeAllTransitiveDependencies(
           dependencies,
         ),
       );
}
