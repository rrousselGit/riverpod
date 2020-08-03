part of 'framework.dart';

/// A hook that listens to a provider and returns its current value.
///
/// As a usage example, consider:
///
/// ```dart
/// final helloWorldProvider = Provider((_) => 'Hello world');
/// ```
///
/// We can then use [useProvider] to listen to `helloWorldProvider` like so:
///
/// ```dart
/// class Example extends HookWidget {
///   @override
///   Widget build(BuildContext context) {
///     final value = useProvider(helloWorldProvider);
///     return Text(value); // Hello world
///   }
/// }
/// ```
///
/// See also:
///
/// - [Provider]/`select`, for filtering unwanted rebuilds.
T useProvider<T>(ProviderListenable<T> provider) {
  final container = ProviderScope.containerOf(useContext());
  return use(_ProviderHook<T>(container, provider));
}

class _ProviderHook<T> extends Hook<T> {
  const _ProviderHook(this._container, this._providerListenable);

  final ProviderContainer _container;
  final ProviderListenable<T> _providerListenable;

  @override
  _ProviderHookState<T> createState() => _ProviderHookState();
}

class _ProviderHookState<T> extends HookState<T, _ProviderHook<T>> {
  ProviderSubscription<T> _link;

  @override
  void initHook() {
    super.initHook();
    _listen();
  }

  void _listen() {
    _link?.close();
    // De-reference the providerListenable so that `is` promotes the type
    final providerListenable = hook._providerListenable;
    _link = hook._container.listen<T>(
      providerListenable,
      mayHaveChanged: (_) => markMayNeedRebuild(),
    );
  }

  @override
  bool shouldRebuild() => _link.flush();

  @override
  T build(BuildContext context) {
    return _link.read();
  }

  @override
  void didUpdateHook(_ProviderHook<T> oldHook) {
    super.didUpdateHook(oldHook);
    assert(
      oldHook._providerListenable.runtimeType ==
          hook._providerListenable.runtimeType,
      'The provider listened cannot change',
    );
    if (oldHook._container != hook._container) {
      _listen();
    } else if (_link is SelectorSubscription<dynamic, T>) {
      final link = _link as SelectorSubscription<dynamic, T>;
      assert(
        hook._providerListenable is ProviderSelector<dynamic, T>,
        'useProvider was updated from `useProvider(provider.select(...)) '
        'to useProvider(provider), which is unsupported',
      );
      if ((hook._providerListenable as ProviderSelector<dynamic, T>).provider !=
          (oldHook._providerListenable as ProviderSelector<dynamic, T>)
              .provider) {
        _listen();
      } else {
        // this will update _state
        link.updateSelector(hook._providerListenable);
      }
    } else if (oldHook._providerListenable != hook._providerListenable) {
      _listen();
    }
  }

  @override
  void dispose() {
    _link.close();
    super.dispose();
  }
}
