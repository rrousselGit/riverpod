import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  testWidgets('adding overrides throws', (tester) async {
    final useProvider = Provider((_) => 0);

    await tester.pumpWidget(ProviderScope(child: Container()));

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(
      tester.takeException(),
      isUnsupportedError.having((s) => s.message, 'message',
          'Adding or removing provider overrides is not supported'),
    );
  });
  testWidgets('removing overrides throws', (tester) async {
    final useProvider = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(ProviderScope(child: Container()));

    expect(
      tester.takeException(),
      isUnsupportedError.having((s) => s.message, 'message',
          'Adding or removing provider overrides is not supported'),
    );
  });

  testWidgets('overrive origin mismatch throws', (tester) async {
    final useProvider = Provider((_) => 0);
    final useProvider2 = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider2.overrideForSubtree(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(
      tester.takeException(),
      isUnsupportedError.having(
        (s) => s.message,
        'message',
        'The provider overriden at the index 0 changed, which is unsupported.',
      ),
    );
  });

  test('ProviderScope requires a child', () {
    expect(() => ProviderScope(child: null), throwsAssertionError);
  });
  testWidgets('throws if no ProviderScope found', (tester) async {
    final useProvider = Provider((_) => 'foo');

    await tester.pumpWidget(
      HookBuilder(builder: (context) {
        useProvider();
        return Container();
      }),
    );

    expect(
      tester.takeException(),
      isA<StateError>()
          .having((e) => e.message, 'message', 'No ProviderScope found'),
    );
  });

  testWidgets('providers can be overriden', (tester) async {
    final useProvider = Provider((_) => 'root');
    final useProvider2 = Provider((_) => 'root2');

    final builder = Directionality(
      textDirection: TextDirection.ltr,
      child: HookBuilder(
        builder: (context) {
          final provider = useProvider();
          final provider2 = useProvider2();
          return Column(
            children: <Widget>[
              Text(provider),
              Text(provider2),
            ],
          );
        },
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        child: builder,
      ),
    );

    expect(find.text('root'), findsOneWidget);
    expect(find.text('root2'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        key: UniqueKey(),
        overrides: [
          useProvider.overrideForSubtree(Provider((_) => 'override')),
        ],
        child: builder,
      ),
    );

    expect(find.text('root'), findsNothing);
    expect(find.text('override'), findsOneWidget);
    expect(find.text('root2'), findsOneWidget);
  });
  testWidgets('listeners can be moved to depend on a new provider',
      (tester) async {
    final firstCompleter = Completer<int>.sync();
    final secondCompleter = Completer<int>.sync();

    final provider = FutureProvider((_) => firstCompleter.future);

    var buildCount = 0;

    final child = Directionality(
      key: GlobalKey(),
      textDirection: TextDirection.ltr,
      child: HookBuilder(builder: (c) {
        buildCount++;
        final value = provider();

        return value.when(
          data: (v) => Text(v.toString()),
          loading: () => const Text('loading'),
          error: (dynamic err, stack) => const Text('error'),
        );
      }),
    );

    await tester.pumpWidget(ProviderScope(child: child));

    expect(find.text('loading'), findsOneWidget);
    expect(buildCount, 1);

    await tester.pumpWidget(
      ProviderScope(
        child: ProviderScope(
          overrides: [
            provider.overrideForSubtree(
              FutureProvider((_) => secondCompleter.future),
            ),
          ],
          child: child,
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);
    expect(buildCount, 2);

    firstCompleter.complete(42);

    await tester.pump();

    expect(buildCount, 2);
    expect(find.text('loading'), findsOneWidget);

    secondCompleter.complete(21);

    await tester.pump();

    expect(find.text('21'), findsOneWidget);
    expect(buildCount, 3);
  });
  testWidgets(
      "don't rebuild a dependent if another unrelated useProvider is updated",
      (tester) async {
    // final useProvider = Provider.value('root');
    // final useProvider2 = Provider.value('root2');

    // var buildCount = 0;
    // var buildCount2 = 0;

    // final builder = Directionality(
    //   textDirection: TextDirection.ltr,
    //   child: Column(
    //     children: <Widget>[
    //       HookBuilder(builder: (context) {
    //         buildCount++;
    //         final provider = useProvider();
    //         return Text(provider);
    //       }),
    //       HookBuilder(builder: (context) {
    //         buildCount2++;
    //         final provider2 = useProvider2();
    //         return Text(provider2);
    //       }),
    //     ],
    //   ),
    // );

    // await tester.pumpWidget(
    //   ProviderScope(
    //     overrides: [
    //       useProvider.overrideForSubtree(Provider.value('override1')),
    //     ],
    //     child: builder,
    //   ),
    // );

    // expect(find.text('override1'), findsOneWidget);
    // expect(find.text('root2'), findsOneWidget);
    // expect(buildCount, 1);
    // expect(buildCount2, 1);

    // await tester.pumpWidget(
    //   ProviderScope(
    //     overrides: [
    //       useProvider.overrideForSubtree(Provider.value('override2')),
    //     ],
    //     child: builder,
    //   ),
    // );

    // expect(find.text('override2'), findsOneWidget);
    // expect(find.text('root2'), findsOneWidget);
    // expect(buildCount, 2);
    // expect(buildCount2, 1);
  }, skip: true);
  testWidgets('ProviderScope can be nested', (tester) async {
    final useProvider = Provider((_) => 'root');
    final useProvider2 = Provider((_) => 'root2');

    var buildCount = 0;
    var buildCount2 = 0;

    final builder = Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: <Widget>[
          HookBuilder(builder: (context) {
            buildCount++;
            final provider = useProvider();
            return Text(provider);
          }),
          HookBuilder(builder: (context) {
            buildCount2++;
            final provider2 = useProvider2();
            return Text(provider2);
          }),
        ],
      ),
    );

    final secondScope = ProviderScope(
      overrides: [
        useProvider2.overrideForSubtree(Provider((_) => 'override2')),
      ],
      child: builder,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useProvider.overrideForSubtree(Provider((_) => 'rootoverride')),
        ],
        child: secondScope,
      ),
    );

    expect(buildCount, 1);
    expect(buildCount2, 1);
    expect(find.text('rootoverride'), findsOneWidget);
    expect(find.text('override2'), findsOneWidget);
  });
}

class MockCreateState extends Mock {
  void call();
}
