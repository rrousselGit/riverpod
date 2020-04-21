// ignore_for_file: omit_local_variable_types
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider_hooks/provider_hooks.dart';

void main() {
  testWidgets('ProviderBuilder1', (tester) async {
    final provider = Provider((_) => 42);

    // These check the type safety
    ProviderState<int> providerState;
    ProviderListenerState<Immutable<int>> firstState;

    final Provider1<Immutable<int>, int> provider1 =
        ProviderBuilder<int>().add(provider).build(
      (state, first) {
        providerState = state;
        firstState = first;
        return first.value * 2;
      },
    );

    await tester.pumpWidget(
      ProviderScope(
        child: HookBuilder(builder: (c) {
          return Text(
            provider1().toString(),
            textDirection: TextDirection.ltr,
          );
        }),
      ),
    );

    expect(providerState, isNotNull);
    expect(firstState, isNotNull);
    expect(find.text('84'), findsOneWidget);
  });
}
