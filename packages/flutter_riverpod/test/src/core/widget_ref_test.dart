import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';

void main() {
  testWidgets('Can be used with mutations', (tester) async {
    final mutation = Mutation<int>();
    late WidgetRef ref;

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, r, _) {
            ref = r;
            return const SizedBox();
          },
        ),
      ),
    );

    final sub = ref.listenManual(mutation, (a, b) {});

    await mutation.run(ref, (tsx) async {
      return 1;
    });

    expect(sub.read(), isMutationSuccess<int>(1));
  });
}
