import 'dart:convert';

import 'package:crypto/crypto.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// Using the package `Freezed` to create our [Configuration] class.
///
/// This is not needed, but reduce the boilerplate.
@freezed
class Configuration with _$Configuration {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Configuration({
    required String publicKey,
    required String privateKey,
  }) = _Configuration;

  factory Configuration.fromJson(Map<String, Object?> json) =>
      _$ConfigurationFromJson(json);
}

class Repository {
  Repository(this._configuration);

  final Configuration _configuration;
  final _client = Dio();

  Future<List<Comic>> fetchComics() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final hash = md5
        .convert(
          utf8.encode(
            '$timestamp${_configuration.privateKey}${_configuration.publicKey}',
          ),
        )
        .toString();

    final result = await _client.get<Map<String, Object?>>(
      'http://gateway.marvel.com/v1/public/comics',
      queryParameters: <String, Object?>{
        'ts': timestamp,
        'apikey': _configuration.publicKey,
        'hash': hash,
      },
    );
    if (result.data == null) {
      return [];
    }
    final response = MarvelResponse.fromJson(result.data!);

    return response //
        .data
        .results
        .map(Comic.fromJson)
        .toList();
  }

  void dispose() {
    _client.close(force: true);
  }
}

@freezed
class MarvelResponse with _$MarvelResponse {
  factory MarvelResponse(MarvelData data) = _MarvelResponse;

  factory MarvelResponse.fromJson(Map<String, Object?> json) =>
      _$MarvelResponseFromJson(json);
}

@freezed
class MarvelData with _$MarvelData {
  factory MarvelData(
    List<Map<String, Object?>> results,
  ) = _MarvelData;

  factory MarvelData.fromJson(Map<String, Object?> json) =>
      _$MarvelDataFromJson(json);
}

@freezed
class Comic with _$Comic {
  factory Comic({
    required int id,
    required String title,
  }) = _Comic;

  factory Comic.fromJson(Map<String, Object?> json) => _$ComicFromJson(json);
}
