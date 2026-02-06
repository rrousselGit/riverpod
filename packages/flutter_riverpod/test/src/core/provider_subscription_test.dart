import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('flushes the provider', (tester) async {
    // Regression test for https://github.com/rrousselGit/riverpod/issues/4669
    final dep = NotifierProvider(() => DeferredNotifier<int>((ref, _) => 0));
    final provider = Provider((ref) => ref.watch(dep));

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          routes: {'/settings': (context) => Container()},
          home: Consumer(
            builder: (context, ref, _) {
              final value = ref.watch(provider);
              return Text('$value', textDirection: TextDirection.ltr);
            },
          ),
        ),
      ),
    );

    final container = tester.container();
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));

    unawaited(navigator.pushNamed('/settings'));
    await tester.pumpAndSettle();

    container.read(dep.notifier).state++;

    unawaited(navigator.maybePop());
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });
}

class DeferredNotifier<StateT> extends Notifier<StateT> {
  DeferredNotifier(this._build);

  final StateT Function(Ref ref, DeferredNotifier<StateT> self) _build;

  @override
  StateT build() {
    return _build(ref, this);
  }
}
