import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('HookConsumer', () {
    testWidgets('can both use hooks and listen to providers', (tester) async {
      final provider = Provider((ref) => 42);

      await tester.pumpWidget(
        ProviderScope(
          child: HookConsumer(builder: (context, ref, child) {
            final a = ref.watch(provider);
            final b = useState(21).value;

            return Text(
              '$a $b',
              textDirection: TextDirection.ltr,
            );
          }),
        ),
      );

      expect(find.text('42 21'), findsOneWidget);
    });
  });

  test('HookConsumerStatefulWidget', () {}, skip: true);
  test('HookConsumerWidget', () {}, skip: true);
}
