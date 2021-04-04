import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  testWidgets('useProvider can read scoped providers', (tester) async {
    final provider = ScopedProvider((_) => 0);

    final child = HookBuilder(
      builder: (context) {
        final value = useProvider(provider);
        return Text(
          '$value',
          textDirection: TextDirection.ltr,
        );
      },
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideWithValue(42),
        ],
        child: child,
      ),
    );

    expect(find.text('42'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          provider.overrideWithValue(21),
        ],
        child: child,
      ),
    );

    expect(find.text('21'), findsOneWidget);
  });

  testWidgets(
      'mutliple useProviders, when one of them forces rebuild, all dependencies are still flushed',
      (tester) async {
    final notifier = Counter();
    final provider = StateNotifierProvider<Counter, int>((_) => notifier);
    var callCount = 0;
    final computed = Provider((ref) {
      callCount++;
      return ref.watch(provider);
    });

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(
          builder: (context) {
            final first = useProvider(provider);
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
    int? result;

    await tester.pumpWidget(
      ProviderScope(
        child: InitState(
          initState: (context) => result = context.read(provider),
        ),
      ),
    );

    expect(result, 42);
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
          provider.overrideWithProvider(Provider((_) => 'override')),
        ],
        child: builder,
      ),
    );

    expect(find.text('root'), findsNothing);
    expect(find.text('override'), findsOneWidget);
    expect(find.text('root2'), findsOneWidget);
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
  const InitState({Key? key, required this.initState}) : super(key: key);

  // ignore: diagnostic_describe_all_properties
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
