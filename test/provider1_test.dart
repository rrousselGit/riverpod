import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider_hooks/provider_hooks.dart';

void main() {
  testWidgets('provider1 can read and listen to other providers',
      (tester) async {
    ProviderState<int> providerState;

    final useProvider = Provider<int>((state) {
      providerState = state;
      return 42;
    });
    var createCount = 0;
    final useProvider1 = Provider1<int, String>(useProvider, (state, first) {
      createCount++;
      first.onChange((v) {
        state.value = v.toString();
      });
      return first.state.toString();
    });

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          return Text(useProvider1(), textDirection: TextDirection.ltr);
        }),
      ),
    );

    expect(find.text('42'), findsOneWidget);

    providerState.value = 21;
    await tester.pump();

    expect(createCount, 1);
    expect(find.text('21'), findsOneWidget);
  });

  // TODO provider1 uses override if the override is at root

}
