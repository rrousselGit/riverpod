// ignore_for_file: unused_result

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mutate_in_create.g.dart';

final a = StateProvider((ref) => 'String');

final b = Provider<bool>((ref) {
  // expect_lint: riverpod_no_mutate_sync
  ref.watch(a.notifier).state = '';
  // expect_lint: riverpod_no_mutate_sync
  ref.watch(c.notifier).fn();
  return false;
});

final c = StateNotifierProvider<C, int>((ref) {
  return C(ref);
});

class C extends StateNotifier<int> {
  C(this.ref) : super(0) {
    // expect_lint: riverpod_no_mutate_sync
    ref.read(a.notifier).state = '';
    Future.delayed(Duration(milliseconds: 10), () {
      ref.read(a.notifier).state = '';
    });
    // expect_lint: riverpod_no_mutate_sync
    ref.read(a.notifier).state = '';
    // expect_lint: riverpod_no_mutate_sync
    fn();
    // expect_lint: riverpod_no_mutate_sync
    fn2();
    fn3();
  }
  final Ref ref;

  void fn() {
    ref.read(a.notifier).state = '';
  }

  // Not okay
  Future<void> fn2() async {
    ref.read(a.notifier).state = '';
    await Future.delayed(Duration(seconds: 1));
  }

  // Okay
  Future<void> fn3() async {
    await Future.delayed(Duration(seconds: 1));
    ref.read(a.notifier).state = '';
  }
}

class D extends ConsumerWidget {
  const D({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // expect_lint: riverpod_no_mutate_sync
    ref.watch(a.notifier).state = '';
    // expect_lint: riverpod_no_mutate_sync
    fn(ref);
    // expect_lint: riverpod_no_mutate_sync
    fn2(ref);
    fn3(ref);
    // expect_lint: riverpod_no_mutate_sync
    ref.watch(c.notifier).fn();
    // expect_lint: riverpod_no_mutate_sync
    ref.fn_g;
    // expect_lint: riverpod_no_mutate_sync
    ref.fn2_g;
    ref.fn3_g;
    return Container();
  }

  void fn(WidgetRef ref) {
    ref.read(a.notifier).state = '';
  }

  // Not okay
  Future<void> fn2(WidgetRef ref) async {
    ref.read(a.notifier).state = '';
    await Future.delayed(Duration(seconds: 1));
  }

  // Okay, for synchronous, but bad for async usage
  Future<void> fn3(WidgetRef ref) async {
    await Future.delayed(Duration(seconds: 1));
    ref.read(a.notifier).state = '';
  }
}

extension on WidgetRef {
  void fn() {
    read(a.notifier).state = '';
  }

  void get fn_g => fn();

  // Not okay
  Future<void> fn2() async {
    read(a.notifier).state = '';
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> get fn2_g => fn2();

  // Okay
  Future<void> fn3() async {
    await Future.delayed(Duration(seconds: 1));
    read(a.notifier).state = '';
  }

  Future<void> get fn3_g => fn3();
}

class E extends ChangeNotifier {
  E(this.ref) {
    // expect_lint: riverpod_no_mutate_sync
    ref.read(a.notifier).state = '';
    Future.delayed(Duration(milliseconds: 10), () {
      ref.read(a.notifier).state = '';
    });
    // expect_lint: riverpod_no_mutate_sync
    ref.read(a.notifier).state = '';
    // expect_lint: riverpod_no_mutate_sync
    fn();
    // expect_lint: riverpod_no_mutate_sync
    fn2();
    // expect_lint: riverpod_no_mutate_sync
    ref.invalidate(a);
    // expect_lint: riverpod_no_mutate_sync
    ref.invalidateSelf();
    fn3();
  }
  final Ref ref;

  void fn() {
    ref.read(a.notifier).state = '';
  }

  // Not okay
  Future<void> fn2() async {
    ref.read(a.notifier).state = '';
    await Future.delayed(Duration(seconds: 1));
  }

  // Okay
  Future<void> fn3() async {
    await Future.delayed(Duration(seconds: 1));
    ref.read(a.notifier).state = '';
  }
}

final f = ChangeNotifierProvider<E>((ref) {
  final e = E(ref);
  // expect_lint: riverpod_no_mutate_sync
  e.fn();
  return e;
});

class G extends ConsumerStatefulWidget {
  const G({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GState();
}

class _GState extends ConsumerState<G> {
  @override
  void initState() {
    // expect_lint: riverpod_no_mutate_sync
    ref.read(a.notifier).state = '';
    // expect_lint: riverpod_no_mutate_sync
    ref.invalidate(a);
    // expect_lint: riverpod_no_mutate_sync
    ref.refresh(a);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

@riverpod
Future<String> generated(GeneratedRef ref, String value, int otherValue) async {
  // expect_lint: riverpod_no_mutate_sync
  ref.watch(a.notifier).state = 'Other';
  // expect_lint: riverpod_no_mutate_sync
  ref.invalidate(a);
  // expect_lint: riverpod_no_mutate_sync
  ref.refresh(a);
  await Future.delayed(Duration(seconds: 1));
  ref.watch(a.notifier).state = 'Other';
  ref.invalidate(a);
  ref.refresh(a);
  return '';
}

@riverpod
String generatedSync(GeneratedSyncRef ref, String value, int otherValue) {
  // expect_lint: riverpod_no_mutate_sync
  ref.watch(a.notifier).state = 'Other';
  // expect_lint: riverpod_no_mutate_sync
  ref.invalidate(a);
  // expect_lint: riverpod_no_mutate_sync
  ref.refresh(a);
  Future.delayed(Duration(seconds: 1), () {
    ref.read(a.notifier).state = 'Other';
    ref.invalidate(a);
    ref.refresh(a);
  });
  return '';
}

@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  Future<String> build(int i, String b) async {
    // expect_lint: riverpod_no_mutate_sync
    ref.watch(a.notifier).state = 'Other';
    // expect_lint: riverpod_no_mutate_sync
    ref.invalidate(a);
    // expect_lint: riverpod_no_mutate_sync
    ref.refresh(a);
    await Future.delayed(Duration(seconds: 1));
    ref.watch(a.notifier).state = 'Other';
    ref.invalidate(a);
    ref.refresh(a);
    return '';
  }
}

@riverpod
class MyNotifier2 extends _$MyNotifier2 {
  @override
  String build(int i, String b) {
    // expect_lint: riverpod_no_mutate_sync
    ref.watch(a.notifier).state = 'Other';
    // expect_lint: riverpod_no_mutate_sync
    ref.invalidate(a);
    // expect_lint: riverpod_no_mutate_sync
    ref.refresh(a);
    Future.delayed(Duration(seconds: 1), () {
      ref.read(a.notifier).state = 'Other';
      ref.invalidate(a);
      ref.refresh(a);
    });
    return '';
  }
}
