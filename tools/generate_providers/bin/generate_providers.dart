// ignore_for_file: avoid_print
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

const matrix = Tuple3(
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
/// {@endtemplate}''';

bool _didAddFamilyTemplate = false;

String familyDoc() {
  if (_didAddFamilyTemplate) {
    return '/// {@macro riverpod.family}';
  }
  _didAddFamilyTemplate = true;
  return _familyDoc;
}

void main() {
  print("import 'package:state_notifier/state_notifier.dart';\n");
  print("import 'internals.dart';\n");
  for (final obj in generateAll()) {
    print(obj.toString());
  }
}

Iterable<Object> generateAll() sync* {
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
        second is StateType &&
        third is ProviderType &&
        (first == DisposeType.none || second != StateType.state)) {
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
      if (item1 == DisposeType.none && item2 != StateType.state) {
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
    return ${configs.providerName}(create);
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
