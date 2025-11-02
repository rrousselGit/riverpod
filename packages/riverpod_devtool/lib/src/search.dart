import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension FuzzyMatchString on String {
  /// Checks if `this` contains all characters from [other], in order.
  FuzzyMatch fuzzyMatch(String other) {
    final charsToMatch = other.characters.indexed.iterator;
    if (!charsToMatch.moveNext()) return FuzzyMatch._ko(this);

    final result = List<FuzzyMatchCharacter>.generate(
      length,
      (i) => const MissCharacter(''),
      growable: false,
    );

    for (final char in characters) {
      if (char == charsToMatch.current.$2) {
        result.add(MatchCharacter(char));
        if (!charsToMatch.moveNext()) return FuzzyMatch._ok(result);

        continue;
      }

      result.add(MissCharacter(char));
    }

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
    final matchStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
    );
    final missStyle = DefaultTextStyle.of(context).style;

    return RichText(
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

class DevtoolSearchBar extends StatelessWidget {
  const DevtoolSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
  });

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: hintText,
      ),
      controller: controller,
    );
  }
}
