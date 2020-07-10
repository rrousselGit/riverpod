import 'package:flutter/foundation.dart';
import 'internals.dart';

/// Builds a [ChangeNotifierProvider].
class ChangeNotifierProviderBuilder {
  /// Builds a [ChangeNotifierProvider].
  const ChangeNotifierProviderBuilder();

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
  ChangeNotifierProvider<T> call<T extends ChangeNotifier>(
    T Function(ProviderReference ref) create, {
    String name,
  }) {
    return ChangeNotifierProvider(create, name: name);
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeChangeNotifierProviderBuilder get autoDispose {
    return const AutoDisposeChangeNotifierProviderBuilder();
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
  ChangeNotifierProviderFamilyBuilder get family {
    return const ChangeNotifierProviderFamilyBuilder();
  }
}

/// Builds a [ChangeNotifierProviderFamily].
class ChangeNotifierProviderFamilyBuilder {
  /// Builds a [ChangeNotifierProviderFamily].
  const ChangeNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  ChangeNotifierProviderFamily<T, Value> call<T extends ChangeNotifier, Value>(
    T Function(ProviderReference ref, Value value) create, {
    String name,
  }) {
    return ChangeNotifierProviderFamily(create);
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeChangeNotifierProviderFamilyBuilder get autoDispose {
    return const AutoDisposeChangeNotifierProviderFamilyBuilder();
  }
}

/// Builds a [AutoDisposeChangeNotifierProvider].
class AutoDisposeChangeNotifierProviderBuilder {
  /// Builds a [AutoDisposeChangeNotifierProvider].
  const AutoDisposeChangeNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeChangeNotifierProvider<T> call<T extends ChangeNotifier>(
    T Function(AutoDisposeProviderReference ref) create, {
    String name,
  }) {
    return AutoDisposeChangeNotifierProvider(create, name: name);
  }

  /// {@macro riverpod.family}
  AutoDisposeChangeNotifierProviderFamilyBuilder get family {
    return const AutoDisposeChangeNotifierProviderFamilyBuilder();
  }
}

/// Builds a [AutoDisposeChangeNotifierProviderFamily].
class AutoDisposeChangeNotifierProviderFamilyBuilder {
  /// Builds a [AutoDisposeChangeNotifierProviderFamily].
  const AutoDisposeChangeNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  AutoDisposeChangeNotifierProviderFamily<T, Value>
      call<T extends ChangeNotifier, Value>(
    T Function(AutoDisposeProviderReference ref, Value value) create, {
    String name,
  }) {
    return AutoDisposeChangeNotifierProviderFamily(create);
  }
}
