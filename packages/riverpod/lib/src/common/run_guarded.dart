import 'dart:async';

import 'package:meta/meta.dart';

/// Run a function while catching errors and reporting possible errors to the zone.
@internal
void runGuarded(void Function() cb) {
  try {
    cb();
  } catch (err, stack) {
    Zone.current.handleUncaughtError(err, stack);
  }
}

/// Run a function while catching errors and reporting possible errors to the zone.
@internal
void runUnaryGuarded<T, Res>(Res Function(T) cb, T value) {
  try {
    cb(value);
  } catch (err, stack) {
    Zone.current.handleUncaughtError(err, stack);
  }
}

/// Run a function while catching errors and reporting possible errors to the zone.
@internal
void runBinaryGuarded<A, B>(void Function(A, B) cb, A value, B value2) {
  try {
    cb(value, value2);
  } catch (err, stack) {
    Zone.current.handleUncaughtError(err, stack);
  }
}

/// Run a function while catching errors and reporting possible errors to the zone.
@internal
void runTernaryGuarded<A, B, C>(
  void Function(A, B, C) cb,
  A value,
  B value2,
  C value3,
) {
  try {
    cb(value, value2, value3);
  } catch (err, stack) {
    Zone.current.handleUncaughtError(err, stack);
  }
}

/// Run a function while catching errors and reporting possible errors to the zone.
@internal
void runQuaternaryGuarded<A, B, C, D>(
  void Function(A, B, C, D) cb,
  A value,
  B value2,
  C value3,
  D value4,
) {
  try {
    cb(value, value2, value3, value4);
  } catch (err, stack) {
    Zone.current.handleUncaughtError(err, stack);
  }
}
