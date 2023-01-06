import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final a = Provider.autoDispose((ref) {});

class B extends ConsumerWidget {
  const B({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // expect_lint: riverpod_avoid_read_inside_build, riverpod_avoid_read_auto_dispose
    ref.read(a);
    return Container();
  }
}

void main() {
  // Example of test usage
  final container = ProviderContainer();
  // Lint
  // expect_lint: riverpod_avoid_read_auto_dispose
  container.read(a);
  container.dispose();
}
