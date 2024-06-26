// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

void main() {
  group('FutureOrAsSync', () {
    test('keeps Futures as is', () {
      final future = Future.value(42);

      expect(future.sync, same(future));
    });

    test('converts non-Futures to SynchronousFuture', () async {
      expect(42.sync, isA<SynchronousFuture<int>>());
      expect(await 42.sync, 42);
    });
  });

  test('SynchronousFuture control test', () async {
    final Future<int> future = SynchronousFuture<int>(42);

    int? result;
    unawaited(
      future.then<void>((value) {
        result = value;
      }),
    );

    expect(result, equals(42));
    result = null;

    final Future<int> futureWithTimeout =
        future.timeout(const Duration(milliseconds: 1));
    await futureWithTimeout.then<void>((value) {
      result = value;
    });
    expect(result, isNull);
    await futureWithTimeout;
    expect(result, equals(42));
    result = null;

    final Stream<int> stream = future.asStream();

    expect(await stream.single, equals(42));

    bool ranAction = false;
    // ignore: void_checks, https://github.com/dart-lang/linter/issues/1675
    final Future<int> completeResult = future.whenComplete(() {
      ranAction = true;
      // verify that whenComplete does NOT propagate its return value:
      return Future<int>.value(31);
    });

    expect(ranAction, isTrue);
    ranAction = false;

    expect(await completeResult, equals(42));

    Object? exception;
    try {
      await future.whenComplete(() {
        throw ArgumentError();
      });
      // Unreached.
      expect(false, isTrue);
    } catch (e) {
      exception = e;
    }
    expect(exception, isArgumentError);
  });
}
