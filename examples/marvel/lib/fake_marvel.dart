import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fake_marvel.g.dart';

@JsonLiteral('characters.json')
final _characters = _$_charactersJsonLiteral;

@JsonLiteral('characters_20.json')
final _characters20 = _$_characters20JsonLiteral;

class FakeDio implements Dio {
  FakeDio([this._apiKey = '42']);

  final String _apiKey;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    switch (path) {
      case 'https://gateway.marvel.com/v1/public/characters':
        if (_apiKey != null && queryParameters['apikey'] != _apiKey) {
          break;
        }
        if (queryParameters['offset'] == 0) {
          return FakeResponse(_characters) as Response<T>;
        }
        if (queryParameters['offset'] == 20) {
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

class FakeResponse implements Response<Map<String, dynamic>> {
  FakeResponse(this.data);

  @override
  final Map<String, dynamic> data;

  @override
  void noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}
