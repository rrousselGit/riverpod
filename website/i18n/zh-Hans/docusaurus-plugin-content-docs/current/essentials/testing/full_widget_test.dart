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

    final element = tester.element(find.byType(YourWidgetYouWantToTest));
    final container = ProviderScope.containerOf(element);

    // TODO 与你的提供者程序交互
    expect(
      container.read(provider),
      'some value',
    );
  });
}
/* SNIPPET END */
