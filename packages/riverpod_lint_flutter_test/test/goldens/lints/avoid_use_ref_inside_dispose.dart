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
    // ignore: avoid_use_ref_inside_dispose
    ref.read(provider);
    // ignore: avoid_use_ref_inside_dispose
    ref.watch(provider);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
