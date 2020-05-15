import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel/marvel.dart';
import 'package:marvel/fake_marvel.dart';
import 'package:marvel/result.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  group('fetch characters', () {
    test('success', () async {
      final owner = ProviderStateOwner();
      final client = FakeDio();
      final repository = MarvelRepository(owner.ref, client: client);

      await expectLater(
        repository.fetchCharacters(offset: 0),
        completion(
          Result.data(
            MarvelListCharactersReponse(
              totalCount: 1493,
              characters: [
                Character(id: 1011334, name: '3-D Man'),
                Character(id: 1017100, name: 'A-Bomb (HAS)'),
                Character(id: 1009144, name: 'A.I.M.'),
                Character(id: 1010699, name: 'Aaron Stack'),
                Character(id: 1009146, name: 'Abomination (Emil Blonsky)'),
                Character(id: 1016823, name: 'Abomination (Ultimate)'),
                Character(id: 1009148, name: 'Absorbing Man'),
                Character(id: 1009149, name: 'Abyss'),
                Character(id: 1010903, name: 'Abyss (Age of Apocalypse)'),
                Character(id: 1011266, name: 'Adam Destine'),
                Character(id: 1010354, name: 'Adam Warlock'),
                Character(id: 1010846, name: 'Aegis (Trey Rollins)'),
                Character(id: 1011297, name: 'Agent Brand'),
                Character(id: 1011031, name: 'Agent X (Nijo)'),
                Character(id: 1009150, name: 'Agent Zero'),
                Character(id: 1011198, name: 'Agents of Atlas'),
                Character(id: 1011175, name: 'Aginar'),
                Character(id: 1011136, name: 'Air-Walker (Gabriel Lan)'),
                Character(id: 1011176, name: 'Ajak'),
                Character(id: 1010870, name: 'Ajaxis'),
              ],
            ),
          ),
        ),
      );
    });
  });
}

class MockResponse<T> extends Mock implements Response<T> {}
