// ignore_for_file: unused_element, unused_local_variable

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'read_vs_watch.g.dart';

final provider = Provider((ref) => 0);

final another = Provider((ref) {
  ref.watch(provider);
  // expect_lint: riverpod_avoid_read_inside_build
  ref.read(provider);

  void fn() {
    // expect_lint: riverpod_avoid_watch_outside_build
    ref.watch(provider);
    ref.read(provider);
  }

  final fn2 = () {
    // expect_lint: riverpod_avoid_watch_outside_build
    ref.watch(provider);
    ref.read(provider);
  };
});

final foo = Consumer(
  builder: (context, ref, child) {
    ref.watch(provider);
    // expect_lint: riverpod_avoid_read_inside_build
    ref.read(provider);

    void fn() {
      ref.watch(provider);
      ref.read(provider);
    }

    final fn2 = () {
      // expect_lint: riverpod_avoid_watch_outside_build
      ref.watch(provider);
      ref.read(provider);
    };

    return Container();
  },
);

final bar = HookConsumer(
  builder: (context, ref, child) {
    ref.watch(provider);
    // expect_lint: riverpod_avoid_read_inside_build
    ref.read(provider);

    void fn() {
      ref.watch(provider);
      ref.read(provider);
    }

    final fn2 = () {
      // expect_lint: riverpod_avoid_watch_outside_build
      ref.watch(provider);
      ref.read(provider);
    };

    return Container();
  },
);

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provider);
    // expect_lint: riverpod_avoid_read_inside_build
    ref.read(provider);

    Builder(builder: (context) {
      ref.watch(provider);
      // expect_lint: riverpod_avoid_read_inside_build
      ref.read(provider);
      return Container();
    });

    FloatingActionButton(
      onPressed: () {
        // expect_lint: riverpod_avoid_watch_outside_build
        ref.watch(provider);
        ref.read(provider);
      },
      child: const Icon(Icons.add),
    );

    return Container();
  }

  void fn(WidgetRef ref) {
    // expect_lint: riverpod_avoid_watch_outside_build
    ref.watch(provider);
    ref.read(provider);
  }
}

class HookHome extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provider);
    // expect_lint: riverpod_avoid_read_inside_build
    ref.read(provider);

    Builder(builder: (context) {
      ref.watch(provider);
      // expect_lint: riverpod_avoid_read_inside_build
      ref.read(provider);
      return Container();
    });

    FloatingActionButton(
      onPressed: () {
        // expect_lint: riverpod_avoid_watch_outside_build
        ref.watch(provider);
        ref.read(provider);
      },
      child: const Icon(Icons.add),
    );

    return Container();
  }

  void fn(WidgetRef ref) {
    // expect_lint: riverpod_avoid_watch_outside_build
    ref.watch(provider);
    ref.read(provider);
  }
}

class Counter extends StateNotifier<int> {
  Counter(this.ref) : super(0) {
    ref.watch(provider);
    ref.read(provider);
  }

  final Ref ref;

  void increment() {
    // expect_lint: riverpod_avoid_watch_outside_build
    ref.watch(provider);
    ref.read(provider);
  }
}

@riverpod
Future<String> generated(GeneratedRef ref, String value, int otherValue) async {
  // expect_lint: riverpod_avoid_read_inside_build
  ref.read(provider);
  ref.watch(provider);
  return '';
}

@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  Future<String> build(int i, String b) async {
    // expect_lint: riverpod_avoid_read_inside_build
    ref.read(provider);
    ref.watch(provider);
    return '';
  }

  void fn() {
    ref.read(provider);
    // expect_lint: riverpod_avoid_watch_outside_build
    ref.watch(provider);
  }
}
