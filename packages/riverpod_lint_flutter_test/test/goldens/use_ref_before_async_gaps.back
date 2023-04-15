// Tests that the ref is used before async gaps in widget methods

// ignore_for_file: unused_result

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

final a = Provider((ref) => '');
final b = StateProvider((ref) => '');

/// GOOD
class C extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bn = ref.watch(b.notifier);
    return ElevatedButton(
      onPressed: () async {
        ref.read(a);
        final n = ref.read(b.notifier);
        fn2(ref);
        await Future.delayed(Duration(seconds: 1));
        n.state = '';
        bn.state = '';
      },
      child: Text('Hi'),
    );
  }

  Future<void> fn2(WidgetRef ref) async {
    ref.read(a);
    ref.invalidate(b);
    ref.listen(b, (_, __) {});
    ref.refresh(b);
  }
}

/// BAD
class D extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // Okay
        ref.read(a);
        ref.invalidate(b);
        ref.listen(b, (_, __) {});
        ref.refresh(b);
        Future.delayed(Duration(milliseconds: 10), () {
          // Bad ref is used in future callback
          // expect_lint: riverpod_no_ref_after_async
          ref.read(b.notifier).state = '';
        });
        // Bad (ref is used after async in fn)
        // expect_lint: riverpod_no_ref_after_async
        fn(ref);
        // Bad (ref is used after async in fn2)
        // expect_lint: riverpod_no_ref_after_async
        fn2(ref);
        // Bad (ref is used after async in fn3)
        // expect_lint: riverpod_no_ref_after_async
        fn3(ref);
        // Bad (ref is used after async in fn4)
        // expect_lint: riverpod_no_ref_after_async
        await fn4(ref);
        // Bad
        // expect_lint: riverpod_no_ref_after_async
        ref.read(b.notifier).state = '';
      },
      child: Text('Hi'),
    );
  }

  Future<void> fn(WidgetRef ref) async {
    await Future.delayed(Duration(seconds: 1));
    ref.read(b.notifier).state = '';
  }

  Future<void> fn2(WidgetRef ref) async {
    await Future.delayed(Duration(seconds: 1));
    ref.invalidate(b);
  }

  Future<void> fn3(WidgetRef ref) async {
    await Future.delayed(Duration(seconds: 1));

    ref.listen(b, (_, __) {});
  }

  Future<void> fn4(WidgetRef ref) async {
    await Future.delayed(Duration(seconds: 1));
    ref.refresh(b);
  }
}

final stream = StreamProvider((ref) async* {
  // No lint after async
  await Future.delayed(Duration(seconds: 1));
  ref.watch(a);
});

final future = FutureProvider((ref) async* {
  await Future.delayed(Duration(seconds: 1));
  // No lint after async
  ref.watch(a);
});
