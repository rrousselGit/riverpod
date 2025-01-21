import 'package:firebase_login/features/auth/providers/auth_form_state.dart';
import 'package:firebase_login/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthFormState>(
      authFormStateProvider,
      (previous, next) {
        next.maybeWhen(
          success: () => Navigator.pop(context),
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
        title: const Text('Create a new account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SignUpForm(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Already have an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});
  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
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
              : () => formStateNotifier.signUpWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
          child: formState.isFormSubmitting
              ? const CircularProgressIndicator.adaptive()
              : const Text('Create your account'),
        ),
      ],
    );
  }
}
