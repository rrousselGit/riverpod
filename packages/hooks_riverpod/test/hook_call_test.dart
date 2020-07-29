import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('.call', (tester) async {
    final notifier = TestNotifier();
    final provider = ChangeNotifierProvider((_) => notifier);

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(
          builder: (context) {
            final count = useProvider(provider).count;

            return Text('$count', textDirection: TextDirection.ltr);
          },
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    notifier.count++;
    await tester.pump();

    expect(find.text('1'), findsOneWidget);

    await tester.pumpWidget(ProviderScope(child: Container()));

    notifier.count++;
    await tester.pump();
  });

  testWidgets('relocating consumer with GlobalKey', (tester) async {
    final notifier = TestNotifier();
    final notifier2 = TestNotifier()..count = 42;

    final provider = ChangeNotifierProvider((_) => notifier);
    final provider2 = provider.overrideWithProvider(
      ChangeNotifierProvider((_) => notifier2),
    );

    var buildCount = 0;
    final consumer = HookBuilder(
      key: GlobalKey(),
      builder: (c) {
        buildCount++;
        final count = useProvider(provider).count;
        return Text('$count', textDirection: TextDirection.ltr);
      },
    );

    await tester.pumpWidget(
      Column(
        textDirection: TextDirection.ltr,
        children: <Widget>[
          ProviderScope(
            child: Container(),
          ),
          ProviderScope(
            overrides: [provider2],
            child: consumer,
          ),
        ],
      ),
    );

    expect(find.text('42'), findsOneWidget);
    expect(buildCount, 1);

    notifier2.count++;
    await tester.pump();

    expect(find.text('43'), findsOneWidget);
    expect(buildCount, 2);

    // move the consumer without disposing the currently listener notifier
    await tester.pumpWidget(
      Column(
        textDirection: TextDirection.ltr,
        children: <Widget>[
          ProviderScope(
            child: consumer,
          ),
          ProviderScope(
            overrides: [provider2],
            child: Container(),
          ),
        ],
      ),
    );

    expect(buildCount, 3);
    expect(find.text('0'), findsOneWidget);

    // does nothing because listener was removed
    notifier2.count++;
    await tester.pump();

    expect(buildCount, 3);

    notifier.count++;
    await tester.pump();

    expect(buildCount, 4);
    expect(find.text('1'), findsOneWidget);
  });
}

class TestNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  set count(int count) {
    _count = count;
    notifyListeners();
  }
}
