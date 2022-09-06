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
          child: HookConsumer(
            builder: (context, ref, child) {
              final a = ref.watch(provider);
              final b = useState(21).value;

              return Text(
                '$a $b',
                textDirection: TextDirection.ltr,
              );
            },
          ),
        ),
      );

      expect(find.text('42 21'), findsOneWidget);
    });
  });

  testWidgets('HookConsumerStatefulWidget', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HookStatefulTest()));

    expect(find.text('Hello world 0 0'), findsOneWidget);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(find.text('Hello world 1 1'), findsOneWidget);
  });

  testWidgets('HookConsumerWidget', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HookConsumerTest()));

    expect(find.text('Hello world 0'), findsOneWidget);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(find.text('Hello world 1'), findsOneWidget);
  });
}

final provider = Provider((ref) => 'Hello world');

class HookStatefulTest extends StatefulHookConsumerWidget {
  const HookStatefulTest({super.key});

  @override
  HookStatefulTestState createState() => HookStatefulTestState();
}

class HookStatefulTestState extends ConsumerState<HookStatefulTest> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final count2 = useState(0);

    return GestureDetector(
      onTap: () {
        count2.value++;
        setState(() => count++);
      },
      child: Text(
        '${ref.watch(provider)} $count ${count2.value}',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}

class HookConsumerTest extends HookConsumerWidget {
  const HookConsumerTest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = useState(0);

    return GestureDetector(
      onTap: () {
        count.value++;
      },
      child: Text(
        '${ref.watch(provider)} ${count.value}',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
