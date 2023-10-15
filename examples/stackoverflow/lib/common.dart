import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final client = Provider((ref) => Dio());

/// A Provider that exposes the current theme.
///
/// This is unimplemented by default, and will be overridden inside [MaterialApp]
/// with the current theme obtained using a [BuildContext].
final themeProvider = Provider<ThemeData>(
  (ref) => throw UnimplementedError(),
  // Specifying an empty "dependencies" signals riverpod_lint that this provider
  // is scoped.
  dependencies: const [],
);

class TimestampParser implements JsonConverter<DateTime, int> {
  const TimestampParser();

  @override
  DateTime fromJson(int json) {
    return DateTime.fromMillisecondsSinceEpoch(
      json * 1000,
      isUtc: true,
    );
  }

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}
