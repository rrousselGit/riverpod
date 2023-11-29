part of 'framework.dart';

abstract class ProviderObserver {
  const ProviderObserver();

  void didAddProvider(
    Provider<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {}

  void providerDidFail(
    Provider<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {}

  void didUpdateProvider(
    Provider<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {}

  void didDisposeProvider(
    Provider<Object?> provider,
    ProviderContainer container,
  ) {}
}
