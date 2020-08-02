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
  /// Marking a provider with `autoDispose` also adds an extra property on `ref`: `maintainState`.
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
  /// A group of providers that builds their value from an external parameter.
  ///
  /// Families can be useful to connect a provider with values that it doesn't
  /// have access to. For example:
  ///
  /// - Allowing a "title provider" access the `Locale`
  ///
  ///   ```dart
  ///   final titleProvider = Provider.family<String, Locale>((_, locale) {
  ///     if (locale == const Locale('en')) {
  ///       return 'English title';
  ///     } else if (locale == const Locale('fr')) {
  ///       return 'Titre Français';
  ///     }
  ///   });
  ///
  ///   // ...
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final locale = Localizations.localeOf(context);
  ///
  ///     // Obtains the title based on the current Locale.
  ///     // Will automatically update the title when the Locale changes.
  ///     final title = useProvider(titleProvider(locale));
  ///
  ///     return Text(title);
  ///   }
  ///   ```
  ///
  /// - Have a "user provider" that receives the user ID as parameter
  ///
  ///   ```dart
  ///   final userProvider = FutureProvider.family<User, int>((ref, userId) async {
  ///     final userRepository = ref.read(userRepositoryProvider);
  ///     return await userRepository.fetch(userId);
  ///   });
  ///
  ///   // ...
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     int userId; // Read the user ID from somewhere
  ///
  ///     // Read and potentially fetch the user with id `userId`.
  ///     // When `userId` changes, this will automatically update the UI
  ///     // Similarly, if two widgets tries to read `userProvider` with the same `userId`
  ///     // then the user will be fetched only once.
  ///     final user = useProvider(userProvider(userId));
  ///
  ///     return user.when(
  ///       data: (user) => Text(user.name),
  ///       loading: () => const CircularProgressIndicator(),
  ///       error: (err, stack) => const Text('error'),
  ///     );
  ///   }
  ///   ```
  ///
  /// - Connect a provider with another provider without having a direct reference on it.
  ///
  ///   ```dart
  ///   final repositoryProvider = Provider.family<String, FutureProvider<Configurations>>((ref, configurationsProvider) {
  ///     // Read a provider without knowing what that provider is.
  ///     final configurations = await ref.read(configurationsProvider);
  ///     return Repository(host: configurations.host);
  ///   });
  ///   ```
  ///
  /// ## Usage
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
  /// **NOTE**: It is totally possible to use a family with different parameters
  /// simultaneously. For example, we could use a `titleProvider` to read both
  /// the french and english translations at the same time:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   final frenchTitle = useProvider(titleProvider(const Locale('fr')));
  ///   final englishTitle = useProvider(titleProvider(const Locale('en')));
  ///
  ///   return Text('fr: $frenchTitle en: $englishTitle');
  /// }
  /// ```
  ///
  /// # Parameter restrictions
  ///
  /// For families to work correctly, it is critical for the parameter passed to
  /// a provider to have a consistent `hashCode` and `==`.
  ///
  /// Ideally the parameter should either be a primitive (bool/int/double/String),
  /// a constant (providers), or an immutable object that override `==` and `hashCode`.
  ///
  ///
  /// - **PREFER** using `family` in combination with `autoDispose` if the
  ///   parameter passed to providers is a complex object:
  ///
  ///   ```dart
  ///   final example = Provider.autoDispose.family<Value, ComplexParameter>((ref, param) {
  ///   });
  ///   ```
  ///
  ///   This ensures that there is no memory leak if the parameter changed and is
  ///   never used again.
  ///
  /// # Passing multiple parameters to a family
  ///
  /// Families have no built-in support for passing multiple values to a provider.
  ///
  /// On the other hand, that value could be _anything_ (as long as it matches with
  /// the restrictions mentioned previously).
  ///
  /// This includes:
  /// - A tuple (using `package:tuple`)
  /// - Objects generated with Freezed/built_value
  /// - Objects based on `package:equatable`
  ///
  /// Here's an example using Freezed:
  ///
  /// ```dart
  /// @freezed
  /// abstract class MyParameter with _$MyParameter {
  ///   factory MyParameter({
  ///     int userId,
  ///     Locale locale,
  ///   }) = _MyParameter;
  /// }
  ///
  /// final exampleProvider = Provider.family<Something, MyParameter>((ref, myParameter) {
  ///   print(myParameter.userId);
  ///   print(myParameter.locale);
  ///   // Do something with userId/locale
  /// })
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   int userId; // Read the user ID from somewhere
  ///   final locale = Localizations.localeOf(context);
  ///
  ///   final something = useProvider(
  ///     exampleProvider(MyParameter(userId: userId, locale: locale)),
  ///   );
  ///
  ///   ...
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
    return ChangeNotifierProviderFamily(create, name: name);
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
    return AutoDisposeChangeNotifierProviderFamily(create, name: name);
  }
}
