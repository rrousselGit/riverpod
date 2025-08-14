import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Can start a mutation and have the result in the same frame',
      (tester) async {
    final mut = Mutation<int>();

    await tester.pumpWidget(
      ProviderScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Consumer(
            builder: (context, ref, _) {
              switch (ref.watch(mut)) {
                case MutationIdle<int>():
                case MutationPending<int>():
                case MutationError<int>():
                  return const SizedBox();
                case MutationSuccess<int>(:final value):
                  return Text(value.toString());
              }
            },
          ),
        ),
      ),
    );

    final container = tester.container();

    expect(find.text('42'), findsNothing);

    await mut.run(container, (ref) async {
      return 42;
    });
    await tester.pump();

    expect(find.text('42'), findsOneWidget);
  });
}
