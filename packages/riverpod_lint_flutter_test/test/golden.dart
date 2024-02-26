import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/test.dart';

final _goldenWrite = bool.parse(Platform.environment[r'goldens'] ?? 'false');

/// Expects that a value matches a golden file.
@visibleForTesting
Matcher matchersGoldenFile<T>(
  File file, {
  required String Function(T value) encode,
  required bool Function(T value) isEmpty,
}) {
  return _MatchesGoldenFile(
    file: file,
    encode: encode,
    isEmpty: isEmpty,
  );
}

class _MatchesGoldenFile<T> extends Matcher {
  _MatchesGoldenFile({
    required this.encode,
    required this.file,
    required this.isEmpty,
  });

  final File file;
  final String Function(T) encode;
  final bool Function(T) isEmpty;

  static final Object _mismatchedValueKey = Object();
  static final Object _expectedKey = Object();

  @override
  bool matches(
    Object? object,
    Map<Object?, Object?> matchState,
  ) {
    if (object is! T) {
      matchState[_mismatchedValueKey] = 'Expected a ${T.toString()}';
      return false;
    }

    late final actual = encode(object);

    if (!_goldenWrite) {
      if (isEmpty(object)) {
        if (file.existsSync()) {
          matchState[_mismatchedValueKey] =
              'Expected to have no file, but found: ${file.path}';
          return false;
        }
        return true;
      }

      if (!file.existsSync()) {
        matchState[_mismatchedValueKey] = 'File not found: ${file.path}';
        return false;
      }

      final expected = file.readAsStringSync();
      if (actual != expected) {
        matchState[_mismatchedValueKey] = actual;
        matchState[_expectedKey] = expected;
        return false;
      }
    } else if (isEmpty(object)) {
      try {
        file.deleteSync(recursive: true);
      } catch (_) {}
    } else {
      file
        ..createSync(recursive: true)
        ..writeAsStringSync(actual);
    }

    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('to match snapshot at ${file.path}');
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<Object?, Object?> matchState,
    bool verbose,
  ) {
    final actualValue = matchState[_mismatchedValueKey] as String?;
    if (actualValue != null) {
      final expected = matchState[_expectedKey] as String?;

      if (expected != null) {
        return mismatchDescription
            .add('Expected to match snapshot at ${file.path}:\n')
            .addDescriptionOf(expected)
            .add('\n\nbut was:\n')
            .addDescriptionOf(actualValue);
      } else {
        return mismatchDescription.add(actualValue);
      }
    }

    return mismatchDescription.add('Unknown mismatch');
  }
}
