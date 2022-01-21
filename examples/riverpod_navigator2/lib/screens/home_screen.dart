import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_pages.dart';
import '../providers/app_state_manager.dart';

class HomeScreen extends ConsumerWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: AppPages.home,
      key: ValueKey(AppPages.home),
      child: const HomeScreen(),
    );
  }

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => ref.watch(appStateManager).logout(),
          child: const Text("Logout"),
        ),
      ),
    );
  }
}
