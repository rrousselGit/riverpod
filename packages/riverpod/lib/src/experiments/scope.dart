part of '../framework.dart';

abstract class ScopeRef {
  T watch<T>(ProviderListenableOrScope<T> provider);
}

sealed class ProviderListenableOrScope<T> {
  /// Starts listening to this transformer
  ProviderSubscription<T> _addListener(
    Node node,
    void Function(T? previous, T next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  });
}

class Scope<T> implements ProviderListenableOrScope<T> {
  factory Scope(T Function(ScopeRef ref) create) => throw UnimplementedError();
  factory Scope.required() => throw UnimplementedError();
  static Scope<T?> optional<T>() => throw UnimplementedError();

  Override overrideWithValue(T value) => throw UnimplementedError();

  @override
  ProviderSubscription<T> _addListener(
    Node node,
    void Function(T? previous, T next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    // TODO: implement _addListener
    throw UnimplementedError();
  }
}
