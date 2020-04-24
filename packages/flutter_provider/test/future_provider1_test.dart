// import 'package:flutter/widgets.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_provider/flutter_provider.dart';

void main() {
  // testWidgets('FutureProvider into FutureProvider1', (tester) async {
  //   final useFuture = FutureProvider((_) async => 42);

  //   final useFuture1 = FutureProviderBuilder<int>() //
  //       .add(useFuture)
  //       .build((state, other) async {
  //     return await other.future * 2;
  //   });

  //   await tester.pumpWidget(
  //     ProviderScope(
  //       child: Directionality(
  //         textDirection: TextDirection.ltr,
  //         child: HookBuilder(builder: (c) {
  //           return useFuture1().when(
  //             data: (value) => Text(value.toString()),
  //             loading: () => const Text('loading'),
  //             error: (dynamic err, stack) => const Text('error'),
  //           );
  //         }),
  //       ),
  //     ),
  //   );

  //   expect(find.text('loading'), findsOneWidget);

  //   await tester.pump();

  //   expect(find.text('84'), findsOneWidget);
  // });
  // testWidgets('FutureProvider1 works with other providers', (tester) async {
  //   final useFuture = Provider((_) => 42);

  //   final useFuture1 = FutureProviderBuilder<int>() //
  //       .add(useFuture)
  //       .build((state, other) async {
  //     return other.value * 2;
  //   });

  //   await tester.pumpWidget(
  //     ProviderScope(
  //       child: Directionality(
  //         textDirection: TextDirection.ltr,
  //         child: HookBuilder(builder: (c) {
  //           return useFuture1().when(
  //             data: (value) => Text(value.toString()),
  //             loading: () => const Text('loading'),
  //             error: (dynamic err, stack) => const Text('error'),
  //           );
  //         }),
  //       ),
  //     ),
  //   );

  //   expect(find.text('loading'), findsOneWidget);

  //   await tester.pump();

  //   expect(find.text('84'), findsOneWidget);
  // });
  // testWidgets('FutureProvider1 can be used directly', (tester) async {
  //   final useFuture = Provider((_) => 42);

  //   final useFuture1 = FutureProvider1<ProviderValue<int>, int>(
  //     useFuture,
  //     (state, other) async {
  //       return other.value * 2;
  //     },
  //   );

  //   await tester.pumpWidget(
  //     ProviderScope(
  //       child: Directionality(
  //         textDirection: TextDirection.ltr,
  //         child: HookBuilder(builder: (c) {
  //           return useFuture1().when(
  //             data: (value) => Text(value.toString()),
  //             loading: () => const Text('loading'),
  //             error: (dynamic err, stack) => const Text('error'),
  //           );
  //         }),
  //       ),
  //     ),
  //   );

  //   expect(find.text('loading'), findsOneWidget);

  //   await tester.pump();

  //   expect(find.text('84'), findsOneWidget);
  // });
}
