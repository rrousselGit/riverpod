import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:mockito/mockito.dart';

void main() {
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
      Consumer((context, watch) {
        watch(provider);
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
      child: Column(
        children: <Widget>[
          Consumer((c, watch) => Text(watch(provider))),
          Consumer((c, watch) => Text(watch(provider2))),
        ],
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

  testWidgets('ProviderScope can be nested', (tester) async {
    final provider = Provider((_) => 'root');
    final provider2 = Provider((_) => 'root2');

    var buildCount = 0;
    var buildCount2 = 0;

    final builder = Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: <Widget>[
          Consumer((c, watch) {
            buildCount++;
            return Text(watch(provider));
          }),
          Consumer((c, watch) {
            buildCount2++;
            return Text(watch(provider2));
          }),
        ],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideAs(Provider((_) => 'rootoverride')),
        ],
        child: ProviderScope(child: builder),
      ),
    );

    expect(buildCount, 1);
    expect(buildCount2, 1);
    expect(find.text('rootoverride'), findsOneWidget);
    expect(find.text('root2'), findsOneWidget);
  });
  testWidgets('debugFillProperties', (tester) async {
    final unnamed = Provider((_) => 0);
    final named = StateNotifierProvider((_) => Counter(), name: 'counter');
    final scopeKey = GlobalKey();

    await tester.pumpWidget(
      ProviderScope(
        key: scopeKey,
        child: Consumer((c, watch) {
          final value = watch(unnamed);
          final count = watch(named.state);
          return Text(
            'value: $value count: $count',
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(find.text('value: 0 count: 0'), findsOneWidget);

    expect(
      scopeKey.currentContext.toString(),
      equalsIgnoringHashCodes('ProviderScope-[GlobalKey#00000]('
          'state: ProviderScopeState#00000, '
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
