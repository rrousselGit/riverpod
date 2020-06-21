import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:state_notifier/state_notifier.dart';

void main() {
  testWidgets(
      'mutliple useProviders, when one of them forces rebuild, all dependencies are still flushed',
      (tester) async {
    final notifier = Counter();
    final provider = StateNotifierProvider((_) => notifier);
    var callCount = 0;
    final computed = Computed((read) {
      callCount++;
      return read(provider.state);
    });

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(
          builder: (context) {
            final first = useProvider(provider.state);
            final second = useProvider(computed);
            return Text(
              '$first $second',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('0 0'), findsOneWidget);
    expect(callCount, 1);

    notifier.increment();
    await tester.pump();

    expect(find.text('1 1'), findsOneWidget);
    expect(callCount, 2);
  });
  testWidgets('AlwaysAliveProviderBase.read(context) inside initState',
      (tester) async {
    final provider = Provider((_) => 42);
    int result;

    await tester.pumpWidget(
      ProviderScope(
        child: InitState(
          initState: (context) => result = provider.read(context),
        ),
      ),
    );

    expect(result, 42);
  });
  testWidgets('AlwaysAliveProviderBase.read(context) inside build',
      (tester) async {
    final provider = Provider((_) => 42);

    await tester.pumpWidget(
      ProviderScope(
        child: Builder(
          builder: (context) {
            provider.read(context);
            return Container();
          },
        ),
      ),
    );

    expect(tester.takeException(), isUnsupportedError);
  });
  testWidgets('adding overrides throws', (tester) async {
    final provider = Provider((_) => 0);

    await tester.pumpWidget(ProviderScope(child: Container()));

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideAs(Provider((_) => 1)),
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
    final provider = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideAs(Provider((_) => 1)),
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
    final provider = Provider((_) => 0);
    final provider2 = Provider((_) => 0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideAs(Provider((_) => 1)),
        ],
        child: Container(),
      ),
    );

    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider2.overrideAs(Provider((_) => 1)),
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
    final provider = Provider((_) => 'foo');

    await tester.pumpWidget(
      HookBuilder(builder: (context) {
        useProvider(provider);
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
    final provider = Provider((_) => 'root');
    final provider2 = Provider((_) => 'root2');

    final builder = Directionality(
      textDirection: TextDirection.ltr,
      child: HookBuilder(
        builder: (context) {
          return Column(
            children: <Widget>[
              Text(useProvider(provider)),
              Text(useProvider(provider2)),
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
          provider.overrideAs(Provider((_) => 'override')),
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
        return useProvider(provider).when(
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
            provider.overrideAs(
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
    // final provider = Provider.value('root');
    // final provider2 = Provider.value('root2');

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
    //       useProvider.overrideAs(Provider.value('override1')),
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
    //       useProvider.overrideAs(Provider.value('override2')),
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
    final provider = Provider((_) => 'root');
    final provider2 = Provider((_) => 'root2');

    var buildCount = 0;
    var buildCount2 = 0;

    final builder = Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: <Widget>[
          HookBuilder(builder: (context) {
            buildCount++;
            return Text(useProvider(provider));
          }),
          HookBuilder(builder: (context) {
            buildCount2++;
            return Text(useProvider(provider2));
          }),
        ],
      ),
    );

    final secondScope = ProviderScope(
      overrides: [
        provider2.overrideAs(Provider((_) => 'override2')),
      ],
      child: builder,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideAs(Provider((_) => 'rootoverride')),
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

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

class MockCreateState extends Mock {
  void call();
}

class InitState extends StatefulWidget {
  const InitState({Key key, this.initState}) : super(key: key);

  final void Function(BuildContext context) initState;

  @override
  _InitStateState createState() => _InitStateState();
}

class _InitStateState extends State<InitState> {
  @override
  void initState() {
    super.initState();
    widget.initState(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
