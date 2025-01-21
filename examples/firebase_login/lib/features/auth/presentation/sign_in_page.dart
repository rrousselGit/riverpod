import 'package:firebase_login/features/auth/providers/auth_form_state.dart';
import 'package:firebase_login/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sign_up_page.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(authFormStateProvider);
    final formStateNotifier = ref.watch(authFormStateProvider.notifier);

    ref.listen<AuthFormState>(
      authFormStateProvider,
      (previous, next) {
        next.maybeWhen(
          failure: (message) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(message)),
              );
          },
          orElse: () {},
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in to your account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SignInForm(),
            ElevatedButton(
              onPressed: formState.isFormSubmitting
                  ? null
                  : formStateNotifier.signInWithGoogle,
              child: formState.isFormSubmitting
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Sign in with google'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const SignUpPage(),
                ),
              ),
              child: const Text('Do not have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});
  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(authFormStateProvider);
    final formStateNotifier = ref.watch(authFormStateProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email address',
            border: OutlineInputBorder(),
          ),
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        ElevatedButton(
          onPressed: formState.isFormSubmitting
              ? null
              : () => formStateNotifier.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
          child: formState.isFormSubmitting
              ? const CircularProgressIndicator.adaptive()
              : const Text('Sign in to your account'),
        ),
      ],
    );
  }
}
