import 'package:material_ui/material_ui.dart';
import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';

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
