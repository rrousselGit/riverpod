// ignore_for_file: avoid_print
import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:trotter/trotter.dart';
import 'package:tuple/tuple.dart';

enum DisposeType {
  none,
  autoDispose,
}

const disposeLabel = {
  DisposeType.none: '',
  DisposeType.autoDispose: 'AutoDispose',
};

class StateDetails {
  StateDetails({
    required this.className,
    required this.ref,
    required this.constraints,
    required this.generics,
    required this.createType,
  });

  final String className;
  final String ref;
  final String constraints;
  final String generics;
  final String createType;
}

enum ProviderType {
  single,
  family,
}

const providerLabel = {
  ProviderType.single: '',
  ProviderType.family: 'Family',
};

const _autoDisposeDoc = '''
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
/// {@endtemplate}''';

bool _didAddAutoDisposeTemplate = false;

String autoDisposeDoc() {
  if (_didAddAutoDisposeTemplate) {
    return '/// {@macro riverpod.autoDispose}';
  }
  _didAddAutoDisposeTemplate = true;
  return _autoDisposeDoc;
}

const _familyDoc = r'''
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
/// {@endtemplate}''';

bool _didAddFamilyTemplate = false;

String familyDoc() {
  if (_didAddFamilyTemplate) {
    return '/// {@macro riverpod.family}';
  }
  _didAddFamilyTemplate = true;
  return _familyDoc;
}

Future<void> main(List<String> args) async {
  if (args.length != 2) {
    print('usage: generate_providers <riverpod/flutter_riverpod> file');
    return;
  }
  if (args.first != 'riverpod' && args.first != 'flutter_riverpod') {
    print('Unknown argument ${args.first}');
    return;
  }

  final file = File.fromUri(Uri.parse(args[1]));
  if (file.existsSync() && file.statSync().type != FileSystemEntityType.file) {
    print('${args[1]} is not a file');
    return;
  }

  Tuple3<List<DisposeType>, List<StateDetails>, List<ProviderType>> matrix;

  final builder = StringBuffer(
    '''
// GENERATED CODE - DO NOT MODIFY BY HAND
//
// If you need to modify this file, instead update /tools/generate_providers/bin/generate_providers.dart
//
// You can install this utility by executing:
// dart pub global activate -s path <repository_path>/tools/generate_providers
//
// You can then use it in your terminal by executing:
// generate_providers <riverpod/flutter_riverpod/hooks_riverpod> <path to builder file to update>

''',
  );

  switch (args.first) {
    case 'riverpod':
      matrix = Tuple3(
        DisposeType.values,
        [
          StateDetails(
            className: 'StateProvider',
            ref: 'StateProviderRef<State>',
            constraints: 'State',
            generics: 'State',
            createType: 'State',
          ),
          StateDetails(
            className: 'StateNotifierProvider',
            ref: 'StateNotifierProviderRef<Notifier, State>',
            constraints: 'Notifier extends StateNotifier<State>, State',
            generics: 'Notifier, State',
            createType: 'Notifier',
          ),
          StateDetails(
            className: 'Provider',
            ref: 'ProviderRef<State>',
            constraints: 'State',
            generics: 'State',
            createType: 'State',
          ),
          StateDetails(
            className: 'FutureProvider',
            ref: 'FutureProviderRef<State>',
            constraints: 'State',
            generics: 'State',
            createType: 'FutureOr<State>',
          ),
          StateDetails(
            className: 'StreamProvider',
            ref: 'StreamProviderRef<State>',
            constraints: 'State',
            generics: 'State',
            createType: 'Stream<State>',
          ),
        ],
        ProviderType.values,
      );
      builder.writeln(
        """
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
""",
      );
      break;
    case 'flutter_riverpod':
      matrix = Tuple3(
        DisposeType.values,
        [
          StateDetails(
            className: 'ChangeNotifierProvider',
            ref: 'ChangeNotifierProviderRef<Notifier>',
            constraints: 'Notifier extends ChangeNotifier?',
            generics: 'Notifier',
            createType: 'Notifier',
          ),
        ],
        ProviderType.values,
      );
      builder.writeln(
        """
import 'package:flutter/foundation.dart';
import 'internals.dart';
""",
      );
      break;
    default:
      throw UnsupportedError('Unknown package ${args.first}');
  }

  builder.writeAll(generateAll(matrix), '\n');

  await file.writeAsString(
    DartFormatter().format(builder.toString()),
  );
}

Iterable<Object> generateAll(
  Tuple3<List<DisposeType>, List<StateDetails>, List<ProviderType>> matrix,
) sync* {
  final combos = Combinations(3, <Object>[
    ...matrix.item1,
    ...matrix.item2,
    ...matrix.item3,
  ]);
  for (final permutation in combos()) {
    final first = permutation.first;
    final second = permutation[1];
    final third = permutation[2];

    if (first is DisposeType &&
        second is StateDetails &&
        third is ProviderType) {
      yield* generate(Tuple3(first, second, third), matrix);
    }
  }
}

extension on Tuple3<DisposeType, StateDetails, ProviderType> {
  String get providerName {
    return '${disposeLabel[item1]}${item2.className}${providerLabel[item3]}';
  }

  String get ref {
    switch (item1) {
      case DisposeType.autoDispose:
        return 'AutoDispose${item2.ref}';
      case DisposeType.none:
      default:
        return item2.ref;
    }
  }

  String get constraint => item2.constraints;

  String get createType => item2.createType;

  String links(
    Tuple3<List<DisposeType>, List<StateDetails>, List<ProviderType>> matrix,
  ) {
    Iterable<String> other() sync* {
      if (item1 == DisposeType.none) {
        yield '''

${autoDisposeDoc().replaceAll('///', '  ///')}
  AutoDispose${providerName}Builder get autoDispose {
    return const AutoDispose${providerName}Builder();
  }''';
      }

      if (item3 == ProviderType.single) {
        yield '''

${familyDoc().replaceAll('///', '  ///')}
  ${providerName}FamilyBuilder get family {
    return const ${providerName}FamilyBuilder();
  }''';
      }
    }

    return other().join('\n');
  }
}

Iterable<Object> generate(
  Tuple3<DisposeType, StateDetails, ProviderType> configs,
  Tuple3<List<DisposeType>, List<StateDetails>, List<ProviderType>> matrix,
) sync* {
  if (configs.item3 == ProviderType.family) {
    yield FamilyBuilder(configs, matrix);
  } else {
    yield ProviderBuilder(configs, matrix);
  }
}

class FamilyBuilder {
  FamilyBuilder(this.configs, this.matrix);
  final Tuple3<DisposeType, StateDetails, ProviderType> configs;
  final Tuple3<List<DisposeType>, List<StateDetails>, List<ProviderType>>
      matrix;

  @override
  String toString() {
    final createNamedParams = [
      'String? name',
      'Iterable<ProviderOrFamily>? dependencies',
    ].map((e) => '$e,').join();
    final providerParams = [
      'create',
      'name: name',
      'dependencies: dependencies',
    ].map((e) => '$e,').join();
    return '''
/// Builds a [${configs.providerName}].
class ${configs.providerName}Builder {
  /// Builds a [${configs.providerName}].
  const ${configs.providerName}Builder();

${familyDoc().replaceAll('///', '  ///')}
  ${configs.providerName}<${configs.item2.generics}, Arg> call<${configs.constraint}, Arg>(
    FamilyCreate<${configs.createType}, ${configs.ref}, Arg> create, { $createNamedParams }) {
    return ${configs.providerName}<${configs.item2.generics}, Arg>($providerParams);
  }
${configs.links(matrix)}
}
''';
  }
}

class ProviderBuilder {
  ProviderBuilder(this.configs, this.matrix);
  final Tuple3<DisposeType, StateDetails, ProviderType> configs;
  final Tuple3<List<DisposeType>, List<StateDetails>, List<ProviderType>>
      matrix;

  @override
  String toString() {
    final callNamedParams = [
      'String? name',
      'Iterable<ProviderOrFamily>? dependencies',
    ].map((e) => '$e,').join();
    final providerParams = [
      'create',
      'name: name',
      'dependencies: dependencies',
    ].map((e) => '$e,').join();

    return '''
/// Builds a [${configs.providerName}].
class ${configs.providerName}Builder {
  /// Builds a [${configs.providerName}].
  const ${configs.providerName}Builder();

${autoDisposeDoc().replaceAll('///', '  ///')}
  ${configs.providerName}<${configs.item2.generics}> call<${configs.constraint}>(
    Create<${configs.createType}, ${configs.ref}> create, { $callNamedParams }) {
    return ${configs.providerName}<${configs.item2.generics}>($providerParams);
  }
${configs.links(matrix)}
}
''';
  }
}
