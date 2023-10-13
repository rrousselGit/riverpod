// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
class MyObserver extends ProviderObserver {
  void handleValue(Object? value) {
    if (value is AsyncError) {
      print('Error: ${value.error}');
    }
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    handleValue(value);
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    handleValue(newValue);
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    print('error: $error');
  }
}
