// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final provider = Provider((_) => 'some value');

class YourWidgetYouWantToTest extends StatelessWidget {
  const YourWidgetYouWantToTest({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();
}

/* SNIPPET START */
void main() {
  testWidgets('Some description', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: YourWidgetYouWantToTest()),
    );

    final container = tester.container();

    // {@template useProvider}
    // TODO interact with your providers
    // {@endtemplate}
    expect(
      container.read(provider),
      'some value',
    );
  });
}
/* SNIPPET END */
