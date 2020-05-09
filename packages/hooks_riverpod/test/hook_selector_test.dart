import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('selector change', (tester) async {
    SetStateProviderContext<int> state;
    final provider = SetStateProvider<int>((s) {
      state = s;
      return 0;
    });

    var res = 'initial';
    var buildCount = 0;
    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(
          builder: (context) {
            buildCount++;
            final value = useSelector(provider.select((value) => res));

            return Text(value, textDirection: TextDirection.ltr);
          },
        ),
      ),
    );

    expect(buildCount, 1);
    expect(find.text('initial'), findsOneWidget);

    // force rebuild
    res = null;
    state.state++;
    // change the selected value during build
    res = 'updated';
    await tester.pump();

    expect(buildCount, 2);
    expect(find.text('updated'), findsOneWidget);

    // trigger an update, but selected value didn't change
    state.state++;
    await tester.pump();

    expect(buildCount, 2);
    expect(find.text('updated'), findsOneWidget);
  });
  testWidgets("don't rebuild dependents when selected value doesn't change",
      (tester) async {
    SetStateProviderContext<List<int>> state;
    final provider = SetStateProvider<List<int>>((s) {
      state = s;
      return [0];
    });

    var buildCount = 0;
    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(
          builder: (context) {
            buildCount++;
            final list = useSelector(provider.select((value) => value));

            return Text('$list', textDirection: TextDirection.ltr);
          },
        ),
      ),
    );

    expect(buildCount, 1);
    expect(find.text('[0]'), findsOneWidget);

    state.state = [0];
    await tester.pump();

    expect(buildCount, 1);

    state.state = [1];
    await tester.pump();

    expect(find.text('[1]'), findsOneWidget);
  });
  testWidgets('.select', (tester) async {
    final notifier = TestNotifier();
    final provider = ChangeNotifierProvider((_) => notifier);

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(
          builder: (context) {
            final count = useSelector(provider.select((value) => value.count));

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
    final provider2 = provider.overrideForSubtree(
      ChangeNotifierProvider((_) => notifier2),
    );

    var buildCount = 0;
    final consumer = HookBuilder(
      key: GlobalKey(),
      builder: (c) {
        buildCount++;
        final count = useSelector(provider.select((value) => value.count));
        return Text('$count', textDirection: TextDirection.ltr);
      },
    );

    await tester.pumpWidget(
      ProviderScope(
        child: Column(
          textDirection: TextDirection.ltr,
          children: <Widget>[
            ProviderScope(
              overrides: [provider2],
              child: consumer,
            ),
          ],
        ),
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
      ProviderScope(
        child: Column(
          textDirection: TextDirection.ltr,
          children: <Widget>[
            ProviderScope(
              overrides: [provider2],
              child: Container(),
            ),
            consumer,
          ],
        ),
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
  testWidgets('changing provider', (tester) async {
    final provider = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(
          builder: (context) {
            final value = useSelector(provider.select((value) => value));
            return Text(
              '$value',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    final provider2 = Provider((_) => 42);

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(
          builder: (context) {
            final value = useSelector(provider2.select((value) => value));
            return Text(
              '$value',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(tester.takeException(), isUnsupportedError);
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
