import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider_hooks/provider_hooks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Provider.value', () {
    testWidgets('expose value as is', (tester) async {
      final useProvider = Provider.value(42);

      await tester.pumpWidget(
        ProviderScope(
          child: HookBuilder(builder: (c) {
            return Text(
              useProvider().toString(),
              textDirection: TextDirection.ltr,
            );
          }),
        ),
      );

      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('override updates rebuild dependents with new value',
        (tester) async {
      final useProvider = Provider.value(0);
      final child = HookBuilder(builder: (c) {
        return Text(
          useProvider().toString(),
          textDirection: TextDirection.ltr,
        );
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [useProvider.overrideForSubstree(Provider.value(42))],
          child: child,
        ),
      );

      expect(find.text('42'), findsOneWidget);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [useProvider.overrideForSubstree(Provider.value(21))],
          child: child,
        ),
      );

      expect(find.text('42'), findsNothing);
      expect(find.text('21'), findsOneWidget);
    });
  });
  group('Provider', () {
    testWidgets('expose value as is', (tester) async {
      var callCount = 0;
      final useProvider = Provider(() {
        callCount++;
        return 42;
      });

      await tester.pumpWidget(
        ProviderScope(
          child: HookBuilder(builder: (c) {
            return Text(
              useProvider().toString(),
              textDirection: TextDirection.ltr,
            );
          }),
        ),
      );

      expect(callCount, 1);
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('override updates rebuild dependents with new value',
        (tester) async {
      final useProvider = Provider.value(0);
      final child = HookBuilder(builder: (c) {
        return Text(
          useProvider().toString(),
          textDirection: TextDirection.ltr,
        );
      });

      var callCount = 0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            useProvider.overrideForSubstree(
              Provider(() {
                callCount++;
                return 42;
              }),
            ),
          ],
          child: child,
        ),
      );

      expect(callCount, 1);
      expect(find.text('42'), findsOneWidget);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            useProvider.overrideForSubstree(
              Provider(() {
                callCount++;
                throw Error();
              }),
            ),
          ],
          child: child,
        ),
      );

      expect(callCount, 1);
      expect(find.text('42'), findsOneWidget);
    });
  });
}
