part of '../../framework.dart';

/// Implementation detail of `riverpod_generator`.
/// Do not use, as this can be removed at any time.
@internal
@reopen
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
    required super.retry,
  });

  @internal
  $FunctionalProvider<StateT, CreatedT> $view({
    required Create<CreatedT> create,
  }) {
    return _FunctionalProviderView.$FunctionalView(this, create);
  }

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
  Override overrideWith(Create<CreatedT> create) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $view(create: create),
    );
  }

  @internal
  CreatedT create(Ref ref);

  @internal
  @override
  $FunctionalProviderElement<StateT, CreatedT> $createElement(
    $ProviderPointer pointer,
  );
}

final class _FunctionalProviderView<StateT, CreatedT> //
    extends $FunctionalProvider<StateT, CreatedT> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use, as this can be removed at any time.
  _FunctionalProviderView.$FunctionalView(
    this._inner,
    this._createOverride,
  ) : super(
          name: _inner.name,
          from: _inner.from,
          argument: _inner.argument,
          dependencies: _inner.dependencies,
          allTransitiveDependencies: _inner.allTransitiveDependencies,
          isAutoDispose: _inner.isAutoDispose,
          retry: _inner.retry,
        );

  final $FunctionalProvider<StateT, CreatedT> _inner;
  final Create<CreatedT> _createOverride;

  @override
  CreatedT create(Ref ref) => _createOverride(ref);

  @internal
  @override
  $FunctionalProviderElement<StateT, CreatedT> $createElement(
    $ProviderPointer pointer,
  ) {
    return _inner.$createElement(pointer)..provider = this;
  }

  @override
  String? debugGetCreateSourceHash() => _inner.debugGetCreateSourceHash();
}

@internal
abstract class $FunctionalProviderElement<StateT, CreatedT>
    extends ProviderElement<StateT> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use, as this can be removed at any time.
  $FunctionalProviderElement(super.pointer)
      : provider = pointer.origin as $FunctionalProvider<StateT, CreatedT>;

  @override
  $FunctionalProvider<StateT, CreatedT> provider;
}
