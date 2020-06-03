import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:state_notifier/state_notifier.dart';

void main() {
  testWidgets('debugFillProperties', (tester) async {
    final unnamed = Provider((_) => 0);
    final named = StateNotifierProvider((_) => Counter(), name: 'counter');
    final scopeKey = GlobalKey();

    await tester.pumpWidget(
      ProviderScope(
        key: scopeKey,
        child: Consumer<int>(
          unnamed,
          builder: (_, value, __) {
            return Consumer<int>(
              named.state,
              builder: (_, count, __) {
                return Text(
                  'value: $value count: $count',
                  textDirection: TextDirection.ltr,
                );
              },
            );
          },
        ),
      ),
    );

    expect(find.text('value: 0 count: 0'), findsOneWidget);

    expect(
      scopeKey.currentContext.toString(),
      equalsIgnoringHashCodes('ProviderScope-[GlobalKey#00000]('
          'state: _ProviderScopeState#00000, '
          'Provider<int>#00000: 0, '
          'counter.state: 0, '
          "counter: Instance of 'Counter')"),
    );
  });
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

class Counter extends StateNotifier<int> {
  Counter() : super(0);
}
