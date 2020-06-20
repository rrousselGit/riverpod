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
import 'result.dart';

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

  Future<Result<MarvelListCharactersReponse>> fetchCharacters({
    @required int offset,
  }) async {
    final response = await _get('characters', queryParameters: <String, Object>{
      'offset': offset,
    });

    return response.chain((value) {
      return MarvelListCharactersReponse(
        characters: value.data.results.map((e) {
          return Character.fromJson(e);
        }).toList(growable: false),
        totalCount: value.data.total,
      );
    });
  }

  Future<Result<MarvelResponse>> _get(
    String path, {
    Map<String, Object> queryParameters,
  }) {
    return Result.guardFuture(() async {
      final configs = await _ref.read(configurationsProvider).future;

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
          });
      return MarvelResponse.fromJson(result.data);
    });
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
