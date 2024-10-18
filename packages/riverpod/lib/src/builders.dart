// GENERATED CODE - DO NOT MODIFY BY HAND
//
// If you need to modify this file, instead update /tools/generate_providers/bin/generate_providers.dart
//
// You can install this utility by executing:
// dart pub global activate -s path <repository_path>/tools/generate_providers
//
// You can then use it in your terminal by executing:
// generate_providers <riverpod/flutter_riverpod/hooks_riverpod> <path to builder file to update>

import 'dart:async';
import 'package:state_notifier/state_notifier.dart';

import 'internals.dart';

/// Builds a [AsyncNotifierProvider].
class AsyncNotifierProviderBuilder {
  /// Builds a [AsyncNotifierProvider].
  const AsyncNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AsyncNotifierProvider<NotifierT, T>
      call<NotifierT extends AsyncNotifier<T>, T>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AsyncNotifierProvider<NotifierT, T>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeAsyncNotifierProviderBuilder get autoDispose {
    return const AutoDisposeAsyncNotifierProviderBuilder();
  }

  /// {@macro riverpod.family}
  AsyncNotifierProviderFamilyBuilder get family {
    return const AsyncNotifierProviderFamilyBuilder();
  }
}

/// Builds a [AsyncNotifierProviderFamily].
class AsyncNotifierProviderFamilyBuilder {
  /// Builds a [AsyncNotifierProviderFamily].
  const AsyncNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  AsyncNotifierProviderFamily<NotifierT, T, Arg>
      call<NotifierT extends FamilyAsyncNotifier<T, Arg>, T, Arg>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AsyncNotifierProviderFamily<NotifierT, T, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeAsyncNotifierProviderFamilyBuilder get autoDispose {
    return const AutoDisposeAsyncNotifierProviderFamilyBuilder();
  }
}

/// Builds a [AutoDisposeAsyncNotifierProvider].
class AutoDisposeAsyncNotifierProviderBuilder {
  /// Builds a [AutoDisposeAsyncNotifierProvider].
  const AutoDisposeAsyncNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeAsyncNotifierProvider<NotifierT, T>
      call<NotifierT extends AutoDisposeAsyncNotifier<T>, T>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeAsyncNotifierProvider<NotifierT, T>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeAsyncNotifierProviderFamilyBuilder get family {
    return const AutoDisposeAsyncNotifierProviderFamilyBuilder();
  }
}

/// Builds a [AutoDisposeAsyncNotifierProviderFamily].
class AutoDisposeAsyncNotifierProviderFamilyBuilder {
  /// Builds a [AutoDisposeAsyncNotifierProviderFamily].
  const AutoDisposeAsyncNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  AutoDisposeAsyncNotifierProviderFamily<NotifierT, T, Arg>
      call<NotifierT extends AutoDisposeFamilyAsyncNotifier<T, Arg>, T, Arg>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeAsyncNotifierProviderFamily<NotifierT, T, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }
}

/// Builds a [NotifierProvider].
class NotifierProviderBuilder {
  /// Builds a [NotifierProvider].
  const NotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  NotifierProvider<NotifierT, State>
      call<NotifierT extends Notifier<State>, State>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return NotifierProvider<NotifierT, State>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeNotifierProviderBuilder get autoDispose {
    return const AutoDisposeNotifierProviderBuilder();
  }

  /// {@macro riverpod.family}
  NotifierProviderFamilyBuilder get family {
    return const NotifierProviderFamilyBuilder();
  }
}

/// Builds a [NotifierProviderFamily].
class NotifierProviderFamilyBuilder {
  /// Builds a [NotifierProviderFamily].
  const NotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  NotifierProviderFamily<NotifierT, State, Arg>
      call<NotifierT extends FamilyNotifier<State, Arg>, State, Arg>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return NotifierProviderFamily<NotifierT, State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeNotifierProviderFamilyBuilder get autoDispose {
    return const AutoDisposeNotifierProviderFamilyBuilder();
  }
}

/// Builds a [AutoDisposeNotifierProvider].
class AutoDisposeNotifierProviderBuilder {
  /// Builds a [AutoDisposeNotifierProvider].
  const AutoDisposeNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeNotifierProvider<NotifierT, State>
      call<NotifierT extends AutoDisposeNotifier<State>, State>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeNotifierProvider<NotifierT, State>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeNotifierProviderFamilyBuilder get family {
    return const AutoDisposeNotifierProviderFamilyBuilder();
  }
}

/// Builds a [AutoDisposeNotifierProviderFamily].
class AutoDisposeNotifierProviderFamilyBuilder {
  /// Builds a [AutoDisposeNotifierProviderFamily].
  const AutoDisposeNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  AutoDisposeNotifierProviderFamily<NotifierT, State, Arg>
      call<NotifierT extends AutoDisposeFamilyNotifier<State, Arg>, State, Arg>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeNotifierProviderFamily<NotifierT, State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }
}

/// Builds a [StreamNotifierProvider].
class StreamNotifierProviderBuilder {
  /// Builds a [StreamNotifierProvider].
  const StreamNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  StreamNotifierProvider<NotifierT, T>
      call<NotifierT extends StreamNotifier<T>, T>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return StreamNotifierProvider<NotifierT, T>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStreamNotifierProviderBuilder get autoDispose {
    return const AutoDisposeStreamNotifierProviderBuilder();
  }

  /// {@macro riverpod.family}
  StreamNotifierProviderFamilyBuilder get family {
    return const StreamNotifierProviderFamilyBuilder();
  }
}

/// Builds a [StreamNotifierProviderFamily].
class StreamNotifierProviderFamilyBuilder {
  /// Builds a [StreamNotifierProviderFamily].
  const StreamNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StreamNotifierProviderFamily<NotifierT, T, Arg>
      call<NotifierT extends FamilyStreamNotifier<T, Arg>, T, Arg>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return StreamNotifierProviderFamily<NotifierT, T, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStreamNotifierProviderFamilyBuilder get autoDispose {
    return const AutoDisposeStreamNotifierProviderFamilyBuilder();
  }
}

/// Builds a [AutoDisposeStreamNotifierProvider].
class AutoDisposeStreamNotifierProviderBuilder {
  /// Builds a [AutoDisposeStreamNotifierProvider].
  const AutoDisposeStreamNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeStreamNotifierProvider<NotifierT, T>
      call<NotifierT extends AutoDisposeStreamNotifier<T>, T>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeStreamNotifierProvider<NotifierT, T>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeStreamNotifierProviderFamilyBuilder get family {
    return const AutoDisposeStreamNotifierProviderFamilyBuilder();
  }
}

/// Builds a [AutoDisposeStreamNotifierProviderFamily].
class AutoDisposeStreamNotifierProviderFamilyBuilder {
  /// Builds a [AutoDisposeStreamNotifierProviderFamily].
  const AutoDisposeStreamNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  AutoDisposeStreamNotifierProviderFamily<NotifierT, T, Arg>
      call<NotifierT extends AutoDisposeFamilyStreamNotifier<T, Arg>, T, Arg>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeStreamNotifierProviderFamily<NotifierT, T, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }
}

/// Builds a [StateProvider].
class StateProviderBuilder {
  /// Builds a [StateProvider].
  const StateProviderBuilder();

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
  StateProvider<State> call<State>(
    // ignore: deprecated_member_use_from_same_package
    Create<State, StateProviderRef<State>> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return StateProvider<State>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStateProviderBuilder get autoDispose {
    return const AutoDisposeStateProviderBuilder();
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
  StateProviderFamilyBuilder get family {
    return const StateProviderFamilyBuilder();
  }
}

/// Builds a [StateProviderFamily].
class StateProviderFamilyBuilder {
  /// Builds a [StateProviderFamily].
  const StateProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StateProviderFamily<State, Arg> call<State, Arg>(
    // ignore: deprecated_member_use_from_same_package
    FamilyCreate<State, StateProviderRef<State>, Arg> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return StateProviderFamily<State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStateProviderFamilyBuilder get autoDispose {
    return const AutoDisposeStateProviderFamilyBuilder();
  }
}

/// Builds a [StateNotifierProvider].
class StateNotifierProviderBuilder {
  /// Builds a [StateNotifierProvider].
  const StateNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  StateNotifierProvider<Notifier, State>
      call<Notifier extends StateNotifier<State>, State>(
    // ignore: deprecated_member_use_from_same_package
    Create<Notifier, StateNotifierProviderRef<Notifier, State>> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return StateNotifierProvider<Notifier, State>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  StateNotifierProviderFamily<Notifier, State, Arg>
      call<Notifier extends StateNotifier<State>, State, Arg>(
    // ignore: deprecated_member_use_from_same_package
    FamilyCreate<Notifier, StateNotifierProviderRef<Notifier, State>, Arg>
        create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return StateNotifierProviderFamily<Notifier, State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  Provider<State> call<State>(
    // ignore: deprecated_member_use_from_same_package
    Create<State, ProviderRef<State>> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return Provider<State>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  ProviderFamily<State, Arg> call<State, Arg>(
    // ignore: deprecated_member_use_from_same_package
    FamilyCreate<State, ProviderRef<State>, Arg> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return ProviderFamily<State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  FutureProvider<State> call<State>(
    // ignore: deprecated_member_use_from_same_package
    Create<FutureOr<State>, FutureProviderRef<State>> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return FutureProvider<State>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  FutureProviderFamily<State, Arg> call<State, Arg>(
    // ignore: deprecated_member_use_from_same_package
    FamilyCreate<FutureOr<State>, FutureProviderRef<State>, Arg> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return FutureProviderFamily<State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  StreamProvider<State> call<State>(
    // ignore: deprecated_member_use_from_same_package
    Create<Stream<State>, StreamProviderRef<State>> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return StreamProvider<State>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  StreamProviderFamily<State, Arg> call<State, Arg>(
    // ignore: deprecated_member_use_from_same_package
    FamilyCreate<Stream<State>, StreamProviderRef<State>, Arg> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return StreamProviderFamily<State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStreamProviderFamilyBuilder get autoDispose {
    return const AutoDisposeStreamProviderFamilyBuilder();
  }
}

/// Builds a [AutoDisposeStateProvider].
class AutoDisposeStateProviderBuilder {
  /// Builds a [AutoDisposeStateProvider].
  const AutoDisposeStateProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeStateProvider<State> call<State>(
    // ignore: deprecated_member_use_from_same_package
    Create<State, AutoDisposeStateProviderRef<State>> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeStateProvider<State>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeStateProviderFamilyBuilder get family {
    return const AutoDisposeStateProviderFamilyBuilder();
  }
}

/// Builds a [AutoDisposeStateProviderFamily].
class AutoDisposeStateProviderFamilyBuilder {
  /// Builds a [AutoDisposeStateProviderFamily].
  const AutoDisposeStateProviderFamilyBuilder();

  /// {@macro riverpod.family}
  AutoDisposeStateProviderFamily<State, Arg> call<State, Arg>(
    // ignore: deprecated_member_use_from_same_package
    FamilyCreate<State, AutoDisposeStateProviderRef<State>, Arg> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeStateProviderFamily<State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }
}

/// Builds a [AutoDisposeStateNotifierProvider].
class AutoDisposeStateNotifierProviderBuilder {
  /// Builds a [AutoDisposeStateNotifierProvider].
  const AutoDisposeStateNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeStateNotifierProvider<Notifier, State>
      call<Notifier extends StateNotifier<State>, State>(
    // ignore: deprecated_member_use_from_same_package
    Create<Notifier, AutoDisposeStateNotifierProviderRef<Notifier, State>>
        create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeStateNotifierProvider<Notifier, State>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  AutoDisposeStateNotifierProviderFamily<Notifier, State, Arg>
      call<Notifier extends StateNotifier<State>, State, Arg>(
    // ignore: deprecated_member_use_from_same_package
    FamilyCreate<Notifier, AutoDisposeStateNotifierProviderRef<Notifier, State>,
            Arg>
        create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeStateNotifierProviderFamily<Notifier, State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }
}

/// Builds a [AutoDisposeProvider].
class AutoDisposeProviderBuilder {
  /// Builds a [AutoDisposeProvider].
  const AutoDisposeProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeProvider<State> call<State>(
    // ignore: deprecated_member_use_from_same_package
    Create<State, AutoDisposeProviderRef<State>> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeProvider<State>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  AutoDisposeProviderFamily<State, Arg> call<State, Arg>(
    // ignore: deprecated_member_use_from_same_package
    FamilyCreate<State, AutoDisposeProviderRef<State>, Arg> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeProviderFamily<State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }
}

/// Builds a [AutoDisposeFutureProvider].
class AutoDisposeFutureProviderBuilder {
  /// Builds a [AutoDisposeFutureProvider].
  const AutoDisposeFutureProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeFutureProvider<State> call<State>(
    // ignore: deprecated_member_use_from_same_package
    Create<FutureOr<State>, AutoDisposeFutureProviderRef<State>> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeFutureProvider<State>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  AutoDisposeFutureProviderFamily<State, Arg> call<State, Arg>(
    // ignore: deprecated_member_use_from_same_package
    FamilyCreate<FutureOr<State>, AutoDisposeFutureProviderRef<State>, Arg>
        create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeFutureProviderFamily<State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }
}

/// Builds a [AutoDisposeStreamProvider].
class AutoDisposeStreamProviderBuilder {
  /// Builds a [AutoDisposeStreamProvider].
  const AutoDisposeStreamProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AutoDisposeStreamProvider<State> call<State>(
    // ignore: deprecated_member_use_from_same_package
    Create<Stream<State>, AutoDisposeStreamProviderRef<State>> create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeStreamProvider<State>(
      create,
      name: name,
      dependencies: dependencies,
    );
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
  AutoDisposeStreamProviderFamily<State, Arg> call<State, Arg>(
    // ignore: deprecated_member_use_from_same_package
    FamilyCreate<Stream<State>, AutoDisposeStreamProviderRef<State>, Arg>
        create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
  }) {
    return AutoDisposeStreamProviderFamily<State, Arg>(
      create,
      name: name,
      dependencies: dependencies,
    );
  }
}
