import 'package:state_notifier/state_notifier.dart';

import 'internals.dart';

class StateProviderBuilder {
  const StateProviderBuilder();

  StateProvider<T> call<T>(
    T Function(ProviderReference ref) create, {
    String name,
  }) {
    return StateProvider(create, name: name);
  }

  StateProviderFamilyBuilder get family => const StateProviderFamilyBuilder();
}

class StateProviderFamilyBuilder {
  const StateProviderFamilyBuilder();

  StateProviderFamily<T, Value> call<T, Value>(
    T Function(ProviderReference ref, Value value) create, {
    String name,
  }) {
    return StateProviderFamily(create);
  }

  
}

class StateNotifierProviderBuilder {
  const StateNotifierProviderBuilder();

  StateNotifierProvider<T> call<T extends StateNotifier<dynamic>>(
    T Function(ProviderReference ref) create, {
    String name,
  }) {
    return StateNotifierProvider(create, name: name);
  }

  AutoDisposeStateNotifierProviderBuilder get autoDispose => const AutoDisposeStateNotifierProviderBuilder();
  StateNotifierProviderFamilyBuilder get family => const StateNotifierProviderFamilyBuilder();
}

class StateNotifierProviderFamilyBuilder {
  const StateNotifierProviderFamilyBuilder();

  StateNotifierProviderFamily<T, Value> call<T extends StateNotifier<dynamic>, Value>(
    T Function(ProviderReference ref, Value value) create, {
    String name,
  }) {
    return StateNotifierProviderFamily(create);
  }

  AutoDisposeStateNotifierProviderFamilyBuilder get autoDispose => const AutoDisposeStateNotifierProviderFamilyBuilder();
}

class ProviderBuilder {
  const ProviderBuilder();

  Provider<T> call<T>(
    T Function(ProviderReference ref) create, {
    String name,
  }) {
    return Provider(create, name: name);
  }

  AutoDisposeProviderBuilder get autoDispose => const AutoDisposeProviderBuilder();
  ProviderFamilyBuilder get family => const ProviderFamilyBuilder();
}

class ProviderFamilyBuilder {
  const ProviderFamilyBuilder();

  ProviderFamily<T, Value> call<T, Value>(
    T Function(ProviderReference ref, Value value) create, {
    String name,
  }) {
    return ProviderFamily(create);
  }

  AutoDisposeProviderFamilyBuilder get autoDispose => const AutoDisposeProviderFamilyBuilder();
}

class FutureProviderBuilder {
  const FutureProviderBuilder();

  FutureProvider<T> call<T>(
    Future<T> Function(ProviderReference ref) create, {
    String name,
  }) {
    return FutureProvider(create, name: name);
  }

  AutoDisposeFutureProviderBuilder get autoDispose => const AutoDisposeFutureProviderBuilder();
  FutureProviderFamilyBuilder get family => const FutureProviderFamilyBuilder();
}

class FutureProviderFamilyBuilder {
  const FutureProviderFamilyBuilder();

  FutureProviderFamily<T, Value> call<T, Value>(
    Future<T> Function(ProviderReference ref, Value value) create, {
    String name,
  }) {
    return FutureProviderFamily(create);
  }

  AutoDisposeFutureProviderFamilyBuilder get autoDispose => const AutoDisposeFutureProviderFamilyBuilder();
}

class StreamProviderBuilder {
  const StreamProviderBuilder();

  StreamProvider<T> call<T>(
    Stream<T> Function(ProviderReference ref) create, {
    String name,
  }) {
    return StreamProvider(create, name: name);
  }

  AutoDisposeStreamProviderBuilder get autoDispose => const AutoDisposeStreamProviderBuilder();
  StreamProviderFamilyBuilder get family => const StreamProviderFamilyBuilder();
}

class StreamProviderFamilyBuilder {
  const StreamProviderFamilyBuilder();

  StreamProviderFamily<T, Value> call<T, Value>(
    Stream<T> Function(ProviderReference ref, Value value) create, {
    String name,
  }) {
    return StreamProviderFamily(create);
  }

  AutoDisposeStreamProviderFamilyBuilder get autoDispose => const AutoDisposeStreamProviderFamilyBuilder();
}

class AutoDisposeStateNotifierProviderBuilder {
  const AutoDisposeStateNotifierProviderBuilder();

  AutoDisposeStateNotifierProvider<T> call<T extends StateNotifier<dynamic>>(
    T Function(AutoDisposeProviderReference ref) create, {
    String name,
  }) {
    return AutoDisposeStateNotifierProvider(create, name: name);
  }

  AutoDisposeStateNotifierProviderFamilyBuilder get family => const AutoDisposeStateNotifierProviderFamilyBuilder();
}

class AutoDisposeStateNotifierProviderFamilyBuilder {
  const AutoDisposeStateNotifierProviderFamilyBuilder();

  AutoDisposeStateNotifierProviderFamily<T, Value> call<T extends StateNotifier<dynamic>, Value>(
    T Function(AutoDisposeProviderReference ref, Value value) create, {
    String name,
  }) {
    return AutoDisposeStateNotifierProviderFamily(create);
  }

  
}

class AutoDisposeProviderBuilder {
  const AutoDisposeProviderBuilder();

  AutoDisposeProvider<T> call<T>(
    T Function(AutoDisposeProviderReference ref) create, {
    String name,
  }) {
    return AutoDisposeProvider(create, name: name);
  }

  AutoDisposeProviderFamilyBuilder get family => const AutoDisposeProviderFamilyBuilder();
}

class AutoDisposeProviderFamilyBuilder {
  const AutoDisposeProviderFamilyBuilder();

  AutoDisposeProviderFamily<T, Value> call<T, Value>(
    T Function(AutoDisposeProviderReference ref, Value value) create, {
    String name,
  }) {
    return AutoDisposeProviderFamily(create);
  }

  
}

class AutoDisposeFutureProviderBuilder {
  const AutoDisposeFutureProviderBuilder();

  AutoDisposeFutureProvider<T> call<T>(
    Future<T> Function(AutoDisposeProviderReference ref) create, {
    String name,
  }) {
    return AutoDisposeFutureProvider(create, name: name);
  }

  AutoDisposeFutureProviderFamilyBuilder get family => const AutoDisposeFutureProviderFamilyBuilder();
}

class AutoDisposeFutureProviderFamilyBuilder {
  const AutoDisposeFutureProviderFamilyBuilder();

  AutoDisposeFutureProviderFamily<T, Value> call<T, Value>(
    Future<T> Function(AutoDisposeProviderReference ref, Value value) create, {
    String name,
  }) {
    return AutoDisposeFutureProviderFamily(create);
  }

  
}

class AutoDisposeStreamProviderBuilder {
  const AutoDisposeStreamProviderBuilder();

  AutoDisposeStreamProvider<T> call<T>(
    Stream<T> Function(AutoDisposeProviderReference ref) create, {
    String name,
  }) {
    return AutoDisposeStreamProvider(create, name: name);
  }

  AutoDisposeStreamProviderFamilyBuilder get family => const AutoDisposeStreamProviderFamilyBuilder();
}

class AutoDisposeStreamProviderFamilyBuilder {
  const AutoDisposeStreamProviderFamilyBuilder();

  AutoDisposeStreamProviderFamily<T, Value> call<T, Value>(
    Stream<T> Function(AutoDisposeProviderReference ref, Value value) create, {
    String name,
  }) {
    return AutoDisposeStreamProviderFamily(create);
  }

  
}

