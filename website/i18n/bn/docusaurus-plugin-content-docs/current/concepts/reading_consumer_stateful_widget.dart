import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reading_counter.dart';

/* SNIPPET START */

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    // "ref" একটি StatefulWidget এর সকল লাইফসাইকেল এ ব্যবহার করে যাবে.
    ref.read(counterProvider);
  }

  @override
  Widget build(BuildContext context) {
    // আমরা আর ব্যবহার করতে পারব "ref" কে বিল্ড মেথড এ একটি প্রভাইডার রিড/লিসেন করার ক্ষেত্রে
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
