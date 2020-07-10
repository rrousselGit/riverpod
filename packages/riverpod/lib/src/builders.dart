import 'package:state_notifier/state_notifier.dart';
import 'internals.dart';

/// Builds a [StateProvider].
class StateProviderBuilder {
  /// Builds a [StateProvider].
  const StateProviderBuilder();

  /// {@template riverpod.autoDispose}
  /// Marks the provider as automatically disposed when no-longer listened.
  ///
  /// Some typical use-cases:
  ///
  /// - Combined with [StreamProvider], this can be used as a mean to keep
  ///   the connection with Firebase alive only when truly needed (to reduce costs).
  /// - Automatically reset a form state when leaving the screen.
  /// - Automatically retry HTTP requests that failed when the user exit and
  ///   re-enter the screen.
  /// - Cancel HTTP requests if the user leaves a screen before the request completed.
  ///
  /// Marking a provider with `autoDispose` has two effects:
  ///
  /// - this adds a new property on the `ref` parameter of your provider: `maintainState`
  /// - the `readOwner(ProviderStateOwner)` and `read(BuildContext)` methods
  ///   of a provider are removed.
  ///   It is no-longer possible to read a provider without listening to it.
  ///
  /// The `maintainState` property is a boolean (`false` by default) that allows
  /// the provider to tell Riverpod if the state of the provider should be preserved
  /// even if no-longer listened.
  ///
  /// A use-case would be to set this flag to `true` after an HTTP request have
  /// completed:
  ///
  /// ```dart
  /// final myProvider = FutureProvider.autoDispose((ref) async {
  ///   final response = await httpClient.get(...);
  ///   ref.maintainState = true;
  ///   return response;
  /// });
  /// ```
  ///
  /// This way, if the request failed and the UI leaves the screen then re-enters
  /// it, then the request will be performed again.
  /// But if the request completed successfuly, the state will be preserved
  /// and re-entering the screen will not trigger a new request.
  ///
  /// It can be combined with `ref.onDispose` for more advanced behaviors, such
  /// as cancelling pending HTTP requests when the user leaves a screen.
  /// For example, modifying our previous snippet and using `dio`, we would have:
  ///
  /// ```diff
  /// final myProvider = FutureProvider.autoDispose((ref) async {
  /// + final cancelToken = CancelToken();
  /// + ref.onDispose(() => cancelToken.cancel());
  /// 
  /// + final response = await dio.get('path', cancelToken: cancelToken);
  /// - final response = await dio.get('path');
  ///   ref.maintainState = true;
  ///   return response;
  /// });
  /// ```
  /// {@endtemplate}
  StateProvider<T> call<T>(
    T Function(ProviderReference ref) create, {
    String name,
  }) {
    return StateProvider(create, name: name);
  }

  /// {@template riverpod.family}
  /// Creates a provider from external parameters.
  ///
  /// Marking a provider with `family` is an easy way to have more advanced
  /// behaviors for our providers.
  ///
  /// A common use-case would be to use `family` to make a provider that fetches
  /// a data from its ID.
  /// By using `family`, this will make our UI automatically support cases such as:
  /// - The ID changed, so we need to fetch the new data and update the UI.
  /// - The UI is reading multiple IDs at the same time.
  ///
  /// The way families works is by adding an extra parameter to the provider.
  /// This parameter can then be freely used in our provider to create some state.
  ///
  /// For example, we could combine `family` with [FutureProvider] to fetch
  /// a "message" from its ID:
  ///
  /// ```dart
  /// final messages = FutureProvider.family<Message, String>((ref, id) async {
  ///   return dio.get('http://my_api.dev/messages/$id);
  /// });
  /// ```
  ///
  /// Then, when using our `messages` provider, the syntax is slightly modified.
  /// The usual:
  /// 
  /// ```dart
  /// Widget build(BuildContext) {
  ///   // Error – messages is not a provider
  ///   final response = useProvider(messages);
  /// }
  /// ```
  ///
  /// will not work anymore.
  /// Instead, we need to pass a parameter to `messages`:
  ///
  /// ```dart
  /// Widget build(BuildContext) {
  ///   final response = useProvider(messages('id'));
  /// }
  /// ```
  ///
  /// Note that it is entirely possible for a widget to listen to `messages` with
  /// different ids simultaneously:
  /// 
  /// ```dart
  /// Widget build(BuildContext) {
  ///   final response = useProvider(messages('21'));
  ///   final response2 = useProvider(messages('42'));
  ///   // Correctly listens to both `messages('21')` and `messages('42')`
  /// }
  /// ```
  /// {@endtemplate}
  StateProviderFamilyBuilder get family {
    return const StateProviderFamilyBuilder();
  }
}
/// Builds a [StateProviderFamily].
class StateProviderFamilyBuilder {
  /// Builds a [StateProviderFamily].
  const StateProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StateProviderFamily<T, Value> call<T, Value>(
    T Function(ProviderReference ref, Value value) create, {
    String name,
  }) {
    return StateProviderFamily(create);
  }

}
/// Builds a [StateNotifierProvider].
class StateNotifierProviderBuilder {
  /// Builds a [StateNotifierProvider].
  const StateNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  StateNotifierProvider<T> call<T extends StateNotifier<dynamic>>(
    T Function(ProviderReference ref) create, {
    String name,
  }) {
    return StateNotifierProvider(create, name: name);
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStateNotifierProviderBuilder get autoDispose {
    return const AutoDisposeStateNotifierProviderBuilder();
  }

  /// {@macro riverpod.family}
  StateNotifierProviderFamilyBuilder get family {
    return const StateNotifierProviderFamilyBuilder();
  }
}
/// Builds a [StateNotifierProviderFamily].
class StateNotifierProviderFamilyBuilder {
  /// Builds a [StateNotifierProviderFamily].
  const StateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StateNotifierProviderFamily<T, Value> call<T extends StateNotifier<dynamic>, Value>(
    T Function(ProviderReference ref, Value value) create, {
    String name,
  }) {
    return StateNotifierProviderFamily(create);
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStateNotifierProviderFamilyBuilder get autoDispose {
    return const AutoDisposeStateNotifierProviderFamilyBuilder();
  }
}
/// Builds a [Provider].
class ProviderBuilder {
  /// Builds a [Provider].
  const ProviderBuilder();

  /// {@macro riverpod.autoDispose}
  Provider<T> call<T>(
    T Function(ProviderReference ref) create, {
    String name,
  }) {
    return Provider(create, name: name);
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeProviderBuilder get autoDispose {
    return const AutoDisposeProviderBuilder();
  }

  /// {@macro riverpod.family}
  ProviderFamilyBuilder get family {
    return const ProviderFamilyBuilder();
  }
}
/// Builds a [ProviderFamily].
class ProviderFamilyBuilder {
  /// Builds a [ProviderFamily].
  const ProviderFamilyBuilder();

  /// {@macro riverpod.family}
  ProviderFamily<T, Value> call<T, Value>(
    T Function(ProviderReference ref, Value value) create, {
    String name,
  }) {
    return ProviderFamily(create);
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeProviderFamilyBuilder get autoDispose {
    return const AutoDisposeProviderFamilyBuilder();
  }
}
/// Builds a [FutureProvider].
class FutureProviderBuilder {
  /// Builds a [FutureProvider].
  const FutureProviderBuilder();

  /// {@macro riverpod.autoDispose}
  FutureProvider<T> call<T>(
    Future<T> Function(ProviderReference ref) create, {
    String name,
  }) {
    return FutureProvider(create, name: name);
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeFutureProviderBuilder get autoDispose {
    return const AutoDisposeFutureProviderBuilder();
  }

  /// {@macro riverpod.family}
  FutureProviderFamilyBuilder get family {
    return const FutureProviderFamilyBuilder();
  }
}
/// Builds a [FutureProviderFamily].
class FutureProviderFamilyBuilder {
  /// Builds a [FutureProviderFamily].
  const FutureProviderFamilyBuilder();

  /// {@macro riverpod.family}
  FutureProviderFamily<T, Value> call<T, Value>(
    Future<T> Function(ProviderReference ref, Value value) create, {
    String name,
  }) {
    return FutureProviderFamily(create);
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeFutureProviderFamilyBuilder get autoDispose {
    return const AutoDisposeFutureProviderFamilyBuilder();
  }
}
/// Builds a [StreamProvider].
class StreamProviderBuilder {
  /// Builds a [StreamProvider].
  const StreamProviderBuilder();

  /// {@macro riverpod.autoDispose}
  StreamProvider<T> call<T>(
    Stream<T> Function(ProviderReference ref) create, {
    String name,
  }) {
    return StreamProvider(create, name: name);
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStreamProviderBuilder get autoDispose {
    return const AutoDisposeStreamProviderBuilder();
  }

  /// {@macro riverpod.family}
  StreamProviderFamilyBuilder get family {
    return const StreamProviderFamilyBuilder();
  }
}
/// Builds a [StreamProviderFamily].
class StreamProviderFamilyBuilder {
  /// Builds a [StreamProviderFamily].
  const StreamProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StreamProviderFamily<T, Value> call<T, Value>(
    Stream<T> Function(ProviderReference ref, Value value) create, {
    String name,
  }) {
    return StreamProviderFamily(create);
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStreamProviderFamilyBuilder get autoDispose {
    return const AutoDisposeStreamProviderFamilyBuilder();
  }
}
/// Builds a [AutoDisposeStateNotifierProvider].
class AutoDisposeStateNotifierProviderBuilder {
  /// Builds a [AutoDisposeStateNotifierProvider].
  const AutoDisposeStateNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeStateNotifierProvider<T> call<T extends StateNotifier<dynamic>>(
    T Function(AutoDisposeProviderReference ref) create, {
    String name,
  }) {
    return AutoDisposeStateNotifierProvider(create, name: name);
  }

  /// {@macro riverpod.family}
  AutoDisposeStateNotifierProviderFamilyBuilder get family {
    return const AutoDisposeStateNotifierProviderFamilyBuilder();
  }
}
/// Builds a [AutoDisposeStateNotifierProviderFamily].
class AutoDisposeStateNotifierProviderFamilyBuilder {
  /// Builds a [AutoDisposeStateNotifierProviderFamily].
  const AutoDisposeStateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  AutoDisposeStateNotifierProviderFamily<T, Value> call<T extends StateNotifier<dynamic>, Value>(
    T Function(AutoDisposeProviderReference ref, Value value) create, {
    String name,
  }) {
    return AutoDisposeStateNotifierProviderFamily(create);
  }

}
/// Builds a [AutoDisposeProvider].
class AutoDisposeProviderBuilder {
  /// Builds a [AutoDisposeProvider].
  const AutoDisposeProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeProvider<T> call<T>(
    T Function(AutoDisposeProviderReference ref) create, {
    String name,
  }) {
    return AutoDisposeProvider(create, name: name);
  }

  /// {@macro riverpod.family}
  AutoDisposeProviderFamilyBuilder get family {
    return const AutoDisposeProviderFamilyBuilder();
  }
}
/// Builds a [AutoDisposeProviderFamily].
class AutoDisposeProviderFamilyBuilder {
  /// Builds a [AutoDisposeProviderFamily].
  const AutoDisposeProviderFamilyBuilder();

  /// {@macro riverpod.family}
  AutoDisposeProviderFamily<T, Value> call<T, Value>(
    T Function(AutoDisposeProviderReference ref, Value value) create, {
    String name,
  }) {
    return AutoDisposeProviderFamily(create);
  }

}
/// Builds a [AutoDisposeFutureProvider].
class AutoDisposeFutureProviderBuilder {
  /// Builds a [AutoDisposeFutureProvider].
  const AutoDisposeFutureProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeFutureProvider<T> call<T>(
    Future<T> Function(AutoDisposeProviderReference ref) create, {
    String name,
  }) {
    return AutoDisposeFutureProvider(create, name: name);
  }

  /// {@macro riverpod.family}
  AutoDisposeFutureProviderFamilyBuilder get family {
    return const AutoDisposeFutureProviderFamilyBuilder();
  }
}
/// Builds a [AutoDisposeFutureProviderFamily].
class AutoDisposeFutureProviderFamilyBuilder {
  /// Builds a [AutoDisposeFutureProviderFamily].
  const AutoDisposeFutureProviderFamilyBuilder();

  /// {@macro riverpod.family}
  AutoDisposeFutureProviderFamily<T, Value> call<T, Value>(
    Future<T> Function(AutoDisposeProviderReference ref, Value value) create, {
    String name,
  }) {
    return AutoDisposeFutureProviderFamily(create);
  }

}
/// Builds a [AutoDisposeStreamProvider].
class AutoDisposeStreamProviderBuilder {
  /// Builds a [AutoDisposeStreamProvider].
  const AutoDisposeStreamProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeStreamProvider<T> call<T>(
    Stream<T> Function(AutoDisposeProviderReference ref) create, {
    String name,
  }) {
    return AutoDisposeStreamProvider(create, name: name);
  }

  /// {@macro riverpod.family}
  AutoDisposeStreamProviderFamilyBuilder get family {
    return const AutoDisposeStreamProviderFamilyBuilder();
  }
}
/// Builds a [AutoDisposeStreamProviderFamily].
class AutoDisposeStreamProviderFamilyBuilder {
  /// Builds a [AutoDisposeStreamProviderFamily].
  const AutoDisposeStreamProviderFamilyBuilder();

  /// {@macro riverpod.family}
  AutoDisposeStreamProviderFamily<T, Value> call<T, Value>(
    Stream<T> Function(AutoDisposeProviderReference ref, Value value) create, {
    String name,
  }) {
    return AutoDisposeStreamProviderFamily(create);
  }

}
