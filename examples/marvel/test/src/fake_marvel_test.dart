import 'package:flutter_test/flutter_test.dart';
import 'package:marvel/src/fake_marvel.dart';

const _characters = 'https://gateway.marvel.com/v1/public/characters';

Future<Map<String, Object?>> _get(
  FakeDio dio,
  String path, [
  Map<String, Object?> queryParameters = const {},
]) async {
  final response = await dio.get<Map<String, Object?>>(
    path,
    queryParameters: {'apikey': '42', ...queryParameters},
  );
  return response.data!;
}

List<Object?> _names(Map<String, Object?> body) {
  final data = body['data']! as Map<String, Object?>;
  final results = data['results']! as List<Object?>;
  return [for (final result in results) (result! as Map)['name']];
}

void main() {
  group('FakeDio', () {
    test('serves the first two pages of characters', () async {
      final dio = FakeDio();

      final page0 = await _get(dio, _characters, {'offset': 0});
      final page20 = await _get(dio, _characters, {'offset': 20});

      expect(_names(page0), contains('3-D Man'));
      expect(_names(page20), isNotEmpty);
      expect(_names(page20), isNot(_names(page0)));
    });

    test('serves characters searched by name', () async {
      final dio = FakeDio();

      final ironMan = await _get(dio, _characters, {
        'nameStartsWith': 'Iron man',
      });

      expect(_names(ironMan), contains('Iron Man'));
    });

    test('serves a character by id', () async {
      final body = await _get(FakeDio(), '$_characters/1009368');

      expect(_names(body), ['Iron Man']);
    });

    test('requires the api key it was given', () async {
      await expectLater(
        FakeDio().get<Object?>(_characters, queryParameters: {'apikey': '0'}),
        throwsStateError,
      );
      await expectLater(
        FakeDio('0').get<Object?>(
          _characters,
          queryParameters: {'apikey': '0', 'offset': 0},
        ),
        completes,
      );
    });

    test('accepts any api key without one', () async {
      final response = await FakeDio(
        null,
      ).get<Map<String, Object?>>(_characters, queryParameters: {'offset': 0});

      expect(_names(response.data!), contains('3-D Man'));
    });

    test('throws on unknown requests', () async {
      await expectLater(
        FakeDio().get<Object?>(_characters, queryParameters: {'apikey': '42'}),
        throwsUnimplementedError,
      );
      expect(() => FakeDio().options, throwsUnimplementedError);
      expect(() => FakeResponse(const {}).statusCode, throwsUnimplementedError);
    });
  });
}
