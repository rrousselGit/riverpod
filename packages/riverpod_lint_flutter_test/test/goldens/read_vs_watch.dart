// ignore_for_file: unused_element, unused_local_variable

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final provider = Provider((ref) => 0);

final another = Provider((ref) {
  ref.watch(provider);
  ref.read(provider);

  void fn() {
    ref.watch(provider);
    ref.read(provider);
  }

  final fn2 = () {
    ref.watch(provider);
    ref.read(provider);
  };
});

final foo = Consumer(
  builder: (context, ref, child) {
    ref.watch(provider);
    ref.read(provider);

    void fn() {
      ref.watch(provider);
      ref.read(provider);
    }

    final fn2 = () {
      ref.watch(provider);
      ref.read(provider);
    };

    return Container();
  },
);

final bar = HookConsumer(
  builder: (context, ref, child) {
    ref.watch(provider);
    ref.read(provider);

    void fn() {
      ref.watch(provider);
      ref.read(provider);
    }

    final fn2 = () {
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
    ref.read(provider);

    Builder(builder: (context) {
      ref.watch(provider);
      ref.read(provider);
      return Container();
    });

    FloatingActionButton(
      onPressed: () {
        ref.watch(provider);
        ref.read(provider);
      },
      child: const Icon(Icons.add),
    );

    return Container();
  }

  void fn(WidgetRef ref) {
    ref.watch(provider);
    ref.read(provider);
  }
}

class HookHome extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(provider);
    ref.read(provider);

    Builder(builder: (context) {
      ref.watch(provider);
      ref.read(provider);
      return Container();
    });

    FloatingActionButton(
      onPressed: () {
        ref.watch(provider);
        ref.read(provider);
      },
      child: const Icon(Icons.add),
    );

    return Container();
  }

  void fn(WidgetRef ref) {
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
    ref.watch(provider);
    ref.read(provider);
  }
}
