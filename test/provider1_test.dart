import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider_hooks/provider_hooks.dart';

void main() {
  testWidgets('didUpdateProvider check dependencies did not change',
      (tester) async {
    final provider = Provider((_) => 42);
    final provider2 = Provider((_) => 0);
    final otherProvider = Provider((_) => 0);

    final consumer = HookBuilder(builder: (c) {
      return Text(
        otherProvider().toString(),
        textDirection: TextDirection.ltr,
      );
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          otherProvider.overrideForSubtree(
            Provider1<int, int>(provider, (_, other) => other.state * 2),
          ),
        ],
        child: consumer,
      ),
    );

    expect(find.text('84'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          otherProvider.overrideForSubtree(
            // Rebuilds override with a matching `runtimeType` but the dependency changed
            Provider1<int, int>(provider2, (_, other) => other.state * 2),
          ),
        ],
        child: consumer,
      ),
    );

    expect(tester.takeException(), isUnsupportedError);
  });
  testWidgets('throws if a provider dependency changed', (tester) async {
    final provider = Provider((_) => 42);
    final otherProvider = Provider1<int, int>(
      provider,
      (_, other) => other.state * 2,
    );

    final secondScope = ProviderScope(
      key: GlobalKey(),
      overrides: [
        otherProvider.overrideForSubtree(otherProvider),
      ],
      child: HookBuilder(builder: (c) {
        return Text(
          otherProvider().toString(),
          textDirection: TextDirection.ltr,
        );
      }),
    );

    await tester.pumpWidget(ProviderScope(child: secondScope));

    expect(find.text('84'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [
          provider.overrideForSubtree(Provider((_) => 21)),
        ],
        child: secondScope,
      ),
    );

    expect(tester.takeException(), isUnsupportedError);
  });
  testWidgets('provider1 as override of normal provider', (tester) async {
    final provider = Provider((_) => 42);
    final provider2 = Provider((_) => 42);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider2.overrideForSubtree(
            Provider1<int, int>(provider, (_, other) => other.state * 2),
          ),
        ],
        child: HookBuilder(builder: (c) {
          return Text(provider2().toString(), textDirection: TextDirection.ltr);
        }),
      ),
    );

    expect(find.text('84'), findsOneWidget);
  });

  testWidgets('provider1 can read and listen to other providers',
      (tester) async {
    // ProviderState<int> providerState;

    final useProvider = Provider<int>((state) {
      // providerState = state;
      return 42;
    });
    var createCount = 0;
    final useProvider1 = Provider1<int, String>(useProvider, (state, first) {
      createCount++;
      // first.onChange((v) {
      //   state.value = v.toString();
      // });
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

    // providerState.value = 21;
    await tester.pump();

    expect(createCount, 1);
    expect(find.text('21'), findsOneWidget);
  }, skip: true);

  testWidgets('provider1 uses override if the override is at root',
      (tester) async {
    final useProvider = Provider((_) => 0);

    final useProvider1 = Provider1<int, String>(useProvider, (state, first) {
      return first.state.toString();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(Provider((_) => 1)),
        ],
        child: HookBuilder(builder: (c) {
          return Text(useProvider1(), textDirection: TextDirection.ltr);
        }),
      ),
    );

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
  testWidgets('provider1 chain', (tester) async {
    final first = Provider((_) => 1);
    final second = Provider1<int, int>(first, (state, first) {
      return first.state + 1;
    });
    final third = Provider1<int, int>(second, (state, second) {
      return second.state + 1;
    });
    final forth = Provider1<int, int>(third, (state, third) {
      return third.state + 1;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          return Text(forth().toString(), textDirection: TextDirection.ltr);
        }),
      ),
    );

    expect(find.text('4'), findsOneWidget);
  });
  testWidgets('overriden provider1 chain', (tester) async {
    final first = Provider((_) => 1);
    final second = Provider1<int, int>(first, (state, first) {
      return first.state + 1;
    });
    final third = Provider1<int, int>(second, (state, second) {
      return second.state + 1;
    });
    final forth = Provider1<int, int>(third, (state, third) {
      return third.state + 1;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          first.overrideForSubtree(Provider((_) => 42)),
        ],
        child: HookBuilder(builder: (c) {
          return Text(forth().toString(), textDirection: TextDirection.ltr);
        }),
      ),
    );

    expect(find.text('45'), findsOneWidget);
  });
  testWidgets('partial override provider1 chain', (tester) async {
    final first = Provider((_) => 1);
    final second = Provider1<int, int>(first, (state, first) {
      return first.state + 1;
    });
    final third = Provider1<int, int>(second, (state, second) {
      return second.state + 1;
    });
    final forth = Provider1<int, int>(third, (state, third) {
      return third.state + 1;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          second.overrideForSubtree(Provider((_) => 0)),
        ],
        child: HookBuilder(builder: (c) {
          return Text(forth().toString(), textDirection: TextDirection.ltr);
        }),
      ),
    );

    expect(find.text('2'), findsOneWidget);
  });
  // TODO make ProviderState hide the current value if the provider is mutable

  // TODO state hydratation
  // TODO Multiple async services merged into one
}
