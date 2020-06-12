// ignore: implementation_imports
import 'package:flutter_riverpod/src/internal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart';

T useProvider<T>(ProviderListenable<T> provider) {
  final owner = ProviderStateOwnerScope.of(useContext());
  return Hook.use(_BaseProviderHook<T>(owner, provider));
}

class _BaseProviderHook<T> extends Hook<T> {
  const _BaseProviderHook(this._owner, this._provider);

  final ProviderStateOwner _owner;
  final ProviderListenable<T> _provider;

  @override
  _BaseProviderHookState<T> createState() => _BaseProviderHookState();
}

class _BaseProviderHookState<T> extends HookState<T, _BaseProviderHook<T>> {
  T _state;
  ProviderSubscription _link;

  @override
  void initHook() {
    super.initHook();
    _listen();
  }

  void _listen() {
    _link?.close();
    _link = hook._provider.addLazyListener(
      hook._owner,
      mayHaveChanged: markMayNeedRebuild,
      onChange: (newState) => _state = newState,
    );
  }

  @override
  bool shouldRebuild() => _link.flush();

  @override
  void didUpdateHook(_BaseProviderHook<T> oldHook) {
    super.didUpdateHook(oldHook);
    assert(
      oldHook._provider.runtimeType == hook._provider.runtimeType,
      'The provider listened cannot change',
    );
    if (oldHook._owner != hook._owner) {
      _listen();
    } else {
      final link = _link;
      if (link is SelectorSubscription<Object, T>) {
        // this will update _state
        link.updateSelector(hook._provider);
      } else if (oldHook._provider != hook._provider) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: UnsupportedError(
              'Used `useProvider(provider)` with a `provider` different than it was before',
            ),
            library: 'flutter_provider',
            stack: StackTrace.current,
          ),
        );
      }
    }
  }

  @override
  T build(BuildContext context) => _state;

  @override
  void dispose() {
    _link.close();
    super.dispose();
  }
}
