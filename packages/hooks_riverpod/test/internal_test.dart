import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('ref.watch supports changing the provider', (tester) async {
    final provider1 = NotifierProvider<Counter, int>(Counter.new);
    final provider2 = NotifierProvider<Counter, int>(() => Counter(42));
    var buildCount = 0;

    Widget build(NotifierProvider<Counter, int> provider) {
      return ProviderScope(
        child: HookConsumer(
          builder: (c, ref, child) {
            buildCount++;
            final value = ref.watch(provider);
            return Text('$value', textDirection: TextDirection.ltr);
          },
        ),
      );
    }

    await tester.pumpWidget(build(provider1));

    final container = tester.container();
    final notifier1 = container.read(provider1.notifier);

    expect(find.text('0'), findsOneWidget);
    expect(buildCount, 1);

    await tester.pumpWidget(build(provider2));

    final notifier2 = container.read(provider2.notifier);

    expect(find.text('42'), findsOneWidget);
    expect(buildCount, 2);

    notifier1.increment();
    await tester.pump();

    expect(find.text('42'), findsOneWidget);
    expect(buildCount, 2);

    notifier2.increment();
    await tester.pump();

    expect(find.text('43'), findsOneWidget);
    expect(buildCount, 3);
  });
}

class Counter extends Notifier<int> {
  Counter([this._initialValue = 0]);

  final int _initialValue;

  @override
  int build() => _initialValue;

  void increment() => state++;
}
