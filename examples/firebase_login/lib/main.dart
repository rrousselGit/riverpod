import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth/auth_repository.dart';
import 'auth/user.dart';
import 'firebase_options.dart';
import 'home/home.dart';
import 'sign_in/sign_in.dart';

part 'main.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;

    return MaterialApp(
      title: 'Riverpod - Firebase Login Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: false,
      ),
      home: user == null
          ? const SignInPage()
          : user.isAuthenticated
              ? const HomePage()
              : const SignInPage(),
    );
  }
}

@riverpod
Stream<User> user(Ref ref) {
  return ref.watch(authRepositoryProvider).user;
}
