/// This file contains the necessary objects to connect with the Marvel API.
///
/// This includes [MarvelRepository], which expose methods to do the request
/// in a tyoe-safe way.
/// It also includes all the intermediate objects used to deserialize the
/// response from the API.
library marvel;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

import 'configuration.dart';

part 'marvel.freezed.dart';
part 'marvel.g.dart';

final repositoryProvider = Provider((ref) => MarvelRepository(ref));

class MarvelRepository {
  MarvelRepository(
    this._ref, {
    int Function() getCurrentTimestamp,
    Dio client,
  })  : _getCurrentTimestamp = getCurrentTimestamp ??
            (() => DateTime.now().millisecondsSinceEpoch),
        _client = client ?? Dio();

  final ProviderReference _ref;
  final Dio _client;
  final int Function() _getCurrentTimestamp;

  Future<MarvelListCharactersReponse> fetchCharacters({
    @required int offset,
    int limit,
    String nameStartsWith,
  }) async {
    final cleanNameFilter = nameStartsWith?.trim();

    final response = await _get('characters', queryParameters: <String, Object>{
      'offset': offset,
      if (limit != null) 'limit': limit,
      if (cleanNameFilter != null && cleanNameFilter.isNotEmpty)
        'nameStartsWith': cleanNameFilter,
    });

    return MarvelListCharactersReponse(
      characters: response.data.results.map((e) {
        return Character.fromJson(e);
      }).toList(growable: false),
      totalCount: response.data.total,
    );
  }

  Future<MarvelResponse> _get(
    String path, {
    Map<String, Object> queryParameters,
  }) async {
    final configs = await _ref.dependOn(configurationsProvider).value;

    final timestamp = _getCurrentTimestamp();
    final hash = md5
        .convert(
          utf8.encode('$timestamp${configs.privateKey}${configs.publicKey}'),
        )
        .toString();

    final result = await _client.get<Map<String, Object>>(
      'https://gateway.marvel.com/v1/public/$path',
      queryParameters: <String, Object>{
        'apikey': configs.publicKey,
        'ts': timestamp,
        'hash': hash,
        ...?queryParameters,
      },
      // TODO deserialize error message
    );
    return MarvelResponse.fromJson(result.data);
  }
}

@freezed
abstract class MarvelListCharactersReponse with _$MarvelListCharactersReponse {
  factory MarvelListCharactersReponse({
    @required int totalCount,
    @required List<Character> characters,
  }) = _MarvelListCharactersReponse;
}

@freezed
abstract class Character with _$Character {
  factory Character({
    @required int id,
    @required String name,
    @required Thumbnail thumbnail,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
}

@freezed
abstract class Thumbnail with _$Thumbnail {
  factory Thumbnail({
    @required String path,
    @required String extension,
  }) = _Thumbnail;

  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);

  @late
  String get url => '$path.$extension';
}

@freezed
abstract class MarvelResponse with _$MarvelResponse {
  factory MarvelResponse(MarvelData data) = _MarvelResponse;

  factory MarvelResponse.fromJson(Map<String, dynamic> json) =>
      _$MarvelResponseFromJson(json);
}

@freezed
abstract class MarvelData with _$MarvelData {
  factory MarvelData(
    List<Map<String, dynamic>> results,
    int total,
  ) = _MarvelData;

  factory MarvelData.fromJson(Map<String, dynamic> json) =>
      _$MarvelDataFromJson(json);
}
