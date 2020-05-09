// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/src/framework.dart';

void main() {
  // TODO keep alive depending on itself throws
  testWidgets('wrap FutureProvider in KeepAlive still updates dependents',
      (tester) async {
    // final onCreate = OnCreateMock();
    // final onDispose = OnDisposeMock();

    // final useFuture = FutureProvider((state) async {
    //   onCreate();
    //   state.onDispose(onDispose);

    //   return 42;
    // }).asKeepAlive();

    // final child = Directionality(
    //   textDirection: TextDirection.ltr,
    //   child: HookBuilder(builder: (c) {
    //     return useFuture().when(
    //       data: (value) => Text(value.toString()),
    //       loading: () => const Text('loading'),
    //       error: (dynamic err, stack) => const Text('error'),
    //     );
    //   }),
    // );

    // await tester.pumpWidget(ProviderScope(child: child));

    // verify(onCreate()).called(1);
    // verifyZeroInteractions(onDispose);

    // expect(find.text('loading'), findsOneWidget);

    // await tester.pump();

    // verifyNoMoreInteractions(onCreate);
    // verifyZeroInteractions(onDispose);

    // expect(find.text('42'), findsOneWidget);

    // await tester.pumpWidget(ProviderScope(child: Container()));

    // verifyNoMoreInteractions(onCreate);
    // verify(onDispose()).called(1);

    // await tester.pumpWidget(ProviderScope(child: child));

    // verify(onCreate()).called(1);
    // verifyNoMoreInteractions(onDispose);

    // expect(find.text('42'), findsNothing);
    // expect(find.text('loading'), findsOneWidget);

    // await tester.pump();

    // verifyNoMoreInteractions(onCreate);
    // verifyNoMoreInteractions(onDispose);

    // expect(find.text('42'), findsOneWidget);

    // await tester.pumpWidget(Container());

    // verify(onDispose()).called(1);
    // verifyNoMoreInteractions(onCreate);
  }, skip: true);
  testWidgets('didUpdate throws if provider changed', (tester) async {
    // final useFuture = FutureProvider((_) async => 42);

    // final child = Directionality(
    //   textDirection: TextDirection.ltr,
    //   child: HookBuilder(builder: (c) {
    //     return useFuture().when(
    //       data: (value) => Text(value.toString()),
    //       loading: () => const Text('loading'),
    //       error: (dynamic err, stack) => const Text('error'),
    //     );
    //   }),
    // );

    // await tester.pumpWidget(
    //   ProviderScope(
    //     overrides: [
    //       useFuture.overrideForSubtree(
    //         FutureProvider((_) async => 21).asKeepAlive(),
    //       ),
    //     ],
    //     child: child,
    //   ),
    // );

    // expect(find.text('loading'), findsOneWidget);

    // await tester.pumpWidget(
    //   ProviderScope(
    //     overrides: [
    //       useFuture.overrideForSubtree(
    //         FutureProvider((_) async => 21).asKeepAlive(),
    //       ),
    //     ],
    //     child: child,
    //   ),
    // );

    // expect(tester.takeException(), isUnsupportedError);
  }, skip: true);
  testWidgets('didUpdate works if provider is unchanged', (tester) async {
    // final useFuture = FutureProvider((_) async => 42);

    // final useOverride = FutureProvider((_) async => 21).asKeepAlive();

    // final child = Directionality(
    //   textDirection: TextDirection.ltr,
    //   child: HookBuilder(builder: (c) {
    //     return useFuture().when(
    //       data: (value) => Text(value.toString()),
    //       loading: () => const Text('loading'),
    //       error: (dynamic err, stack) => const Text('error'),
    //     );
    //   }),
    // );

    // await tester.pumpWidget(
    //   ProviderScope(
    //     overrides: [useFuture.overrideForSubtree(useOverride)],
    //     child: child,
    //   ),
    // );

    // expect(find.text('loading'), findsOneWidget);

    // await tester.pumpWidget(
    //   ProviderScope(
    //     overrides: [useFuture.overrideForSubtree(useOverride)],
    //     child: child,
    //   ),
    // );

    // expect(find.text('21'), findsOneWidget);
  }, skip: true);
}

class OnDisposeMock extends Mock {
  void call();
}

class OnCreateMock extends Mock {
  void call();
}
