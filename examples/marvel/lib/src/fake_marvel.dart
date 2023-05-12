// ignore: import_of_legacy_library_into_null_safe
// ignore_for_file: invalid_annotation_target

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fake_marvel.g.dart';

@JsonLiteral('characters.json')
final _characters = _$_charactersJsonLiteral;

@JsonLiteral('characters_20.json')
final _characters20 = _$_characters20JsonLiteral;

@JsonLiteral('characters_name= Iron man.json')
final _charactersIronMan = _$_charactersIronManJsonLiteral;

@JsonLiteral('characters_name= Iron man (.json')
final _charactersIronMan2 = _$_charactersIronMan2JsonLiteral;

@JsonLiteral('character_1009368.json')
final _character1009368 = _$_character1009368JsonLiteral;

class FakeDio implements Dio {
  FakeDio([this._apiKey = '42']);

  final String? _apiKey;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    print('hello $_apiKey $queryParameters');
    if (_apiKey != null && queryParameters?['apikey'] != _apiKey) {
      throw StateError('Missing api key');
    }

    switch (path) {
      case 'https://gateway.marvel.com/v1/public/characters/1009368':
        return FakeResponse(_character1009368) as Response<T>;
      case 'https://gateway.marvel.com/v1/public/characters':
        if (queryParameters?['nameStartsWith'] == 'Iron man') {
          return FakeResponse(_charactersIronMan) as Response<T>;
        }
        if (queryParameters?['nameStartsWith'] == 'Iron man (') {
          return FakeResponse(_charactersIronMan2) as Response<T>;
        }
        if (queryParameters?['offset'] == 0) {
          return FakeResponse(_characters) as Response<T>;
        }
        if (queryParameters?['offset'] == 20) {
          return FakeResponse(_characters20) as Response<T>;
        }
        break;
    }
    if (path == '?apikey=$_apiKey') {}
    throw UnimplementedError();
  }

  @override
  void noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}

class FakeResponse implements Response<Map<String, Object?>> {
  FakeResponse(this.data);

  @override
  final Map<String, Object?> data;

  @override
  void noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}
