import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_devtool/src/search/fuzzy_text.dart';
import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';

void main() {
  testWidgets('FuzzyText only emphasizes the characters that matched', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: FuzzyText(match: 'counter'.fuzzyMatch('cn')),
      ),
    );

    final text = tester.widget<RichText>(find.byType(RichText)).text;
    final spans = (text as TextSpan).children!.cast<TextSpan>();

    expect(spans.map((span) => span.text).join(), 'counter');
    expect(
      [
        for (final span in spans)
          if (span.style!.fontWeight == FontWeight.bold) span.text,
      ],
      ['c', 'n'],
    );
  });
}
