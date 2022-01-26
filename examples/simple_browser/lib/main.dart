import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../resources/strings_manager.dart';
import '../screens/home.dart';

void main() {
  runApp(const ProviderScope(child: BrowserApp()));
}

class BrowserApp extends StatelessWidget {
  const BrowserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: ThemeData.dark(),
      home: const Home(),
    );
  }

}
