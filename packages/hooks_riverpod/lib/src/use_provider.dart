import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'internals.dart';

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
  ProviderSubscription<T>? _link;

  @override
  void initHook() {
    super.initHook();
    _listen();
  }

  void _listen() {
    _link?.close();
    _link = hook._container.listen<T>(
      hook._providerListenable,
      mayHaveChanged: _mayHaveChanged,
    );
  }

  @override
  bool shouldRebuild() => _link!.flush();

  void _mayHaveChanged(ProviderSubscription<T> sub) {
    markMayNeedRebuild();
  }

  @override
  T build(BuildContext context) {
    return _link!.read();
  }

  @override
  void didUpdateHook(_ProviderHook<T> oldHook) {
    super.didUpdateHook(oldHook);
    assert(
      oldHook._providerListenable.runtimeType ==
          hook._providerListenable.runtimeType,
      'The provider listened cannot change',
    );

    final link = _link;

    if (oldHook._container != hook._container) {
      _listen();
    } else if (link is SelectorSubscription<Object?, T>) {
      assert(
        hook._providerListenable is ProviderSelector<Object?, T>,
        'useProvider was updated from `useProvider(provider.select(...)) '
        'to useProvider(provider), which is unsupported',
      );
      if ((hook._providerListenable as ProviderSelector<Object?, T>).provider !=
          (oldHook._providerListenable as ProviderSelector<Object?, T>)
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
    _link!.close();
    super.dispose();
  }
}
