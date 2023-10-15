// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:devtools_app_shared/service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

final _log = Logger('riverpod_error_logger_observer');

class ErrorLoggerObserver extends ProviderObserver {
  const ErrorLoggerObserver();

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    _maybeLogError(provider, value);
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _maybeLogError(provider, newValue);
  }

  void _maybeLogError(ProviderBase provider, Object? value) {
    if (value is AsyncError) {
      if (value.error is SentinelException) return;
      _log.shout('Provider $provider failed with "${value.error}"');

      final stackTrace = value.stackTrace;
      if (stackTrace != null) {
        _log.info(stackTrace);
      }
    }
  }
}
