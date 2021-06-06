/// This file contains the necessary objects to connect with the Marvel API.
///
/// This includes [MarvelRepository], which expose methods to do the request
/// in a type-safe way.
/// It also includes all the intermediate objects used to deserialize the
/// response from the API.
library marvel;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'configuration.dart';

part 'marvel.freezed.dart';
part 'marvel.g.dart';

final dioProvider = Provider((ref) => Dio());

final repositoryProvider = Provider((ref) => MarvelRepository(ref.read));

class MarvelRepository {
  MarvelRepository(
    this._read, {
    int Function()? getCurrentTimestamp,
  }) : _getCurrentTimestamp = getCurrentTimestamp ??
            (() => DateTime.now().millisecondsSinceEpoch);

  final Reader _read;
  final int Function() _getCurrentTimestamp;
  final _characterCache = <String, Character>{};

  Future<MarvelListCharactersReponse> fetchCharacters({
    required int offset,
    int? limit,
    String? nameStartsWith,
    CancelToken? cancelToken,
  }) async {
    final cleanNameFilter = nameStartsWith?.trim();

    final response =
        await _get('characters', queryParameters: <String, Object?>{
      'offset': offset,
      if (limit != null) 'limit': limit,
      if (cleanNameFilter != null && cleanNameFilter.isNotEmpty)
        'nameStartsWith': cleanNameFilter,
    });

    final result = MarvelListCharactersReponse(
      characters: response.data.results.map((e) {
        return Character.fromJson(e);
      }).toList(growable: false),
      totalCount: response.data.total,
    );

    for (final character in result.characters) {
      _characterCache[character.id.toString()] = character;
    }

    return result;
  }

  Future<Character> fetchCharacter(
    String id, {
    CancelToken? cancelToken,
  }) async {
    // Don't fetch the Character if it was already obtained previously, either
    // in the home page or in the detail page.
    if (_characterCache.containsKey(id)) {
      return _characterCache[id]!;
    }

    final response = await _get('characters/$id', cancelToken: cancelToken);
    return Character.fromJson(response.data.results.single);
  }

  Future<MarvelResponse> _get(
    String path, {
    Map<String, Object?>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    final configs = await _read(configurationsProvider.future);

    final timestamp = _getCurrentTimestamp();
    final hash = md5
        .convert(
          utf8.encode('$timestamp${configs.privateKey}${configs.publicKey}'),
        )
        .toString();

    final result = await _read(dioProvider).get<Map<String, Object?>>(
      'https://gateway.marvel.com/v1/public/$path',
      cancelToken: cancelToken,
      queryParameters: <String, Object?>{
        'apikey': configs.publicKey,
        'ts': timestamp,
        'hash': hash,
        ...?queryParameters,
      },
      // TODO deserialize error message
    );
    return MarvelResponse.fromJson(Map<String, Object>.from(result.data!));
  }
}

@freezed
class MarvelListCharactersReponse with _$MarvelListCharactersReponse {
  factory MarvelListCharactersReponse({
    required int totalCount,
    required List<Character> characters,
  }) = _MarvelListCharactersReponse;
}

@freezed
class Character with _$Character {
  factory Character({
    required int id,
    required String name,
    required Thumbnail thumbnail,
  }) = _Character;

  factory Character.fromJson(Map<String, Object?> json) =>
      _$CharacterFromJson(json);
}

@freezed
class Thumbnail with _$Thumbnail {
  factory Thumbnail({
    required String path,
    required String extension,
  }) = _Thumbnail;
  Thumbnail._();

  factory Thumbnail.fromJson(Map<String, Object?> json) =>
      _$ThumbnailFromJson(json);

  late final String url =
      '${path.replaceFirst('http://', 'https://')}.$extension';
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
    int total,
  ) = _MarvelData;

  factory MarvelData.fromJson(Map<String, Object?> json) =>
      _$MarvelDataFromJson(json);
}
