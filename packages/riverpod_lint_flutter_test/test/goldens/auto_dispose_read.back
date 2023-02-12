import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_dispose_read.g.dart';

final a = Provider.autoDispose((ref) {});

class B extends ConsumerWidget {
  const B({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // expect_lint: riverpod_avoid_read_auto_dispose
        ref.read(a);
      },
    );
  }
}

@riverpod
class Foo extends _$Foo {
  @override
  int build() => 0;

  void onChange() {
    // expect_lint: riverpod_avoid_read_auto_dispose
    ref.read(a);
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
