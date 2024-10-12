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

import 'package:meta/meta.dart';
import 'package:state_notifier/state_notifier.dart';

import 'internals.dart';

@internal
class StateProviderFamilyBuilder {
  const StateProviderFamilyBuilder();

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
  StateProviderFamily<StateT, ArgT> call<StateT, ArgT>(
    StateT Function(Ref<StateT> ref, ArgT param) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return StateProviderFamily<StateT, ArgT>(
      create,
      name: name,
      dependencies: dependencies,
      retry: retry,
    );
  }

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
  AutoDisposeStateProviderFamilyBuilder get autoDispose =>
      const AutoDisposeStateProviderFamilyBuilder();
}

@internal
class AutoDisposeStateProviderBuilder {
  const AutoDisposeStateProviderBuilder();

  /// {@macro riverpod.family}
  StateProvider<StateT> call<StateT>(
    StateT Function(Ref<StateT> ref) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return StateProvider<StateT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeStateProviderFamilyBuilder get family =>
      const AutoDisposeStateProviderFamilyBuilder();
}

@internal
class AutoDisposeStateProviderFamilyBuilder {
  const AutoDisposeStateProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StateProviderFamily<StateT, ArgT> call<StateT, ArgT>(
    StateT Function(Ref<StateT> ref, ArgT param) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return StateProviderFamily<StateT, ArgT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
    );
  }
}

@internal
class StateNotifierProviderFamilyBuilder {
  const StateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StateNotifierProviderFamily<NotifierT, StateT, ArgT>
      call<NotifierT extends StateNotifier<StateT>, StateT, ArgT>(
    NotifierT Function(Ref<StateT> ref, ArgT param) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return StateNotifierProviderFamily<NotifierT, StateT, ArgT>(
      create,
      name: name,
      dependencies: dependencies,
      retry: retry,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStateNotifierProviderFamilyBuilder get autoDispose =>
      const AutoDisposeStateNotifierProviderFamilyBuilder();
}

@internal
class AutoDisposeStateNotifierProviderBuilder {
  const AutoDisposeStateNotifierProviderBuilder();

  /// {@macro riverpod.family}
  StateNotifierProvider<NotifierT, StateT>
      call<NotifierT extends StateNotifier<StateT>, StateT>(
    NotifierT Function(Ref<StateT> ref) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return StateNotifierProvider<NotifierT, StateT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeStateNotifierProviderFamilyBuilder get family =>
      const AutoDisposeStateNotifierProviderFamilyBuilder();
}

@internal
class AutoDisposeStateNotifierProviderFamilyBuilder {
  const AutoDisposeStateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StateNotifierProviderFamily<NotifierT, StateT, ArgT>
      call<NotifierT extends StateNotifier<StateT>, StateT, ArgT>(
    NotifierT Function(Ref<StateT> ref, ArgT param) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return StateNotifierProviderFamily<NotifierT, StateT, ArgT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
    );
  }
}

@internal
class ProviderFamilyBuilder {
  const ProviderFamilyBuilder();

  /// {@macro riverpod.family}
  ProviderFamily<StateT, ArgT> call<StateT, ArgT>(
    StateT Function(Ref<StateT> ref, ArgT param) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return ProviderFamily<StateT, ArgT>(
      create,
      name: name,
      dependencies: dependencies,
      retry: retry,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeProviderFamilyBuilder get autoDispose =>
      const AutoDisposeProviderFamilyBuilder();
}

@internal
class AutoDisposeProviderBuilder {
  const AutoDisposeProviderBuilder();

  /// {@macro riverpod.family}
  Provider<StateT> call<StateT>(
    StateT Function(Ref<StateT> ref) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return Provider<StateT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeProviderFamilyBuilder get family =>
      const AutoDisposeProviderFamilyBuilder();
}

@internal
class AutoDisposeProviderFamilyBuilder {
  const AutoDisposeProviderFamilyBuilder();

  /// {@macro riverpod.family}
  ProviderFamily<StateT, ArgT> call<StateT, ArgT>(
    StateT Function(Ref<StateT> ref, ArgT param) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return ProviderFamily<StateT, ArgT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
    );
  }
}

@internal
class FutureProviderFamilyBuilder {
  const FutureProviderFamilyBuilder();

  /// {@macro riverpod.family}
  FutureProviderFamily<StateT, ArgT> call<StateT, ArgT>(
    FutureOr<StateT> Function(Ref<AsyncValue<StateT>> ref, ArgT param) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return FutureProviderFamily<StateT, ArgT>(
      create,
      name: name,
      dependencies: dependencies,
      retry: retry,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeFutureProviderFamilyBuilder get autoDispose =>
      const AutoDisposeFutureProviderFamilyBuilder();
}

@internal
class AutoDisposeFutureProviderBuilder {
  const AutoDisposeFutureProviderBuilder();

  /// {@macro riverpod.family}
  FutureProvider<StateT> call<StateT>(
    FutureOr<StateT> Function(Ref<AsyncValue<StateT>> ref) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return FutureProvider<StateT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeFutureProviderFamilyBuilder get family =>
      const AutoDisposeFutureProviderFamilyBuilder();
}

@internal
class AutoDisposeFutureProviderFamilyBuilder {
  const AutoDisposeFutureProviderFamilyBuilder();

  /// {@macro riverpod.family}
  FutureProviderFamily<StateT, ArgT> call<StateT, ArgT>(
    FutureOr<StateT> Function(Ref<AsyncValue<StateT>> ref, ArgT param) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return FutureProviderFamily<StateT, ArgT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
    );
  }
}

@internal
class StreamProviderFamilyBuilder {
  const StreamProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StreamProviderFamily<StateT, ArgT> call<StateT, ArgT>(
    Stream<StateT> Function(Ref<AsyncValue<StateT>> ref, ArgT param) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return StreamProviderFamily<StateT, ArgT>(
      create,
      name: name,
      dependencies: dependencies,
      retry: retry,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStreamProviderFamilyBuilder get autoDispose =>
      const AutoDisposeStreamProviderFamilyBuilder();
}

@internal
class AutoDisposeStreamProviderBuilder {
  const AutoDisposeStreamProviderBuilder();

  /// {@macro riverpod.family}
  StreamProvider<StateT> call<StateT>(
    Stream<StateT> Function(Ref<AsyncValue<StateT>> ref) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return StreamProvider<StateT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeStreamProviderFamilyBuilder get family =>
      const AutoDisposeStreamProviderFamilyBuilder();
}

@internal
class AutoDisposeStreamProviderFamilyBuilder {
  const AutoDisposeStreamProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StreamProviderFamily<StateT, ArgT> call<StateT, ArgT>(
    Stream<StateT> Function(Ref<AsyncValue<StateT>> ref, ArgT param) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
  }) {
    return StreamProviderFamily<StateT, ArgT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
    );
  }
}

@internal
class AutoDisposeNotifierProviderBuilder {
  const AutoDisposeNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  NotifierProvider<NotifierT, StateT>
      call<NotifierT extends Notifier<StateT>, StateT>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
    Persist? persistOptions,
    bool? shouldPersist,
  }) {
    return NotifierProvider<NotifierT, StateT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
      persistOptions: persistOptions,
      shouldPersist: shouldPersist,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeNotifierProviderFamilyBuilder get family =>
      const AutoDisposeNotifierProviderFamilyBuilder();
}

@internal
class NotifierProviderFamilyBuilder {
  const NotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  NotifierProviderFamily<NotifierT, StateT, ArgT>
      call<NotifierT extends FamilyNotifier<StateT, ArgT>, StateT, ArgT>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
    Persist? persistOptions,
    bool? shouldPersist,
  }) {
    return NotifierProviderFamily<NotifierT, StateT, ArgT>.internal(
      create,
      name: name,
      dependencies: dependencies,
      retry: retry,
      persistOptions: persistOptions,
      shouldPersist: shouldPersist,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeNotifierProviderFamilyBuilder get autoDispose =>
      const AutoDisposeNotifierProviderFamilyBuilder();
}

@internal
class AutoDisposeNotifierProviderFamilyBuilder {
  const AutoDisposeNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  NotifierProviderFamily<NotifierT, StateT, ArgT>
      call<NotifierT extends FamilyNotifier<StateT, ArgT>, StateT, ArgT>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
    Persist? persistOptions,
    bool? shouldPersist,
  }) {
    return NotifierProviderFamily<NotifierT, StateT, ArgT>.internal(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
      persistOptions: persistOptions,
      shouldPersist: shouldPersist,
    );
  }
}

@internal
class AutoDisposeStreamNotifierProviderBuilder {
  const AutoDisposeStreamNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  StreamNotifierProvider<NotifierT, StateT>
      call<NotifierT extends StreamNotifier<StateT>, StateT>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
    Persist? persistOptions,
    bool? shouldPersist,
  }) {
    return StreamNotifierProvider<NotifierT, StateT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
      persistOptions: persistOptions,
      shouldPersist: shouldPersist,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeStreamNotifierProviderFamilyBuilder get family =>
      const AutoDisposeStreamNotifierProviderFamilyBuilder();
}

@internal
class StreamNotifierProviderFamilyBuilder {
  const StreamNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  StreamNotifierProviderFamily<NotifierT, StateT, ArgT>
      call<NotifierT extends FamilyStreamNotifier<StateT, ArgT>, StateT, ArgT>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
    Persist? persistOptions,
    bool? shouldPersist,
  }) {
    return StreamNotifierProviderFamily<NotifierT, StateT, ArgT>.internal(
      create,
      name: name,
      dependencies: dependencies,
      retry: retry,
      persistOptions: persistOptions,
      shouldPersist: shouldPersist,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStreamNotifierProviderFamilyBuilder get autoDispose =>
      const AutoDisposeStreamNotifierProviderFamilyBuilder();
}

@internal
class AutoDisposeStreamNotifierProviderFamilyBuilder {
  const AutoDisposeStreamNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  StreamNotifierProviderFamily<NotifierT, StateT, ArgT>
      call<NotifierT extends FamilyStreamNotifier<StateT, ArgT>, StateT, ArgT>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
    Persist? persistOptions,
    bool? shouldPersist,
  }) {
    return StreamNotifierProviderFamily<NotifierT, StateT, ArgT>.internal(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
      persistOptions: persistOptions,
      shouldPersist: shouldPersist,
    );
  }
}

@internal
class AutoDisposeAsyncNotifierProviderBuilder {
  const AutoDisposeAsyncNotifierProviderBuilder();

  /// {@macro riverpod.autoDispose}
  AsyncNotifierProvider<NotifierT, StateT>
      call<NotifierT extends AsyncNotifier<StateT>, StateT>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
    Persist? persistOptions,
    bool? shouldPersist,
  }) {
    return AsyncNotifierProvider<NotifierT, StateT>(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
      persistOptions: persistOptions,
      shouldPersist: shouldPersist,
    );
  }

  /// {@macro riverpod.family}
  AutoDisposeAsyncNotifierProviderFamilyBuilder get family =>
      const AutoDisposeAsyncNotifierProviderFamilyBuilder();
}

@internal
class AsyncNotifierProviderFamilyBuilder {
  const AsyncNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  AsyncNotifierProviderFamily<NotifierT, StateT, ArgT>
      call<NotifierT extends FamilyAsyncNotifier<StateT, ArgT>, StateT, ArgT>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
    Persist? persistOptions,
    bool? shouldPersist,
  }) {
    return AsyncNotifierProviderFamily<NotifierT, StateT, ArgT>.internal(
      create,
      name: name,
      dependencies: dependencies,
      retry: retry,
      persistOptions: persistOptions,
      shouldPersist: shouldPersist,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeAsyncNotifierProviderFamilyBuilder get autoDispose =>
      const AutoDisposeAsyncNotifierProviderFamilyBuilder();
}

@internal
class AutoDisposeAsyncNotifierProviderFamilyBuilder {
  const AutoDisposeAsyncNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  AsyncNotifierProviderFamily<NotifierT, StateT, ArgT>
      call<NotifierT extends FamilyAsyncNotifier<StateT, ArgT>, StateT, ArgT>(
    NotifierT Function() create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
    Persist? persistOptions,
    bool? shouldPersist,
  }) {
    return AsyncNotifierProviderFamily<NotifierT, StateT, ArgT>.internal(
      create,
      name: name,
      isAutoDispose: true,
      dependencies: dependencies,
      retry: retry,
      persistOptions: persistOptions,
      shouldPersist: shouldPersist,
    );
  }
}
