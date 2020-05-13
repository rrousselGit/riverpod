import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'configuration.freezed.dart';
part 'configuration.g.dart';

@freezed
abstract class Configuration with _$Configuration {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Configuration({
    @required String publicKey,
    @required String privateKey,
  }) = _Configuration;

  factory Configuration.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationFromJson(json);
}

final configurationsProvider = FutureProvider((_) async {
  // SynchronousFuture
  final content = json.decode(
    await rootBundle.loadString('assets/configurations.json'),
  ) as Map<String, dynamic>;

  return Configuration.fromJson(content);
});
