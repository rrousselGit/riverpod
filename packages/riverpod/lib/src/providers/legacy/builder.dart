// GENERATED CODE - DO NOT MODIFY BY HAND
//
// If you need to modify this file, instead update /tools/generate_providers/bin/generate_providers.dart
//
// You can install this utility by executing:
// dart pub global activate -s path <repository_path>/tools/generate_providers
//
// You can then use it in your terminal by executing:
// generate_providers <riverpod/riverpod_legacy/flutter_riverpod> <path to builder file to update>

import 'package:meta/meta.dart';

import '../../internals.dart';

@internal
final class StateProviderFamilyBuilder {
  const StateProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StateProviderFamily<StateT, ArgT> call<StateT, ArgT>(
    StateT Function(Ref ref, ArgT param) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
    bool isAutoDispose = false,
  }) {
    return StateProviderFamily<StateT, ArgT>(
      create,
      name: name,
      isAutoDispose: isAutoDispose,
      dependencies: dependencies,
      retry: retry,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStateProviderFamilyBuilder get autoDispose =>
      const AutoDisposeStateProviderFamilyBuilder();
}

@internal
final class AutoDisposeStateProviderBuilder {
  const AutoDisposeStateProviderBuilder();

  /// {@macro riverpod.family}
  StateProvider<StateT> call<StateT>(
    StateT Function(Ref ref) create, {
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
final class AutoDisposeStateProviderFamilyBuilder {
  const AutoDisposeStateProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StateProviderFamily<StateT, ArgT> call<StateT, ArgT>(
    StateT Function(Ref ref, ArgT param) create, {
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
final class StateNotifierProviderFamilyBuilder {
  const StateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StateNotifierProviderFamily<NotifierT, StateT, ArgT>
  call<NotifierT extends StateNotifier<StateT>, StateT, ArgT>(
    NotifierT Function(Ref ref, ArgT param) create, {
    String? name,
    Iterable<ProviderOrFamily>? dependencies,
    Retry? retry,
    bool isAutoDispose = false,
  }) {
    return StateNotifierProviderFamily<NotifierT, StateT, ArgT>(
      create,
      name: name,
      isAutoDispose: isAutoDispose,
      dependencies: dependencies,
      retry: retry,
    );
  }

  /// {@macro riverpod.autoDispose}
  AutoDisposeStateNotifierProviderFamilyBuilder get autoDispose =>
      const AutoDisposeStateNotifierProviderFamilyBuilder();
}

@internal
final class AutoDisposeStateNotifierProviderBuilder {
  const AutoDisposeStateNotifierProviderBuilder();

  /// {@macro riverpod.family}
  StateNotifierProvider<NotifierT, StateT>
  call<NotifierT extends StateNotifier<StateT>, StateT>(
    NotifierT Function(Ref ref) create, {
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
final class AutoDisposeStateNotifierProviderFamilyBuilder {
  const AutoDisposeStateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.family}
  StateNotifierProviderFamily<NotifierT, StateT, ArgT>
  call<NotifierT extends StateNotifier<StateT>, StateT, ArgT>(
    NotifierT Function(Ref ref, ArgT param) create, {
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
