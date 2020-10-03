import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'internals.dart';

/// A hook that listens to a provider and and triggers a callback whenevr the value of provider is changed.
///
/// As a usage example, consider:
///
/// ```dart
/// class Counter extends StateNotifier<int> {
///   Counter(): super(0);
///    void increment() => state++;
/// }
///
/// final counterProvider = StateNotifierProvider((ref) => Counter());
/// ```
///
/// We can then use [useProviderListener] to listen to `helloWorldProvider` like so:
///
/// ```dart
/// class Example extends HookWidget {
///   @override
///   Widget build(BuildContext context) {
///     final counter = userProvider(counter.state);
///     useProviderListener(counterProvider, (context, value) {
///       if (value % 2 == 0) print('even');
///       else print('odd');
///     });
///    return Column(
///       children: [
///         Text('$count'),
///         RaisedButton(
///           onPressed: () => context.read(counterProvider).increment(),
///          child: const Text('increment'),
///         )
///       ],
///     );
///   }
/// }
/// ```
///
/// See also:
///
/// - [Provider]/`select`, for filtering unwanted rebuilds.
void useProviderListener<T>(
    ProviderListenable<T> provider, OnProviderChange<T> onChange) {
  final container = ProviderScope.containerOf(useContext());
  return use(_ProviderListenerHook(container, provider, onChange));
}

typedef OnProviderChange<T> = void Function(BuildContext context, T value);

class _ProviderListenerHook<T> extends Hook<void> {
  const _ProviderListenerHook(
      this._container, this._providerListenable, this.onChange);

  final ProviderContainer _container;
  final ProviderListenable<T> _providerListenable;
  final OnProviderChange<T> onChange;

  @override
  _ProviderListenerHookState<T> createState() => _ProviderListenerHookState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<OnProviderChange<T>>('onChange', onChange),
    );

    if (_providerListenable is ProviderSelector<dynamic, T>) {
      properties.add(DiagnosticsProperty<ProviderBase<Object, T>>(
          'provider',
          (_providerListenable as ProviderSelector<dynamic, T>).provider
              as ProviderBase<Object, T>));
    } else {
      properties.add(DiagnosticsProperty<ProviderBase<Object, T>>(
          'provider', _providerListenable as ProviderBase<Object, T>));
    }
  }
}

class _ProviderListenerHookState<T>
    extends HookState<void, _ProviderListenerHook<T>> {
  ProviderSubscription<T> _link;

  @override
  void initHook() {
    super.initHook();
    _listen();
  }

  @override
  void build(BuildContext context) {}

  void _listen() {
    _link?.close();
    final providerListenable = hook._providerListenable;
    _link = hook._container.listen<T>(
      providerListenable,
      mayHaveChanged: _mayHaveChanged,
    );
  }

  void _mayHaveChanged(ProviderSubscription<T> subscription) {
    Future.microtask(() {
      if (subscription.flush()) {
        hook.onChange(context, subscription.read());
      }
    });
  }

  @override
  void didUpdateHook(_ProviderListenerHook<T> oldHook) {
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

  @override
  String get debugLabel => 'useProviderListener';

  @override
  bool get debugSkipValue => true;
}
