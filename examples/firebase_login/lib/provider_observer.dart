import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// {@template app_provider_observer}
/// Custom instance of [ProviderObserver] which logs
/// all events happening in the provider tree.
/// {@endtemplate}
class AppProviderObserver extends ProviderObserver {
  /// {@macro app_provider_observer}
  const AppProviderObserver();

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    super.didUpdateProvider(provider, previousValue, newValue, container);
    log(
      'Provider: ${provider.name ?? provider.runtimeType}, previous value: '
      '$previousValue, current value: $newValue',
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    super.providerDidFail(provider, error, stackTrace, container);
    log(
      'Provider ${provider.name ?? provider.runtimeType}, error: $error, '
      'stackTrace: $stackTrace',
    );
  }
}
