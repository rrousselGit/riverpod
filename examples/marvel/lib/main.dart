import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/screens/character_detail.dart';
import 'src/screens/home.dart';

void main() {
  runApp(
    const ProviderScope(
      // uncomment to mock the HTTP requests

      // overrides: [
      //   repositoryProvider.overrideAs(
      //     Provider(
      //       (ref) => MarvelRepository(ref, client: FakeDio(null)),
      //     ),
      //   ),
      // ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      routes: {
        '/character': (c) => const CharacterView(),
      },
    );
  }
}
