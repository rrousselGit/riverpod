part of '../../framework.dart';

/// Internal typedef for cancelling the subscription to an async operation
@internal
typedef AsyncSubscription = ({
  /// The provider was disposed, but may rebuild later
  void Function() cancel,
  void Function()? pause,
  void Function()? resume,

  /// The provider was disposed
  void Function()? abort,
});

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@internal
@publicInCodegen
mixin $AsyncClassModifier<ValueT, CreatedT>
    on AnyNotifier<AsyncValue<ValueT>, ValueT> {
  @visibleForTesting
  @protected
  @override
  AsyncValue<ValueT> get state;

  @visibleForTesting
  @protected
  @override
  set state(AsyncValue<ValueT> newState);

  /// {@template riverpod.async_notifier.future}
  /// Obtains a [Future] that resolves with the first [state] value that is not
  /// [AsyncLoading].
  ///
  /// This future will not necessarily wait for [AsyncNotifier.build] to complete.
  /// If [state] is modified before [AsyncNotifier.build] completes, then [future]
  /// will resolve with that new [state] value.
  ///
  /// The future will fail if [state] is in error state. In which case the
  /// error will be the same as [AsyncValue.error] and its stacktrace.
  /// {@endtemplate}
  @visibleForTesting
  @protected
  Future<ValueT> get future {
    final element = requireElement();

    element.flush();
    return (element as FutureModifierElement<ValueT>)
        .futureNotifier
        .requireResult
        .valueOrRawException;
  }

  /// A function to update [state] from its previous value, while
  /// abstracting loading/error cases for [state].
  ///
  /// This method neither causes [state] to go back to "loading" while the
  /// operation is pending. Neither does it cause [state] to go to error state
  /// if the operation fails.
  ///
  /// If [state] was in error state, the callback will not be invoked and instead
  /// the error will be returned. Alternatively, [onError] can specified to
  /// gracefully handle error states.
  ///
  /// See also:
  /// - [future], for manually awaiting the resolution of [state].
  /// - [AsyncValue.guard], and alternate way to perform asynchronous operations.
  @visibleForTesting
  @protected
  Future<ValueT> update(
    FutureOr<ValueT> Function(ValueT previousState) cb, {
    FutureOr<ValueT> Function(Object err, StackTrace stackTrace)? onError,
  }) async {
    final newState = await future.then(cb, onError: onError);
    state = AsyncData<ValueT>(newState);
    return newState;
  }
}

/// A [ProviderListenable] that exposes an [AsyncValue] and
/// can be converted into a [Future] using the [future] property.
///
/// This is used by [FutureProvider] and [StreamProvider] to
/// expose their asynchronous values.
@publicInMisc
abstract interface class AsyncProviderListenable<ValueT>
    implements ProviderListenable<AsyncValue<ValueT>> {
  /// Obtains the [Future] representing this provider.
  ///
  /// The instance of [Future] obtained may change over time. This typically
  /// happens when a new "data" or "error" is emitted, or when the provider
  /// re-enters a "loading" state.
  ///
  /// This modifier enables using `async`/`await` to easily combine
  /// providers together:
  ///
  /// ```dart
  /// final configsProvider = FutureProvider((ref) async => Configs());
  ///
  /// final productsProvider = FutureProvider((ref) async {
  ///   // Wait for the configurations to resolve
  ///   final configs = await ref.watch(configsProvider.future);
  ///
  ///   // Do something with the result
  ///   return await http.get('${configs.host}/products');
  /// });
  /// ```
  Refreshable<Future<ValueT>> get future;
}

/// Implementation detail for `riverpod_generator`.
/// Do not use.
@internal
@publicInCodegen
base mixin $FutureModifier<ValueT> on $ProviderBaseImpl<AsyncValue<ValueT>>
    implements AsyncProviderListenable<ValueT> {
  @override
  Refreshable<Future<ValueT>> get future => _future;

  _ProviderRefreshable<Future<ValueT>, AsyncValue<ValueT>> get _future {
    return ProviderElementProxy<Future<ValueT>, AsyncValue<ValueT>>(this, (
      element,
    ) {
      element as FutureModifierElement<ValueT>;

      return element.futureNotifier;
    });
  }

  /// {@template riverpod.async_select}
  /// A variant of [select] for asynchronous values
  ///
  /// [selectAsync] is useful for filtering rebuilds of a provider
  /// when it depends on asynchronous values, which we want to await.
  ///
  /// A common use-case would be to combine [selectAsync] with
  /// [FutureProvider] to perform an async operation, where that
  /// async operation depends on the result of another async operation.
  ///
  ///
  /// ```dart
  /// // A provider which asynchronously loads configurations,
  /// // which may change over time.
  /// final configsProvider = StreamProvider<Config>((ref) async {
  ///   // TO-DO fetch the configurations, such as by using Firebase
  /// });
  ///
  /// // A provider which fetches a list of products based on the configurations
  /// final productsProvider = FutureProvider<List>((ref) async {
  ///   // We obtain the host from the configs, while ignoring changes to
  ///   // other properties. As such, the productsProvider will rebuild only
  ///   // if the host changes
  ///   final host = await ref.watch(configsProvider.selectAsync((config) => config.host));
  ///
  ///   return http.get('$host/products');
  /// });
  /// ```
  /// {@endtemplate}
  ProviderListenable<Future<OutT>> selectAsync<OutT>(
    OutT Function(ValueT data) selector,
  ) {
    return _AsyncSelector<ValueT, OutT>(
      selector: selector,
      provider: this,
      future: _future,
    );
  }
}

@internal
mixin FutureModifierClassElement<
  NotifierT extends AnyNotifier<AsyncValue<ValueT>, ValueT>,
  ValueT,
  CreatedT
>
    on
        FutureModifierElement<ValueT>,
        $ClassProviderElement<NotifierT, AsyncValue<ValueT>, ValueT, CreatedT> {
  @override
  void handleError(Ref ref, Object error, StackTrace stackTrace) {
    onError(triggerRetry(error, stackTrace), seamless: !ref.isReload);
  }
}

/// Mixin to help implement logic for listening to [Future]s/[Stream]s and setup
/// `provider.future` + convert the object into an [AsyncValue].
@internal
mixin FutureModifierElement<ValueT>
    on ElementWithFuture<AsyncValue<ValueT>, ValueT> {
  @override
  $Result<AsyncValue<ValueT>> resultForValue(AsyncValue<ValueT> value) {
    return $ResultData(value);
  }

  @override
  void setValueFromState(AsyncValue<ValueT> state) => value = state;
}
