// GENERATED CODE - DO NOT MODIFY BY HAND
//
// If you need to modify this file, instead update /tools/generate_providers/bin/generate_providers.dart
//
// You can install this utility by executing:
// dart pub global activate -s path <repository_path>/tools/generate_providers
//
// You can then use it in your terminal by executing:
// generate_providers <riverpod/flutter_riverpod/hooks_riverpod> <path to builder file to update>

// ignore_for_file: invalid_use_of_internal_member

import 'package:flutter/foundation.dart';
import 'internals.dart';

/// Builds a [ChangeNotifierProvider].
class ChangeNotifierProviderBuilder {
  /// Builds a [ChangeNotifierProvider].
  const ChangeNotifierProviderBuilder();

  /// {@template riverpod.autoDispose}
  /// Marks the provider as automatically disposed when no longer listened to.
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
  /// Marking a provider with `autoDispose` also adds an extra method on `ref`: `keepAlive`.
  ///
  /// The `keepAlive` function is used to tell Riverpod that the state of the provider
  /// should be preserved even if no longer listened to.
  ///
  /// A use-case would be to set this flag to `true` after an HTTP request have
  /// completed:
  ///
  /// ```dart
  /// final myProvider = FutureProvider.autoDispose((ref) async {
  ///   final response = await httpClient.get(...);
  ///   ref.keepAlive();
  ///   return response;
  /// });
  /// ```
  ///
  /// This way, if the request failed and the UI leaves the screen then re-enters
  /// it, then the request will be performed again.
  /// But if the request completed successfully, the state will be preserved
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
  ///   ref.keepAlive();
  ///   return response;
  /// });
  /// ```
  /// {@endtemplate}
  ChangeNotifierProvider<Notifier> call<Notifier extends ChangeNotifier?>(
    // ignore: deprecated_member_use_from_same_package
    Create<Notifier, ChangeNotifierProviderRef<Notifier>> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return ChangeNotifierProvider<Notifier>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  ///   final titleFamily = Provider.family<String, Locale>((ref, locale) {
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
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     final locale = Localizations.localeOf(context);
  ///
  ///     // Obtains the title based on the current Locale.
  ///     // Will automatically update the title when the Locale changes.
  ///     final title = ref.watch(titleFamily(locale));
  ///
  ///     return Text(title);
  ///   }
  ///   ```
  ///
  /// - Have a "user provider" that receives the user ID as a parameter
  ///
  ///   ```dart
  ///   final userFamily = FutureProvider.family<User, int>((ref, userId) async {
  ///     final userRepository = ref.read(userRepositoryProvider);
  ///     return await userRepository.fetch(userId);
  ///   });
  ///
  ///   // ...
  ///
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     int userId; // Read the user ID from somewhere
  ///
  ///     // Read and potentially fetch the user with id `userId`.
  ///     // When `userId` changes, this will automatically update the UI
  ///     // Similarly, if two widgets tries to read `userFamily` with the same `userId`
  ///     // then the user will be fetched only once.
  ///     final user = ref.watch(userFamily(userId));
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
  ///     final configurations = await ref.read(configurationsProvider.future);
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
  /// a `Message` from its ID:
  ///
  /// ```dart
  /// final messagesFamily = FutureProvider.family<Message, String>((ref, id) async {
  ///   return dio.get('http://my_api.dev/messages/$id');
  /// });
  /// ```
  ///
  /// Then, when using our `messagesFamily` provider, the syntax is slightly modified.
  /// The usual:
  ///
  /// ```dart
  /// Widget build(BuildContext context, WidgetRef ref) {
  ///   // Error – messagesFamily is not a provider
  ///   final response = ref.watch(messagesFamily);
  /// }
  /// ```
  ///
  /// will not work anymore.
  /// Instead, we need to pass a parameter to `messagesFamily`:
  ///
  /// ```dart
  /// Widget build(BuildContext context, WidgetRef ref) {
  ///   final response = ref.watch(messagesFamily('id'));
  /// }
  /// ```
  ///
  /// **NOTE**: It is totally possible to use a family with different parameters
  /// simultaneously. For example, we could use a `titleFamily` to read both
  /// the french and english translations at the same time:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context, WidgetRef ref) {
  ///   final frenchTitle = ref.watch(titleFamily(const Locale('fr')));
  ///   final englishTitle = ref.watch(titleFamily(const Locale('en')));
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
  /// This includes:
  /// - A tuple (using `package:tuple`)
  /// - Objects generated with Freezed/built_value, such as:
  ///   ```dart
  ///   @freezed
  ///   abstract class MyParameter with _$MyParameter {
  ///     factory MyParameter({
  ///       required int userId,
  ///       required Locale locale,
  ///     }) = _MyParameter;
  ///   }
  ///
  ///   final exampleProvider = Provider.family<Something, MyParameter>((ref, myParameter) {
  ///     print(myParameter.userId);
  ///     print(myParameter.locale);
  ///     // Do something with userId/locale
  ///   });
  ///
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     int userId; // Read the user ID from somewhere
  ///     final locale = Localizations.localeOf(context);
  ///
  ///     final something = ref.watch(
  ///       exampleProvider(MyParameter(userId: userId, locale: locale)),
  ///     );
  ///   }
  ///   ```
  ///
  /// - Objects based on `package:equatable`, such as:
  ///   ```dart
  ///   class MyParameter extends Equatable  {
  ///     factory MyParameter({
  ///       required this.userId,
  ///       requires this.locale,
  ///     });
  ///
  ///     final int userId;
  ///     final Local locale;
  ///
  ///     @override
  ///     List<Object> get props => [userId, locale];
  ///   }
  ///
  ///   final exampleProvider = Provider.family<Something, MyParameter>((ref, myParameter) {
  ///     print(myParameter.userId);
  ///     print(myParameter.locale);
  ///     // Do something with userId/locale
  ///   });
  ///
  ///   @override
  ///   Widget build(BuildContext context, WidgetRef ref) {
  ///     int userId; // Read the user ID from somewhere
  ///     final locale = Localizations.localeOf(context);
  ///
  ///     final something = ref.watch(
  ///       exampleProvider(MyParameter(userId: userId, locale: locale)),
  ///     );
  ///   }
  ///   ```
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
  ChangeNotifierProviderFamily<Notifier, Arg>
      call<Notifier extends ChangeNotifier?, Arg>(
    // ignore: deprecated_member_use_from_same_package
    FamilyCreate<Notifier, ChangeNotifierProviderRef<Notifier>, Arg> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return ChangeNotifierProviderFamily<Notifier, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  AutoDisposeChangeNotifierProvider<Notifier>
      call<Notifier extends ChangeNotifier?>(
    // ignore: deprecated_member_use_from_same_package
    Create<Notifier, AutoDisposeChangeNotifierProviderRef<Notifier>> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeChangeNotifierProvider<Notifier>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  AutoDisposeChangeNotifierProviderFamily<Notifier, Arg>
      call<Notifier extends ChangeNotifier?, Arg>(
    // ignore: deprecated_member_use_from_same_package
    FamilyCreate<Notifier, AutoDisposeChangeNotifierProviderRef<Notifier>, Arg>
        create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeChangeNotifierProviderFamily<Notifier, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }
}
