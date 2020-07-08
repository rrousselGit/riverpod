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
        yield 'AutoDispose${providerName}Builder get autoDispose => const AutoDispose${providerName}Builder();';
      }
      // if (item2 == StateType.none) {
      //   String nameFor(StateType type) {
      //     final clone = Tuple3(item1, type, item3);
      //     return clone.providerName;
      //   }

      // if (matrix.item2.contains(StateType.future)) {
      //   yield 'final future = const ${nameFor(StateType.future)}Builder();';
      // }
      // if (matrix.item2.contains(StateType.stateNotifier)) {
      //   yield 'final stateNotifier = const ${nameFor(StateType.stateNotifier)}Builder();';
      // }
      // if (item1 != DisposeType.autoDispose &&
      //     matrix.item2.contains(StateType.state)) {
      //   yield 'final state = const ${nameFor(StateType.state)}Builder();';
      // }
      // if (matrix.item2.contains(StateType.stream)) {
      //   yield 'final stream = const ${nameFor(StateType.stream)}Builder();';
      // }
      // if (matrix.item2.contains(StateType.changeNotifier)) {
      //   yield 'final changeNotifier = const ${nameFor(StateType.changeNotifier)}Builder();';
      // }
      // }
      if (item3 == ProviderType.single) {
        yield '${providerName}FamilyBuilder get family => const ${providerName}FamilyBuilder();';
      }
    }

    return other().join('\n  ');
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
class ${configs.providerName}Builder {
  const ${configs.providerName}Builder();

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
class ${configs.providerName}Builder {
  const ${configs.providerName}Builder();

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
