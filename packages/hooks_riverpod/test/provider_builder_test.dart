// ignore_for_file: omit_local_variable_types
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('ProviderBuilder1', (tester) async {
    final provider = Provider((_) => 42);

    // These check the type safety
    ProviderContext providerContext;
    ProviderSubscription<int> firstState;

    final Provider<int> provider1 = Provider<int>((context) {
      final first = context.dependOn(provider);
      providerContext = context;
      firstState = first;
      return first.value * 2;
    });

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          return Text(
            useProvider(provider1).toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(providerContext, isNotNull);
    expect(firstState, isNotNull);
    expect(find.text('84'), findsOneWidget);
  });
}
