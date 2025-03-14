part of 'providers.dart';

sealed class ProviderListenableOrScope<T> {}

abstract class ScopeRef {
  T watch<T>(ProviderListenableOrScope<T> provider);
}

class _ScopeError extends Error {
  _ScopeError();

  @override
  String toString() {
    return 'A Scope was used with no defined behavior. '
        'Either write Scope((ref) => ...), '
        'or override it using ProviderScope(overrides: [scope.overrideWithValue(...)])';
  }
}

class Scope<T> implements ProviderListenableOrScope<T> {
  factory Scope(T Function(ScopeRef ref) create) => throw UnimplementedError();
  static Scope<T?> optional<T>() => throw UnimplementedError();
  factory Scope.required() => throw UnimplementedError();

  Override overrideWithValue(T value) => throw UnimplementedError();
}
