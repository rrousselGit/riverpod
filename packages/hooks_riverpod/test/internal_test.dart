import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  // testWidgets('ref.watch supports changing the selected provider',
  //     (tester) async {
  //   final notifier1 = Counter();
  //   final provider1 = StateNotifierProvider<Counter, int>((_) => notifier1);
  //   final notifier2 = Counter(42);
  //   final provider2 = StateNotifierProvider<Counter, int>((_) => notifier2);
  //   var buildCount = 0;
  //   var selectCount = 0;

  //   Widget build(StateNotifierProvider<Counter, int> provider) {
  //     return ProviderScope(
  //       child: HookConsumer(builder: (c, ref, child) {
  //         buildCount++;
  //         final value = ref.watch(provider.select((value) {
  //           selectCount++;
  //           return value > 5;
  //         }));
  //         return Text('$value', textDirection: TextDirection.ltr);
  //       }),
  //     );
  //   }

  //   await tester.pumpWidget(build(provider1));

  //   expect(find.text('false'), findsOneWidget);
  //   expect(buildCount, 1);
  //   expect(selectCount, 1);

  //   await tester.pumpWidget(build(provider2));

  //   expect(find.text('true'), findsOneWidget);
  //   expect(buildCount, 2);
  //   expect(selectCount, 2);

  //   notifier1.state = 42;
  //   await tester.pump();

  //   expect(find.text('true'), findsOneWidget);
  //   expect(buildCount, 2);
  //   expect(selectCount, 2);

  //   notifier2.state = 0;
  //   await tester.pump();

  //   expect(find.text('false'), findsOneWidget);
  //   expect(buildCount, 3);
  //   expect(selectCount, 4);
  // });

  testWidgets('ref.watch supports changing the provider', (tester) async {
    final notifier1 = Counter();
    final provider1 = StateNotifierProvider<Counter, int>((_) => notifier1);
    final notifier2 = Counter(42);
    final provider2 = StateNotifierProvider<Counter, int>((_) => notifier2);
    var buildCount = 0;

    Widget build(StateNotifierProvider<Counter, int> provider) {
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

    expect(find.text('0'), findsOneWidget);
    expect(buildCount, 1);

    await tester.pumpWidget(build(provider2));

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

  group('ref.watch(provider.select)', () {
    // testWidgets('simple flow', (tester) async {
    //   final notifier = Counter();
    //   final provider = StateNotifierProvider<Counter, int>((_) => notifier);
    //   final selector = SelectorSpy<int>();
    //   var buildCount = 0;
    //   Object? lastSelectedValue;

    //   await tester.pumpWidget(
    //     ProviderScope(
    //       child: HookConsumer(builder: (c, ref, child) {
    //         buildCount++;
    //         lastSelectedValue = ref.watch(provider.select((value) {
    //           selector(value);
    //           return value.isNegative;
    //         }));
    //         return Container();
    //       }),
    //     ),
    //   );

    //   expect(lastSelectedValue, false);
    //   expect(buildCount, 1);
    //   verify(selector(0)).called(1);
    //   verifyNoMoreInteractions(selector);

    //   notifier.increment();

    //   verifyNoMoreInteractions(selector);

    //   await tester.pump();

    //   expect(lastSelectedValue, false);
    //   expect(buildCount, 1);
    //   verify(selector(1)).called(1);
    //   verifyNoMoreInteractions(selector);
    // });

    // testWidgets('recompute value when changing selector', (tester) async {
    //   final notifier = Counter();
    //   final provider = StateNotifierProvider<Counter, int>((_) => notifier);
    //   final selector = SelectorSpy<String>();
    //   String? value2;
    //   final build = BuildSpy();
    //   when(build()).thenAnswer((_) => value2 = 'foo');
    //   Object? lastSelectedValue;

    //   await tester.pumpWidget(
    //     ProviderScope(child: HookConsumer(builder: (c, ref, child) {
    //       build();
    //       lastSelectedValue = ref.watch(provider.select((value) {
    //         selector('$value $value2');
    //         return '$value $value2';
    //       }));
    //       return Container();
    //     })),
    //   );

    //   expect(lastSelectedValue, '0 foo');
    //   verifyInOrder([
    //     build(),
    //     selector('0 foo'),
    //   ]);
    //   verifyNoMoreInteractions(selector);
    //   verifyNoMoreInteractions(build);

    //   notifier.increment();
    //   when(build()).thenAnswer((_) => value2 = 'bar');

    //   await tester.pump();

    //   expect(lastSelectedValue, '1 bar');
    //   verifyInOrder([
    //     selector('1 foo'),
    //     build(),
    //     selector('1 bar'),
    //   ]);
    //   verifyNoMoreInteractions(selector);
    //   verifyNoMoreInteractions(build);
    // });

    // testWidgets('stop calling selectors after one cause rebuild',
    //     (tester) async {
    //   final notifier = Counter();
    //   final provider = StateNotifierProvider<Counter, int>((_) => notifier);
    //   bool? lastSelectedValue;
    //   final selector = SelectorSpy<int>();
    //   int? lastSelectedValue2;
    //   final selector2 = SelectorSpy<int>();
    //   Object? lastSelectedValue3;
    //   final selector3 = SelectorSpy<int>();
    //   final build = BuildSpy();

    //   await tester.pumpWidget(
    //     ProviderScope(child: HookConsumer(builder: (c, ref, child) {
    //       build();
    //       lastSelectedValue = ref.watch(provider.select((value) {
    //         selector(value);
    //         return value.isNegative;
    //       }));
    //       lastSelectedValue2 = ref.watch(provider.select((value) {
    //         selector2(value);
    //         return value;
    //       }));
    //       lastSelectedValue3 = ref.watch(provider.select((value) {
    //         selector3(value);
    //         return value;
    //       }));
    //       return Container();
    //     })),
    //   );

    //   verifyInOrder([
    //     build(),
    //     selector(0),
    //     selector2(0),
    //     selector3(0),
    //   ]);
    //   verifyNoMoreInteractions(build);
    //   verifyNoMoreInteractions(selector);
    //   verifyNoMoreInteractions(selector2);
    //   verifyNoMoreInteractions(selector3);
    //   expect(lastSelectedValue, false);
    //   expect(lastSelectedValue2, 0);
    //   expect(lastSelectedValue3, 0);

    //   notifier.increment();

    //   verifyNoMoreInteractions(build);
    //   verifyNoMoreInteractions(selector);
    //   verifyNoMoreInteractions(selector2);
    //   verifyNoMoreInteractions(selector3);

    //   await tester.pump();

    //   verifyInOrder([
    //     selector(1),
    //     selector2(1),
    //     build(),
    //     selector(1),
    //     selector2(1),
    //     selector3(1),
    //   ]);
    //   verifyNoMoreInteractions(build);
    //   verifyNoMoreInteractions(selector);
    //   verifyNoMoreInteractions(selector2);
    //   verifyNoMoreInteractions(selector3);
    //   expect(lastSelectedValue, false);
    //   expect(lastSelectedValue2, 1);
    //   expect(lastSelectedValue3, 1);
    // });
  });
}

// class SelectorSpy<T> extends Mock {
//   void call(T value);
// }

// class BuildSpy extends Mock {
//   void call();
// }

// class MockCreateState extends Mock {
//   void call();
// }

class Counter extends StateNotifier<int> {
  Counter([super.initialValue = 0]);

  void increment() => state++;

  @override
  set state(int value) {
    super.state = value;
  }
}
