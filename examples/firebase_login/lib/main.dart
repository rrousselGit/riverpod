import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/features/auth/presentation/home_page.dart';
import 'package:firebase_login/features/auth/presentation/sign_in_page.dart';
import 'package:firebase_login/features/auth/providers/auth_providers.dart';
import 'package:firebase_login/provider_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      observers: [AppProviderObserver()],
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Riverpod - Firebase Login Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: false,
      ),
      home: authState.when(
        authenticated: (_) => const HomePage(),
        unauthenticated: () => const SignInPage(),
      ),
    );
  }
}
