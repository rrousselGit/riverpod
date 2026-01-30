import 'package:flutter/material.dart';

extension FuzzyMatchString on String {
  /// Checks if `this` contains all characters from [other], in order.
  FuzzyMatch fuzzyMatch(String other) {
    final charsToMatch = other.characters.indexed.iterator;
    if (!charsToMatch.moveNext()) {
      return FuzzyMatch._ok([MissCharacter(this)]);
    }

    final result = List<FuzzyMatchCharacter>.generate(
      length,
      (i) => const MissCharacter(''),
      growable: false,
    );

    var didMatch = false;

    for (final (index, char) in characters.indexed) {
      if (!didMatch &&
          char.toLowerCase() == charsToMatch.current.$2.toLowerCase()) {
        result[index] = MatchCharacter(char);
        if (!charsToMatch.moveNext()) {
          didMatch = true;
        }

        continue;
      }

      result[index] = MissCharacter(char);
    }

    if (didMatch) return FuzzyMatch._ok(result);

    return FuzzyMatch._ko(this);
  }
}

final class FuzzyMatch {
  FuzzyMatch._ok(this.characters) : didMatch = true;

  FuzzyMatch._ko(String source)
    : didMatch = false,
      characters = [MissCharacter(source)];

  final bool didMatch;

  /// Information about the match. This enables rendering how a text matched
  /// a given search query.
  ///
  /// Cf [FuzzyText]
  final List<FuzzyMatchCharacter> characters;
}

sealed class FuzzyMatchCharacter {
  const FuzzyMatchCharacter(this.value);
  final String value;
}

final class MatchCharacter extends FuzzyMatchCharacter {
  const MatchCharacter(super.value);
}

final class MissCharacter extends FuzzyMatchCharacter {
  const MissCharacter(super.value);
}

/// Renders a [FuzzyMatch]
///
/// See also:
/// - [FuzzyMatchString.fuzzyMatch], to obtain an instance of [FuzzyMatch].
class FuzzyText extends StatelessWidget {
  const FuzzyText({super.key, required this.match});

  final FuzzyMatch match;

  @override
  Widget build(BuildContext context) {
    final missStyle = DefaultTextStyle.of(context).style;
    final matchStyle = TextStyle(
      color: missStyle.color,
      fontWeight: FontWeight.bold,
    );

    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          for (final char in match.characters)
            TextSpan(
              text: char.value,
              style: switch (char) {
                MatchCharacter() => matchStyle,
                MissCharacter() => missStyle,
              },
            ),
        ],
      ),
    );
  }
}
