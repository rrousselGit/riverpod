import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // expect_lint: missing_provider_scope
  runApp(
    MyApp(),
  );
  runApp(ProviderScope(child: MyApp()));
  runApp(
    UncontrolledProviderScope(
      container: ProviderContainer(),
      child: MyApp(),
    ),
  );
}

void definitelyNotAMain() {
  // expect_lint: missing_provider_scope
  runApp(
    MyApp(),
  );
  runApp(ProviderScope(child: MyApp()));
  runApp(
    UncontrolledProviderScope(
      container: ProviderContainer(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
