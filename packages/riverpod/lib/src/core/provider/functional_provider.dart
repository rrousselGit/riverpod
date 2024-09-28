part of '../../framework.dart';

/// Implementation detail of `riverpod_generator`.
/// Do not use, as this can be removed at any time.
abstract base class $FunctionalProvider< //
        StateT,
        CreatedT> //
    extends ProviderBase<StateT> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use, as this can be removed at any time.
  const $FunctionalProvider({
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required super.persist,
    required super.retry,
  });

  /// Clone a provider with a different initialization method.
  ///
  /// This is an implementation detail of Riverpod and should not be used.
  @visibleForOverriding
  $FunctionalProvider<StateT, CreatedT> $copyWithCreate(
    Create<CreatedT, Ref<StateT>> create,
  );

  /// {@template riverpod.override_with}
  /// Override the provider with a new initialization function.
  ///
  /// This will also disable the auto-scoping mechanism, meaning that if the
  /// overridden provider specified `dependencies`, it will have no effect.
  ///
  /// The override must not specify a `dependencies`.
  ///
  /// Some common use-cases are:
  /// - testing, by replacing a service with a fake implementation, or to reach
  ///   a very specific state easily.
  /// - multiple environments, by changing the implementation of a class
  ///   based on the platform or other parameters.
  ///
  /// This function should be used in combination with `ProviderScope.overrides`
  /// or `ProviderContainer.overrides`:
  ///
  /// ```dart
  /// final myService = Provider((ref) => MyService());
  ///
  /// runApp(
  ///   ProviderScope(
  ///     overrides: [
  ///       // Replace the implementation of the provider with a different one
  ///       myService.overrideWith((ref) {
  ///         ref.watch('other');
  ///         return MyFakeService(),
  ///       })),
  ///     ],
  ///     child: MyApp(),
  ///   ),
  /// );
  /// ```
  /// {@endtemplate}
  Override overrideWith(Create<CreatedT, Ref<StateT>> create) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $copyWithCreate(create),
    );
  }
}
