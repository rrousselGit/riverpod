// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_test.dart';

void main() {
  testWidgets('Some description', (tester) async {
    /* SNIPPET START */
    final element = tester.element(find.byType(YourWidgetYouWantToTest));
    final container = ProviderScope.containerOf(element);
    /* SNIPPET END */
  });
}
