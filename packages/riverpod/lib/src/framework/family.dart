part of 'framework.dart';

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
///     final userRepository = ref.dependOn(userRepositoryProvider);
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
///     final configurations = await ref.dependOn(configurationsProvider).future;
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
/// For families to work correctly, it is critical that the parameter passed to
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
abstract class Family<P extends ProviderBase, A> {
  Family(this._create);

  final P Function(A value) _create;
  final _cache = <A, P>{};

  /// Create a provider from an external value.
  ///
  /// That external value should be immutable and preferrably override `==`/`hashCode`.
  /// See the documentation of [ProviderFamily] for more informations.
  P call(A value) {
    return _cache.putIfAbsent(value, () {
      final provider = _create(value);
      assert(
        provider._family == null,
        'The provider created already belongs to a Family',
      );
      return provider
        .._family = this
        .._parameter = value;
    });
  }
}

class FamilyOverride implements Override {
  FamilyOverride(this._family, this.createOverride);

  final ProviderBase Function(Object value) createOverride;
  final Family _family;
}
