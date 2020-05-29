import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProviderScope throws if ancestorOwner changed', (tester) async {
    final key = GlobalKey();

    await tester.pumpWidget(
      ProviderScope(
        child: ProviderScope(
          key: key,
          child: Container(),
        ),
      ),
    );

    expect(find.byType(Container), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        child: ProviderScope(
          child: ProviderScope(
            key: key,
            child: Container(),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isUnsupportedError);
  });
  testWidgets('ProviderScope throws if ancestorOwner removed', (tester) async {
    final key = GlobalKey();

    await tester.pumpWidget(
      ProviderScope(
        child: ProviderScope(
          key: key,
          child: Container(),
        ),
      ),
    );

    expect(find.byType(Container), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        key: key,
        child: Container(),
      ),
    );

    expect(tester.takeException(), isUnsupportedError);
  });
}
