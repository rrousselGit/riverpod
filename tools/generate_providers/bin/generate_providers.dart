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

enum StateType {
  none,
  state,
  stateNotifier,
  changeNotifier,
  future,
  stream,
}

const stateLabel = {
  StateType.none: '',
  StateType.state: 'State',
  StateType.stateNotifier: 'StateNotifier',
  StateType.changeNotifier: 'ChangeNotifier',
  StateType.future: 'Future',
  StateType.stream: 'Stream',
};

enum ProviderType {
  single,
  family,
}

const providerLabel = {
  ProviderType.single: 'Provider',
  ProviderType.family: 'ProviderFamily',
};

const _autoDisposeDoc = '''
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
///   ref.maintainState = true;
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
///   final titleFamily = Provider.family<String, Locale>((_, locale) {
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
///   Widget build(BuildContext context, ScopedReader watch) {
///     final locale = Localizations.localeOf(context);
///
///     // Obtains the title based on the current Locale.
///     // Will automatically update the title when the Locale changes.
///     final title = watch(titleFamily(locale));
///
///     return Text(title);
///   }
///   ```
///
/// - Have a "user provider" that receives the user ID as parameter
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
///   Widget build(BuildContext context, ScopedReader watch) {
///     int userId; // Read the user ID from somewhere
///
///     // Read and potentially fetch the user with id `userId`.
///     // When `userId` changes, this will automatically update the UI
///     // Similarly, if two widgets tries to read `userFamily` with the same `userId`
///     // then the user will be fetched only once.
///     final user = watch(userFamily(userId));
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
/// Widget build(BuildContext, ScopedReader watch) {
///   // Error – messagesFamily is not a provider
///   final response = watch(messagesFamily);
/// }
/// ```
///
/// will not work anymore.
/// Instead, we need to pass a parameter to `messagesFamily`:
///
/// ```dart
/// Widget build(BuildContext, ScopedReader watch) {
///   final response = watch(messagesFamily('id'));
/// }
/// ```
///
/// **NOTE**: It is totally possible to use a family with different parameters
/// simultaneously. For example, we could use a `titleFamily` to read both
/// the french and english translations at the same time:
///
/// ```dart
/// @override
/// Widget build(BuildContext context, ScopedReader watch) {
///   final frenchTitle = watch(titleFamily(const Locale('fr')));
///   final englishTitle = watch(titleFamily(const Locale('en')));
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
/// Widget build(BuildContext context, ScopedReader watch) {
///   int userId; // Read the user ID from somewhere
///   final locale = Localizations.localeOf(context);
///
///   final something = watch(
///     exampleProvider(MyParameter(userId: userId, locale: locale)),
///   );
///
///   ...
/// }
/// ```
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

  Tuple3<List<DisposeType>, List<StateType>, List<ProviderType>> matrix;

  final builder = StringBuffer();

  switch (args.first) {
    case 'riverpod':
      matrix = const Tuple3(
        DisposeType.values,
        [
          StateType.state,
          StateType.stateNotifier,
          StateType.none,
          StateType.future,
          StateType.stream,
        ],
        ProviderType.values,
      );
      builder.writeln(
        """
import 'internals.dart';
""",
      );
      break;
    case 'flutter_riverpod':
      matrix = const Tuple3(
        DisposeType.values,
        [StateType.changeNotifier],
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
      throw FallThroughError();
  }

  builder.writeAll(generateAll(matrix), '\n');

  await file.writeAsString(
    DartFormatter().format(builder.toString()),
  );
}

Iterable<Object> generateAll(
  Tuple3<List<DisposeType>, List<StateType>, List<ProviderType>> matrix,
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

    if (first is DisposeType && second is StateType && third is ProviderType) {
      yield* generate(Tuple3(first, second, third), matrix);
    }
  }
}

extension on Tuple3<DisposeType, StateType, ProviderType> {
  String get providerName {
    return '${disposeLabel[item1]}${stateLabel[item2]}${providerLabel[item3]}';
  }

  String get ref {
    switch (item1) {
      case DisposeType.autoDispose:
        return 'AutoDisposeProviderReference';
      case DisposeType.none:
      default:
        return 'ProviderReference';
    }
  }

  String get constraint {
    switch (item2) {
      case StateType.stateNotifier:
        return ' extends StateNotifier<dynamic>';
      case StateType.changeNotifier:
        return ' extends ChangeNotifier';
      default:
        return '';
    }
  }

  String get createType {
    switch (item2) {
      case StateType.future:
        return 'Future<T>';
      case StateType.stream:
        return 'Stream<T>';
      default:
        return 'T';
    }
  }

  String links(
    Tuple3<List<DisposeType>, List<StateType>, List<ProviderType>> matrix,
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
  Tuple3<DisposeType, StateType, ProviderType> configs,
  Tuple3<List<DisposeType>, List<StateType>, List<ProviderType>> matrix,
) sync* {
  if (configs.item3 == ProviderType.family) {
    yield FamilyBuilder(configs, matrix);
  } else {
    yield ProviderBuilder(configs, matrix);
  }
}

class FamilyBuilder {
  FamilyBuilder(this.configs, this.matrix);
  final Tuple3<DisposeType, StateType, ProviderType> configs;
  final Tuple3<List<DisposeType>, List<StateType>, List<ProviderType>> matrix;

  @override
  String toString() {
    return '''
/// Builds a [${configs.providerName}].
class ${configs.providerName}Builder {
  /// Builds a [${configs.providerName}].
  const ${configs.providerName}Builder();

${familyDoc().replaceAll('///', '  ///')}
  ${configs.providerName}<T, Value> call<T${configs.constraint}, Value>(
    ${configs.createType} Function(${configs.ref} ref, Value value) create, {
    String name,
  }) {
    return ${configs.providerName}(create, name: name);
  }
${configs.links(matrix)}
}
''';
  }
}

class ProviderBuilder {
  ProviderBuilder(this.configs, this.matrix);
  final Tuple3<DisposeType, StateType, ProviderType> configs;
  final Tuple3<List<DisposeType>, List<StateType>, List<ProviderType>> matrix;

  @override
  String toString() {
    return '''
/// Builds a [${configs.providerName}].
class ${configs.providerName}Builder {
  /// Builds a [${configs.providerName}].
  const ${configs.providerName}Builder();

${autoDisposeDoc().replaceAll('///', '  ///')}
  ${configs.providerName}<T> call<T${configs.constraint}>(
    ${configs.createType} Function(${configs.ref} ref) create, {
    String name,
  }) {
    return ${configs.providerName}(create, name: name);
  }
${configs.links(matrix)}
}
''';
  }
}
