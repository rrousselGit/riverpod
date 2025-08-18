// IMPORTANT: Any change to this file must also be applied to:
// - The DartPad embed gist
//   https://gist.github.com/rrousselGit/6bf918e3fc97a40b53d1ea80fd937146
// - The website tutorial
//   https://riverpod.dev/docs/tutorials/first_app

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeView());
  }
}
