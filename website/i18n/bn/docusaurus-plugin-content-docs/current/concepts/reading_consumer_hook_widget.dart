// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'reading_counter.dart';

/* SNIPPET START */

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // HookConsumerWidget অনুমতি দেয় বিল্ড মেথড এর ভিতরে hooks ব্যবহার করার
    final state = useState(0);

    // আমরা একইসাথে "ref" দিয়ে প্রভাইডার রিড করতে পারব
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
