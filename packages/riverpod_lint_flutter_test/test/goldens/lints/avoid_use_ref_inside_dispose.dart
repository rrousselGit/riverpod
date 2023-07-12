import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final provider = Provider((ref) => 0);

class MyWidget extends ConsumerStatefulWidget {
  const MyWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  void dispose() {
    // expect_lint: avoid_ref_inside_state_dispose
    ref.read(provider);
    // expect_lint: avoid_ref_inside_state_dispose
    ref.watch(provider);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PlainClass with ChangeNotifier {
  PlainClass(this.ref);

  final WidgetRef ref;

  @override
  void dispose() {
    ref.read(provider);
    ref.watch(provider);

    super.dispose();
  }
}
