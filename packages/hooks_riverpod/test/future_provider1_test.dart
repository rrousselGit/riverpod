import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('FutureProvider into FutureProviderFamily', (tester) async {
    final futureProvider = FutureProvider((_) async => 42);

    final futureProviderFamily = FutureProvider<int>((ref) async {
      return await ref.watch(futureProvider.future) * 2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: HookBuilder(builder: (c) {
            return useProvider(futureProviderFamily).when(
              data: (value) => Text(value.toString()),
              loading: () => const Text('loading'),
              // ignore: avoid_types_on_closure_parameters
              error: (Object? err, stack) => const Text('error'),
            );
          }),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.pump();

    expect(find.text('84'), findsOneWidget);
  });

  testWidgets('FutureProviderFamily works with other providers',
      (tester) async {
    final provider = Provider((_) => 42);

    final futureProviderFamily = FutureProvider<int>((ref) async {
      return ref.watch(provider) * 2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: HookBuilder(builder: (c) {
            return useProvider(futureProviderFamily).when(
              data: (value) => Text(value.toString()),
              loading: () => const Text('loading'),
              // ignore: avoid_types_on_closure_parameters
              error: (Object? err, stack) => const Text('error'),
            );
          }),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.pump();

    expect(find.text('84'), findsOneWidget);
  });

  testWidgets('FutureProviderFamily can be used directly', (tester) async {
    final provider = Provider((_) => 42);

    final futureProviderFamily = FutureProvider<int>((ref) async {
      return ref.watch(provider) * 2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: HookBuilder(builder: (c) {
            return useProvider(futureProviderFamily).when(
              data: (value) => Text(value.toString()),
              loading: () => const Text('loading'),
              // ignore: avoid_types_on_closure_parameters
              error: (Object? err, stack) => const Text('error'),
            );
          }),
        ),
      ),
    );

    expect(find.text('loading'), findsOneWidget);

    await tester.pump();

    expect(find.text('84'), findsOneWidget);
  });
}
