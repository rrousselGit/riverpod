import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel/src/marvel.dart';
import 'package:marvel/src/fake_marvel.dart';
import 'package:marvel/src/result.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  group('fetch characters', () {
    test('success', () async {
      final container = ProviderContainer(
        overrides: [dioProvider.overrideWithValue(FakeDio())],
      );
      final repository = container.read(repositoryProvider);

      await expectLater(
        repository.fetchCharacters(offset: 0),
        completion(
          Result.data(
            MarvelListCharactersReponse(
              totalCount: 1493,
              characters: [
                Character(
                  id: 1011334,
                  name: '3-D Man',
                  thumbnail: null,
                ),
                Character(
                  id: 1017100,
                  name: 'A-Bomb (HAS)',
                  thumbnail: null,
                ),
                Character(
                  id: 1009144,
                  name: 'A.I.M.',
                  thumbnail: null,
                ),
                Character(
                  id: 1010699,
                  name: 'Aaron Stack',
                  thumbnail: null,
                ),
                Character(
                  id: 1009146,
                  name: 'Abomination (Emil Blonsky)',
                  thumbnail: null,
                ),
                Character(
                  id: 1016823,
                  name: 'Abomination (Ultimate)',
                  thumbnail: null,
                ),
                Character(
                  id: 1009148,
                  name: 'Absorbing Man',
                  thumbnail: null,
                ),
                Character(
                  id: 1009149,
                  name: 'Abyss',
                  thumbnail: null,
                ),
                Character(
                  id: 1010903,
                  name: 'Abyss (Age of Apocalypse)',
                  thumbnail: null,
                ),
                Character(
                  id: 1011266,
                  name: 'Adam Destine',
                  thumbnail: null,
                ),
                Character(
                  id: 1010354,
                  name: 'Adam Warlock',
                  thumbnail: null,
                ),
                Character(
                  id: 1010846,
                  name: 'Aegis (Trey Rollins)',
                  thumbnail: null,
                ),
                Character(
                  id: 1011297,
                  name: 'Agent Brand',
                  thumbnail: null,
                ),
                Character(
                  id: 1011031,
                  name: 'Agent X (Nijo)',
                  thumbnail: null,
                ),
                Character(
                  id: 1009150,
                  name: 'Agent Zero',
                  thumbnail: null,
                ),
                Character(
                  id: 1011198,
                  name: 'Agents of Atlas',
                  thumbnail: null,
                ),
                Character(
                  id: 1011175,
                  name: 'Aginar',
                  thumbnail: null,
                ),
                Character(
                  id: 1011136,
                  name: 'Air-Walker (Gabriel Lan)',
                  thumbnail: null,
                ),
                Character(
                  id: 1011176,
                  name: 'Ajak',
                  thumbnail: null,
                ),
                Character(
                  id: 1010870,
                  name: 'Ajaxis',
                  thumbnail: null,
                ),
              ],
            ),
          ),
        ),
      );
    });
  });
}

class MockResponse<T> extends Mock implements Response<T> {}
