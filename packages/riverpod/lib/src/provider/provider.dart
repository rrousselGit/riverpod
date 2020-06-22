import '../common.dart';
import '../framework/framework.dart';

part 'auto_dispose_provider.dart';

/// The state to a [Provider].
abstract class ProviderDependency<T> extends ProviderDependencyBase {
  /// The value exposed by [Provider].
  ///
  /// It is guaranteed to never change.
  T get value;
}

// ignore: public_member_api_docs
class ProviderDependencyImpl<T> implements ProviderDependency<T> {
  // ignore: public_member_api_docs
  ProviderDependencyImpl(this.value);

  @override
  final T value;
}

/// A provider that exposes a read-only value.
// TODO doc
class Provider<T> extends AlwaysAliveProviderBase<ProviderDependency<T>, T> {
  /// Creates an immutable value.
  Provider(this._create, {String name}) : super(name);

  final Create<T, ProviderReference> _create;

  @override
  ProviderState<T> createState() => ProviderState();
}

/// The internal state of a [Provider].
class ProviderState<T>
    extends ProviderStateBase<ProviderDependency<T>, T, Provider<T>> {
  @override
  T state;

  @override
  void initState() {
    state = provider._create(ProviderReference(this));
  }

  @override
  ProviderDependency<T> createProviderDependency() {
    return ProviderDependencyImpl(state);
  }
}

/// A group of providers that builds their value from an external parameter.
///
/// Families can be useful to connect a provider with values that it doesn't
/// have access to. For example:
///
/// - Allowing a "title provider" access the `Locale`
///
///   ```dart
///   final titleProvider = ProviderFamily<String, Locale>((_, locale) {
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
///   final userProvider = FutureProviderFamily<User, int>((ref, userId) async {
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
///   final repositoryProvider = ProviderFamily<String, FutureProvider<Configurations>>((ref, configurationsProvider) {
///     // Read a provider without knowing what that provider is.
///     final configurations = await ref.read(configurationsProvider).future;
///     return Repository(host: configurations.host);
///   });
///   ```
///
///
/// **NOTE**: It is totally possible to use a family with different parameters
/// simultaneously. For example, we could use `titleProvider` mentioned above this way:
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
/// Using a complex object that does not override `==`/`hashCode` could lead to
/// memory leak.
///
/// - **AVOID** passing heavy objects or objects that changes very often as parameters.
///
///   A parameter and its associated provider will never be removed from memory,
///   even if no-longer used (although the state of the provider may get destroyed).
///
///   This is not a problem for simple variables like a user ID, but passing the
///   entire application state as parameter could have unexpected consequences.
///
/// # Passing multiple parameters to a family
///
/// Families have no built-in support for passing multiple values to a provider.
///
/// On the other hand, that value could be _anything_ (as long as it matched with
/// the restrictions mentionned previously).
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
/// final exampleProvider = ProviderFamily<Something, MyParameter>((ref, myParameter) {
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
class ProviderFamily<Result, A> extends Family<Provider<Result>, A> {
  /// Creates a value from an external parameter
  ProviderFamily(Result Function(ProviderReference ref, A a) create)
      : super((a) => Provider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
    Result Function(ProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) => Provider<Result>((ref) => override(ref, value as A)),
    );
  }
}
