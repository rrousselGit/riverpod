// ignore: implementation_imports
import 'package:flutter_riverpod/src/internal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'src/selector.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart';

/// Exposes the `select` method on providers, later used by [useProvider].
extension ProviderSelect<Value> on ProviderBase<ProviderDependencyBase, Value> {
  /// Partially listen to a provider.
  ///
  /// The [select] function allows filtering unwanted rebuilds of a Widget
  /// by reading only the properties that we care about.
  ///
  /// For example, consider the following `ChangeNotifier`:
  ///
  /// ```dart
  /// class Person extends ChangeNotifier {
  ///   int _age = 0;
  ///   int get age => _age;
  ///   set age(int age) {
  ///     _age = age;
  ///     notifyListeners();
  ///   }
  ///
  ///   String _name = '';
  ///   String get name => _name;
  ///   set name(String name) {
  ///     _name = name;
  ///     notifyListeners();
  ///   }
  /// }
  ///
  /// final personProvider = ChangeNotifierProvider((_) => Person());
  /// ```
  ///
  /// In this class, both `name` and `age` may change, but a widget may need
  /// only `age`.
  ///
  /// If we used `useProvider`/`Consumer` as we normally would, this would cause
  /// widgets that only use `age` to still rebuild when `name` changes, which
  /// is inefficient.
  ///
  /// The method [select] can be used to fix this, by explicitly reading only
  /// a specific part of the object.
  ///
  /// A typical usage would be:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   final age = useProvider(personProvider.select((p) => p.age));
  ///   return Text('$age');
  /// }
  /// ```
  ///
  /// This will cause our widget to rebuild **only** when `age` changes.
  ///
  ///
  /// **NOTE**: The function passed to [select] can return complex computations
  /// too.
  ///
  /// For example, instead of `age`, we could return a "isAdult" boolean:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   final isAdult = useProvider(personProvider.select((p) => p.age >= 18));
  ///   return Text('$isAdult');
  /// }
  /// ```
  ///
  /// This will further optimise our widget by rebuilding it only when "isAdult"
  /// changed instead of whenever the age changes.
  ProviderListenable<Selected> select<Selected>(
    Selected Function(Value value) selector,
  ) {
    return ProviderSelector(this, selector);
  }
}

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
///     final greeting = useProvider(helloWorldProvider);
///     return Text(value); // Hello world
///   }
/// }
/// ```
///
/// See also:
///
/// - [Computed]/`select`, for filtering unwanted rebuilds.
T useProvider<T>(ProviderListenable<T> provider) {
  final owner = ProviderStateOwnerScope.of(useContext());
  return Hook.use(_ProviderHook<T>(owner, provider));
}

class _ProviderHook<T> extends Hook<T> {
  const _ProviderHook(this._owner, this._provider);

  final ProviderStateOwner _owner;
  final ProviderListenable<T> _provider;

  @override
  _ProviderHookState<T> createState() => _ProviderHookState();
}

class _ProviderHookState<T> extends HookState<T, _ProviderHook<T>> {
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
  void didUpdateHook(_ProviderHook<T> oldHook) {
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
