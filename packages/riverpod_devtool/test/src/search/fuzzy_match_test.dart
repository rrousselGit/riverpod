import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_devtool/src/search/fuzzy_match.dart';

void main() {
  group('fuzzyMatch', () {
    test('matches an empty query against the whole source', () {
      final match = 'Riverpod'.fuzzyMatch('');

      expect(match.didMatch, isTrue);
      expect(match.characters, hasLength(1));
      expect(match.characters.single, isA<MissCharacter>());
      expect(match.characters.single.value, 'Riverpod');
    });

    test('matches characters in order, case-insensitively', () {
      final match = 'Riverpod'.fuzzyMatch('rvp');

      expect(match.didMatch, isTrue);
      expect(match.characters.map((char) => char.runtimeType), [
        MatchCharacter,
        MissCharacter,
        MatchCharacter,
        MissCharacter,
        MissCharacter,
        MatchCharacter,
        MissCharacter,
        MissCharacter,
      ]);
    });

    test('fails when all characters cannot be matched in order', () {
      final match = 'Riverpod'.fuzzyMatch('rz');

      expect(match.didMatch, isFalse);
      expect(match.characters, hasLength(1));
      expect(match.characters.single.value, 'Riverpod');
    });
  });
}
