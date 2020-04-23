import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider_hooks/provider_hooks.dart';
import 'package:provider_hooks/src/framework.dart';

void main() {
  testWidgets('wrap FutureProvider in KeepAlive still updates dependents',
      (tester) async {
    final onCreate = OnCreateMock();
    final onDispose = OnDisposeMock();

    final useFuture = FutureProvider((state) async {
      onCreate();
      state.onDispose(onDispose);

      return 42;
    }).asKeepAlive();

    final child = Directionality(
      textDirection: TextDirection.ltr,
      child: HookBuilder(builder: (c) {
        return useFuture().when(
          data: (value) => Text(value.toString()),
          loading: () => const Text('loading'),
          error: (dynamic err, stack) => const Text('error'),
        );
      }),
    );

    await tester.pumpWidget(ProviderScope(child: child));

    verify(onCreate()).called(1);
    verifyZeroInteractions(onDispose);

    expect(find.text('loading'), findsOneWidget);

    await tester.pump();

    verifyNoMoreInteractions(onCreate);
    verifyZeroInteractions(onDispose);

    expect(find.text('42'), findsOneWidget);

    await tester.pumpWidget(ProviderScope(child: Container()));

    verifyNoMoreInteractions(onCreate);
    verify(onDispose()).called(1);

    await tester.pumpWidget(ProviderScope(child: child));

    verify(onCreate()).called(1);
    verifyNoMoreInteractions(onDispose);

    expect(find.text('42'), findsNothing);
    expect(find.text('loading'), findsOneWidget);

    await tester.pump();

    verifyNoMoreInteractions(onCreate);
    verifyNoMoreInteractions(onDispose);

    expect(find.text('42'), findsOneWidget);

    await tester.pumpWidget(Container());

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onCreate);
  });
}

class OnDisposeMock extends Mock {
  void call();
}

class OnCreateMock extends Mock {
  void call();
}
